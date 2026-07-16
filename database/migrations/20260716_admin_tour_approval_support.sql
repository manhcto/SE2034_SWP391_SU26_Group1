/* Support Admin Tour Approval flow without changing existing business data. */

IF COL_LENGTH('dbo.Tour_Scheduler', 'scheduleTransportType') IS NULL
BEGIN
    ALTER TABLE dbo.Tour_Scheduler
    ADD scheduleTransportType NVARCHAR(50) NULL;
END;
GO

DECLARE @constraintName NVARCHAR(200);

SELECT @constraintName = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c
    ON dc.parent_object_id = c.object_id
   AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('dbo.Tour')
  AND c.name = 'status';

IF @constraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE dbo.Tour DROP CONSTRAINT ' + @constraintName);
END;
GO

ALTER TABLE dbo.Tour
ADD CONSTRAINT DF_Tour_Status DEFAULT (N'Draft') FOR status;
GO

DECLARE @scheduleConstraintName NVARCHAR(200);

SELECT @scheduleConstraintName = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c
    ON dc.parent_object_id = c.object_id
   AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('dbo.Tour_Scheduler')
  AND c.name = 'scheduleStatus';

IF @scheduleConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE dbo.Tour_Scheduler DROP CONSTRAINT ' + @scheduleConstraintName);
END;
GO

ALTER TABLE dbo.Tour_Scheduler
ADD CONSTRAINT DF_TourScheduler_Status DEFAULT (N'Planned') FOR scheduleStatus;
GO

UPDATE ts
SET scheduleStatus = N'Planned', updatedAt = GETDATE()
FROM dbo.Tour_Scheduler ts
JOIN dbo.Tour t ON t.tourID = ts.tourID
WHERE t.status IN (N'Draft', N'Pending', N'Rejected')
  AND ts.scheduleStatus = N'Open';
GO

UPDATE ts
SET scheduleStatus = N'Closed', updatedAt = GETDATE()
FROM dbo.Tour_Scheduler ts
JOIN dbo.Tour t ON t.tourID = ts.tourID
WHERE t.status = N'Inactive'
  AND ts.scheduleStatus = N'Open';
GO
