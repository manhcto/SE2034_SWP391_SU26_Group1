USE [WonderVn];
GO

SET XACT_ABORT ON;

BEGIN TRANSACTION;

IF OBJECT_ID(N'dbo.ExternalTicket', N'U') IS NOT NULL
    AND OBJECT_ID(N'dbo.External_Ticket', N'U') IS NULL
BEGIN
    EXEC sp_rename N'dbo.ExternalTicket', N'External_Ticket';
END;

IF OBJECT_ID(N'dbo.[External Ticket]', N'U') IS NOT NULL
    AND OBJECT_ID(N'dbo.External_Ticket', N'U') IS NULL
BEGIN
    EXEC sp_rename N'dbo.[External Ticket]', N'External_Ticket';
END;

IF OBJECT_ID(N'dbo.Entertainment', N'U') IS NOT NULL
    AND OBJECT_ID(N'dbo.External_Ticket', N'U') IS NULL
BEGIN
    EXEC sp_rename N'dbo.Entertainment', N'External_Ticket';
END;

IF OBJECT_ID(N'dbo.Entertaiment', N'U') IS NOT NULL
    AND OBJECT_ID(N'dbo.External_Ticket', N'U') IS NULL
BEGIN
    EXEC sp_rename N'dbo.Entertaiment', N'External_Ticket';
END;

