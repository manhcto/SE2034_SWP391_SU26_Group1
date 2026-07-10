/*
    Optional: dùng để test nhanh phần hiển thị tour ở trang chủ/customer.
    Chỉ cập nhật tour mẫu trong seed. Không chạy nếu bạn muốn giữ tour mẫu ở trạng thái Draft.
*/

IF EXISTS (SELECT 1 FROM Tour WHERE tourCode = N'TOUR-SEED-HLNB-3N2D')
BEGIN
    UPDATE Tour
    SET [status] = N'Active',
        approvedAt = ISNULL(approvedAt, GETDATE()),
        updatedAt = GETDATE()
    WHERE tourCode = N'TOUR-SEED-HLNB-3N2D';

    UPDATE ts
    SET scheduleStatus = N'Open',
        updatedAt = GETDATE()
    FROM Tour_Scheduler ts
    JOIN Tour t ON t.tourID = ts.tourID
    WHERE t.tourCode = N'TOUR-SEED-HLNB-3N2D'
      AND ts.startDate >= CAST(GETDATE() AS date);
END
