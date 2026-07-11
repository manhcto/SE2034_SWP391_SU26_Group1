USE WonderVn;
GO

IF COL_LENGTH('dbo.Tour_Scheduler', 'scheduleTransportType') IS NULL
BEGIN
    ALTER TABLE dbo.Tour_Scheduler
    ADD scheduleTransportType NVARCHAR(50) NULL;
END
GO

UPDATE ts
SET scheduleTransportType = t.mainTransportType
FROM dbo.Tour_Scheduler ts
JOIN dbo.Tour t ON t.tourID = ts.tourID
WHERE (ts.scheduleTransportType IS NULL OR LTRIM(RTRIM(ts.scheduleTransportType)) = '')
  AND t.mainTransportType IS NOT NULL
  AND LTRIM(RTRIM(t.mainTransportType)) <> '';
GO
