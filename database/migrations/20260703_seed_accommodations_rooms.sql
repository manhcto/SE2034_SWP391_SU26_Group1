USE [WonderVn];
GO

SET NOCOUNT ON;
GO

/*
    Sample accommodation catalog for testing search, room availability, and booking.
    Safe to run multiple times: existing accommodations/rooms are reused by name/type.
    Target data: 10 accommodations and 10 room types for each accommodation.
*/
BEGIN TRANSACTION;

IF NOT EXISTS (SELECT 1 FROM [dbo].[Facility] WHERE [facilityName] = N'Wifi')
    INSERT INTO [dbo].[Facility] ([facilityName], [icon], [facilityScope], [status])
    VALUES (N'Wifi', N'fa-wifi', N'Both', N'Active');

IF NOT EXISTS (SELECT 1 FROM [dbo].[Facility] WHERE [facilityName] = N'Điều hòa')
    INSERT INTO [dbo].[Facility] ([facilityName], [icon], [facilityScope], [status])
    VALUES (N'Điều hòa', N'fa-snowflake', N'Room', N'Active');

IF NOT EXISTS (SELECT 1 FROM [dbo].[Facility] WHERE [facilityName] = N'Bữa sáng')
    INSERT INTO [dbo].[Facility] ([facilityName], [icon], [facilityScope], [status])
    VALUES (N'Bữa sáng', N'fa-mug-saucer', N'Accommodation', N'Active');

IF NOT EXISTS (SELECT 1 FROM [dbo].[Facility] WHERE [facilityName] = N'Bãi đỗ xe')
    INSERT INTO [dbo].[Facility] ([facilityName], [icon], [facilityScope], [status])
    VALUES (N'Bãi đỗ xe', N'fa-square-parking', N'Accommodation', N'Active');

IF NOT EXISTS (SELECT 1 FROM [dbo].[Facility] WHERE [facilityName] = N'Hồ bơi')
    INSERT INTO [dbo].[Facility] ([facilityName], [icon], [facilityScope], [status])
    VALUES (N'Hồ bơi', N'fa-person-swimming', N'Accommodation', N'Active');

IF NOT EXISTS (SELECT 1 FROM [dbo].[Facility] WHERE [facilityName] = N'Phòng tắm riêng')
    INSERT INTO [dbo].[Facility] ([facilityName], [icon], [facilityScope], [status])
    VALUES (N'Phòng tắm riêng', N'fa-bath', N'Room', N'Active');

DECLARE @staffUserID INT = (
    SELECT TOP 1 u.[userID]
    FROM [dbo].[User] u
    INNER JOIN [dbo].[Role] r ON r.[roleID] = u.[roleID]
    WHERE r.[roleName] = N'Staff'
    ORDER BY u.[userID]
);

DECLARE @AccommodationSeed TABLE (
    [seedNo] INT NOT NULL PRIMARY KEY,
    [name] NVARCHAR(255) NOT NULL,
    [image] NVARCHAR(MAX) NULL,
    [address] NVARCHAR(255) NOT NULL,
    [phone] NVARCHAR(20) NULL,
    [description] NVARCHAR(MAX) NULL,
    [rate] DECIMAL(3,2) NULL,
    [type] NVARCHAR(100) NULL,
    [province] NVARCHAR(100) NULL,
    [district] NVARCHAR(100) NULL,
    [ward] NVARCHAR(100) NULL
);

INSERT INTO @AccommodationSeed
    ([seedNo], [name], [image], [address], [phone], [description], [rate], [type], [province], [district], [ward])
