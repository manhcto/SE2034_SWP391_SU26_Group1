USE [WonderVn]
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @StaffUserID INT = (
        SELECT TOP (1) [userID]
        FROM [dbo].[User]
        WHERE [roleID] IN (1, 2) AND [status] = N'Active'
        ORDER BY CASE WHEN [roleID] = 2 THEN 0 ELSE 1 END, [userID]
    );
    DECLARE @DefaultCategoryID INT = (
        SELECT TOP (1) [tourCategoryID]
        FROM [dbo].[Tour_Category]
        WHERE [status] = N'Active'
        ORDER BY [tourCategoryID]
    );
    DECLARE @NorthRegionID INT = (
        SELECT TOP (1) [regionID] FROM [dbo].[Region]
        WHERE [regionName] = N'Miền Bắc' AND [status] = N'Active'
    );
    DECLARE @CentralRegionID INT = (
        SELECT TOP (1) [regionID] FROM [dbo].[Region]
        WHERE [regionName] = N'Miền Trung' AND [status] = N'Active'
    );
    DECLARE @SouthRegionID INT = (
        SELECT TOP (1) [regionID] FROM [dbo].[Region]
        WHERE [regionName] = N'Miền Nam' AND [status] = N'Active'
    );

    IF @StaffUserID IS NULL OR @DefaultCategoryID IS NULL
        THROW 50001, N'Cần có ít nhất một staff/admin và một danh mục tour đang hoạt động.', 1;

    SET @NorthRegionID = COALESCE(@NorthRegionID, (SELECT TOP (1) [regionID] FROM [dbo].[Region] ORDER BY [regionID]));
    SET @CentralRegionID = COALESCE(@CentralRegionID, @NorthRegionID);
    SET @SouthRegionID = COALESCE(@SouthRegionID, @NorthRegionID);

    /* 10 tour. Mã WV-DEMO-* là khóa nhận diện để script có thể chạy lại an toàn. */
    ;WITH TourSeed AS (
        SELECT *
        FROM (VALUES
            (N'WV-DEMO-01', N'Hà Nội - Hạ Long - Yên Tử 3N2Đ', 3, 2, N'Hà Nội', N'Quảng Ninh', N'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=85', 3990000.00, 2990000.00, N'Xe du lịch', N'Hành trình di sản kết hợp vịnh Hạ Long và không gian thanh tịnh Yên Tử.', @NorthRegionID, 1),
            (N'WV-DEMO-02', N'Hà Nội - Sa Pa - Fansipan 3N2Đ', 3, 2, N'Hà Nội', N'Lào Cai', N'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=85', 4290000.00, 3290000.00, N'Xe du lịch', N'Săn mây Sa Pa, khám phá bản làng và chinh phục đỉnh Fansipan.', @NorthRegionID, 1),
            (N'WV-DEMO-03', N'Hà Nội - Hà Giang - Đồng Văn 4N3Đ', 4, 3, N'Hà Nội', N'Hà Giang', N'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1200&q=85', 5690000.00, 4390000.00, N'Xe du lịch', N'Khám phá cao nguyên đá, Mã Pí Lèng và những cung đường đẹp nhất miền Bắc.', @NorthRegionID, 1),
            (N'WV-DEMO-04', N'Đà Nẵng - Hội An - Bà Nà Hills 3N2Đ', 3, 2, N'Đà Nẵng', N'Đà Nẵng', N'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1200&q=85', 4590000.00, 3490000.00, N'Xe du lịch', N'Kết hợp phố cổ Hội An, biển Mỹ Khê và trải nghiệm Cầu Vàng.', @CentralRegionID, 1),
            (N'WV-DEMO-05', N'Huế - Quảng Bình - Phong Nha 3N2Đ', 3, 2, N'Huế', N'Quảng Bình', N'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=1200&q=85', 4190000.00, 3190000.00, N'Xe du lịch', N'Từ cố đô Huế đến kỳ quan hang động Phong Nha - Kẻ Bàng.', @CentralRegionID, 0),
            (N'WV-DEMO-06', N'Nha Trang - Đảo Hòn Mun 3N2Đ', 3, 2, N'Thành phố Hồ Chí Minh', N'Khánh Hòa', N'https://images.unsplash.com/photo-1530789253388-582c481c54b0?auto=format&fit=crop&w=1200&q=85', 4890000.00, 3690000.00, N'Máy bay', N'Nghỉ dưỡng biển, lặn ngắm san hô và thưởng thức hải sản Nha Trang.', @CentralRegionID, 1),
            (N'WV-DEMO-07', N'Thành phố Hồ Chí Minh - Đà Lạt 3N2Đ', 3, 2, N'Thành phố Hồ Chí Minh', N'Lâm Đồng', N'https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=85', 3790000.00, 2890000.00, N'Xe du lịch', N'Hành trình săn mây, tham quan vườn hoa và trải nghiệm cà phê cao nguyên.', @SouthRegionID, 1),
            (N'WV-DEMO-08', N'Thành phố Hồ Chí Minh - Phú Quốc 4N3Đ', 4, 3, N'Thành phố Hồ Chí Minh', N'An Giang', N'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=85', 6990000.00, 5290000.00, N'Máy bay', N'Nghỉ dưỡng đảo ngọc, ngắm hoàng hôn và khám phá biển phía Nam.', @SouthRegionID, 1),
            (N'WV-DEMO-09', N'Cần Thơ - Sóc Trăng - Bạc Liêu 3N2Đ', 3, 2, N'Cần Thơ', N'Cà Mau', N'https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=85', 3590000.00, 2690000.00, N'Xe du lịch', N'Khám phá chợ nổi, văn hóa Khmer và nhịp sống miền Tây sông nước.', @SouthRegionID, 0),
            (N'WV-DEMO-10', N'Thành phố Hồ Chí Minh - Côn Đảo 3N2Đ', 3, 2, N'Thành phố Hồ Chí Minh', N'Thành phố Hồ Chí Minh', N'https://images.unsplash.com/photo-1518509562904-e7ef99cdcc86?auto=format&fit=crop&w=1200&q=85', 7290000.00, 5490000.00, N'Máy bay', N'Hành trình biển đảo kết hợp lịch sử, thiên nhiên và nghỉ dưỡng yên tĩnh.', @SouthRegionID, 1)
        ) AS data(tourCode, tourName, numberOfDay, numberOfNights, startPlace, endPlace, image, adultPrice, childrenPrice, transport, introduction, regionID, isFeatured)
    )
    INSERT INTO [dbo].[Tour] (
        [tourCategoryID], [tourName], [tourCode], [tourType], [numberOfDay], [numberOfNights],
        [startPlace], [endPlace], [image], [adultPrice], [childrenPrice], [infantPrice],
        [singleRoomSurcharge], [depositPercent], [vatPercent], [tourIntroduce], [tourInclude],
        [tourNonInclude], [pickupPointName], [pickupAddress], [arriveBeforeMinutes], [pickupNote],
        [mainTransportType], [childPolicyNote], [rate], [status], [isFeatured], [regionID],
        [createdByUserID], [approvedByUserID], [approvedAt], [createdAt]
    )
    SELECT
        @DefaultCategoryID, seed.tourName, seed.tourCode, N'Tour trọn gói', seed.numberOfDay,
        seed.numberOfNights, seed.startPlace, seed.endPlace, seed.image, seed.adultPrice,
        seed.childrenPrice, 0, 0, 20, 0, seed.introduction,
        N'Xe đưa đón, khách sạn, vé tham quan và các bữa ăn theo chương trình.',
        N'Chi phí cá nhân và dịch vụ ngoài chương trình.', N'Điểm hẹn trung tâm',
        seed.startPlace, 30, N'Có mặt trước giờ khởi hành 30 phút.', seed.transport,
        N'Giá trẻ em áp dụng theo chính sách tại thời điểm booking.', 4.60, N'Active',
        seed.isFeatured, seed.regionID, @StaffUserID, @StaffUserID, GETDATE(), GETDATE()
    FROM TourSeed seed
    WHERE NOT EXISTS (
        SELECT 1 FROM [dbo].[Tour] currentTour WHERE currentTour.[tourCode] = seed.tourCode
    );

    /* Tour chỉ hiển thị cho customer khi có lịch Open trong tương lai. */
    ;WITH SeedTourSchedule AS (
        SELECT t.[tourID], t.[numberOfDay], t.[adultPrice], t.[childrenPrice],
               ROW_NUMBER() OVER (ORDER BY t.[tourCode]) AS rowNumber
        FROM [dbo].[Tour] t
        WHERE t.[tourCode] LIKE N'WV-DEMO-%'
    )
    INSERT INTO [dbo].[Tour_Scheduler] (
        [tourID], [startDate], [endDate], [departureTime], [expectedReturnTime],
        [bookingDeadline], [minParticipants], [maxParticipants], [quantity], [bookedSeats],
        [maxParticipantsPerBooking], [adultPrice], [childPrice], [infantPrice],
        [singleRoomSurcharge], [depositPercent], [vatPercent], [scheduleStatus], [createdAt]
    )
    SELECT
        seed.[tourID],
        DATEADD(DAY, 7 + ((seed.rowNumber - 1) * 3), CAST(GETDATE() AS date)),
        DATEADD(DAY, seed.[numberOfDay] + 6 + ((seed.rowNumber - 1) * 3), CAST(GETDATE() AS date)),
        CAST('06:30' AS time), CAST('18:00' AS time),
        DATEADD(DAY, 4 + ((seed.rowNumber - 1) * 3), CAST(GETDATE() AS date)),
        5, 30, 0, 0, 8, seed.[adultPrice], seed.[childrenPrice], 0, 0, 20, 0,
        N'Open', GETDATE()
    FROM SeedTourSchedule seed
    WHERE NOT EXISTS (
        SELECT 1 FROM [dbo].[Tour_Scheduler] schedule WHERE schedule.[tourID] = seed.[tourID]
    );

    /* 10 nơi lưu trú. */
    ;WITH AccommodationSeed AS (
        SELECT *
        FROM (VALUES
            (N'Wonder Riverside Hà Nội', N'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=85', N'18 Tông Đản', N'02438881001', N'Khách sạn trung tâm gần phố cổ, phù hợp khách công tác và gia đình.', 4.70, N'Khách sạn', N'Thành phố Hà Nội', N'Phường Hoàn Kiếm'),
            (N'Sa Pa Cloud Retreat', N'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=85', N'36 Fansipan', N'02143881002', N'Retreat nhìn ra thung lũng, không gian yên tĩnh và gần trung tâm Sa Pa.', 4.80, N'Retreat', N'Tỉnh Lào Cai', N'Phường Sa Pa'),
            (N'Hạ Long Marina Hotel', N'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=85', N'88 Hạ Long', N'02033881003', N'Khách sạn ven biển với tầm nhìn vịnh và khu vực vui chơi lân cận.', 4.60, N'Khách sạn', N'Tỉnh Quảng Ninh', N'Phường Bãi Cháy'),
            (N'Huế Heritage House', N'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1200&q=85', N'12 Lê Lợi', N'02343881004', N'Không gian lưu trú mang nét Huế, gần sông Hương và khu di sản.', 4.50, N'Homestay', N'Thành phố Huế', N'Phường Thuận Hóa'),
            (N'Đà Nẵng Ocean Suites', N'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?auto=format&fit=crop&w=1200&q=85', N'120 Võ Nguyên Giáp', N'02363881005', N'Căn phòng hiện đại bên biển, thuận tiện di chuyển đến Hội An.', 4.85, N'Khách sạn', N'Thành phố Đà Nẵng', N'Phường Ngũ Hành Sơn'),
            (N'Hội An Lantern Villa', N'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=85', N'25 Nguyễn Phúc Chu', N'02353881006', N'Villa nhỏ gần phố cổ với sân vườn và hồ bơi riêng.', 4.75, N'Villa', N'Thành phố Đà Nẵng', N'Phường Hội An'),
            (N'Nha Trang Bay Hotel', N'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=1200&q=85', N'66 Trần Phú', N'02583881007', N'Khách sạn hướng biển, gần quảng trường và bến tàu du lịch.', 4.65, N'Khách sạn', N'Tỉnh Khánh Hòa', N'Phường Nha Trang'),
            (N'Đà Lạt Pine Retreat', N'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=85', N'40 Trần Hưng Đạo', N'02633881008', N'Retreat giữa đồi thông, có khu sinh hoạt chung và quán cà phê.', 4.55, N'Retreat', N'Tỉnh Lâm Đồng', N'Phường Xuân Hương - Đà Lạt'),
            (N'Phú Quốc Sunset Resort', N'https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=1200&q=85', N'95 Trần Hưng Đạo', N'02973881009', N'Resort gần biển với hồ bơi, nhà hàng và khu ngắm hoàng hôn.', 4.90, N'Resort', N'Tỉnh An Giang', N'Đặc khu Phú Quốc'),
            (N'Cần Thơ Mekong Lodge', N'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=85', N'15 Hai Bà Trưng', N'02923881010', N'Lodge bên sông, thuận tiện trải nghiệm chợ nổi và ẩm thực miền Tây.', 4.45, N'Lodge', N'Thành phố Cần Thơ', N'Phường Ninh Kiều')
        ) AS data(name, image, address, phone, description, rate, type, province, ward)
    )
    INSERT INTO [dbo].[Accommodation] (
        [name], [image], [address], [phone], [description], [rate], [type], [status],
        [checkInTime], [checkOutTime], [province], [district], [ward], [createdByUserID], [createdAt]
    )
    SELECT seed.name, seed.image, seed.address, seed.phone, seed.description, seed.rate,
           seed.type, N'Available', CAST('14:00' AS time), CAST('12:00' AS time),
           seed.province, NULL, seed.ward, @StaffUserID, GETDATE()
    FROM AccommodationSeed seed
    WHERE NOT EXISTS (
        SELECT 1 FROM [dbo].[Accommodation] currentAccommodation
        WHERE currentAccommodation.[name] = seed.name
    );

    /* 10 loại phòng, mỗi nơi lưu trú mẫu có một loại phòng. */
    ;WITH RoomSeed AS (
        SELECT *
        FROM (VALUES
            (N'Wonder Riverside Hà Nội', N'Deluxe City View', 8, 1150000.00, N'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=1200&q=85', N'Phòng hướng thành phố, bàn làm việc và phòng tắm riêng.', 1, N'Giường King', 2, 1, 30.00),
            (N'Sa Pa Cloud Retreat', N'Valley Balcony', 6, 1450000.00, N'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=85', N'Ban công nhìn thung lũng và khu vực ngồi thư giãn.', 1, N'Giường Queen', 2, 1, 32.00),
            (N'Hạ Long Marina Hotel', N'Bay View Twin', 10, 1350000.00, N'https://images.unsplash.com/photo-1568495248636-6432b97bd949?auto=format&fit=crop&w=1200&q=85', N'Hai giường đơn, cửa sổ lớn nhìn ra vịnh.', 2, N'Giường đơn', 2, 1, 34.00),
            (N'Huế Heritage House', N'Heritage Double', 5, 890000.00, N'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=85', N'Phòng mang phong cách Huế, yên tĩnh và nhiều ánh sáng.', 1, N'Giường Queen', 2, 1, 26.00),
            (N'Đà Nẵng Ocean Suites', N'Ocean Front Suite', 8, 1850000.00, N'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=85', N'Suite hướng biển có khu tiếp khách và bồn tắm.', 1, N'Giường King', 2, 1, 42.00),
            (N'Hội An Lantern Villa', N'Garden Villa', 4, 1650000.00, N'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?auto=format&fit=crop&w=1200&q=85', N'Phòng villa nhìn ra vườn, phù hợp gia đình nhỏ.', 2, N'Giường Queen', 3, 1, 38.00),
            (N'Nha Trang Bay Hotel', N'Superior Sea View', 9, 1290000.00, N'https://images.unsplash.com/photo-1595576508898-0ad5c879a061?auto=format&fit=crop&w=1200&q=85', N'Phòng hướng biển với cửa sổ toàn cảnh.', 1, N'Giường King', 2, 1, 31.00),
            (N'Đà Lạt Pine Retreat', N'Pine Family Room', 6, 1190000.00, N'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?auto=format&fit=crop&w=1200&q=85', N'Phòng gia đình ấm cúng nhìn ra rừng thông.', 2, N'Giường đôi', 3, 1, 36.00),
            (N'Phú Quốc Sunset Resort', N'Sunset Bungalow', 7, 2150000.00, N'https://images.unsplash.com/photo-1602002418082-a4443e081dd1?auto=format&fit=crop&w=1200&q=85', N'Bungalow riêng gần biển và khu vực ngắm hoàng hôn.', 1, N'Giường King', 2, 1, 45.00),
            (N'Cần Thơ Mekong Lodge', N'River View Double', 5, 950000.00, N'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?auto=format&fit=crop&w=1200&q=85', N'Phòng nhìn ra sông, có ban công và bàn trà.', 1, N'Giường Queen', 2, 1, 28.00)
        ) AS data(accommodationName, roomType, roomCount, price, image, description, bedCount, bedType, maxAdults, maxChildren, roomSize)
    )
    INSERT INTO [dbo].[Room] (
        [accommodationID], [roomType], [numberOfRooms], [priceOfRoom], [status],
        [roomAvailability], [image], [description], [bedCount], [bedType],
        [maxAdults], [maxChildren], [roomSize], [createdAt]
    )
    SELECT accommodation.[accommodationID], seed.roomType, seed.roomCount, seed.price,
           N'Available', seed.roomCount, seed.image, seed.description, seed.bedCount,
           seed.bedType, seed.maxAdults, seed.maxChildren, seed.roomSize, GETDATE()
    FROM RoomSeed seed
    INNER JOIN [dbo].[Accommodation] accommodation ON accommodation.[name] = seed.accommodationName
    WHERE NOT EXISTS (
        SELECT 1 FROM [dbo].[Room] currentRoom
        WHERE currentRoom.[accommodationID] = accommodation.[accommodationID]
          AND currentRoom.[roomType] = seed.roomType
    );

    /* 10 bài blog đã duyệt để xuất hiện ở Home và trang Blog. */
    ;WITH BlogSeed AS (
        SELECT *
        FROM (VALUES
            (N'Kinh nghiệm chọn tour phù hợp cho gia đình', N'kinh-nghiem-chon-tour-gia-dinh', N'https://images.unsplash.com/photo-1504150558240-0b4fd8946624?auto=format&fit=crop&w=1200&q=85', N'Cách cân đối thời lượng, lịch trình và ngân sách khi đi cùng trẻ nhỏ.', N'Hãy ưu tiên tour có thời gian di chuyển hợp lý, lịch nghỉ rõ ràng và dịch vụ phù hợp độ tuổi của các thành viên.'),
            (N'Checklist chuẩn bị trước ngày khởi hành', N'checklist-truoc-ngay-khoi-hanh', N'https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=85', N'Danh sách giấy tờ, hành lý và thông tin booking cần kiểm tra.', N'Trước chuyến đi, hãy kiểm tra căn cước, vé, mã booking, thời tiết và thời gian có mặt tại điểm tập kết.'),
            (N'Cẩm nang du lịch Hạ Long tự túc', N'cam-nang-du-lich-ha-long', N'https://images.unsplash.com/photo-1573270689103-d7a4e42b609a?auto=format&fit=crop&w=1200&q=85', N'Gợi ý thời điểm, điểm tham quan và món ngon tại Hạ Long.', N'Hạ Long phù hợp cho chuyến đi từ hai đến ba ngày với lịch tham quan vịnh, bảo tàng và khu phố biển.'),
            (N'Đi Sa Pa mùa nào đẹp nhất?', N'sa-pa-mua-nao-dep', N'https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=85', N'Mỗi mùa Sa Pa có thời tiết và cảnh quan rất khác nhau.', N'Mùa xuân có hoa, mùa hè mát mẻ, mùa thu có ruộng bậc thang và mùa đông phù hợp trải nghiệm săn mây.'),
            (N'Ba ngày khám phá Đà Nẵng và Hội An', N'ba-ngay-da-nang-hoi-an', N'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1200&q=85', N'Lịch trình gọn cho biển, Bà Nà Hills và phố cổ.', N'Ngày đầu khám phá biển, ngày hai dành cho Bà Nà Hills và ngày cuối di chuyển đến Hội An trước khi trở về.'),
            (N'Cách tìm phòng khách sạn còn trống theo ngày', N'cach-tim-phong-con-trong', N'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=85', N'Chọn đúng ngày, số khách và số phòng để nhận kết quả chính xác.', N'Phòng trống phụ thuộc khoảng ngày lưu trú và sức chứa. Hãy nhập đủ người lớn, trẻ em và số phòng trước khi tìm.'),
            (N'Kinh nghiệm du lịch Phú Quốc mùa hè', N'kinh-nghiem-phu-quoc-mua-he', N'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=85', N'Những lưu ý về thời tiết, bãi biển và lịch tham quan đảo.', N'Nên theo dõi dự báo thời tiết, linh hoạt lịch đi đảo và ưu tiên nơi lưu trú thuận tiện cho các hoạt động đã chọn.'),
            (N'Khám phá ẩm thực miền Tây', N'kham-pha-am-thuc-mien-tay', N'https://images.unsplash.com/photo-1559314809-0d155014e29e?auto=format&fit=crop&w=1200&q=85', N'Các món ăn đặc trưng nên thử khi đến Cần Thơ và vùng lân cận.', N'Bún cá, bánh xèo, lẩu mắm và trái cây miệt vườn là những trải nghiệm ẩm thực tiêu biểu của miền Tây.'),
            (N'Hướng dẫn kiểm tra thông tin booking', N'huong-dan-kiem-tra-booking', N'https://images.unsplash.com/photo-1452421822248-d4c2b47f0c81?auto=format&fit=crop&w=1200&q=85', N'Những mục cần đối chiếu sau khi gửi yêu cầu đặt tour hoặc phòng.', N'Kiểm tra mã booking, dịch vụ, ngày sử dụng, thông tin khách và trạng thái xử lý trong mục Đơn booking của tài khoản.'),
            (N'Lưu ý khi tải ảnh căn cước để đặt phòng', N'luu-y-anh-can-cuoc-dat-phong', N'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&w=1200&q=85', N'Cách chuẩn bị ảnh rõ nét và đúng định dạng để hoàn tất form.', N'Ảnh cần đủ sáng, không bị lóa, đọc được thông tin và sử dụng định dạng JPG, PNG hoặc WebP theo giới hạn dung lượng.' )
        ) AS data(title, slug, image, summary, content)
    )
    INSERT INTO [dbo].[Blog] (
        [title], [slug], [image], [summary], [content], [authorUserID], [status], [createdAt]
    )
    SELECT seed.title, seed.slug, seed.image, seed.summary, seed.content,
           @StaffUserID, N'Published', DATEADD(MINUTE, -ROW_NUMBER() OVER (ORDER BY seed.slug), GETDATE())
    FROM BlogSeed seed
    WHERE NOT EXISTS (
        SELECT 1 FROM [dbo].[Blog] currentBlog WHERE currentBlog.[slug] = seed.slug
    );

    COMMIT TRANSACTION;

    SELECT N'Tour mẫu' AS [Nhóm dữ liệu], COUNT(*) AS [Tổng số]
    FROM [dbo].[Tour] WHERE [tourCode] LIKE N'WV-DEMO-%'
    UNION ALL
    SELECT N'Lịch tour mẫu', COUNT(*)
    FROM [dbo].[Tour_Scheduler] schedule
    INNER JOIN [dbo].[Tour] tour ON tour.[tourID] = schedule.[tourID]
    WHERE tour.[tourCode] LIKE N'WV-DEMO-%'
    UNION ALL
    SELECT N'Nơi lưu trú mẫu', COUNT(*)
    FROM [dbo].[Accommodation]
    WHERE [name] IN (
        N'Wonder Riverside Hà Nội', N'Sa Pa Cloud Retreat', N'Hạ Long Marina Hotel',
        N'Huế Heritage House', N'Đà Nẵng Ocean Suites', N'Hội An Lantern Villa',
        N'Nha Trang Bay Hotel', N'Đà Lạt Pine Retreat', N'Phú Quốc Sunset Resort',
        N'Cần Thơ Mekong Lodge'
    )
    UNION ALL
    SELECT N'Phòng mẫu', COUNT(*)
    FROM [dbo].[Room] room
    INNER JOIN [dbo].[Accommodation] accommodation
        ON accommodation.[accommodationID] = room.[accommodationID]
    WHERE accommodation.[name] IN (
        N'Wonder Riverside Hà Nội', N'Sa Pa Cloud Retreat', N'Hạ Long Marina Hotel',
        N'Huế Heritage House', N'Đà Nẵng Ocean Suites', N'Hội An Lantern Villa',
        N'Nha Trang Bay Hotel', N'Đà Lạt Pine Retreat', N'Phú Quốc Sunset Resort',
        N'Cần Thơ Mekong Lodge'
    )
    UNION ALL
    SELECT N'Blog mẫu', COUNT(*)
    FROM [dbo].[Blog] WHERE [slug] IN (
        N'kinh-nghiem-chon-tour-gia-dinh', N'checklist-truoc-ngay-khoi-hanh',
        N'cam-nang-du-lich-ha-long', N'sa-pa-mua-nao-dep', N'ba-ngay-da-nang-hoi-an',
        N'cach-tim-phong-con-trong', N'kinh-nghiem-phu-quoc-mua-he',
        N'kham-pha-am-thuc-mien-tay', N'huong-dan-kiem-tra-booking',
        N'luu-y-anh-can-cuoc-dat-phong'
    );
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
