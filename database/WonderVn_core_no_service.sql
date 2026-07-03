USE [master];
GO

IF DB_ID(N'WonderVn') IS NULL
BEGIN
    CREATE DATABASE [WonderVn];
END;
GO

USE [WonderVn];
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

/*
    WonderVn core database without the generic Service module.

    Core scope:
    - User / role management
    - Tour, tour schedule, tour assignment, tour progress
    - Accommodation, room, facilities
    - Booking for tours and accommodations
    - Payment, voucher, feedback, cancellation/refund
    - Blog content
    - Reporting configuration

    Removed scope:
    - Vehicle
    - Cart
    - External ticket / entertainment service
    - Generic Service, Service_Category, Service_Partner, Service_Contract
    - Restaurant and meal package modules
    - Notification module

    This script is intended as a clean total schema.
    It drops the listed application tables if they already exist.
*/

DECLARE @tablesToDrop TABLE ([tableName] SYSNAME NOT NULL PRIMARY KEY);

INSERT INTO @tablesToDrop ([tableName])
VALUES
    (N'Administrative_Unit'),
    (N'Audit_Log'),
    (N'Blog'),
    (N'Booking'),
    (N'Booking_Detail'),
    (N'Booking_Traveler'),
    (N'Cancel_Reason'),
    (N'Cart_Items'),
    (N'Carts'),
    (N'Destination'),
    (N'Entertainment'),
    (N'Entertaiment'),
    (N'External Ticket'),
    (N'External_Ticket'),
    (N'ExternalTicket'),
    (N'Facility'),
    (N'Feedback'),
    (N'History_Update_Voucher'),
    (N'Invoice'),
    (N'Meal_Package'),
    (N'Notification'),
    (N'Payments'),
    (N'Private_Tour_Quotation'),
    (N'Private_Tour_Request'),
    (N'Region'),
    (N'Report_Config'),
    (N'Request_Cancel'),
    (N'Restaurant'),
    (N'Role'),
    (N'Room'),
    (N'Room_Facility'),
    (N'Service'),
    (N'Service_Category'),
    (N'Service_Contract'),
    (N'Service_Partner'),
    (N'Staff'),
    (N'Tour'),
    (N'Tour_Approval_Log'),
    (N'Tour_Assignments'),
    (N'Tour_Category'),
    (N'Tour_Image'),
    (N'Tour_Itinerary'),
    (N'Tour_Optional_Service'),
    (N'Tour_Progress_Log'),
    (N'Tour_Schedule_Price_History'),
    (N'Tour_Schedule_Service_Assignment'),
    (N'Tour_Scheduler'),
    (N'Tour_Service_Detail'),
    (N'User'),
    (N'Vehicle'),
    (N'Vehicle_Brand'),
    (N'Voucher');

DECLARE @dropForeignKeysSql NVARCHAR(MAX) = N'';

SELECT @dropForeignKeysSql +=
    N'ALTER TABLE '
    + QUOTENAME(OBJECT_SCHEMA_NAME(fk.[parent_object_id]))
    + N'.'
    + QUOTENAME(OBJECT_NAME(fk.[parent_object_id]))
    + N' DROP CONSTRAINT '
    + QUOTENAME(fk.[name])
    + N';' + CHAR(13)
FROM sys.foreign_keys fk
WHERE OBJECT_SCHEMA_NAME(fk.[parent_object_id]) = N'dbo'
  AND (
        OBJECT_NAME(fk.[parent_object_id]) IN (SELECT [tableName] FROM @tablesToDrop)
        OR OBJECT_NAME(fk.[referenced_object_id]) IN (SELECT [tableName] FROM @tablesToDrop)
  );

IF LEN(@dropForeignKeysSql) > 0
BEGIN
    EXEC sp_executesql @dropForeignKeysSql;
END;
GO

DROP TABLE IF EXISTS [dbo].[Audit_Log];
DROP TABLE IF EXISTS [dbo].[Report_Config];
DROP TABLE IF EXISTS [dbo].[Blog];
DROP TABLE IF EXISTS [dbo].[Notification];
DROP TABLE IF EXISTS [dbo].[Request_Cancel];
DROP TABLE IF EXISTS [dbo].[Cancel_Reason];
DROP TABLE IF EXISTS [dbo].[Feedback];
DROP TABLE IF EXISTS [dbo].[Payments];
DROP TABLE IF EXISTS [dbo].[Booking_Traveler];
DROP TABLE IF EXISTS [dbo].[Booking_Detail];
DROP TABLE IF EXISTS [dbo].[Booking];
DROP TABLE IF EXISTS [dbo].[Invoice];
DROP TABLE IF EXISTS [dbo].[History_Update_Voucher];
DROP TABLE IF EXISTS [dbo].[Voucher];
DROP TABLE IF EXISTS [dbo].[Private_Tour_Quotation];
DROP TABLE IF EXISTS [dbo].[Private_Tour_Request];
DROP TABLE IF EXISTS [dbo].[Tour_Progress_Log];
DROP TABLE IF EXISTS [dbo].[Tour_Assignments];
DROP TABLE IF EXISTS [dbo].[Tour_Schedule_Price_History];
DROP TABLE IF EXISTS [dbo].[Tour_Schedule_Service_Assignment];
DROP TABLE IF EXISTS [dbo].[Tour_Scheduler];
DROP TABLE IF EXISTS [dbo].[Tour_Itinerary];
DROP TABLE IF EXISTS [dbo].[Tour_Image];
DROP TABLE IF EXISTS [dbo].[Tour_Approval_Log];
DROP TABLE IF EXISTS [dbo].[Tour];
DROP TABLE IF EXISTS [dbo].[Tour_Category];
DROP TABLE IF EXISTS [dbo].[Room_Facility];
DROP TABLE IF EXISTS [dbo].[Room];
DROP TABLE IF EXISTS [dbo].[Accommodation_Facility];
DROP TABLE IF EXISTS [dbo].[Accommodation];
DROP TABLE IF EXISTS [dbo].[Facility];
DROP TABLE IF EXISTS [dbo].[Destination];
DROP TABLE IF EXISTS [dbo].[Region];
DROP TABLE IF EXISTS [dbo].[Staff];
DROP TABLE IF EXISTS [dbo].[User];
DROP TABLE IF EXISTS [dbo].[Role];
DROP TABLE IF EXISTS [dbo].[Administrative_Unit];