VALUES
    (1, N'Wonder Hotel Hà Nội', N'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80', N'25 Lý Thường Kiệt', N'02439990000', N'Khách sạn trung tâm phù hợp khách công tác và du lịch gia đình.', 4.60, N'Hotel', N'Hà Nội', N'Hoàn Kiếm', N'Cửa Nam'),
    (2, N'Sapa Mist Resort', N'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80', N'12 Fansipan', N'02143880001', N'Resort nghỉ dưỡng nhìn ra thung lũng, phù hợp tour miền núi.', 4.70, N'Resort', N'Lào Cai', N'Sa Pa', N'Sa Pa'),
    (3, N'Hạ Long Marina Hotel', N'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=1200&q=80', N'88 Hạ Long', N'02033880002', N'Khách sạn gần bến du thuyền, thuận tiện tham quan vịnh.', 4.50, N'Hotel', N'Quảng Ninh', N'Hạ Long', N'Bãi Cháy'),
    (4, N'Ninh Bình Eco Lodge', N'https://images.unsplash.com/photo-1501117716987-c8e1ecb21035?auto=format&fit=crop&w=1200&q=80', N'35 Tràng An', N'02293880003', N'Lodge sinh thái yên tĩnh, gần các tuyến tham quan Tràng An.', 4.40, N'Lodge', N'Ninh Bình', N'Hoa Lư', N'Tràng An'),
    (5, N'Huế Heritage Hotel', N'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=80', N'9 Lê Lợi', N'02343880004', N'Không gian lưu trú gần sông Hương và các điểm di sản.', 4.45, N'Hotel', N'Thành phố Huế', N'Huế', N'Phú Hội'),
    (6, N'Đà Nẵng Ocean Suites', N'https://images.unsplash.com/photo-1564501049412-61c2a3083791?auto=format&fit=crop&w=1200&q=80', N'120 Võ Nguyên Giáp', N'02363880005', N'Khách sạn biển có nhiều hạng phòng cho gia đình và nhóm bạn.', 4.80, N'Hotel', N'Đà Nẵng', N'Ngũ Hành Sơn', N'Mỹ An'),
    (7, N'Hội An Lantern Villa', N'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=1200&q=80', N'18 Nguyễn Phúc Chu', N'02353880006', N'Villa phong cách phố cổ, phù hợp khách nghỉ dưỡng ngắn ngày.', 4.55, N'Villa', N'Đà Nẵng', N'Hội An', N'Minh An'),
    (8, N'Nha Trang Bay Hotel', N'https://images.unsplash.com/photo-1568084680786-a84f91d1153c?auto=format&fit=crop&w=1200&q=80', N'66 Trần Phú', N'02583880007', N'Khách sạn ven biển với nhiều phòng hướng vịnh.', 4.65, N'Hotel', N'Khánh Hòa', N'Nha Trang', N'Lộc Thọ'),
    (9, N'Đà Lạt Pine Retreat', N'https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=1200&q=80', N'40 Trần Hưng Đạo', N'02633880008', N'Khu nghỉ dưỡng yên tĩnh giữa không gian thông xanh.', 4.50, N'Retreat', N'Lâm Đồng', N'Đà Lạt', N'Phường 10'),
    (10, N'Phú Quốc Sunset Resort', N'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=1200&q=80', N'95 Trần Hưng Đạo', N'02973880009', N'Resort biển phù hợp nghỉ dưỡng dài ngày và tuần trăng mật.', 4.85, N'Resort', N'An Giang', N'Phú Quốc', N'Dương Đông');

DECLARE @RoomSeed TABLE (
    [roomNo] INT NOT NULL PRIMARY KEY,
    [roomType] NVARCHAR(100) NOT NULL,
    [priceOfRoom] DECIMAL(18,2) NOT NULL,
    [numberOfRooms] INT NOT NULL,
    [bedCount] INT NOT NULL,
    [bedType] NVARCHAR(50) NOT NULL,
    [maxAdults] INT NOT NULL,
    [maxChildren] INT NOT NULL,
    [roomSize] DECIMAL(10,2) NOT NULL,
    [image] NVARCHAR(MAX) NULL,
    [description] NVARCHAR(MAX) NULL
);

INSERT INTO @RoomSeed
    ([roomNo], [roomType], [priceOfRoom], [numberOfRooms], [bedCount], [bedType], [maxAdults], [maxChildren], [roomSize], [image], [description])
VALUES
    (1, N'Standard Queen', 650000, 10, 1, N'Queen', 2, 1, 24, N'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=1200&q=80', N'Phòng tiêu chuẩn gọn gàng, phù hợp khách đi công tác hoặc cặp đôi.'),
    (2, N'Superior Twin', 760000, 10, 2, N'Twin', 2, 1, 28, N'https://images.unsplash.com/photo-1590490359683-658d3d23f972?auto=format&fit=crop&w=1200&q=80', N'Phòng hai giường đơn, tiện cho bạn bè hoặc đồng nghiệp.'),
    (3, N'Deluxe Double', 950000, 9, 1, N'King', 2, 1, 32, N'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=1200&q=80', N'Phòng đôi rộng, có khu vực ngồi và ánh sáng tự nhiên.'),
    (4, N'Premier Balcony', 1150000, 8, 1, N'King', 2, 1, 36, N'https://images.unsplash.com/photo-1591088398332-8a7791972843?auto=format&fit=crop&w=1200&q=80', N'Phòng có ban công, thích hợp khách muốn không gian thoáng.'),
    (5, N'Family Suite', 1450000, 7, 2, N'Queen + Single', 3, 2, 45, N'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', N'Suite gia đình với không gian sinh hoạt riêng.'),
    (6, N'Executive King', 1680000, 6, 1, N'King', 2, 1, 42, N'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1200&q=80', N'Phòng cao cấp dành cho khách cần tiện nghi làm việc.'),
    (7, N'Connecting Room', 1880000, 5, 3, N'Queen + Twin', 4, 2, 58, N'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?auto=format&fit=crop&w=1200&q=80', N'Hai phòng thông nhau, phù hợp gia đình đông người.'),
    (8, N'Studio Apartment', 2100000, 5, 1, N'King', 2, 1, 52, N'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=1200&q=80', N'Phòng dạng căn hộ có khu bếp nhỏ và bàn ăn.'),
    (9, N'Garden View Suite', 2450000, 4, 1, N'King', 2, 2, 62, N'https://images.unsplash.com/photo-1609766857041-ed402ea8069a?auto=format&fit=crop&w=1200&q=80', N'Suite rộng với hướng nhìn sân vườn hoặc cảnh quan nội khu.'),
    (10, N'Presidential Suite', 4200000, 2, 2, N'King + Queen', 4, 2, 96, N'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80', N'Hạng phòng sang trọng nhất, có phòng khách và tiện nghi cao cấp.');

