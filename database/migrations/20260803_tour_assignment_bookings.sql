/* One assignment = one guide + one tour schedule; paid bookings are linked separately. */
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF OBJECT_ID(N'dbo.Tour_Assignment_Booking', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tour_Assignment_Booking (
        assignmentBookingID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
        assignmentID INT NOT NULL,
        bookingID INT NOT NULL,
        linkedAt DATETIME NOT NULL CONSTRAINT DF_TourAssignmentBooking_LinkedAt DEFAULT GETDATE(),
        CONSTRAINT FK_TourAssignmentBooking_Assignment
            FOREIGN KEY (assignmentID) REFERENCES dbo.Tour_Assignments(assignmentID) ON DELETE CASCADE,
        CONSTRAINT FK_TourAssignmentBooking_Booking
            FOREIGN KEY (bookingID) REFERENCES dbo.Booking(bookingID),
        CONSTRAINT UQ_TourAssignmentBooking_Assignment_Booking UNIQUE (assignmentID, bookingID)
    );
END;

IF EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments')
      AND name = N'bookingID' AND is_nullable = 0
)
BEGIN
    ALTER TABLE dbo.Tour_Assignments ALTER COLUMN bookingID INT NULL;
END;

INSERT INTO dbo.Tour_Assignment_Booking (assignmentID, bookingID)
SELECT ta.assignmentID, ta.bookingID
FROM dbo.Tour_Assignments ta
WHERE ta.bookingID IS NOT NULL AND ta.bookingID > 0
  AND NOT EXISTS (
      SELECT 1 FROM dbo.Tour_Assignment_Booking tab
      WHERE tab.assignmentID = ta.assignmentID AND tab.bookingID = ta.bookingID
  );

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_TourAssignmentBooking_AssignmentID'
      AND object_id = OBJECT_ID(N'dbo.Tour_Assignment_Booking')
)
BEGIN
    CREATE INDEX IX_TourAssignmentBooking_AssignmentID
        ON dbo.Tour_Assignment_Booking (assignmentID, bookingID);
END;

COMMIT TRANSACTION;
GO