DROP TABLE IF EXISTS [dbo].[Cart_Items];
DROP TABLE IF EXISTS [dbo].[Carts];
DROP TABLE IF EXISTS [dbo].[Vehicle];
DROP TABLE IF EXISTS [dbo].[Vehicle_Brand];
DROP TABLE IF EXISTS [dbo].[External_Ticket];
DROP TABLE IF EXISTS [dbo].[ExternalTicket];
DROP TABLE IF EXISTS [dbo].[External Ticket];
DROP TABLE IF EXISTS [dbo].[Entertainment];
DROP TABLE IF EXISTS [dbo].[Entertaiment];
DROP TABLE IF EXISTS [dbo].[Tour_Service_Detail];
DROP TABLE IF EXISTS [dbo].[Tour_Optional_Service];
DROP TABLE IF EXISTS [dbo].[Meal_Package];
DROP TABLE IF EXISTS [dbo].[Restaurant];
DROP TABLE IF EXISTS [dbo].[Service_Contract];
DROP TABLE IF EXISTS [dbo].[Service_Partner];
DROP TABLE IF EXISTS [dbo].[Service_Category];
DROP TABLE IF EXISTS [dbo].[Service];
GO

CREATE TABLE [dbo].[Role] (
    [roleID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [roleName] NVARCHAR(50) NOT NULL UNIQUE,
    [status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Role_Status] DEFAULT (N'Active')
);
GO

CREATE TABLE [dbo].[User] (
    [userID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [firstName] NVARCHAR(100) NOT NULL,
    [lastName] NVARCHAR(100) NOT NULL,
    [dob] DATE NULL,
    [email] NVARCHAR(255) NOT NULL UNIQUE,
    [phone] NVARCHAR(20) NULL,
    [gender] NVARCHAR(20) NULL,
    [address] NVARCHAR(255) NULL,
    [password] NVARCHAR(255) NOT NULL,
    [createAt] DATETIME NOT NULL CONSTRAINT [DF_User_CreateAt] DEFAULT (GETDATE()),
    [updateAt] DATETIME NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_User_Status] DEFAULT (N'Active'),
    [roleID] INT NOT NULL,
    CONSTRAINT [FK_User_Role] FOREIGN KEY ([roleID]) REFERENCES [dbo].[Role] ([roleID]),
    CONSTRAINT [CK_User_Status] CHECK ([status] IN (N'Active', N'Inactive', N'Blocked', N'Locked'))
);
GO

CREATE TABLE [dbo].[Staff] (
    [staffID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [userID] INT NOT NULL UNIQUE,
    [position] NVARCHAR(100) NULL,
    [hireDate] DATE NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Staff_Status] DEFAULT (N'Active'),
    CONSTRAINT [FK_Staff_User] FOREIGN KEY ([userID]) REFERENCES [dbo].[User] ([userID])
);
GO

CREATE TABLE [dbo].[Administrative_Unit] (
    [administrativeUnitID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [provinceCode] VARCHAR(2) NOT NULL,
    [provinceName] NVARCHAR(100) NOT NULL,
    [wardType] NVARCHAR(20) NOT NULL,
    [wardName] NVARCHAR(150) NOT NULL,
    [isActive] BIT NOT NULL CONSTRAINT [DF_Administrative_Unit_isActive] DEFAULT (1),
    [createdAt] DATETIME2(0) NOT NULL CONSTRAINT [DF_Administrative_Unit_createdAt] DEFAULT (SYSUTCDATETIME())
);
GO

CREATE INDEX [IX_Administrative_Unit_Province]
    ON [dbo].[Administrative_Unit] ([provinceCode], [provinceName]);
GO

CREATE INDEX [IX_Administrative_Unit_Province_Ward]
    ON [dbo].[Administrative_Unit] ([provinceName], [wardName]);
GO

CREATE TABLE [dbo].[Region] (
    [regionID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [regionName] NVARCHAR(100) NOT NULL UNIQUE,
    [description] NVARCHAR(500) NULL,
    [status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Region_Status] DEFAULT (N'Active')
);
GO

CREATE TABLE [dbo].[Destination] (
    [destinationID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [regionID] INT NULL,
    [destinationName] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(MAX) NULL,
    [status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Destination_Status] DEFAULT (N'Active'),
    CONSTRAINT [FK_Destination_Region] FOREIGN KEY ([regionID]) REFERENCES [dbo].[Region] ([regionID])
);
GO

CREATE TABLE [dbo].[Tour_Category] (
    [tourCategoryID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [categoryName] NVARCHAR(100) NOT NULL UNIQUE,
    [description] NVARCHAR(500) NULL,
    [status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Tour_Category_Status] DEFAULT (N'Active')
);
GO

CREATE TABLE [dbo].[Tour] (
    [tourID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [tourCategoryID] INT NOT NULL,
    [tourName] NVARCHAR(255) NOT NULL,
    [tourCode] NVARCHAR(50) NULL UNIQUE,
    [tourType] NVARCHAR(30) NULL,
    [numberOfDay] INT NOT NULL,
    [numberOfNights] INT NULL,
    [startPlace] NVARCHAR(255) NOT NULL,
    [endPlace] NVARCHAR(255) NOT NULL,
    [image] NVARCHAR(500) NULL,
    [adultPrice] DECIMAL(18,2) NOT NULL,
    [childrenPrice] DECIMAL(18,2) NOT NULL,
    [infantPrice] DECIMAL(18,2) NOT NULL CONSTRAINT [DF_Tour_InfantPrice] DEFAULT (0),
    [singleRoomSurcharge] DECIMAL(18,2) NOT NULL CONSTRAINT [DF_Tour_SingleRoomSurcharge] DEFAULT (0),
    [depositPercent] INT NOT NULL CONSTRAINT [DF_Tour_DepositPercent] DEFAULT (0),
    [vatPercent] INT NOT NULL CONSTRAINT [DF_Tour_VatPercent] DEFAULT (0),
    [tourIntroduce] NVARCHAR(MAX) NULL,
    [tourInclude] NVARCHAR(MAX) NULL,
    [tourNonInclude] NVARCHAR(MAX) NULL,
    [pickupPointName] NVARCHAR(255) NULL,
    [pickupAddress] NVARCHAR(500) NULL,
    [arriveBeforeMinutes] INT NULL,
    [pickupNote] NVARCHAR(500) NULL,
    [mainTransportType] NVARCHAR(50) NULL,
    [childPolicyNote] NVARCHAR(MAX) NULL,
    [rate] DECIMAL(3,2) NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Tour_Status] DEFAULT (N'Active'),
    [isFeatured] BIT NOT NULL CONSTRAINT [DF_Tour_IsFeatured] DEFAULT (0),
    [regionID] INT NULL,
    [createdByUserID] INT NULL,
    [approvedByUserID] INT NULL,
    [approvedAt] DATETIME NULL,
    [rejectionReason] NVARCHAR(MAX) NULL,
    [createdAt] DATETIME NOT NULL CONSTRAINT [DF_Tour_CreatedAt] DEFAULT (GETDATE()),
    [updatedAt] DATETIME NULL,
    CONSTRAINT [FK_Tour_TourCategory] FOREIGN KEY ([tourCategoryID]) REFERENCES [dbo].[Tour_Category] ([tourCategoryID]),
    CONSTRAINT [FK_Tour_Region] FOREIGN KEY ([regionID]) REFERENCES [dbo].[Region] ([regionID]),
    CONSTRAINT [FK_Tour_CreatedBy] FOREIGN KEY ([createdByUserID]) REFERENCES [dbo].[User] ([userID]),
    CONSTRAINT [FK_Tour_ApprovedBy] FOREIGN KEY ([approvedByUserID]) REFERENCES [dbo].[User] ([userID]),
    CONSTRAINT [CK_Tour_NumberOfDay] CHECK ([numberOfDay] > 0),
    CONSTRAINT [CK_Tour_Price] CHECK ([adultPrice] >= 0 AND [childrenPrice] >= 0 AND [infantPrice] >= 0),
    CONSTRAINT [CK_Tour_Rate] CHECK ([rate] IS NULL OR ([rate] >= 0 AND [rate] <= 5)),
    CONSTRAINT [CK_Tour_Percent] CHECK ([depositPercent] BETWEEN 0 AND 100 AND [vatPercent] BETWEEN 0 AND 100)
);
GO

CREATE TABLE [dbo].[Tour_Image] (
    [imageID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [tourID] INT NOT NULL,
    [imageUrl] NVARCHAR(500) NOT NULL,
    [caption] NVARCHAR(255) NULL,
    [displayOrder] INT NOT NULL CONSTRAINT [DF_Tour_Image_DisplayOrder] DEFAULT (1),
    [status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Tour_Image_Status] DEFAULT (N'Active'),
    CONSTRAINT [FK_Tour_Image_Tour] FOREIGN KEY ([tourID]) REFERENCES [dbo].[Tour] ([tourID]) ON DELETE CASCADE
);
GO

CREATE TABLE [dbo].[Tour_Itinerary] (
    [itineraryID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [tourID] INT NOT NULL,
    [dayNumber] INT NOT NULL,
    [title] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(MAX) NULL,
    [mealPlan] NVARCHAR(255) NULL,
    [transportNote] NVARCHAR(255) NULL,
    [status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Tour_Itinerary_Status] DEFAULT (N'Active'),
    CONSTRAINT [FK_Tour_Itinerary_Tour] FOREIGN KEY ([tourID]) REFERENCES [dbo].[Tour] ([tourID]) ON DELETE CASCADE,
    CONSTRAINT [CK_Tour_Itinerary_Day] CHECK ([dayNumber] > 0)
);
GO

CREATE TABLE [dbo].[Tour_Scheduler] (
    [tourScheduleID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [tourID] INT NOT NULL,
    [startDate] DATETIME NOT NULL,
    [endDate] DATETIME NOT NULL,
    [departureTime] TIME NULL,
    [expectedReturnTime] TIME NULL,
    [bookingDeadline] DATETIME NULL,
    [minParticipants] INT NOT NULL CONSTRAINT [DF_TourScheduler_MinParticipants] DEFAULT (1),
    [maxParticipants] INT NOT NULL,
    [quantity] INT NOT NULL,
    [bookedSeats] INT NOT NULL CONSTRAINT [DF_TourScheduler_BookedSeats] DEFAULT (0),
    [maxParticipantsPerBooking] INT NOT NULL CONSTRAINT [DF_TourScheduler_MaxPerBooking] DEFAULT (10),
    [adultPrice] DECIMAL(18,2) NULL,
    [childPrice] DECIMAL(18,2) NULL,
    [infantPrice] DECIMAL(18,2) NULL,
    [singleRoomSurcharge] DECIMAL(18,2) NULL,
    [depositPercent] INT NULL,
    [vatPercent] INT NULL,
    [cancellationPolicy] NVARCHAR(MAX) NULL,
    [scheduleStatus] NVARCHAR(30) NOT NULL CONSTRAINT [DF_TourScheduler_Status] DEFAULT (N'Open'),
    [createdAt] DATETIME NOT NULL CONSTRAINT [DF_TourScheduler_CreatedAt] DEFAULT (GETDATE()),
    [updatedAt] DATETIME NULL,
    CONSTRAINT [FK_TourScheduler_Tour] FOREIGN KEY ([tourID]) REFERENCES [dbo].[Tour] ([tourID]),
    CONSTRAINT [CK_TourScheduler_Date] CHECK ([endDate] >= [startDate]),
    CONSTRAINT [CK_TourScheduler_Quantity] CHECK ([maxParticipants] > 0 AND [quantity] >= 0 AND [quantity] <= [maxParticipants]),
    CONSTRAINT [CK_TourScheduler_BookedSeats] CHECK ([bookedSeats] >= 0 AND [bookedSeats] <= [maxParticipants])
);
GO

CREATE TABLE [dbo].[Tour_Schedule_Price_History] (
    [priceHistoryID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [tourScheduleID] INT NOT NULL,
    [oldAdultPrice] DECIMAL(18,2) NULL,
    [newAdultPrice] DECIMAL(18,2) NULL,
    [oldChildPrice] DECIMAL(18,2) NULL,
    [newChildPrice] DECIMAL(18,2) NULL,
    [changedByUserID] INT NULL,
    [changedAt] DATETIME NOT NULL CONSTRAINT [DF_Tour_Schedule_Price_History_ChangedAt] DEFAULT (GETDATE()),
    [note] NVARCHAR(500) NULL,
    CONSTRAINT [FK_Tour_Schedule_Price_History_Scheduler] FOREIGN KEY ([tourScheduleID]) REFERENCES [dbo].[Tour_Scheduler] ([tourScheduleID]),
    CONSTRAINT [FK_Tour_Schedule_Price_History_User] FOREIGN KEY ([changedByUserID]) REFERENCES [dbo].[User] ([userID])
);
GO

CREATE TABLE [dbo].[Tour_Assignments] (
    [assignmentID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [tourScheduleID] INT NOT NULL,
    [userID] INT NOT NULL,
    [roleInTour] NVARCHAR(100) NOT NULL,
    [assignmentStatus] NVARCHAR(30) NOT NULL CONSTRAINT [DF_Tour_Assignments_Status] DEFAULT (N'Assigned'),
    [note] NVARCHAR(500) NULL,
    [createdAt] DATETIME NOT NULL CONSTRAINT [DF_Tour_Assignments_CreatedAt] DEFAULT (GETDATE()),
    [updatedAt] DATETIME NULL,
    CONSTRAINT [FK_TourAssignments_TourScheduler] FOREIGN KEY ([tourScheduleID]) REFERENCES [dbo].[Tour_Scheduler] ([tourScheduleID]),
    CONSTRAINT [FK_TourAssignments_User] FOREIGN KEY ([userID]) REFERENCES [dbo].[User] ([userID])
);
GO

CREATE TABLE [dbo].[Tour_Progress_Log] (
    [progressLogID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [tourScheduleID] INT NOT NULL,
    [assignmentID] INT NULL,
    [loggedByUserID] INT NULL,
    [logTime] DATETIME NOT NULL CONSTRAINT [DF_Tour_Progress_Log_LogTime] DEFAULT (GETDATE()),
    [progressStatus] NVARCHAR(50) NOT NULL,
    [title] NVARCHAR(255) NULL,
    [content] NVARCHAR(MAX) NULL,
    CONSTRAINT [FK_Tour_Progress_Log_Scheduler] FOREIGN KEY ([tourScheduleID]) REFERENCES [dbo].[Tour_Scheduler] ([tourScheduleID]),
    CONSTRAINT [FK_Tour_Progress_Log_Assignment] FOREIGN KEY ([assignmentID]) REFERENCES [dbo].[Tour_Assignments] ([assignmentID]),
    CONSTRAINT [FK_Tour_Progress_Log_User] FOREIGN KEY ([loggedByUserID]) REFERENCES [dbo].[User] ([userID])
);
GO

CREATE TABLE [dbo].[Facility] (
    [facilityID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [facilityName] NVARCHAR(100) NOT NULL,
    [icon] NVARCHAR(100) NULL,
    [facilityScope] NVARCHAR(30) NOT NULL,
    [status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Facility_Status] DEFAULT (N'Active'),
    CONSTRAINT [CK_Facility_Scope] CHECK ([facilityScope] IN (N'Accommodation', N'Room', N'Both')),
    CONSTRAINT [CK_Facility_Status] CHECK ([status] IN (N'Active', N'Inactive'))
);
GO

CREATE TABLE [dbo].[Accommodation] (
    [accommodationID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [name] NVARCHAR(255) NOT NULL,
    [image] NVARCHAR(MAX) NULL,
    [address] NVARCHAR(255) NOT NULL,
    [phone] NVARCHAR(20) NULL,
    [description] NVARCHAR(MAX) NULL,
    [rate] DECIMAL(3,2) NULL,
    [type] NVARCHAR(100) NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Accommodation_Status] DEFAULT (N'Available'),
    [checkInTime] TIME NULL,
    [checkOutTime] TIME NULL,
    [province] NVARCHAR(100) NULL,
    [district] NVARCHAR(100) NULL,
    [ward] NVARCHAR(100) NULL,
    [createdByUserID] INT NULL,
    [createdAt] DATETIME NOT NULL CONSTRAINT [DF_Accommodation_CreatedAt] DEFAULT (GETDATE()),
    [updatedAt] DATETIME NULL,
    CONSTRAINT [FK_Accommodation_CreatedBy] FOREIGN KEY ([createdByUserID]) REFERENCES [dbo].[User] ([userID]),
    CONSTRAINT [CK_Accommodation_Rate] CHECK ([rate] IS NULL OR ([rate] >= 0 AND [rate] <= 5))
);
GO

CREATE TABLE [dbo].[Accommodation_Facility] (
    [accommodationID] INT NOT NULL,
    [facilityID] INT NOT NULL,
    CONSTRAINT [PK_Accommodation_Facility] PRIMARY KEY ([accommodationID], [facilityID]),
    CONSTRAINT [FK_AccommodationFacility_Accommodation] FOREIGN KEY ([accommodationID]) REFERENCES [dbo].[Accommodation] ([accommodationID]) ON DELETE CASCADE,
    CONSTRAINT [FK_AccommodationFacility_Facility] FOREIGN KEY ([facilityID]) REFERENCES [dbo].[Facility] ([facilityID])
);
GO

CREATE TABLE [dbo].[Room] (
    [roomID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [accommodationID] INT NOT NULL,
    [roomType] NVARCHAR(100) NOT NULL,
    [numberOfRooms] INT NOT NULL,
    [priceOfRoom] DECIMAL(18,2) NOT NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Room_Status] DEFAULT (N'Available'),
    [roomAvailability] INT NOT NULL,
    [image] NVARCHAR(500) NULL,
    [description] NVARCHAR(MAX) NULL,
    [bedCount] INT NOT NULL,
    [bedType] NVARCHAR(50) NULL,
    [maxAdults] INT NOT NULL,
    [maxChildren] INT NOT NULL CONSTRAINT [DF_Room_MaxChildren] DEFAULT (0),
    [roomSize] DECIMAL(10,2) NULL,
    [createdAt] DATETIME NOT NULL CONSTRAINT [DF_Room_CreatedAt] DEFAULT (GETDATE()),
    [updatedAt] DATETIME NULL,
    CONSTRAINT [FK_Room_Accommodation] FOREIGN KEY ([accommodationID]) REFERENCES [dbo].[Accommodation] ([accommodationID]) ON DELETE CASCADE,
    CONSTRAINT [CK_Room_NumberOfRooms] CHECK ([numberOfRooms] >= 0),
    CONSTRAINT [CK_Room_Availability] CHECK ([roomAvailability] >= 0 AND [roomAvailability] <= [numberOfRooms]),
    CONSTRAINT [CK_Room_Price] CHECK ([priceOfRoom] > 0),
    CONSTRAINT [CK_Room_Capacity] CHECK ([bedCount] > 0 AND [maxAdults] > 0 AND [maxChildren] >= 0)
);
GO

CREATE TABLE [dbo].[Room_Facility] (
    [roomID] INT NOT NULL,
    [facilityID] INT NOT NULL,
    CONSTRAINT [PK_Room_Facility] PRIMARY KEY ([roomID], [facilityID]),
    CONSTRAINT [FK_RoomFacility_Room] FOREIGN KEY ([roomID]) REFERENCES [dbo].[Room] ([roomID]) ON DELETE CASCADE,
    CONSTRAINT [FK_RoomFacility_Facility] FOREIGN KEY ([facilityID]) REFERENCES [dbo].[Facility] ([facilityID])
);
GO

CREATE TABLE [dbo].[Voucher] (
    [voucherID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [code] NVARCHAR(50) NOT NULL UNIQUE,
    [description] NVARCHAR(500) NULL,
    [percentDiscount] DECIMAL(5,2) NULL,
    [amountDiscount] DECIMAL(18,2) NULL,
    [minOrderAmount] DECIMAL(18,2) NULL,
    [quantity] INT NOT NULL CONSTRAINT [DF_Voucher_Quantity] DEFAULT (0),
    [startDate] DATETIME NOT NULL,
    [endDate] DATETIME NOT NULL,
    [status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Voucher_Status] DEFAULT (N'Active'),
    [createdAt] DATETIME NOT NULL CONSTRAINT [DF_Voucher_CreatedAt] DEFAULT (GETDATE()),
    [updatedAt] DATETIME NULL,
    CONSTRAINT [CK_Voucher_Date] CHECK ([endDate] >= [startDate]),
    CONSTRAINT [CK_Voucher_PercentDiscount] CHECK ([percentDiscount] IS NULL OR ([percentDiscount] >= 0 AND [percentDiscount] <= 100)),
    CONSTRAINT [CK_Voucher_Quantity] CHECK ([quantity] >= 0)
);
GO

CREATE TABLE [dbo].[History_Update_Voucher] (
    [historyID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [voucherID] INT NOT NULL,
    [updateBy] INT NULL,
    [oldValue] NVARCHAR(MAX) NULL,
    [newValue] NVARCHAR(MAX) NULL,
    [updatedAt] DATETIME NOT NULL CONSTRAINT [DF_History_Update_Voucher_UpdatedAt] DEFAULT (GETDATE()),
    [note] NVARCHAR(500) NULL,
    CONSTRAINT [FK_HistoryUpdateVoucher_Voucher] FOREIGN KEY ([voucherID]) REFERENCES [dbo].[Voucher] ([voucherID]),
    CONSTRAINT [FK_HistoryUpdateVoucher_User] FOREIGN KEY ([updateBy]) REFERENCES [dbo].[User] ([userID])
);
GO

CREATE TABLE [dbo].[Booking] (
    [bookingID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [bookingCode] NVARCHAR(50) NOT NULL UNIQUE,
    [bookingType] NVARCHAR(100) NOT NULL,
    [email] NVARCHAR(255) NOT NULL,
    [phone] NVARCHAR(20) NOT NULL,
    [numberAdult] INT NOT NULL,
    [numberChildren] INT NOT NULL CONSTRAINT [DF_Booking_NumberChildren] DEFAULT (0),
    [numberInfant] INT NOT NULL CONSTRAINT [DF_Booking_NumberInfant] DEFAULT (0),
    [note] NVARCHAR(MAX) NULL,
    [identityNumber] NVARCHAR(50) NULL,
    [identityImageUrl] NVARCHAR(500) NULL,
    [address] NVARCHAR(255) NULL,
    [firstName] NVARCHAR(100) NOT NULL,
    [lastName] NVARCHAR(100) NOT NULL,
    [userID] INT NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Booking_Status] DEFAULT (N'Pending'),
    [bookDate] DATETIME NOT NULL CONSTRAINT [DF_Booking_BookDate] DEFAULT (GETDATE()),
    [isBookedForOther] BIT NOT NULL CONSTRAINT [DF_Booking_IsBookedForOther] DEFAULT (0),
    [totalPrice] DECIMAL(18,2) NOT NULL,
    [depositAmount] DECIMAL(18,2) NULL,
    [remainingAmount] DECIMAL(18,2) NULL,
    [voucherID] INT NULL,
    [updatedAt] DATETIME NULL,
    CONSTRAINT [FK_Booking_User] FOREIGN KEY ([userID]) REFERENCES [dbo].[User] ([userID]),
    CONSTRAINT [FK_Booking_Voucher] FOREIGN KEY ([voucherID]) REFERENCES [dbo].[Voucher] ([voucherID]),
    CONSTRAINT [CK_Booking_Type] CHECK ([bookingType] IN (N'Tour', N'Accommodation')),
    CONSTRAINT [CK_Booking_NumberPeople] CHECK ([numberAdult] >= 0 AND [numberChildren] >= 0 AND [numberInfant] >= 0),
    CONSTRAINT [CK_Booking_TotalPrice] CHECK ([totalPrice] >= 0)
);
GO

CREATE TABLE [dbo].[Booking_Detail] (
    [bookingDetailID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [bookingID] INT NOT NULL,
    [tourScheduleID] INT NULL,
    [accommodationID] INT NULL,
    [roomID] INT NULL,
    [quantity] INT NOT NULL,
    [unitPrice] DECIMAL(18,2) NOT NULL,
    [subTotal] DECIMAL(18,2) NOT NULL,
    [startDate] DATETIME NULL,
    [endDate] DATETIME NULL,
    [note] NVARCHAR(MAX) NULL,
    CONSTRAINT [FK_BookingDetail_Booking] FOREIGN KEY ([bookingID]) REFERENCES [dbo].[Booking] ([bookingID]) ON DELETE CASCADE,
    CONSTRAINT [FK_BookingDetail_TourScheduler] FOREIGN KEY ([tourScheduleID]) REFERENCES [dbo].[Tour_Scheduler] ([tourScheduleID]),
    CONSTRAINT [FK_BookingDetail_Accommodation] FOREIGN KEY ([accommodationID]) REFERENCES [dbo].[Accommodation] ([accommodationID]),
    CONSTRAINT [FK_BookingDetail_Room] FOREIGN KEY ([roomID]) REFERENCES [dbo].[Room] ([roomID]),
    CONSTRAINT [CK_BookingDetail_Tour_Or_Accommodation] CHECK (
        ([tourScheduleID] IS NOT NULL AND [accommodationID] IS NULL AND [roomID] IS NULL)
        OR
        ([tourScheduleID] IS NULL AND [accommodationID] IS NOT NULL)
    ),
    CONSTRAINT [CK_BookingDetail_Quantity] CHECK ([quantity] > 0),
    CONSTRAINT [CK_BookingDetail_Price] CHECK ([unitPrice] >= 0 AND [subTotal] >= 0),
    CONSTRAINT [CK_BookingDetail_Date] CHECK ([endDate] IS NULL OR [startDate] IS NULL OR [endDate] >= [startDate])
);
GO

CREATE TABLE [dbo].[Booking_Traveler] (
    [travelerID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [bookingID] INT NOT NULL,
    [fullName] NVARCHAR(255) NOT NULL,
    [gender] NVARCHAR(20) NULL,
    [dateOfBirth] DATE NULL,
    [travelerType] NVARCHAR(20) NOT NULL,
    [phone] NVARCHAR(20) NULL,
    [identityNumber] NVARCHAR(50) NULL,
    [travelerStatus] NVARCHAR(30) NOT NULL CONSTRAINT [DF_Booking_Traveler_Status] DEFAULT (N'Pending'),
    [note] NVARCHAR(500) NULL,
    CONSTRAINT [FK_Booking_Traveler_Booking] FOREIGN KEY ([bookingID]) REFERENCES [dbo].[Booking] ([bookingID]) ON DELETE CASCADE
);
GO

CREATE TABLE [dbo].[Payments] (
    [paymentID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [bookingID] INT NOT NULL,
    [payment_method] NVARCHAR(100) NOT NULL,
    [totalAmount] DECIMAL(18,2) NOT NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Payments_Status] DEFAULT (N'Pending'),
    [paymentType] NVARCHAR(30) NULL,
    [transactionCode] NVARCHAR(100) NULL,
    [paymentDate] DATETIME NULL,
    [note] NVARCHAR(500) NULL,
    [createdAt] DATETIME NOT NULL CONSTRAINT [DF_Payments_CreatedAt] DEFAULT (GETDATE()),
    CONSTRAINT [FK_Payments_Booking] FOREIGN KEY ([bookingID]) REFERENCES [dbo].[Booking] ([bookingID]),
    CONSTRAINT [CK_Payments_TotalAmount] CHECK ([totalAmount] >= 0)
);
GO

CREATE TABLE [dbo].[Feedback] (
    [feedbackID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [bookingID] INT NOT NULL,
    [userID] INT NULL,
    [rate] INT NOT NULL,
    [comment] NVARCHAR(MAX) NULL,
    [staffReply] NVARCHAR(MAX) NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Feedback_Status] DEFAULT (N'Visible'),
    [createdAt] DATETIME NOT NULL CONSTRAINT [DF_Feedback_CreatedAt] DEFAULT (GETDATE()),
    [updatedAt] DATETIME NULL,
    CONSTRAINT [FK_Feedback_Booking] FOREIGN KEY ([bookingID]) REFERENCES [dbo].[Booking] ([bookingID]),
    CONSTRAINT [FK_Feedback_User] FOREIGN KEY ([userID]) REFERENCES [dbo].[User] ([userID]),
    CONSTRAINT [CK_Feedback_Rate] CHECK ([rate] BETWEEN 0 AND 5)
);
GO

CREATE TABLE [dbo].[Cancel_Reason] (
    [cancelReasonID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [reason] NVARCHAR(MAX) NOT NULL,
    [status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Cancel_Reason_Status] DEFAULT (N'Active')
);
GO

CREATE TABLE [dbo].[Request_Cancel] (
    [requestCancelID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [cancelReasonID] INT NULL,
    [bookingID] INT NOT NULL,
    [requestDate] DATETIME NOT NULL CONSTRAINT [DF_Request_Cancel_RequestDate] DEFAULT (GETDATE()),
    [reason] NVARCHAR(MAX) NULL,
    [note] NVARCHAR(MAX) NULL,
    [refundAmount] DECIMAL(18,2) NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Request_Cancel_Status] DEFAULT (N'Pending'),
    [processedByUserID] INT NULL,
    [processedAt] DATETIME NULL,
    CONSTRAINT [FK_RequestCancel_Booking] FOREIGN KEY ([bookingID]) REFERENCES [dbo].[Booking] ([bookingID]),
    CONSTRAINT [FK_RequestCancel_CancelReason] FOREIGN KEY ([cancelReasonID]) REFERENCES [dbo].[Cancel_Reason] ([cancelReasonID]),
    CONSTRAINT [FK_RequestCancel_ProcessedBy] FOREIGN KEY ([processedByUserID]) REFERENCES [dbo].[User] ([userID]),
    CONSTRAINT [CK_RequestCancel_RefundAmount] CHECK ([refundAmount] IS NULL OR [refundAmount] >= 0)
);
GO

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
    [updatedAt] DATETIME NULL,
    CONSTRAINT [FK_Blog_User] FOREIGN KEY ([authorUserID]) REFERENCES [dbo].[User] ([userID])
);
GO

CREATE UNIQUE INDEX [UX_Blog_Slug]
    ON [dbo].[Blog] ([slug])
    WHERE [slug] IS NOT NULL;
GO

CREATE TABLE [dbo].[Report_Config] (
    [reportID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [reportName] NVARCHAR(255) NOT NULL,
    [reportType] NVARCHAR(100) NOT NULL,
    [filterJson] NVARCHAR(MAX) NULL,
    [status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Report_Config_Status] DEFAULT (N'Active'),
    [createdByUserID] INT NULL,
    [createdAt] DATETIME NOT NULL CONSTRAINT [DF_Report_Config_CreatedAt] DEFAULT (GETDATE()),
    [updatedAt] DATETIME NULL,
    CONSTRAINT [FK_Report_Config_User] FOREIGN KEY ([createdByUserID]) REFERENCES [dbo].[User] ([userID])
);
GO

CREATE TABLE [dbo].[Audit_Log] (
    [auditLogID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [userID] INT NULL,
    [action] NVARCHAR(100) NOT NULL,
    [tableName] NVARCHAR(100) NULL,
    [recordID] NVARCHAR(100) NULL,
    [oldValue] NVARCHAR(MAX) NULL,
    [newValue] NVARCHAR(MAX) NULL,
    [createdAt] DATETIME NOT NULL CONSTRAINT [DF_Audit_Log_CreatedAt] DEFAULT (GETDATE()),
    CONSTRAINT [FK_Audit_Log_User] FOREIGN KEY ([userID]) REFERENCES [dbo].[User] ([userID])
);
GO

CREATE INDEX [IX_Booking_User] ON [dbo].[Booking] ([userID]);
CREATE INDEX [IX_Booking_Status_Type] ON [dbo].[Booking] ([status], [bookingType]);
CREATE INDEX [IX_Booking_Detail_TourSchedule] ON [dbo].[Booking_Detail] ([tourScheduleID]);
CREATE INDEX [IX_Booking_Detail_Accommodation] ON [dbo].[Booking_Detail] ([accommodationID], [roomID]);
CREATE INDEX [IX_Room_Accommodation] ON [dbo].[Room] ([accommodationID]);
CREATE INDEX [IX_Tour_Scheduler_Tour_Date] ON [dbo].[Tour_Scheduler] ([tourID], [startDate]);
CREATE INDEX [IX_Feedback_Booking] ON [dbo].[Feedback] ([bookingID]);
GO

INSERT INTO [dbo].[Role] ([roleName], [status])
VALUES
    (N'Admin', N'Active'),
    (N'Staff', N'Active'),
    (N'TourGuide', N'Active'),
    (N'Customer', N'Active');
GO

INSERT INTO [dbo].[Region] ([regionName], [description], [status])
VALUES
    (N'Miền Bắc', N'Các điểm đến phía Bắc Việt Nam', N'Active'),
    (N'Miền Trung', N'Các điểm đến miền Trung Việt Nam', N'Active'),
    (N'Miền Nam', N'Các điểm đến phía Nam Việt Nam', N'Active');
GO

INSERT INTO [dbo].[Tour_Category] ([categoryName], [description], [status])
VALUES
    (N'Tour gia đình', N'Tour phù hợp gia đình và nhóm nhỏ', N'Active'),
    (N'Tour nghỉ dưỡng', N'Tour nghỉ dưỡng, thư giãn', N'Active'),
    (N'Tour khám phá', N'Tour trải nghiệm, tham quan, khám phá', N'Active');
GO

INSERT INTO [dbo].[Facility] ([facilityName], [icon], [facilityScope], [status])
VALUES
    (N'Wifi', N'fa-wifi', N'Both', N'Active'),
    (N'Điều hòa', N'fa-snowflake', N'Room', N'Active'),
    (N'Bữa sáng', N'fa-mug-saucer', N'Accommodation', N'Active'),
    (N'Bãi đỗ xe', N'fa-square-parking', N'Accommodation', N'Active'),
    (N'Hồ bơi', N'fa-person-swimming', N'Accommodation', N'Active'),
    (N'Phòng tắm riêng', N'fa-bath', N'Room', N'Active');
GO

INSERT INTO [dbo].[Cancel_Reason] ([reason], [status])
VALUES
    (N'Khách thay đổi lịch trình', N'Active'),
    (N'Khách nhập sai thông tin đặt chỗ', N'Active'),
    (N'Không đủ điều kiện thanh toán', N'Active'),
    (N'Lý do khác', N'Active');
GO

DECLARE @adminRoleID INT = (SELECT [roleID] FROM [dbo].[Role] WHERE [roleName] = N'Admin');
DECLARE @staffRoleID INT = (SELECT [roleID] FROM [dbo].[Role] WHERE [roleName] = N'Staff');
DECLARE @customerRoleID INT = (SELECT [roleID] FROM [dbo].[Role] WHERE [roleName] = N'Customer');
DECLARE @guideRoleID INT = (SELECT [roleID] FROM [dbo].[Role] WHERE [roleName] = N'TourGuide');

INSERT INTO [dbo].[User] ([firstName], [lastName], [dob], [email], [phone], [gender], [address], [password], [status], [roleID])
VALUES (N'Admin', N'WonderVN', '1995-01-01', N'admin@wonder.vn', N'0900000001', N'Other', N'Hà Nội', N'123', N'Active', @adminRoleID);
DECLARE @adminID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[User] ([firstName], [lastName], [dob], [email], [phone], [gender], [address], [password], [status], [roleID])
VALUES (N'Staff', N'WonderVN', '1996-02-02', N'staff@wonder.vn', N'0900000002', N'Other', N'Hà Nội', N'123', N'Active', @staffRoleID);
DECLARE @staffID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[User] ([firstName], [lastName], [dob], [email], [phone], [gender], [address], [password], [status], [roleID])
VALUES (N'Minh', N'Anh', '2000-03-03', N'customer@wonder.vn', N'0900000003', N'Female', N'12 Tràng Tiền, Hà Nội', N'123', N'Active', @customerRoleID);
DECLARE @customerID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[User] ([firstName], [lastName], [dob], [email], [phone], [gender], [address], [password], [status], [roleID])
VALUES (N'Hướng dẫn', N'Viên', '1994-04-04', N'guide@wonder.vn', N'0900000004', N'Other', N'Đà Nẵng', N'123', N'Active', @guideRoleID);
DECLARE @guideID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[Staff] ([userID], [position], [hireDate], [status])
VALUES (@staffID, N'Booking Staff', CAST(GETDATE() AS DATE), N'Active');

DECLARE @northRegionID INT = (SELECT TOP 1 [regionID] FROM [dbo].[Region] WHERE [regionName] = N'Miền Bắc');
DECLARE @centralRegionID INT = (SELECT TOP 1 [regionID] FROM [dbo].[Region] WHERE [regionName] = N'Miền Trung');
DECLARE @familyCategoryID INT = (SELECT TOP 1 [tourCategoryID] FROM [dbo].[Tour_Category] WHERE [categoryName] = N'Tour gia đình');

INSERT INTO [dbo].[Destination] ([regionID], [destinationName], [description], [status])
VALUES
    (@northRegionID, N'Hạ Long', N'Vịnh biển nổi tiếng phù hợp tour nghỉ dưỡng.', N'Active'),
    (@centralRegionID, N'Đà Nẵng', N'Thành phố biển và điểm trung chuyển miền Trung.', N'Active');

INSERT INTO [dbo].[Tour] (
    [tourCategoryID], [tourName], [tourCode], [tourType], [numberOfDay], [numberOfNights],
    [startPlace], [endPlace], [image], [adultPrice], [childrenPrice], [infantPrice],
    [singleRoomSurcharge], [depositPercent], [vatPercent], [tourIntroduce],
    [tourInclude], [tourNonInclude], [pickupPointName], [pickupAddress],
    [arriveBeforeMinutes], [pickupNote], [mainTransportType], [childPolicyNote],
    [rate], [status], [isFeatured], [regionID], [createdByUserID]
)
VALUES (
    @familyCategoryID, N'Hà Nội - Hạ Long 2N1Đ', N'TOUR-HL-2N1D', N'Package', 2, 1,
    N'Hà Nội', N'Hạ Long', N'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80',
    2500000, 1800000, 0, 450000, 30, 8,
    N'Lịch trình ngắn ngày cho gia đình và nhóm bạn.',
    N'Xe đưa đón, hướng dẫn viên, vé tham quan, 1 đêm khách sạn.',
    N'Chi phí cá nhân và đồ uống ngoài chương trình.',
    N'Nhà hát Lớn Hà Nội', N'1 Tràng Tiền, Hoàn Kiếm, Hà Nội',
    30, N'Có mặt trước giờ khởi hành 30 phút.', N'Bus', N'Trẻ em tính theo chính sách tour.',
    4.80, N'Active', 1, @northRegionID, @staffID
);
DECLARE @tourID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[Tour_Itinerary] ([tourID], [dayNumber], [title], [description], [mealPlan], [transportNote], [status])
VALUES
    (@tourID, 1, N'Hà Nội - Hạ Long', N'Di chuyển đến Hạ Long, tham quan vịnh và nhận phòng.', N'Trưa, tối', N'Xe du lịch', N'Active'),
    (@tourID, 2, N'Hạ Long - Hà Nội', N'Tự do buổi sáng, trả phòng và về Hà Nội.', N'Sáng, trưa', N'Xe du lịch', N'Active');

INSERT INTO [dbo].[Tour_Scheduler] (
    [tourID], [startDate], [endDate], [departureTime], [expectedReturnTime], [bookingDeadline],
    [minParticipants], [maxParticipants], [quantity], [bookedSeats], [maxParticipantsPerBooking],
    [adultPrice], [childPrice], [infantPrice], [singleRoomSurcharge], [depositPercent],
    [vatPercent], [cancellationPolicy], [scheduleStatus]
)
VALUES (
    @tourID, DATEADD(DAY, 14, CAST(GETDATE() AS DATE)), DATEADD(DAY, 15, CAST(GETDATE() AS DATE)),
    '07:00', '18:30', DATEADD(DAY, 10, GETDATE()),
    4, 30, 2, 2, 8,
    2500000, 1800000, 0, 450000, 30, 8,
    N'Hủy trước 7 ngày hoàn 70% giá trị tour.', N'Open'
);
DECLARE @tourScheduleID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[Tour_Assignments] ([tourScheduleID], [userID], [roleInTour], [assignmentStatus], [note])
VALUES (@tourScheduleID, @guideID, N'TourGuide', N'Assigned', N'Hướng dẫn viên chính cho tour mẫu');
DECLARE @assignmentID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[Tour_Progress_Log] ([tourScheduleID], [assignmentID], [loggedByUserID], [progressStatus], [title], [content])
VALUES (@tourScheduleID, @assignmentID, @guideID, N'Planned', N'Chuẩn bị khởi hành', N'Lịch trình mẫu đã sẵn sàng.');

INSERT INTO [dbo].[Accommodation] (
    [name], [image], [address], [phone], [description], [rate], [type], [status],
    [checkInTime], [checkOutTime], [province], [district], [ward], [createdByUserID]
)
VALUES (
    N'Wonder Hotel Hà Nội',
    N'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80',
    N'25 Lý Thường Kiệt', N'02439990000',
    N'Khách sạn trung tâm phù hợp khách công tác và du lịch gia đình.',
    4.60, N'Hotel', N'Available', '14:00', '12:00',
    N'Hà Nội', N'Hoàn Kiếm', N'Cửa Nam', @staffID
);
DECLARE @accommodationID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[Accommodation_Facility] ([accommodationID], [facilityID])
SELECT @accommodationID, [facilityID]
FROM [dbo].[Facility]
WHERE [facilityName] IN (N'Wifi', N'Bữa sáng', N'Bãi đỗ xe');

INSERT INTO [dbo].[Room] (
    [accommodationID], [roomType], [numberOfRooms], [priceOfRoom], [status], [roomAvailability],
    [image], [description], [bedCount], [bedType], [maxAdults], [maxChildren], [roomSize]
)
VALUES (
    @accommodationID, N'Deluxe Double', 8, 950000, N'Available', 7,
    N'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=1200&q=80',
    N'Phòng đôi có cửa sổ, bàn làm việc và phòng tắm riêng.',
    1, N'Queen', 2, 1, 28
);
DECLARE @roomID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[Room_Facility] ([roomID], [facilityID])
SELECT @roomID, [facilityID]
FROM [dbo].[Facility]
WHERE [facilityName] IN (N'Wifi', N'Điều hòa', N'Phòng tắm riêng');

INSERT INTO [dbo].[Voucher] ([code], [description], [percentDiscount], [amountDiscount], [minOrderAmount], [quantity], [startDate], [endDate], [status])
VALUES (N'WONDER10', N'Giảm 10% cho booking mẫu', 10, NULL, 1000000, 50, GETDATE(), DATEADD(DAY, 90, GETDATE()), N'Active');

INSERT INTO [dbo].[Booking] (
    [bookingCode], [bookingType], [email], [phone], [numberAdult], [numberChildren],
    [note], [identityNumber], [identityImageUrl], [address], [firstName], [lastName],
    [userID], [status], [bookDate], [isBookedForOther], [totalPrice]
)
VALUES (
    N'AC-100001', N'Accommodation', N'customer@wonder.vn', N'0900000003', 2, 0,
    N'Khách muốn phòng yên tĩnh.', N'001203006697',
    N'https://placehold.co/640x400?text=CCCD+Demo',
    N'12 Tràng Tiền, Hà Nội', N'Minh', N'Anh',
    @customerID, N'Pending', GETDATE(), 0, 1900000
);
DECLARE @accommodationBookingID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[Booking_Detail] (
    [bookingID], [accommodationID], [roomID], [quantity], [unitPrice], [subTotal], [startDate], [endDate], [note]
)
VALUES (
    @accommodationBookingID, @accommodationID, @roomID, 1, 950000, 1900000,
    DATEADD(DAY, 7, CAST(GETDATE() AS DATE)), DATEADD(DAY, 9, CAST(GETDATE() AS DATE)),
    N'2 đêm lưu trú'
);

INSERT INTO [dbo].[Booking] (
    [bookingCode], [bookingType], [email], [phone], [numberAdult], [numberChildren],
    [note], [address], [firstName], [lastName], [userID], [status], [bookDate],
    [isBookedForOther], [totalPrice]
)
VALUES (
    N'TR-100001', N'Tour', N'customer@wonder.vn', N'0900000003', 2, 0,
    N'Khách ăn bình thường.', N'12 Tràng Tiền, Hà Nội', N'Minh', N'Anh',
    @customerID, N'Pending', GETDATE(), 0, 5000000
);
DECLARE @tourBookingID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[Booking_Detail] (
    [bookingID], [tourScheduleID], [quantity], [unitPrice], [subTotal], [note]
)
VALUES (@tourBookingID, @tourScheduleID, 2, 2500000, 5000000, N'2 người lớn');

INSERT INTO [dbo].[Booking_Traveler] (
    [bookingID], [fullName], [gender], [dateOfBirth], [travelerType],
    [phone], [identityNumber], [travelerStatus], [note]
)
VALUES
    (@tourBookingID, N'Nguyễn Minh Anh', N'Female', '2000-03-03', N'Adult', N'0900000003', N'001203006697', N'Pending', N'Khách đại diện'),
    (@tourBookingID, N'Trần Gia Bảo', N'Male', '1999-08-18', N'Adult', N'0900000005', N'001199008888', N'Pending', N'Đi cùng nhóm');

INSERT INTO [dbo].[Payments] ([bookingID], [payment_method], [totalAmount], [status], [paymentType], [note])
VALUES
    (@accommodationBookingID, N'Cash', 1900000, N'Pending', N'Full', N'Thanh toán khi nhận phòng'),
    (@tourBookingID, N'BankTransfer', 1500000, N'Pending', N'Deposit', N'Cọc 30%');

INSERT INTO [dbo].[Blog] ([title], [slug], [image], [summary], [content], [authorUserID], [status])
VALUES (
    N'Kinh nghiệm đặt tour và lưu trú trên WonderVN',
    N'kinh-nghiem-dat-tour-luu-tru-wondervn',
    N'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
    N'Một vài lưu ý khi chọn lịch tour, ngày nhận phòng và thông tin CCCD.',
    N'Khách hàng nên kiểm tra ngày đi, ngày nhận phòng, số khách và chuẩn bị ảnh CCCD rõ nét khi đặt phòng.',
    @staffID,
    N'Published'
);
GO

SELECT N'WonderVn core database without Service created successfully.' AS [message];
GO