DECLARE @seedNo INT = 1;
DECLARE @accommodationID INT;
DECLARE @roomID INT;
DECLARE @roomNo INT;

WHILE @seedNo <= 10
BEGIN
    SELECT @accommodationID = [accommodationID]
    FROM [dbo].[Accommodation]
    WHERE [name] = (SELECT [name] FROM @AccommodationSeed WHERE [seedNo] = @seedNo);

    IF @accommodationID IS NULL
    BEGIN
        INSERT INTO [dbo].[Accommodation] (
            [name], [image], [address], [phone], [description], [rate], [type], [status],
            [checkInTime], [checkOutTime], [province], [district], [ward], [createdByUserID]
        )
        SELECT
            [name], [image], [address], [phone], [description], [rate], [type], N'Available',
            CAST(N'14:00:00' AS TIME), CAST(N'12:00:00' AS TIME), [province], [district], [ward], @staffUserID
        FROM @AccommodationSeed
        WHERE [seedNo] = @seedNo;

        SET @accommodationID = SCOPE_IDENTITY();
    END;

    INSERT INTO [dbo].[Accommodation_Facility] ([accommodationID], [facilityID])
    SELECT @accommodationID, f.[facilityID]
    FROM [dbo].[Facility] f
    WHERE f.[facilityName] IN (N'Wifi', N'Bữa sáng', N'Bãi đỗ xe', N'Hồ bơi')
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[Accommodation_Facility] af
          WHERE af.[accommodationID] = @accommodationID
            AND af.[facilityID] = f.[facilityID]
      );

    SET @roomNo = 1;
    WHILE @roomNo <= 10
    BEGIN
        SELECT @roomID = [roomID]
        FROM [dbo].[Room]
        WHERE [accommodationID] = @accommodationID
          AND [roomType] = (SELECT [roomType] FROM @RoomSeed WHERE [roomNo] = @roomNo);

        IF @roomID IS NULL
        BEGIN
            INSERT INTO [dbo].[Room] (
                [accommodationID], [roomType], [numberOfRooms], [priceOfRoom], [status],
                [roomAvailability], [image], [description], [bedCount], [bedType],
                [maxAdults], [maxChildren], [roomSize]
            )
            SELECT
                @accommodationID,
                rs.[roomType],
                rs.[numberOfRooms],
                rs.[priceOfRoom] + ((@seedNo - 1) * 85000),
                N'Available',
                rs.[numberOfRooms],
                rs.[image],
                rs.[description],
                rs.[bedCount],
                rs.[bedType],
                rs.[maxAdults],
                rs.[maxChildren],
                rs.[roomSize]
            FROM @RoomSeed rs
            WHERE rs.[roomNo] = @roomNo;

            SET @roomID = SCOPE_IDENTITY();
        END;

        INSERT INTO [dbo].[Room_Facility] ([roomID], [facilityID])
        SELECT @roomID, f.[facilityID]
        FROM [dbo].[Facility] f
        WHERE f.[facilityName] IN (N'Wifi', N'Điều hòa', N'Phòng tắm riêng')
          AND NOT EXISTS (
              SELECT 1
              FROM [dbo].[Room_Facility] rf
              WHERE rf.[roomID] = @roomID
                AND rf.[facilityID] = f.[facilityID]
          );

        SET @roomNo += 1;
        SET @roomID = NULL;
    END;

    SET @seedNo += 1;
    SET @accommodationID = NULL;
END;

COMMIT TRANSACTION;

SELECT
    (SELECT COUNT(*) FROM [dbo].[Accommodation]) AS [accommodationCount],
    (SELECT COUNT(*) FROM [dbo].[Room]) AS [roomCount],
    N'Seeded accommodation and room sample data successfully.' AS [message];
GO
