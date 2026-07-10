USE WonderVn;
GO

/* =========================================================
   WonderVN - Tour_Assignments only upgrade

   Goal:
   - Keep every existing table unchanged.
   - Only add practical management fields to dbo.Tour_Assignments.
   - Existing columns stay the same:
       assignmentID, tourScheduleID, userID, roleInTour

   Safe to run after the original database script.
   This script checks each column/index/foreign key before adding it.
========================================================= */

IF OBJECT_ID(N'dbo.Tour_Assignments', N'U') IS NULL
BEGIN
    RAISERROR(N'Table dbo.Tour_Assignments does not exist. Run the base database script first.', 16, 1);
    RETURN;
END;
GO

/* =========================
   1) ADD columns for assignment management
========================= */

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'assignmentCode')
    ALTER TABLE dbo.Tour_Assignments ADD assignmentCode NVARCHAR(50) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'bookingID')
    ALTER TABLE dbo.Tour_Assignments ADD bookingID INT NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'assignedBy')
    ALTER TABLE dbo.Tour_Assignments ADD assignedBy INT NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'assignmentStatus')
    ALTER TABLE dbo.Tour_Assignments
        ADD assignmentStatus NVARCHAR(50) NOT NULL
        CONSTRAINT DF_TourAssignments_AssignmentStatus DEFAULT N'Pending';

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'priorityLevel')
    ALTER TABLE dbo.Tour_Assignments
        ADD priorityLevel NVARCHAR(50) NOT NULL
        CONSTRAINT DF_TourAssignments_PriorityLevel DEFAULT N'Normal';

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'assignedAt')
    ALTER TABLE dbo.Tour_Assignments
        ADD assignedAt DATETIME NOT NULL
        CONSTRAINT DF_TourAssignments_AssignedAt DEFAULT GETDATE();

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'acceptedAt')
    ALTER TABLE dbo.Tour_Assignments ADD acceptedAt DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'rejectedAt')
    ALTER TABLE dbo.Tour_Assignments ADD rejectedAt DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'rejectionReason')
    ALTER TABLE dbo.Tour_Assignments ADD rejectionReason NVARCHAR(MAX) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'confirmedAt')
    ALTER TABLE dbo.Tour_Assignments ADD confirmedAt DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'completedAt')
    ALTER TABLE dbo.Tour_Assignments ADD completedAt DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'cancelledAt')
    ALTER TABLE dbo.Tour_Assignments ADD cancelledAt DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'checkInDeadline')
    ALTER TABLE dbo.Tour_Assignments ADD checkInDeadline DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'actualStartAt')
    ALTER TABLE dbo.Tour_Assignments ADD actualStartAt DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'actualEndAt')
    ALTER TABLE dbo.Tour_Assignments ADD actualEndAt DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'meetingPoint')
    ALTER TABLE dbo.Tour_Assignments ADD meetingPoint NVARCHAR(255) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'pickupTime')
    ALTER TABLE dbo.Tour_Assignments ADD pickupTime DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'guideNameSnapshot')
    ALTER TABLE dbo.Tour_Assignments ADD guideNameSnapshot NVARCHAR(255) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'guidePhoneSnapshot')
    ALTER TABLE dbo.Tour_Assignments ADD guidePhoneSnapshot NVARCHAR(30) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'staffNote')
    ALTER TABLE dbo.Tour_Assignments ADD staffNote NVARCHAR(MAX) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'guideNote')
    ALTER TABLE dbo.Tour_Assignments ADD guideNote NVARCHAR(MAX) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'customerNote')
    ALTER TABLE dbo.Tour_Assignments ADD customerNote NVARCHAR(MAX) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'createdAt')
    ALTER TABLE dbo.Tour_Assignments
        ADD createdAt DATETIME NOT NULL
        CONSTRAINT DF_TourAssignments_CreatedAt DEFAULT GETDATE();

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'updatedAt')
    ALTER TABLE dbo.Tour_Assignments ADD updatedAt DATETIME NULL;
