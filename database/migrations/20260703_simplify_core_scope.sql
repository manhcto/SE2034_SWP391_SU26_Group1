USE [WonderVn];
GO

SET XACT_ABORT ON;
GO

/*
    Simplify WonderVn around the approved core scope:
    - Keep tour booking and accommodation booking.
    - Remove vehicle, cart, external ticket/entertainment, and generic service modules.
    - Replace external ticket/entertainment content with Blog.

    Run this after backing up the database.
    Code must be refactored after this migration because serviceID becomes accommodationID.
*/
BEGIN TRANSACTION;

/* 1. Normalize code-dependent role IDs and account statuses */
IF OBJECT_ID(N'[dbo].[Role]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[User]', N'U') IS NOT NULL
BEGIN
    DECLARE @currentCustomerRoleID INT = (
        SELECT TOP 1 [roleID]
        FROM [dbo].[Role]
        WHERE [roleName] = N'Customer'
    );
    DECLARE @currentGuideRoleID INT = (
        SELECT TOP 1 [roleID]
        FROM [dbo].[Role]
        WHERE [roleName] = N'TourGuide'
    );

    IF @currentCustomerRoleID = 3 AND @currentGuideRoleID = 4
    BEGIN
        UPDATE [dbo].[User]
        SET [roleID] = CASE
            WHEN [roleID] = @currentCustomerRoleID THEN @currentGuideRoleID
            WHEN [roleID] = @currentGuideRoleID THEN @currentCustomerRoleID
            ELSE [roleID]
        END
        WHERE [roleID] IN (@currentCustomerRoleID, @currentGuideRoleID);

        UPDATE [dbo].[Role]
        SET [roleName] = N'__TMP_CUSTOMER__'
        WHERE [roleID] = @currentCustomerRoleID;

        UPDATE [dbo].[Role]
        SET [roleName] = N'Customer'
        WHERE [roleID] = @currentGuideRoleID;

        UPDATE [dbo].[Role]
        SET [roleName] = N'TourGuide'
        WHERE [roleID] = @currentCustomerRoleID;
    END;
END;

IF OBJECT_ID(N'[dbo].[CK_User_Status]', N'C') IS NOT NULL
    ALTER TABLE [dbo].[User] DROP CONSTRAINT [CK_User_Status];

IF OBJECT_ID(N'[dbo].[User]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[User]
    SET [status] = N'Blocked'
    WHERE [status] = N'Locked';

    ALTER TABLE [dbo].[User] WITH CHECK ADD CONSTRAINT [CK_User_Status]
    CHECK ([status] IN (N'Active', N'Inactive', N'Blocked', N'Locked'));
END;

/* 2. Create Blog and migrate Entertainment/External_Ticket content */
IF OBJECT_ID(N'[dbo].[Blog]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Blog] (
        [blogID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [title] NVARCHAR(255) NOT NULL,
        [slug] NVARCHAR(255) NULL,
        [image] NVARCHAR(500) NULL,
        [summary] NVARCHAR(500) NULL,
        [content] NVARCHAR(MAX) NULL,
        [authorUserID] INT NULL,
        [status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Blog_Status] DEFAULT (N'Published'),
        [createdAt] DATETIME NOT NULL CONSTRAINT [DF_Blog_CreatedAt] DEFAULT (GETDATE()),
        [updatedAt] DATETIME NULL
    );
END;

IF COL_LENGTH(N'dbo.Blog', N'slug') IS NULL
BEGIN
    ALTER TABLE [dbo].[Blog] ADD [slug] NVARCHAR(255) NULL;
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE [name] = N'UX_Blog_Slug'
      AND [object_id] = OBJECT_ID(N'[dbo].[Blog]')
)
BEGIN
    CREATE UNIQUE INDEX [UX_Blog_Slug]
        ON [dbo].[Blog] ([slug])
        WHERE [slug] IS NOT NULL;
END;

IF OBJECT_ID(N'[dbo].[Entertainment]', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[Blog] ([title], [image], [summary], [content], [status], [createdAt])
    SELECT
        e.[name],
        e.[image],
        LEFT(ISNULL(e.[description], N''), 500),
        e.[description],
        CASE WHEN e.[status] IN (N'Inactive', N'Hidden', N'Draft') THEN N'Draft' ELSE N'Published' END,
        GETDATE()
    FROM [dbo].[Entertainment] e
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[Blog] b
        WHERE b.[title] = e.[name]
    );
END;

IF OBJECT_ID(N'[dbo].[External_Ticket]', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[Blog] ([title], [image], [summary], [content], [status], [createdAt])
    SELECT
        et.[name],
        et.[image],
        LEFT(ISNULL(et.[description], N''), 500),
        et.[description],
        CASE WHEN et.[status] IN (N'Inactive', N'Hidden', N'Draft') THEN N'Draft' ELSE N'Published' END,
        GETDATE()
    FROM [dbo].[External_Ticket] et
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[Blog] b
        WHERE b.[title] = et.[name]
    );
END;

IF OBJECT_ID(N'[dbo].[FK_Blog_User]', N'F') IS NULL
    AND OBJECT_ID(N'[dbo].[User]', N'U') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Blog] WITH CHECK ADD CONSTRAINT [FK_Blog_User]
    FOREIGN KEY ([authorUserID]) REFERENCES [dbo].[User] ([userID]);
