/*
    STAFF TOUR - FIX DUPLICATE PROVINCE OPTIONS
    Chạy file này nếu dropdown Điểm khởi hành / Điểm đến bị lặp tỉnh/thành nhiều lần.

    Nguyên nhân:
      - Bảng Administrative_Unit có nhiều phường/xã cùng provinceName.
      - Seed dữ liệu có thể đã bị chạy nhiều lần trước đó.

    Script này chỉ xóa các dòng đại diện cấp tỉnh/thành bị trùng
    (wardType = 'Tỉnh/Thành' hoặc wardName = 'Trung tâm'), không xóa dữ liệu phường/xã gốc.
*/

USE [WonderVn];
GO

SET NOCOUNT ON;
GO

;WITH RankedProvinceRepresentatives AS (
    SELECT
        administrativeUnitID,
        ROW_NUMBER() OVER (
            PARTITION BY LTRIM(RTRIM(provinceName))
            ORDER BY administrativeUnitID
        ) AS rn
    FROM dbo.Administrative_Unit
    WHERE isActive = 1
      AND provinceName IS NOT NULL
      AND LTRIM(RTRIM(provinceName)) <> N''
      AND (
            wardType IN (N'Tỉnh/Thành', N'Tỉnh', N'Thành phố')
            OR wardName = N'Trung tâm'
          )
)
DELETE FROM dbo.Administrative_Unit
WHERE administrativeUnitID IN (
    SELECT administrativeUnitID
    FROM RankedProvinceRepresentatives
    WHERE rn > 1
);
GO

SELECT
    provinceName,
    COUNT(*) AS duplicateRepresentativeCount
FROM dbo.Administrative_Unit
WHERE isActive = 1
  AND provinceName IS NOT NULL
  AND LTRIM(RTRIM(provinceName)) <> N''
  AND (
        wardType IN (N'Tỉnh/Thành', N'Tỉnh', N'Thành phố')
        OR wardName = N'Trung tâm'
      )
GROUP BY provinceName
HAVING COUNT(*) > 1;
GO
