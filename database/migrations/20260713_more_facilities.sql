USE [WonderVn];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @FacilitySeed TABLE (
        [facilityName] NVARCHAR(100) NOT NULL,
        [icon] NVARCHAR(100) NULL,
        [facilityScope] NVARCHAR(30) NOT NULL
    );

    INSERT INTO @FacilitySeed ([facilityName], [icon], [facilityScope])
    VALUES
        (N'Nhà hàng', N'fa-utensils', N'Accommodation'),
        (N'Phòng gym', N'fa-dumbbell', N'Accommodation'),
        (N'Spa', N'fa-spa', N'Accommodation'),
        (N'Lễ tân 24/7', N'fa-bell-concierge', N'Accommodation'),
        (N'Thang máy', N'fa-elevator', N'Accommodation'),
        (N'Dịch vụ giặt ủi', N'fa-shirt', N'Accommodation'),
        (N'Đưa đón sân bay', N'fa-van-shuttle', N'Accommodation'),
        (N'Phòng họp', N'fa-people-group', N'Accommodation'),
        (N'Khu vui chơi trẻ em', N'fa-child-reaching', N'Accommodation'),
        (N'Quầy bar', N'fa-martini-glass', N'Accommodation'),
        (N'Bãi biển riêng', N'fa-umbrella-beach', N'Accommodation'),
        (N'Khu vực BBQ', N'fa-fire-burner', N'Accommodation'),
        (N'Cho thuê xe đạp', N'fa-bicycle', N'Accommodation'),
        (N'Không hút thuốc', N'fa-ban-smoking', N'Accommodation'),
        (N'Cho phép thú cưng', N'fa-paw', N'Accommodation'),
        (N'Giữ hành lý', N'fa-suitcase', N'Accommodation'),
        (N'TV màn hình phẳng', N'fa-tv', N'Room'),
        (N'Minibar', N'fa-wine-bottle', N'Room'),
        (N'Két an toàn', N'fa-vault', N'Room'),
        (N'Ấm đun nước', N'fa-mug-hot', N'Room'),
        (N'Bàn làm việc', N'fa-laptop', N'Room'),
        (N'Máy sấy tóc', N'fa-wind', N'Room'),
        (N'Ban công', N'fa-building', N'Room'),
        (N'Tủ lạnh', N'fa-box', N'Room'),
        (N'Tủ quần áo', N'fa-door-closed', N'Room'),
        (N'Vòi sen', N'fa-shower', N'Room'),
        (N'Bồn tắm', N'fa-bath', N'Room'),
        (N'Dép đi trong phòng', N'fa-shoe-prints', N'Room'),
        (N'Bàn ủi', N'fa-plug', N'Room'),
        (N'Cách âm', N'fa-volume-xmark', N'Room'),
        (N'Máy pha cà phê', N'fa-mug-saucer', N'Room'),
        (N'Điện thoại nội bộ', N'fa-phone', N'Room'),
        (N'Dịch vụ phòng', N'fa-bell', N'Room'),
        (N'View biển', N'fa-water', N'Room'),
        (N'Dọn phòng hàng ngày', N'fa-broom', N'Both'),
        (N'Hỗ trợ người khuyết tật', N'fa-wheelchair', N'Both');

    INSERT INTO [dbo].[Facility] (
        [facilityName], [icon], [facilityScope], [status]
    )
    SELECT seed.[facilityName], seed.[icon], seed.[facilityScope], N'Active'
    FROM @FacilitySeed seed
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[Facility] currentFacility
        WHERE currentFacility.[facilityName] = seed.[facilityName]
    );

    /* Các tiện ích cơ bản áp dụng cho mọi nơi lưu trú đang sử dụng. */
    INSERT INTO [dbo].[Accommodation_Facility] ([accommodationID], [facilityID])
    SELECT accommodation.[accommodationID], facility.[facilityID]
    FROM [dbo].[Accommodation] accommodation
    CROSS JOIN [dbo].[Facility] facility
    WHERE accommodation.[status] = N'Available'
      AND facility.[status] = N'Active'
      AND facility.[facilityName] IN (
          N'Wifi', N'Nhà hàng', N'Lễ tân 24/7', N'Thang máy',
          N'Dịch vụ giặt ủi', N'Không hút thuốc', N'Giữ hành lý',
          N'Dọn phòng hàng ngày', N'Hỗ trợ người khuyết tật'
      )
      AND facility.[facilityScope] IN (N'Accommodation', N'Both')
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[Accommodation_Facility] currentLink
          WHERE currentLink.[accommodationID] = accommodation.[accommodationID]
            AND currentLink.[facilityID] = facility.[facilityID]
      );

    /* Phân bổ thêm tiện ích theo ID để dữ liệu mẫu đa dạng, không nơi nào giống hệt nhau. */
    INSERT INTO [dbo].[Accommodation_Facility] ([accommodationID], [facilityID])
    SELECT accommodation.[accommodationID], facility.[facilityID]
    FROM [dbo].[Accommodation] accommodation
    CROSS JOIN [dbo].[Facility] facility
    WHERE accommodation.[status] = N'Available'
      AND facility.[status] = N'Active'
      AND facility.[facilityScope] IN (N'Accommodation', N'Both')
      AND (
          (accommodation.[accommodationID] % 2 = 0
              AND facility.[facilityName] IN (N'Phòng gym', N'Spa', N'Quầy bar'))
          OR (accommodation.[accommodationID] % 3 = 0
              AND facility.[facilityName] IN (N'Đưa đón sân bay', N'Phòng họp', N'Khu vui chơi trẻ em'))
          OR (accommodation.[accommodationID] % 4 = 0
              AND facility.[facilityName] IN (N'Bãi biển riêng', N'Khu vực BBQ', N'Cho thuê xe đạp'))
          OR (accommodation.[accommodationID] % 5 = 0
              AND facility.[facilityName] IN (N'Cho phép thú cưng', N'Bữa sáng', N'Bãi đỗ xe'))
      )
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[Accommodation_Facility] currentLink
          WHERE currentLink.[accommodationID] = accommodation.[accommodationID]
            AND currentLink.[facilityID] = facility.[facilityID]
      );

    /* Các tiện ích cơ bản áp dụng cho mọi loại phòng đang sử dụng. */
    INSERT INTO [dbo].[Room_Facility] ([roomID], [facilityID])
    SELECT room.[roomID], facility.[facilityID]
    FROM [dbo].[Room] room
    CROSS JOIN [dbo].[Facility] facility
    WHERE room.[status] = N'Available'
      AND facility.[status] = N'Active'
      AND facility.[facilityName] IN (
          N'Wifi', N'Điều hòa', N'Phòng tắm riêng', N'TV màn hình phẳng',
          N'Két an toàn', N'Ấm đun nước', N'Bàn làm việc', N'Máy sấy tóc',
          N'Tủ quần áo', N'Vòi sen', N'Dép đi trong phòng', N'Cách âm',
          N'Điện thoại nội bộ', N'Dịch vụ phòng', N'Dọn phòng hàng ngày'
      )
      AND facility.[facilityScope] IN (N'Room', N'Both')
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[Room_Facility] currentLink
          WHERE currentLink.[roomID] = room.[roomID]
            AND currentLink.[facilityID] = facility.[facilityID]
      );

    /* Mỗi loại phòng nhận thêm một nhóm tiện ích khác nhau. */
    INSERT INTO [dbo].[Room_Facility] ([roomID], [facilityID])
    SELECT room.[roomID], facility.[facilityID]
    FROM [dbo].[Room] room
    CROSS JOIN [dbo].[Facility] facility
    WHERE room.[status] = N'Available'
      AND facility.[status] = N'Active'
      AND facility.[facilityScope] IN (N'Room', N'Both')
      AND (
          (room.[roomID] % 2 = 0
              AND facility.[facilityName] IN (N'Minibar', N'Ban công', N'Tủ lạnh'))
          OR (room.[roomID] % 3 = 0
              AND facility.[facilityName] IN (N'Bồn tắm', N'Máy pha cà phê', N'Bàn ủi'))
          OR (room.[roomID] % 4 = 0
              AND facility.[facilityName] IN (N'View biển', N'Ban công', N'Minibar'))
      )
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[Room_Facility] currentLink
          WHERE currentLink.[roomID] = room.[roomID]
            AND currentLink.[facilityID] = facility.[facilityID]
      );

    COMMIT TRANSACTION;

    SELECT [facilityScope] AS [Phạm vi], COUNT(*) AS [Số tiện ích đang hoạt động]
    FROM [dbo].[Facility]
    WHERE [status] = N'Active'
    GROUP BY [facilityScope]
    ORDER BY [facilityScope];

    SELECT
        (SELECT COUNT(*) FROM [dbo].[Accommodation_Facility]) AS [Liên kết nơi lưu trú],
        (SELECT COUNT(*) FROM [dbo].[Room_Facility]) AS [Liên kết phòng];
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