END;

/* 3. Move accommodation references away from Service */
IF COL_LENGTH(N'dbo.Booking_Detail', N'accommodationID') IS NULL
BEGIN
    ALTER TABLE [dbo].[Booking_Detail] ADD [accommodationID] INT NULL;
END;

IF COL_LENGTH(N'dbo.Booking_Detail', N'roomID') IS NULL
BEGIN
    ALTER TABLE [dbo].[Booking_Detail] ADD [roomID] INT NULL;
END;

IF COL_LENGTH(N'dbo.Booking', N'identityNumber') IS NULL
BEGIN
    ALTER TABLE [dbo].[Booking] ADD [identityNumber] NVARCHAR(50) NULL;
END;

IF COL_LENGTH(N'dbo.Booking', N'identityImageUrl') IS NULL
BEGIN
    ALTER TABLE [dbo].[Booking] ADD [identityImageUrl] NVARCHAR(500) NULL;
END;

IF COL_LENGTH(N'dbo.Booking_Detail', N'serviceID') IS NOT NULL
BEGIN
    UPDATE bd
    SET [accommodationID] = bd.[serviceID]
    FROM [dbo].[Booking_Detail] bd
    INNER JOIN [dbo].[Accommodation] a ON a.[serviceID] = bd.[serviceID]
    WHERE bd.[accommodationID] IS NULL;

    DELETE bd
    FROM [dbo].[Booking_Detail] bd
    WHERE bd.[tourScheduleID] IS NULL
      AND bd.[accommodationID] IS NULL;
END;

IF COL_LENGTH(N'dbo.Booking_Detail', N'roomID') IS NOT NULL
BEGIN
    UPDATE bd
    SET [roomID] = TRY_CONVERT(
        INT,
        SUBSTRING(
            bd.[note],
            LEN(N'ROOM_ID=') + 1,
            CHARINDEX(N';', bd.[note] + N';') - LEN(N'ROOM_ID=') - 1
        )
    )
    FROM [dbo].[Booking_Detail] bd
    WHERE bd.[roomID] IS NULL
      AND bd.[note] LIKE N'ROOM_ID=%';
END;

IF COL_LENGTH(N'dbo.Request_Cancel', N'accommodationID') IS NULL
BEGIN
    ALTER TABLE [dbo].[Request_Cancel] ADD [accommodationID] INT NULL;
END;

IF COL_LENGTH(N'dbo.Request_Cancel', N'serviceID') IS NOT NULL
BEGIN
    UPDATE rc
    SET [accommodationID] = rc.[serviceID]
    FROM [dbo].[Request_Cancel] rc
    INNER JOIN [dbo].[Accommodation] a ON a.[serviceID] = rc.[serviceID]
    WHERE rc.[accommodationID] IS NULL;
