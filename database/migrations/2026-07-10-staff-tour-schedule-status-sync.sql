USE WonderVn;
GO

-- Đồng bộ lịch khởi hành cũ để không có tình trạng Tour đang Draft/Pending/Rejected
-- nhưng lịch lại hiển thị Open như đã được bán.
UPDATE ts
SET ts.scheduleStatus = N'Planned',
    ts.updatedAt = GETDATE()
FROM Tour_Scheduler ts
JOIN Tour t ON t.tourID = ts.tourID
WHERE t.[status] IN (N'Draft', N'Pending', N'Rejected')
  AND ts.scheduleStatus = N'Open';
GO

-- Tour ngừng bán thì các lịch đang Open chuyển về Closed.
UPDATE ts
SET ts.scheduleStatus = N'Closed',
    ts.updatedAt = GETDATE()
FROM Tour_Scheduler ts
JOIN Tour t ON t.tourID = ts.tourID
WHERE t.[status] = N'Inactive'
  AND ts.scheduleStatus = N'Open';
GO