IF OBJECT_ID(N'dbo.External_Ticket', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[External_Ticket](
        [serviceID] [int] NOT NULL,
        [name] [nvarchar](255) NOT NULL,
        [image] [nvarchar](500) NULL,
        [address] [nvarchar](255) NOT NULL,
        [phone] [nvarchar](20) NULL,
        [description] [nvarchar](max) NULL,
        [rate] [decimal](3, 2) NULL,
        [type] [nvarchar](100) NULL,
        [status] [nvarchar](50) NOT NULL,
        [timeOpen] [time](7) NULL,
        [timeClose] [time](7) NULL,
        [dayOfWeekOpen] [nvarchar](100) NULL,
        [ticketPrice] [decimal](18, 2) NULL,
        CONSTRAINT [PK_ExternalTicket] PRIMARY KEY CLUSTERED ([serviceID] ASC)
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
END;

IF OBJECT_ID(N'dbo.Entertainment', N'U') IS NOT NULL
    AND OBJECT_ID(N'dbo.External_Ticket', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[External_Ticket] (
        [serviceID], [name], [image], [address], [phone], [description],
        [rate], [type], [status], [timeOpen], [timeClose],
        [dayOfWeekOpen], [ticketPrice]
    )
    SELECT
        e.[serviceID], e.[name], e.[image], e.[address], e.[phone], e.[description],
        e.[rate], e.[type], e.[status], e.[timeOpen], e.[timeClose],
        e.[dayOfWeekOpen], e.[ticketPrice]
    FROM [dbo].[Entertainment] e
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[External_Ticket] et
        WHERE et.[serviceID] = e.[serviceID]
    );

    DROP TABLE [dbo].[Entertainment];
END;

IF OBJECT_ID(N'dbo.Entertaiment', N'U') IS NOT NULL
    AND OBJECT_ID(N'dbo.External_Ticket', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[External_Ticket] (
        [serviceID], [name], [image], [address], [phone], [description],
        [rate], [type], [status], [timeOpen], [timeClose],
        [dayOfWeekOpen], [ticketPrice]
    )
    SELECT
        e.[serviceID], e.[name], e.[image], e.[address], e.[phone], e.[description],
        e.[rate], e.[type], e.[status], e.[timeOpen], e.[timeClose],
        e.[dayOfWeekOpen], e.[ticketPrice]
    FROM [dbo].[Entertaiment] e
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[External_Ticket] et
        WHERE et.[serviceID] = e.[serviceID]
    );

    DROP TABLE [dbo].[Entertaiment];
END;

IF OBJECT_ID(N'dbo.PK_ExternalTicket', N'PK') IS NULL
BEGIN
    DECLARE @pkName sysname;
    DECLARE @pkObjectName nvarchar(512);

    SELECT @pkName = kc.[name]
    FROM sys.key_constraints kc
    WHERE kc.parent_object_id = OBJECT_ID(N'dbo.External_Ticket')
      AND kc.[type] = N'PK';

    IF @pkName IS NOT NULL
    BEGIN
        SET @pkObjectName = N'dbo.' + @pkName;
        EXEC sp_rename @pkObjectName, N'PK_ExternalTicket', N'OBJECT';
    END;
    ELSE
    BEGIN
        ALTER TABLE [dbo].[External_Ticket]
        ADD CONSTRAINT [PK_ExternalTicket] PRIMARY KEY CLUSTERED ([serviceID] ASC);
    END;
END;

IF OBJECT_ID(N'dbo.FK_Entertainment_Service', N'F') IS NOT NULL
    AND OBJECT_ID(N'dbo.FK_ExternalTicket_Service', N'F') IS NULL
BEGIN
    EXEC sp_rename N'dbo.FK_Entertainment_Service', N'FK_ExternalTicket_Service', N'OBJECT';
END;

IF OBJECT_ID(N'dbo.FK_Entertaiment_Service', N'F') IS NOT NULL
    AND OBJECT_ID(N'dbo.FK_ExternalTicket_Service', N'F') IS NULL
BEGIN
    EXEC sp_rename N'dbo.FK_Entertaiment_Service', N'FK_ExternalTicket_Service', N'OBJECT';
END;

IF OBJECT_ID(N'dbo.FK_ExternalTicket_Service', N'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[External_Ticket] WITH CHECK ADD CONSTRAINT [FK_ExternalTicket_Service]
    FOREIGN KEY([serviceID]) REFERENCES [dbo].[Service] ([serviceID]);

    ALTER TABLE [dbo].[External_Ticket] CHECK CONSTRAINT [FK_ExternalTicket_Service];
END;

IF OBJECT_ID(N'dbo.CK_Entertainment_Rate', N'C') IS NOT NULL
    AND OBJECT_ID(N'dbo.CK_ExternalTicket_Rate', N'C') IS NULL
BEGIN
    EXEC sp_rename N'dbo.CK_Entertainment_Rate', N'CK_ExternalTicket_Rate', N'OBJECT';
END;

IF OBJECT_ID(N'dbo.CK_Entertaiment_Rate', N'C') IS NOT NULL
    AND OBJECT_ID(N'dbo.CK_ExternalTicket_Rate', N'C') IS NULL
BEGIN
    EXEC sp_rename N'dbo.CK_Entertaiment_Rate', N'CK_ExternalTicket_Rate', N'OBJECT';
END;

IF OBJECT_ID(N'dbo.CK_ExternalTicket_Rate', N'C') IS NULL
BEGIN
    ALTER TABLE [dbo].[External_Ticket] WITH CHECK ADD CONSTRAINT [CK_ExternalTicket_Rate]
    CHECK (([rate] IS NULL OR [rate] >= 0 AND [rate] <= 5));

    ALTER TABLE [dbo].[External_Ticket] CHECK CONSTRAINT [CK_ExternalTicket_Rate];
END;

IF OBJECT_ID(N'dbo.CK_Entertainment_TicketPrice', N'C') IS NOT NULL
    AND OBJECT_ID(N'dbo.CK_ExternalTicket_TicketPrice', N'C') IS NULL
BEGIN
    EXEC sp_rename N'dbo.CK_Entertainment_TicketPrice', N'CK_ExternalTicket_TicketPrice', N'OBJECT';
END;

IF OBJECT_ID(N'dbo.CK_Entertaiment_TicketPrice', N'C') IS NOT NULL
    AND OBJECT_ID(N'dbo.CK_ExternalTicket_TicketPrice', N'C') IS NULL
BEGIN
    EXEC sp_rename N'dbo.CK_Entertaiment_TicketPrice', N'CK_ExternalTicket_TicketPrice', N'OBJECT';
END;

IF OBJECT_ID(N'dbo.CK_ExternalTicket_TicketPrice', N'C') IS NULL
BEGIN
    ALTER TABLE [dbo].[External_Ticket] WITH CHECK ADD CONSTRAINT [CK_ExternalTicket_TicketPrice]
    CHECK (([ticketPrice] IS NULL OR [ticketPrice] >= 0));

    ALTER TABLE [dbo].[External_Ticket] CHECK CONSTRAINT [CK_ExternalTicket_TicketPrice];
END;

DECLARE @statusDefaultName sysname;
DECLARE @statusDefaultObjectName nvarchar(512);

SELECT @statusDefaultName = dc.[name]
FROM sys.default_constraints dc
INNER JOIN sys.columns c ON c.object_id = dc.parent_object_id
    AND c.column_id = dc.parent_column_id
WHERE dc.parent_object_id = OBJECT_ID(N'dbo.External_Ticket')
  AND c.[name] = N'status';

IF @statusDefaultName IS NULL
BEGIN
    ALTER TABLE [dbo].[External_Ticket]
    ADD CONSTRAINT [DF_ExternalTicket_Status] DEFAULT (N'Active') FOR [status];
END
ELSE IF @statusDefaultName <> N'DF_ExternalTicket_Status'
    AND OBJECT_ID(N'dbo.DF_ExternalTicket_Status', N'D') IS NULL
BEGIN
    SET @statusDefaultObjectName = N'dbo.' + @statusDefaultName;
    EXEC sp_rename @statusDefaultObjectName, N'DF_ExternalTicket_Status', N'OBJECT';
END;

IF COL_LENGTH(N'dbo.Service', N'serviceType') IS NOT NULL
BEGIN
    UPDATE [dbo].[Service]
    SET [serviceType] = N'External Ticket',
        [fulfillmentType] = COALESCE(NULLIF([fulfillmentType], N''), N'Ticket'),
        [updateAt] = COALESCE([updateAt], GETDATE())
    WHERE [serviceType] IN (
        N'Entertainment', N'Entertaiment', N'entertainment', N'entertaiment',
        N'ExternalTicket', N'External_Ticket'
    );
END;

IF COL_LENGTH(N'dbo.Booking', N'bookingType') IS NOT NULL
BEGIN
    UPDATE [dbo].[Booking]
    SET [bookingType] = N'External Ticket'
    WHERE [bookingType] IN (
        N'Entertainment', N'Entertaiment', N'entertainment', N'entertaiment',
        N'ExternalTicket', N'External_Ticket'
    );
END;

IF COL_LENGTH(N'dbo.Service_Category', N'serviceType') IS NOT NULL
BEGIN
    UPDATE [dbo].[Service_Category]
    SET [serviceType] = N'External Ticket'
    WHERE [serviceType] IN (
        N'Entertainment', N'Entertaiment', N'entertainment', N'entertaiment',
        N'ExternalTicket', N'External_Ticket'
    );
END;

IF COL_LENGTH(N'dbo.Service_Category', N'serviceCategoryName') IS NOT NULL
BEGIN
    UPDATE [dbo].[Service_Category]
    SET [serviceCategoryName] = N'External Ticket'
    WHERE [serviceCategoryName] IN (
        N'Entertainment', N'Entertaiment', N'entertainment', N'entertaiment',
        N'ExternalTicket', N'External_Ticket'
    );
END;

COMMIT TRANSACTION;
GO