END;

/* 4. Drop FK constraints tied to modules being removed or renamed */
DECLARE @dropFkSql NVARCHAR(MAX) = N'';

SELECT @dropFkSql +=
    N'ALTER TABLE '
    + QUOTENAME(OBJECT_SCHEMA_NAME(fk.[parent_object_id]))
    + N'.'
    + QUOTENAME(OBJECT_NAME(fk.[parent_object_id]))
    + N' DROP CONSTRAINT '
    + QUOTENAME(fk.[name])
    + N';' + CHAR(13)
FROM sys.foreign_keys fk
WHERE fk.[referenced_object_id] IN (
        OBJECT_ID(N'dbo.Service'),
        OBJECT_ID(N'dbo.Service_Category'),
        OBJECT_ID(N'dbo.Service_Partner'),
        OBJECT_ID(N'dbo.Vehicle'),
        OBJECT_ID(N'dbo.Vehicle_Brand'),
        OBJECT_ID(N'dbo.Carts'),
        OBJECT_ID(N'dbo.Cart_Items'),
        OBJECT_ID(N'dbo.Entertainment'),
        OBJECT_ID(N'dbo.External_Ticket'),
        OBJECT_ID(N'dbo.Restaurant'),
        OBJECT_ID(N'dbo.Meal_Package')
    )
   OR fk.[parent_object_id] IN (
        OBJECT_ID(N'dbo.Service'),
        OBJECT_ID(N'dbo.Service_Category'),
        OBJECT_ID(N'dbo.Service_Contract'),
        OBJECT_ID(N'dbo.Service_Partner'),
        OBJECT_ID(N'dbo.Vehicle'),
        OBJECT_ID(N'dbo.Vehicle_Brand'),
        OBJECT_ID(N'dbo.Carts'),
        OBJECT_ID(N'dbo.Cart_Items'),
        OBJECT_ID(N'dbo.Entertainment'),
        OBJECT_ID(N'dbo.External_Ticket'),
        OBJECT_ID(N'dbo.Restaurant'),
        OBJECT_ID(N'dbo.Meal_Package'),
        OBJECT_ID(N'dbo.Tour_Service_Detail'),
        OBJECT_ID(N'dbo.Tour_Optional_Service')
    );

IF LEN(@dropFkSql) > 0
BEGIN
    EXEC sp_executesql @dropFkSql;
END;

IF OBJECT_ID(N'[dbo].[FK_AccommodationFacility_Accommodation]', N'F') IS NOT NULL
    ALTER TABLE [dbo].[Accommodation_Facility] DROP CONSTRAINT [FK_AccommodationFacility_Accommodation];

IF OBJECT_ID(N'[dbo].[FK_Room_Accommodation]', N'F') IS NOT NULL
    ALTER TABLE [dbo].[Room] DROP CONSTRAINT [FK_Room_Accommodation];

IF OBJECT_ID(N'[dbo].[CK_BookingDetail_Tour_Or_Service]', N'C') IS NOT NULL
    ALTER TABLE [dbo].[Booking_Detail] DROP CONSTRAINT [CK_BookingDetail_Tour_Or_Service];

/* 5. Drop default constraints before dropping service columns */
DECLARE @dropDefaultSql NVARCHAR(MAX) = N'';

SELECT @dropDefaultSql +=
    N'ALTER TABLE '
    + QUOTENAME(OBJECT_SCHEMA_NAME(dc.[parent_object_id]))
    + N'.'
    + QUOTENAME(OBJECT_NAME(dc.[parent_object_id]))
    + N' DROP CONSTRAINT '
    + QUOTENAME(dc.[name])
    + N';' + CHAR(13)
FROM sys.default_constraints dc
INNER JOIN sys.columns c
    ON c.[object_id] = dc.[parent_object_id]
   AND c.[column_id] = dc.[parent_column_id]