GO

/* =========================
   2) UPDATE existing rows with useful defaults
========================= */

UPDATE dbo.Tour_Assignments
SET assignmentCode = N'ASG-' + RIGHT('000000' + CAST(assignmentID AS VARCHAR(20)), 6)
WHERE assignmentCode IS NULL;
GO

UPDATE ta
SET
    guideNameSnapshot = LTRIM(RTRIM(ISNULL(u.firstName, N'') + N' ' + ISNULL(u.lastName, N''))),
    guidePhoneSnapshot = u.phone
FROM dbo.Tour_Assignments ta
JOIN dbo.[User] u
    ON ta.userID = u.userID
WHERE ta.guideNameSnapshot IS NULL
   OR ta.guidePhoneSnapshot IS NULL;
GO

/* =========================
   3) ADD constraints and indexes on Tour_Assignments only
========================= */

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'bookingID')
   AND OBJECT_ID(N'dbo.Booking', N'U') IS NOT NULL
   AND NOT EXISTS (
        SELECT 1
        FROM sys.foreign_keys
        WHERE name = N'FK_TourAssignments_Booking'
          AND parent_object_id = OBJECT_ID(N'dbo.Tour_Assignments')
   )
BEGIN
    ALTER TABLE dbo.Tour_Assignments WITH CHECK
    ADD CONSTRAINT FK_TourAssignments_Booking
        FOREIGN KEY (bookingID) REFERENCES dbo.Booking(bookingID);
END;
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Tour_Assignments') AND name = N'assignedBy')
   AND NOT EXISTS (
        SELECT 1
        FROM sys.foreign_keys
        WHERE name = N'FK_TourAssignments_AssignedBy'
          AND parent_object_id = OBJECT_ID(N'dbo.Tour_Assignments')
   )
BEGIN
    ALTER TABLE dbo.Tour_Assignments WITH CHECK
    ADD CONSTRAINT FK_TourAssignments_AssignedBy
        FOREIGN KEY (assignedBy) REFERENCES dbo.[User](userID);
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_TourAssignments_AssignmentCode'
      AND object_id = OBJECT_ID(N'dbo.Tour_Assignments')
)
BEGIN
    CREATE UNIQUE INDEX UX_TourAssignments_AssignmentCode
    ON dbo.Tour_Assignments(assignmentCode)
    WHERE assignmentCode IS NOT NULL;
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_TourAssignments_AssignmentStatus'
      AND object_id = OBJECT_ID(N'dbo.Tour_Assignments')
)
BEGIN
    CREATE INDEX IX_TourAssignments_AssignmentStatus
    ON dbo.Tour_Assignments(assignmentStatus);
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_TourAssignments_BookingID'
      AND object_id = OBJECT_ID(N'dbo.Tour_Assignments')
)
BEGIN
    CREATE INDEX IX_TourAssignments_BookingID
    ON dbo.Tour_Assignments(bookingID)
    WHERE bookingID IS NOT NULL;
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_TourAssignments_AssignedBy'
      AND object_id = OBJECT_ID(N'dbo.Tour_Assignments')
)
BEGIN
    CREATE INDEX IX_TourAssignments_AssignedBy
    ON dbo.Tour_Assignments(assignedBy)
    WHERE assignedBy IS NOT NULL;
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_TourAssignments_DateRange'
      AND parent_object_id = OBJECT_ID(N'dbo.Tour_Assignments')
)
BEGIN
    ALTER TABLE dbo.Tour_Assignments WITH CHECK
    ADD CONSTRAINT CK_TourAssignments_DateRange
        CHECK (actualEndAt IS NULL OR actualStartAt IS NULL OR actualEndAt >= actualStartAt);
END;
GO

/* =========================
   4) Commands for add/edit/view/delete assignment
   Copy the block you need, replace the IDs/values, then run it manually.
========================= */

