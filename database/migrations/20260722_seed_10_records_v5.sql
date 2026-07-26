USE [WonderVn]
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @DefaultCategoryID INT = (
        SELECT TOP (1) [tourCategoryID]
        FROM [dbo].[Tour_Category]
        WHERE [status] = N'Active'
        ORDER BY [tourCategoryID]
    );
    DECLARE @DefaultRegionID INT = (
        SELECT TOP (1) [regionID]
        FROM [dbo].[Region]
        WHERE [status] = N'Active'
        ORDER BY [regionID]
    );
    DECLARE @CreatedByUserID INT = (
        SELECT TOP (1) [userID]
        FROM [dbo].[User]
        WHERE [status] = N'Active'
        ORDER BY CASE WHEN [roleID] IN (1, 2) THEN 0 ELSE 1 END, [userID]
    );

    IF @DefaultCategoryID IS NULL OR @DefaultRegionID IS NULL
        THROW 50021, N'Cần có ít nhất một Tour_Category và Region đang Active trước khi seed.', 1;

    /* 10 accommodation mới. Tên được dùng làm khóa nhận diện để chạy lại không bị trùng. */
    ;WITH AccommodationSeed AS (
        SELECT *
        FROM (VALUES
            (N'Hội An Garden Stay', N'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1200&q=85', N'18 Nguyễn Phúc Chu', N'02353980101', N'Không gian nghỉ dưỡng yên tĩnh bên sông Hoài, gần phố cổ Hội An.', CAST(4.70 AS decimal(3,2)), N'Hotel', N'Tỉnh Quảng Nam', N'Thành phố Hội An', N'Phường Minh An'),
            (N'Mộc Châu Green Valley', N'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=85', N'42 Tân Lập', N'02123880102', N'Homestay giữa thung lũng xanh, phù hợp nhóm bạn và gia đình.', CAST(4.60 AS decimal(3,2)), N'Homestay', N'Tỉnh Sơn La', N'Huyện Mộc Châu', N'Thị trấn Mộc Châu'),
            (N'Quy Nhơn Seaside Hotel', N'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=1200&q=85', N'88 Xuân Diệu', N'02563880103', N'Khách sạn ven biển, thuận tiện đến Kỳ Co, Eo Gió và trung tâm thành phố.', CAST(4.80 AS decimal(3,2)), N'Hotel', N'Tỉnh Bình Định', N'Thành phố Quy Nhơn', N'Phường Hải Cảng'),
            (N'Sa Đéc Riverside Lodge', N'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=85', N'10 Nguyễn Huệ', N'02773880104', N'Lodge bên sông Tiền, gần làng hoa và các điểm ẩm thực miền Tây.', CAST(4.40 AS decimal(3,2)), N'Lodge', N'Tỉnh Đồng Tháp', N'Thành phố Sa Đéc', N'Phường 1'),
            (N'Vũng Tàu Lighthouse Hotel', N'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?auto=format&fit=crop&w=1200&q=85', N'120 Hạ Long', N'02543880105', N'Khách sạn gần biển và ngọn hải đăng, phù hợp chuyến nghỉ cuối tuần.', CAST(4.55 AS decimal(3,2)), N'Hotel', N'Tỉnh Bà Rịa - Vũng Tàu', N'Thành phố Vũng Tàu', N'Phường 2'),
            (N'Cát Bà Island Retreat', N'https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=1200&q=85', N'25 1/4 Cát Bà', N'02253880106', N'Retreat gần vườn quốc gia và bến tàu, có không gian nghỉ dưỡng riêng tư.', CAST(4.75 AS decimal(3,2)), N'Resort', N'Thành phố Hải Phòng', N'Huyện Cát Hải', N'Thị trấn Cát Bà'),
            (N'Buôn Ma Thuột Coffee House', N'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=85', N'56 Nguyễn Đình Chiểu', N'02623880107', N'Lưu trú mang phong cách cà phê cao nguyên, gần bảo tàng và chợ trung tâm.', CAST(4.35 AS decimal(3,2)), N'Hotel', N'Tỉnh Đắk Lắk', N'Thành phố Buôn Ma Thuột', N'Phường Tân Tiến'),
            (N'Phan Thiết Sand Dunes Resort', N'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=85', N'90 Huỳnh Tấn Phát', N'02523880108', N'Resort gần đồi cát và biển Mũi Né, có hồ bơi và khu vui chơi gia đình.', CAST(4.65 AS decimal(3,2)), N'Resort', N'Tỉnh Bình Thuận', N'Thành phố Phan Thiết', N'Phường Mũi Né'),
            (N'Tam Đảo Misty Hill', N'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=85', N'15 Tây Thiên', N'02113880109', N'Villa trên đồi có khí hậu mát mẻ, phù hợp nghỉ dưỡng ngắn ngày.', CAST(4.50 AS decimal(3,2)), N'Villa', N'Tỉnh Vĩnh Phúc', N'Huyện Tam Đảo', N'Thị trấn Tam Đảo'),
            (N'Hà Giang Stone Valley', N'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=85', N'08 Đường Hạnh Phúc', N'02193880110', N'Nhà nghỉ nhìn ra núi đá, thuận tiện khám phá Đồng Văn và Mã Pí Lèng.', CAST(4.60 AS decimal(3,2)), N'Lodge', N'Tỉnh Hà Giang', N'Huyện Đồng Văn', N'Thị trấn Đồng Văn')
        ) AS data([name], [image], [address], [phone], [description], [rate], [type], [province], [district], [ward])
    )
    INSERT INTO [dbo].[Accommodation] (
        [name], [image], [address], [phone], [description], [rate], [type], [status],
        [checkInTime], [checkOutTime], [province], [district], [ward], [createdByUserID], [createdAt]
    )
    SELECT seed.[name], seed.[image], seed.[address], seed.[phone], seed.[description], seed.[rate], seed.[type],
           N'Available', CAST('14:00' AS time), CAST('12:00' AS time), seed.[province], seed.[district], seed.[ward],
           @CreatedByUserID, GETDATE()
    FROM AccommodationSeed seed
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[Accommodation] currentAccommodation
        WHERE currentAccommodation.[name] = seed.[name]
    );

    /* Mỗi accommodation mới có một room mới tương ứng. */
    ;WITH RoomSeed AS (
        SELECT *
        FROM (VALUES
            (N'Hội An Garden Stay', N'Garden Deluxe', 6, CAST(1250000.00 AS decimal(18,2)), N'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=1200&q=85', N'Phòng hướng vườn, có bàn làm việc và phòng tắm riêng.', 1, N'Giường King', 2, 1, CAST(30.00 AS decimal(10,2))),
            (N'Mộc Châu Green Valley', N'Valley Bungalow', 5, CAST(1550000.00 AS decimal(18,2)), N'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=85', N'Bungalow nhìn ra thung lũng, có hiên ngồi thư giãn.', 1, N'Giường Queen', 2, 1, CAST(35.00 AS decimal(10,2))),
            (N'Quy Nhơn Seaside Hotel', N'Ocean Balcony Twin', 8, CAST(1450000.00 AS decimal(18,2)), N'https://images.unsplash.com/photo-1568495248636-6432b97bd949?auto=format&fit=crop&w=1200&q=85', N'Phòng hai giường đơn, ban công hướng biển và cửa sổ lớn.', 2, N'Giường đơn', 2, 1, CAST(32.00 AS decimal(10,2))),
            (N'Sa Đéc Riverside Lodge', N'Riverside Family Loft', 4, CAST(1100000.00 AS decimal(18,2)), N'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=85', N'Phòng gia đình có gác nhỏ, nhìn ra sông và vườn cây.', 2, N'Giường đôi', 4, 2, CAST(42.00 AS decimal(10,2))),
            (N'Vũng Tàu Lighthouse Hotel', N'Lighthouse Suite', 7, CAST(1780000.00 AS decimal(18,2)), N'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=85', N'Suite rộng, có khu tiếp khách và ban công nhìn biển.', 1, N'Giường King', 2, 1, CAST(40.00 AS decimal(10,2))),
            (N'Cát Bà Island Retreat', N'Island Cottage', 6, CAST(1950000.00 AS decimal(18,2)), N'https://images.unsplash.com/photo-1602002418082-a4443e081dd1?auto=format&fit=crop&w=1200&q=85', N'Cottage riêng tư gần biển, phù hợp cặp đôi và gia đình nhỏ.', 1, N'Giường King', 2, 1, CAST(38.00 AS decimal(10,2))),
            (N'Buôn Ma Thuột Coffee House', N'Coffee View Double', 5, CAST(980000.00 AS decimal(18,2)), N'https://images.unsplash.com/photo-1595576508898-0ad5c879a061?auto=format&fit=crop&w=1200&q=85', N'Phòng đôi ấm cúng, có góc pha cà phê và cửa sổ thành phố.', 1, N'Giường Queen', 2, 1, CAST(28.00 AS decimal(10,2))),
            (N'Phan Thiết Sand Dunes Resort', N'Dune Pool Villa', 9, CAST(2250000.00 AS decimal(18,2)), N'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?auto=format&fit=crop&w=1200&q=85', N'Villa gần hồ bơi, có sân riêng và không gian cho trẻ em.', 1, N'Giường King', 2, 2, CAST(45.00 AS decimal(10,2))),
            (N'Tam Đảo Misty Hill', N'Mountain View Triple', 4, CAST(1350000.00 AS decimal(18,2)), N'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?auto=format&fit=crop&w=1200&q=85', N'Phòng ba giường nhìn xuống thung lũng, phù hợp nhóm bạn.', 3, N'Giường đơn', 3, 1, CAST(36.00 AS decimal(10,2))),
            (N'Hà Giang Stone Valley', N'Stone House Family', 3, CAST(1680000.00 AS decimal(18,2)), N'https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=1200&q=85', N'Phòng gia đình phong cách đá bản địa, có ban công nhìn núi.', 2, N'Giường Queen', 4, 2, CAST(48.00 AS decimal(10,2)))
        ) AS data([accommodationName], [roomType], [roomCount], [price], [image], [description], [bedCount], [bedType], [maxAdults], [maxChildren], [roomSize])
    )
    INSERT INTO [dbo].[Room] (
        [accommodationID], [roomType], [numberOfRooms], [priceOfRoom], [status], [roomAvailability],
        [image], [description], [bedCount], [bedType], [maxAdults], [maxChildren], [roomSize], [createdAt]
    )
    SELECT accommodation.[accommodationID], seed.[roomType], seed.[roomCount], seed.[price], N'Available', seed.[roomCount],
           seed.[image], seed.[description], seed.[bedCount], seed.[bedType], seed.[maxAdults], seed.[maxChildren], seed.[roomSize], GETDATE()
    FROM RoomSeed seed
    INNER JOIN [dbo].[Accommodation] accommodation
        ON accommodation.[name] = seed.[accommodationName]
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[Room] currentRoom
        WHERE currentRoom.[accommodationID] = accommodation.[accommodationID]
          AND currentRoom.[roomType] = seed.[roomType]
    );

    /* 10 tour mới, phân bổ theo category/region đang có trong database. */
    ;WITH TourSeed AS (
        SELECT *
        FROM (VALUES
            (N'Hà Nội - Ninh Bình - Tràng An 2N1Đ', N'WV50-TOUR-01', N'Package', 2, 1, N'Hà Nội', N'Ninh Bình', N'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=85', CAST(2890000.00 AS decimal(18,2)), CAST(2190000.00 AS decimal(18,2)), N'Bus', N'Hành trình ngắn ngày khám phá Tràng An, Hoa Lư và cảnh sắc miền Bắc.', N'Tour gia đình', N'Miền Bắc', 1),
            (N'Hải Phòng - Cát Bà 3N2Đ', N'WV50-TOUR-02', N'Package', 3, 2, N'Hải Phòng', N'Cát Bà', N'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=85', CAST(3990000.00 AS decimal(18,2)), CAST(2990000.00 AS decimal(18,2)), N'Bus', N'Tận hưởng biển đảo, chèo kayak và khám phá vườn quốc gia Cát Bà.', N'Tour nghỉ dưỡng', N'Miền Bắc', 0),
            (N'Sơn La - Mộc Châu mùa hoa 3N2Đ', N'WV50-TOUR-03', N'Package', 3, 2, N'Hà Nội', N'Mộc Châu', N'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1200&q=85', CAST(3690000.00 AS decimal(18,2)), CAST(2790000.00 AS decimal(18,2)), N'Bus', N'Khám phá đồi chè, thác Dải Yếm và những cung đường hoa Mộc Châu.', N'Tour khám phá', N'Miền Bắc', 0),
            (N'Hà Nội - Tam Đảo cuối tuần 2N1Đ', N'WV50-TOUR-04', N'Package', 2, 1, N'Hà Nội', N'Tam Đảo', N'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=1200&q=85', CAST(2490000.00 AS decimal(18,2)), CAST(1890000.00 AS decimal(18,2)), N'Bus', N'Kỳ nghỉ trên núi với khí hậu mát mẻ, phù hợp gia đình và nhóm nhỏ.', N'Tour gia đình', N'Miền Bắc', 0),
            (N'Quy Nhơn - Kỳ Co - Eo Gió 3N2Đ', N'WV50-TOUR-05', N'Package', 3, 2, N'Quy Nhơn', N'Kỳ Co', N'https://images.unsplash.com/photo-1530789253388-582c481c54b0?auto=format&fit=crop&w=1200&q=85', CAST(4590000.00 AS decimal(18,2)), CAST(3490000.00 AS decimal(18,2)), N'Bus', N'Kết hợp biển xanh, hải sản và các điểm check-in nổi bật Bình Định.', N'Tour nghỉ dưỡng', N'Miền Trung', 1),
            (N'Phan Thiết - Mũi Né 3N2Đ', N'WV50-TOUR-06', N'Package', 3, 2, N'Thành phố Hồ Chí Minh', N'Mũi Né', N'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=85', CAST(4290000.00 AS decimal(18,2)), CAST(3190000.00 AS decimal(18,2)), N'Bus', N'Nghỉ dưỡng biển, ngắm bình minh đồi cát và trải nghiệm làng chài.', N'Tour nghỉ dưỡng', N'Miền Trung', 1),
            (N'Buôn Ma Thuột - Hồ Lắk 3N2Đ', N'WV50-TOUR-07', N'Package', 3, 2, N'Buôn Ma Thuột', N'Hồ Lắk', N'https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=85', CAST(3890000.00 AS decimal(18,2)), CAST(2890000.00 AS decimal(18,2)), N'Bus', N'Tìm hiểu văn hóa Tây Nguyên, thưởng thức cà phê và ngắm hồ Lắk.', N'Tour khám phá', N'Miền Trung', 0),
            (N'Hà Nội - Hà Giang - Lũng Cú 4N3Đ', N'WV50-TOUR-08', N'Package', 4, 3, N'Hà Nội', N'Lũng Cú', N'https://images.unsplash.com/photo-1504150558240-0b4fd8946624?auto=format&fit=crop&w=1200&q=85', CAST(5990000.00 AS decimal(18,2)), CAST(4590000.00 AS decimal(18,2)), N'Bus', N'Chinh phục cao nguyên đá, đèo Mã Pí Lèng và cột cờ Lũng Cú.', N'Tour khám phá', N'Miền Bắc', 1),
            (N'Thành phố Hồ Chí Minh - Vũng Tàu 2N1Đ', N'WV50-TOUR-09', N'Package', 2, 1, N'Thành phố Hồ Chí Minh', N'Vũng Tàu', N'https://images.unsplash.com/photo-1518509562904-e7ef99cdcc86?auto=format&fit=crop&w=1200&q=85', CAST(2690000.00 AS decimal(18,2)), CAST(1990000.00 AS decimal(18,2)), N'Bus', N'Chuyến nghỉ biển cuối tuần với lịch trình nhẹ và nhiều thời gian tự do.', N'Tour gia đình', N'Miền Nam', 0),
            (N'Cần Thơ - Châu Đốc - Trà Sư 3N2Đ', N'WV50-TOUR-10', N'Package', 3, 2, N'Cần Thơ', N'An Giang', N'https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=85', CAST(3590000.00 AS decimal(18,2)), CAST(2690000.00 AS decimal(18,2)), N'Bus', N'Khám phá chợ nổi, rừng tràm Trà Sư và văn hóa miền Tây sông nước.', N'Tour khám phá', N'Miền Nam', 0)
        ) AS data([tourName], [tourCode], [tourType], [numberOfDay], [numberOfNights], [startPlace], [endPlace], [image], [adultPrice], [childrenPrice], [transport], [introduction], [categoryName], [regionName], [isFeatured])
    )
    INSERT INTO [dbo].[Tour] (
        [tourCategoryID], [tourName], [tourCode], [tourType], [numberOfDay], [numberOfNights], [startPlace], [endPlace],
        [image], [adultPrice], [childrenPrice], [infantPrice], [singleRoomSurcharge], [depositPercent], [vatPercent],
        [tourIntroduce], [tourInclude], [tourNonInclude], [pickupPointName], [pickupAddress], [arriveBeforeMinutes], [pickupNote],
        [mainTransportType], [childPolicyNote], [rate], [status], [isFeatured], [regionID], [createdByUserID], [createdAt]
    )
    SELECT COALESCE(category.[tourCategoryID], @DefaultCategoryID), seed.[tourName], seed.[tourCode], seed.[tourType],
           seed.[numberOfDay], seed.[numberOfNights], seed.[startPlace], seed.[endPlace], seed.[image], seed.[adultPrice],
           seed.[childrenPrice], CAST(0.00 AS decimal(18,2)), CAST(0.00 AS decimal(18,2)), 20, 8, seed.[introduction],
           N'Xe đưa đón, khách sạn, vé tham quan và các bữa ăn theo chương trình.',
           N'Chi phí cá nhân và dịch vụ ngoài chương trình.', N'Điểm hẹn trung tâm', seed.[startPlace], 30,
           N'Có mặt trước giờ khởi hành 30 phút.', seed.[transport], N'Giá trẻ em áp dụng theo chính sách tại thời điểm booking.',
           CAST(4.50 AS decimal(3,2)), N'Active', seed.[isFeatured], COALESCE(region.[regionID], @DefaultRegionID),
           @CreatedByUserID, GETDATE()
    FROM TourSeed seed
    LEFT JOIN [dbo].[Tour_Category] category
        ON category.[categoryName] = seed.[categoryName] AND category.[status] = N'Active'
    LEFT JOIN [dbo].[Region] region
        ON region.[regionName] = seed.[regionName] AND region.[status] = N'Active'
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[Tour] currentTour
        WHERE currentTour.[tourCode] = seed.[tourCode]
    );

    /* 10 voucher mới; applicableType/usedCount là hai cột được bổ sung trong database 5.0. */
    ;WITH VoucherSeed AS (
        SELECT *
        FROM (VALUES
            (N'WV50-SUMMER10', N'Giảm 10% cho đơn từ 1.500.000đ', CAST(10.00 AS decimal(5,2)), CAST(NULL AS decimal(18,2)), CAST(1500000.00 AS decimal(18,2)), 100, -1, 75, N'All'),
            (N'WV50-TOUR15', N'Giảm 15% cho booking tour', CAST(15.00 AS decimal(5,2)), CAST(NULL AS decimal(18,2)), CAST(3000000.00 AS decimal(18,2)), 60, 0, 90, N'Tour'),
            (N'WV50-ROOM200', N'Giảm 200.000đ cho booking accommodation', CAST(NULL AS decimal(5,2)), CAST(200000.00 AS decimal(18,2)), CAST(1000000.00 AS decimal(18,2)), 80, 0, 120, N'Accommodation'),
            (N'WV50-FAMILY12', N'Giảm 12% cho chuyến đi gia đình', CAST(12.00 AS decimal(5,2)), CAST(NULL AS decimal(18,2)), CAST(5000000.00 AS decimal(18,2)), 40, 0, 100, N'All'),
            (N'WV50-WEEKEND8', N'Giảm 8% cho kỳ nghỉ cuối tuần', CAST(8.00 AS decimal(5,2)), CAST(NULL AS decimal(18,2)), CAST(2000000.00 AS decimal(18,2)), 120, 7, 150, N'All'),
            (N'WV50-MOUNTAIN18', N'Giảm 18% cho tour vùng núi', CAST(18.00 AS decimal(5,2)), CAST(NULL AS decimal(18,2)), CAST(2500000.00 AS decimal(18,2)), 35, 0, 110, N'Tour'),
            (N'WV50-BEACH250', N'Giảm 250.000đ cho kỳ nghỉ biển', CAST(NULL AS decimal(5,2)), CAST(250000.00 AS decimal(18,2)), CAST(3500000.00 AS decimal(18,2)), 70, 0, 95, N'Accommodation'),
            (N'WV50-EARLYBIRD20', N'Giảm 20% cho khách đặt sớm', CAST(20.00 AS decimal(5,2)), CAST(NULL AS decimal(18,2)), CAST(4000000.00 AS decimal(18,2)), 25, 0, 60, N'Tour'),
            (N'WV50-LOCAL100', N'Giảm 100.000đ cho đơn địa phương', CAST(NULL AS decimal(5,2)), CAST(100000.00 AS decimal(18,2)), CAST(1000000.00 AS decimal(18,2)), 150, 0, 180, N'All'),
            (N'WV50-VIP300', N'Giảm 300.000đ cho đơn giá trị cao', CAST(NULL AS decimal(5,2)), CAST(300000.00 AS decimal(18,2)), CAST(6000000.00 AS decimal(18,2)), 30, 0, 210, N'All')
        ) AS data([code], [description], [percentDiscount], [amountDiscount], [minOrderAmount], [quantity], [startOffset], [endOffset], [applicableType])
    )
    INSERT INTO [dbo].[Voucher] (
        [code], [description], [percentDiscount], [amountDiscount], [minOrderAmount], [quantity], [startDate], [endDate],
        [status], [createdAt], [applicableType], [usedCount]
    )
    SELECT seed.[code], seed.[description], seed.[percentDiscount], seed.[amountDiscount], seed.[minOrderAmount], seed.[quantity],
           CAST(DATEADD(DAY, seed.[startOffset], CAST(GETDATE() AS date)) AS datetime),
           CAST(DATEADD(DAY, seed.[endOffset], CAST(GETDATE() AS date)) AS datetime),
           N'Active', GETDATE(), seed.[applicableType], 0
    FROM VoucherSeed seed
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[Voucher] currentVoucher
        WHERE currentVoucher.[code] = seed.[code]
    );

    COMMIT TRANSACTION;

    SELECT N'Accommodation' AS [DataSet], COUNT(*) AS [Total]
    FROM [dbo].[Accommodation]
    WHERE [name] IN (
        N'Hội An Garden Stay', N'Mộc Châu Green Valley', N'Quy Nhơn Seaside Hotel', N'Sa Đéc Riverside Lodge',
        N'Vũng Tàu Lighthouse Hotel', N'Cát Bà Island Retreat', N'Buôn Ma Thuột Coffee House', N'Phan Thiết Sand Dunes Resort',
        N'Tam Đảo Misty Hill', N'Hà Giang Stone Valley'
    )
    UNION ALL
    SELECT N'Room', COUNT(*)
    FROM [dbo].[Room]
    WHERE [roomType] IN (
        N'Garden Deluxe', N'Valley Bungalow', N'Ocean Balcony Twin', N'Riverside Family Loft', N'Lighthouse Suite',
        N'Island Cottage', N'Coffee View Double', N'Dune Pool Villa', N'Mountain View Triple', N'Stone House Family'
    )
    UNION ALL
    SELECT N'Tour', COUNT(*) FROM [dbo].[Tour] WHERE [tourCode] LIKE N'WV50-TOUR-%'
    UNION ALL
    SELECT N'Voucher', COUNT(*) FROM [dbo].[Voucher] WHERE [code] LIKE N'WV50-%';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