WHERE (
        OBJECT_NAME(dc.[parent_object_id]) = N'Booking_Detail'
        AND c.[name] = N'serviceID'
    )
    OR (
        OBJECT_NAME(dc.[parent_object_id]) = N'Request_Cancel'
        AND c.[name] = N'serviceID'
    )
    OR (
        OBJECT_NAME(dc.[parent_object_id]) = N'Tour_Schedule_Service_Assignment'
        AND c.[name] IN (N'serviceID', N'vehicleServiceID', N'mealPackageID')
    );

IF LEN(@dropDefaultSql) > 0
BEGIN
    EXEC sp_executesql @dropDefaultSql;
END;

/* 6. Rename serviceID columns that are really accommodation IDs */
IF COL_LENGTH(N'dbo.Accommodation', N'serviceID') IS NOT NULL
    AND COL_LENGTH(N'dbo.Accommodation', N'accommodationID') IS NULL
BEGIN
    EXEC sp_rename N'dbo.Accommodation.serviceID', N'accommodationID', N'COLUMN';
END;

IF COL_LENGTH(N'dbo.Accommodation_Facility', N'serviceID') IS NOT NULL
    AND COL_LENGTH(N'dbo.Accommodation_Facility', N'accommodationID') IS NULL
BEGIN
    EXEC sp_rename N'dbo.Accommodation_Facility.serviceID', N'accommodationID', N'COLUMN';
END;

IF COL_LENGTH(N'dbo.Room', N'serviceID') IS NOT NULL
    AND COL_LENGTH(N'dbo.Room', N'accommodationID') IS NULL
BEGIN
    EXEC sp_rename N'dbo.Room.serviceID', N'accommodationID', N'COLUMN';
END;

DECLARE @nextAccommodationID INT;
SELECT @nextAccommodationID = ISNULL(MAX([accommodationID]), 0) + 1
FROM [dbo].[Accommodation];

IF OBJECT_ID(N'[dbo].[Seq_AccommodationID]', N'SO') IS NULL
BEGIN
    DECLARE @createSequenceSql NVARCHAR(MAX);
    SET @createSequenceSql = N'CREATE SEQUENCE [dbo].[Seq_AccommodationID] AS INT START WITH '
        + CAST(@nextAccommodationID AS NVARCHAR(20))
        + N' INCREMENT BY 1;';
    EXEC sp_executesql @createSequenceSql;
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.default_constraints dc
    INNER JOIN sys.columns c
        ON c.[object_id] = dc.[parent_object_id]
       AND c.[column_id] = dc.[parent_column_id]
    WHERE dc.[parent_object_id] = OBJECT_ID(N'dbo.Accommodation')
      AND c.[name] = N'accommodationID'
)
BEGIN
    ALTER TABLE [dbo].[Accommodation]
    ADD CONSTRAINT [DF_Accommodation_AccommodationID]
    DEFAULT (NEXT VALUE FOR [dbo].[Seq_AccommodationID]) FOR [accommodationID];
END;

/* 7. Remove service columns no longer needed */
IF COL_LENGTH(N'dbo.Booking_Detail', N'serviceID') IS NOT NULL
    ALTER TABLE [dbo].[Booking_Detail] DROP COLUMN [serviceID];

IF COL_LENGTH(N'dbo.Request_Cancel', N'serviceID') IS NOT NULL
    ALTER TABLE [dbo].[Request_Cancel] DROP COLUMN [serviceID];

IF COL_LENGTH(N'dbo.Tour_Schedule_Service_Assignment', N'serviceID') IS NOT NULL
    ALTER TABLE [dbo].[Tour_Schedule_Service_Assignment] DROP COLUMN [serviceID];

IF COL_LENGTH(N'dbo.Tour_Schedule_Service_Assignment', N'vehicleServiceID') IS NOT NULL
    ALTER TABLE [dbo].[Tour_Schedule_Service_Assignment] DROP COLUMN [vehicleServiceID];

IF COL_LENGTH(N'dbo.Tour_Schedule_Service_Assignment', N'mealPackageID') IS NOT NULL
    ALTER TABLE [dbo].[Tour_Schedule_Service_Assignment] DROP COLUMN [mealPackageID];

