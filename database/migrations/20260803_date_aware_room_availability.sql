USE [WonderVn];
GO

SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;

-- roomAvailability is the operational capacity configured by staff.
-- Older code decremented this value for every booking regardless of stay dates.
UPDATE [dbo].[Room]
SET roomAvailability = numberOfRooms,
    updatedAt = GETDATE()
WHERE roomAvailability <> numberOfRooms;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE [name] = N'IX_BookingDetail_Room_DateRange'
      AND object_id = OBJECT_ID(N'[dbo].[Booking_Detail]')
)
BEGIN
    CREATE INDEX IX_BookingDetail_Room_DateRange
        ON [dbo].[Booking_Detail] (roomID, startDate, endDate)
        INCLUDE (accommodationID, quantity, bookingID);
END;

COMMIT TRANSACTION;
GO
