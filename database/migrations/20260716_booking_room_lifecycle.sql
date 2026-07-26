USE [WonderVn];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;

-- Normalize legacy booking values without collapsing Approved into Completed.
UPDATE [dbo].[Booking]
SET [status] = CASE
    WHEN [status] = N'Pending' THEN N'Đang xử lý'
    WHEN [status] = N'Confirmed' THEN N'Đã duyệt'
    WHEN [status] = N'Completed' THEN N'Hoàn thành'
    WHEN [status] = N'Cancelled' THEN N'Đã hủy'
    ELSE [status]
END
WHERE [status] IN (N'Pending', N'Confirmed', N'Completed', N'Cancelled');

-- Old code globally decremented this value for every booking. From now on it is
-- the operational room capacity; date-based reservations are calculated from Booking_Detail.
UPDATE [dbo].[Room]
SET roomAvailability = numberOfRooms,
    updatedAt = GETDATE()
WHERE [status] IN (N'Available', N'Active')
  AND roomAvailability <> numberOfRooms;

COMMIT TRANSACTION;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE [name] = N'IX_BookingDetail_Room_DateRange'
      AND [object_id] = OBJECT_ID(N'[dbo].[Booking_Detail]')
)
BEGIN
    CREATE INDEX [IX_BookingDetail_Room_DateRange]
        ON [dbo].[Booking_Detail] (roomID, startDate, endDate)
        INCLUDE (bookingID, quantity);
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE [name] = N'IX_Booking_Status_Type'
      AND [object_id] = OBJECT_ID(N'[dbo].[Booking]')
)
BEGIN
    CREATE INDEX [IX_Booking_Status_Type]
        ON [dbo].[Booking] ([status], bookingType)
        INCLUDE (bookingID, updatedAt);
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE [name] = N'IX_Payment_Status_ExpiredAt'
      AND [object_id] = OBJECT_ID(N'[dbo].[Payment]')
)
BEGIN
    CREATE INDEX [IX_Payment_Status_ExpiredAt]
        ON [dbo].[Payment] ([status], expiredAt)
        INCLUDE (bookingID);
END
GO