/* 8. Restore core foreign keys and booking check */
IF OBJECT_ID(N'[dbo].[FK_BookingDetail_Accommodation]', N'F') IS NULL
    AND COL_LENGTH(N'dbo.Booking_Detail', N'accommodationID') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Booking_Detail] WITH CHECK ADD CONSTRAINT [FK_BookingDetail_Accommodation]
    FOREIGN KEY ([accommodationID]) REFERENCES [dbo].[Accommodation] ([accommodationID]);
END;

IF OBJECT_ID(N'[dbo].[FK_RequestCancel_Accommodation]', N'F') IS NULL
    AND COL_LENGTH(N'dbo.Request_Cancel', N'accommodationID') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Request_Cancel] WITH CHECK ADD CONSTRAINT [FK_RequestCancel_Accommodation]
    FOREIGN KEY ([accommodationID]) REFERENCES [dbo].[Accommodation] ([accommodationID]);
END;

IF OBJECT_ID(N'[dbo].[FK_AccommodationFacility_Accommodation]', N'F') IS NULL
    AND COL_LENGTH(N'dbo.Accommodation_Facility', N'accommodationID') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Accommodation_Facility] WITH CHECK ADD CONSTRAINT [FK_AccommodationFacility_Accommodation]
    FOREIGN KEY ([accommodationID]) REFERENCES [dbo].[Accommodation] ([accommodationID]);
END;

IF OBJECT_ID(N'[dbo].[FK_Room_Accommodation]', N'F') IS NULL
    AND COL_LENGTH(N'dbo.Room', N'accommodationID') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Room] WITH CHECK ADD CONSTRAINT [FK_Room_Accommodation]
    FOREIGN KEY ([accommodationID]) REFERENCES [dbo].[Accommodation] ([accommodationID]);
END;

IF OBJECT_ID(N'[dbo].[FK_BookingDetail_Room]', N'F') IS NULL
    AND COL_LENGTH(N'dbo.Booking_Detail', N'roomID') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Booking_Detail] WITH CHECK ADD CONSTRAINT [FK_BookingDetail_Room]
    FOREIGN KEY ([roomID]) REFERENCES [dbo].[Room] ([roomID]);
END;

IF OBJECT_ID(N'[dbo].[CK_BookingDetail_Tour_Or_Accommodation]', N'C') IS NULL
BEGIN
    ALTER TABLE [dbo].[Booking_Detail] WITH CHECK ADD CONSTRAINT [CK_BookingDetail_Tour_Or_Accommodation]
    CHECK ([accommodationID] IS NOT NULL OR [tourScheduleID] IS NOT NULL);
END;

/* 9. Drop removed feature tables */
DROP TABLE IF EXISTS [dbo].[Cart_Items];
DROP TABLE IF EXISTS [dbo].[Carts];
DROP TABLE IF EXISTS [dbo].[Vehicle];
DROP TABLE IF EXISTS [dbo].[Vehicle_Brand];
DROP TABLE IF EXISTS [dbo].[External_Ticket];
DROP TABLE IF EXISTS [dbo].[Entertainment];
DROP TABLE IF EXISTS [dbo].[Notification];
DROP TABLE IF EXISTS [dbo].[Tour_Service_Detail];
DROP TABLE IF EXISTS [dbo].[Tour_Optional_Service];
DROP TABLE IF EXISTS [dbo].[Meal_Package];
DROP TABLE IF EXISTS [dbo].[Restaurant];
DROP TABLE IF EXISTS [dbo].[Service_Contract];
DROP TABLE IF EXISTS [dbo].[Service_Partner];
DROP TABLE IF EXISTS [dbo].[Service_Category];
DROP TABLE IF EXISTS [dbo].[Service];

COMMIT TRANSACTION;

SELECT
    N'Core scope migration completed. Next step: refactor Java DAO/controllers to use accommodationID and remove vehicle/cart/service code.' AS [message];
GO