/*
-- ADD / INSERT assignment
DECLARE @newAssignmentID INT;

INSERT INTO dbo.Tour_Assignments
(
    tourScheduleID,
    userID,
    roleInTour,
    bookingID,
    assignedBy,
    assignmentStatus,
    priorityLevel,
    meetingPoint,
    pickupTime,
    checkInDeadline,
    staffNote
)
VALUES
(
    1,                         -- tourScheduleID
    3,                         -- guide userID
    N'Hướng dẫn viên chính',    -- roleInTour
    NULL,                      -- bookingID, optional
    2,                         -- assignedBy staff userID, optional
    N'Pending',
    N'Normal',
    N'Cổng chính điểm hẹn',
    '2026-07-01 07:30:00',
    '2026-07-01 07:15:00',
    N'Gọi khách trước giờ khởi hành.'
);

SET @newAssignmentID = SCOPE_IDENTITY();

UPDATE dbo.Tour_Assignments
SET assignmentCode = N'ASG-' + RIGHT('000000' + CAST(@newAssignmentID AS VARCHAR(20)), 6)
WHERE assignmentID = @newAssignmentID;

SELECT *
FROM dbo.Tour_Assignments
WHERE assignmentID = @newAssignmentID;
GO
*/

/*
-- EDIT / UPDATE assignment
UPDATE dbo.Tour_Assignments
SET
    userID = 3,
    roleInTour = N'Hướng dẫn viên chính',
    bookingID = NULL,
    assignedBy = 2,
    assignmentStatus = N'Confirmed',
    priorityLevel = N'High',
    meetingPoint = N'Cổng chính điểm hẹn',
    pickupTime = '2026-07-01 07:30:00',
    checkInDeadline = '2026-07-01 07:15:00',
    staffNote = N'Cần xác nhận lại xe trước 1 ngày.',
    guideNote = N'Đã nhận phân công.',
    updatedAt = GETDATE()
WHERE assignmentID = 1;
GO
*/

/*
-- VIEW assignment detail
SELECT
    ta.assignmentID,
    ta.assignmentCode,
    ta.tourScheduleID,
    ta.userID AS guideID,
    ta.roleInTour,
    ta.bookingID,
    ta.assignedBy,
    ta.assignmentStatus,
    ta.priorityLevel,
    ta.assignedAt,
    ta.acceptedAt,
    ta.confirmedAt,
    ta.completedAt,
    ta.meetingPoint,
    ta.pickupTime,
    ta.checkInDeadline,
    ta.actualStartAt,
    ta.actualEndAt,
    ta.guideNameSnapshot,
    ta.guidePhoneSnapshot,
    ta.staffNote,
    ta.guideNote,
    ta.customerNote,
    ta.createdAt,
    ta.updatedAt
FROM dbo.Tour_Assignments ta
WHERE ta.assignmentID = 1;
GO
*/

/*
-- LIST assignment with guide and schedule info
SELECT
    ta.assignmentID,
    ta.assignmentCode,
    ta.roleInTour,
    ta.assignmentStatus,
    ta.priorityLevel,
    ta.meetingPoint,
    ta.pickupTime,
    ts.startDate,
    ts.endDate,
    t.tourName,
    u.firstName + N' ' + u.lastName AS guideName,
    u.phone AS guidePhone
FROM dbo.Tour_Assignments ta
JOIN dbo.Tour_Scheduler ts
    ON ta.tourScheduleID = ts.tourScheduleID
JOIN dbo.Tour t
    ON ts.tourID = t.tourID
JOIN dbo.[User] u
    ON ta.userID = u.userID
ORDER BY ta.assignedAt DESC, ta.assignmentID DESC;
GO
*/

/*
-- DELETE assignment
DELETE FROM dbo.Tour_Assignments
WHERE assignmentID = 1;
GO
*/
