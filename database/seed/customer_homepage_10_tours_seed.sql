/*
    CUSTOMER HOMEPAGE - 10 TOUR DEMO DATA
    Chạy sau SQL gốc + các migration/patch staff tour.
    Mục tiêu:
      - Có 10 tour thuộc nhiều thể loại/khu vực để xem trong Staff và Homepage.
      - Tất cả tour demo được set Active và có lịch Open trong tương lai để homepage hiển thị.
      - Script viết an toàn để chạy lại nhiều lần, không spam tour trùng theo tourCode.
*/

USE [WonderVn];
GO

SET NOCOUNT ON;
GO

/* =========================================================
   1. VÁ NHẸ NHỮNG CỘT STAFF/CUSTOMER TOUR CẦN DÙNG
   ========================================================= */

IF COL_LENGTH(N'dbo.Tour_Category', N'categoryName') IS NULL ALTER TABLE dbo.Tour_Category ADD categoryName NVARCHAR(100) NULL;
IF COL_LENGTH(N'dbo.Tour_Category', N'description') IS NULL ALTER TABLE dbo.Tour_Category ADD [description] NVARCHAR(500) NULL;
IF COL_LENGTH(N'dbo.Tour_Category', N'status') IS NULL ALTER TABLE dbo.Tour_Category ADD [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_CustomerHomeSeed_TourCategory_Status DEFAULT (N'Active');
GO

IF COL_LENGTH(N'dbo.Region', N'regionName') IS NULL ALTER TABLE dbo.Region ADD regionName NVARCHAR(100) NULL;
IF COL_LENGTH(N'dbo.Region', N'description') IS NULL ALTER TABLE dbo.Region ADD [description] NVARCHAR(500) NULL;
IF COL_LENGTH(N'dbo.Region', N'status') IS NULL ALTER TABLE dbo.Region ADD [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_CustomerHomeSeed_Region_Status DEFAULT (N'Active');
GO

IF COL_LENGTH(N'dbo.Tour', N'tourCode') IS NULL ALTER TABLE dbo.Tour ADD tourCode NVARCHAR(50) NULL;
IF COL_LENGTH(N'dbo.Tour', N'tourType') IS NULL ALTER TABLE dbo.Tour ADD tourType NVARCHAR(30) NULL;
IF COL_LENGTH(N'dbo.Tour', N'numberOfDay') IS NULL ALTER TABLE dbo.Tour ADD numberOfDay INT NOT NULL CONSTRAINT DF_CustomerHomeSeed_Tour_Day DEFAULT (1);
IF COL_LENGTH(N'dbo.Tour', N'numberOfNights') IS NULL ALTER TABLE dbo.Tour ADD numberOfNights INT NULL;
IF COL_LENGTH(N'dbo.Tour', N'startPlace') IS NULL ALTER TABLE dbo.Tour ADD startPlace NVARCHAR(255) NULL;
IF COL_LENGTH(N'dbo.Tour', N'endPlace') IS NULL ALTER TABLE dbo.Tour ADD endPlace NVARCHAR(255) NULL;
IF COL_LENGTH(N'dbo.Tour', N'image') IS NULL ALTER TABLE dbo.Tour ADD [image] NVARCHAR(500) NULL;
IF COL_LENGTH(N'dbo.Tour', N'adultPrice') IS NULL ALTER TABLE dbo.Tour ADD adultPrice DECIMAL(18,2) NOT NULL CONSTRAINT DF_CustomerHomeSeed_Tour_Adult DEFAULT (0);
IF COL_LENGTH(N'dbo.Tour', N'childrenPrice') IS NULL ALTER TABLE dbo.Tour ADD childrenPrice DECIMAL(18,2) NOT NULL CONSTRAINT DF_CustomerHomeSeed_Tour_Child DEFAULT (0);
IF COL_LENGTH(N'dbo.Tour', N'infantPrice') IS NULL ALTER TABLE dbo.Tour ADD infantPrice DECIMAL(18,2) NOT NULL CONSTRAINT DF_CustomerHomeSeed_Tour_Infant DEFAULT (0);
IF COL_LENGTH(N'dbo.Tour', N'singleRoomSurcharge') IS NULL ALTER TABLE dbo.Tour ADD singleRoomSurcharge DECIMAL(18,2) NOT NULL CONSTRAINT DF_CustomerHomeSeed_Tour_Single DEFAULT (0);
IF COL_LENGTH(N'dbo.Tour', N'depositPercent') IS NULL ALTER TABLE dbo.Tour ADD depositPercent INT NOT NULL CONSTRAINT DF_CustomerHomeSeed_Tour_Deposit DEFAULT (0);
IF COL_LENGTH(N'dbo.Tour', N'vatPercent') IS NULL ALTER TABLE dbo.Tour ADD vatPercent INT NOT NULL CONSTRAINT DF_CustomerHomeSeed_Tour_Vat DEFAULT (8);
IF COL_LENGTH(N'dbo.Tour', N'tourIntroduce') IS NULL ALTER TABLE dbo.Tour ADD tourIntroduce NVARCHAR(MAX) NULL;
IF COL_LENGTH(N'dbo.Tour', N'tourInclude') IS NULL ALTER TABLE dbo.Tour ADD tourInclude NVARCHAR(MAX) NULL;
IF COL_LENGTH(N'dbo.Tour', N'tourNonInclude') IS NULL ALTER TABLE dbo.Tour ADD tourNonInclude NVARCHAR(MAX) NULL;
IF COL_LENGTH(N'dbo.Tour', N'pickupAddress') IS NULL ALTER TABLE dbo.Tour ADD pickupAddress NVARCHAR(500) NULL;
IF COL_LENGTH(N'dbo.Tour', N'mainTransportType') IS NULL ALTER TABLE dbo.Tour ADD mainTransportType NVARCHAR(50) NULL;
IF COL_LENGTH(N'dbo.Tour', N'rate') IS NULL ALTER TABLE dbo.Tour ADD rate DECIMAL(3,2) NULL;
IF COL_LENGTH(N'dbo.Tour', N'status') IS NULL ALTER TABLE dbo.Tour ADD [status] NVARCHAR(50) NOT NULL CONSTRAINT DF_CustomerHomeSeed_Tour_Status DEFAULT (N'Draft');
IF COL_LENGTH(N'dbo.Tour', N'isFeatured') IS NULL ALTER TABLE dbo.Tour ADD isFeatured BIT NOT NULL CONSTRAINT DF_CustomerHomeSeed_Tour_Featured DEFAULT (0);
IF COL_LENGTH(N'dbo.Tour', N'regionID') IS NULL ALTER TABLE dbo.Tour ADD regionID INT NULL;
IF COL_LENGTH(N'dbo.Tour', N'createdByUserID') IS NULL ALTER TABLE dbo.Tour ADD createdByUserID INT NULL;
IF COL_LENGTH(N'dbo.Tour', N'approvedByUserID') IS NULL ALTER TABLE dbo.Tour ADD approvedByUserID INT NULL;
IF COL_LENGTH(N'dbo.Tour', N'approvedAt') IS NULL ALTER TABLE dbo.Tour ADD approvedAt DATETIME NULL;
IF COL_LENGTH(N'dbo.Tour', N'createdAt') IS NULL ALTER TABLE dbo.Tour ADD createdAt DATETIME NOT NULL CONSTRAINT DF_CustomerHomeSeed_Tour_Created DEFAULT (GETDATE());
IF COL_LENGTH(N'dbo.Tour', N'updatedAt') IS NULL ALTER TABLE dbo.Tour ADD updatedAt DATETIME NULL;
GO

IF OBJECT_ID(N'dbo.Tour_Image', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tour_Image (
        imageID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        tourID INT NOT NULL,
        imageUrl NVARCHAR(500) NOT NULL,
        caption NVARCHAR(255) NULL,
        displayOrder INT NOT NULL CONSTRAINT DF_CustomerHomeSeed_TourImage_Order DEFAULT (1),
        [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_CustomerHomeSeed_TourImage_Status DEFAULT (N'Active')
    );
END;
GO
IF COL_LENGTH(N'dbo.Tour_Image', N'displayOrder') IS NULL ALTER TABLE dbo.Tour_Image ADD displayOrder INT NOT NULL CONSTRAINT DF_CustomerHomeSeed_TourImage_Order2 DEFAULT (1);
IF COL_LENGTH(N'dbo.Tour_Image', N'status') IS NULL ALTER TABLE dbo.Tour_Image ADD [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_CustomerHomeSeed_TourImage_Status2 DEFAULT (N'Active');
GO

IF COL_LENGTH(N'dbo.Tour_Itinerary', N'description') IS NULL ALTER TABLE dbo.Tour_Itinerary ADD [description] NVARCHAR(MAX) NULL;
IF COL_LENGTH(N'dbo.Tour_Itinerary', N'mealPlan') IS NULL ALTER TABLE dbo.Tour_Itinerary ADD mealPlan NVARCHAR(500) NULL;
IF COL_LENGTH(N'dbo.Tour_Itinerary', N'transportNote') IS NULL ALTER TABLE dbo.Tour_Itinerary ADD transportNote NVARCHAR(500) NULL;
IF COL_LENGTH(N'dbo.Tour_Itinerary', N'status') IS NULL ALTER TABLE dbo.Tour_Itinerary ADD [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_CustomerHomeSeed_Itinerary_Status DEFAULT (N'Active');
GO

IF COL_LENGTH(N'dbo.Tour_Scheduler', N'scheduleTransportType') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD scheduleTransportType NVARCHAR(50) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'quantity') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD quantity INT NOT NULL CONSTRAINT DF_CustomerHomeSeed_Schedule_Quantity DEFAULT (0);
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'bookedSeats') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD bookedSeats INT NOT NULL CONSTRAINT DF_CustomerHomeSeed_Schedule_Booked DEFAULT (0);
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'maxParticipantsPerBooking') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD maxParticipantsPerBooking INT NOT NULL CONSTRAINT DF_CustomerHomeSeed_Schedule_MaxPerBooking DEFAULT (10);
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'adultPrice') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD adultPrice DECIMAL(18,2) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'childPrice') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD childPrice DECIMAL(18,2) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'infantPrice') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD infantPrice DECIMAL(18,2) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'singleRoomSurcharge') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD singleRoomSurcharge DECIMAL(18,2) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'depositPercent') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD depositPercent INT NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'vatPercent') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD vatPercent INT NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'cancellationPolicy') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD cancellationPolicy NVARCHAR(MAX) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'scheduleStatus') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD scheduleStatus NVARCHAR(30) NOT NULL CONSTRAINT DF_CustomerHomeSeed_Schedule_Status DEFAULT (N'Open');
GO

/* =========================================================
   2. DANH MỤC, KHU VỰC, TỈNH/THÀNH
   ========================================================= */

DECLARE @Categories TABLE (categoryName NVARCHAR(100), [description] NVARCHAR(500));
INSERT INTO @Categories (categoryName, [description]) VALUES
    (N'Tour gia đình', N'Tour phù hợp gia đình và nhóm nhỏ'),
    (N'Tour nghỉ dưỡng', N'Tour nghỉ dưỡng biển, resort, thư giãn'),
    (N'Tour khám phá', N'Tour tham quan, trải nghiệm, khám phá điểm đến'),
    (N'Tour biển đảo', N'Tour biển đảo, du thuyền, nghỉ dưỡng ven biển'),
    (N'Tour văn hóa - lịch sử', N'Tour tham quan di tích, văn hóa, lịch sử'),
    (N'Tour miền núi', N'Tour vùng cao, săn mây, khám phá thiên nhiên'),
    (N'Tour team building', N'Tour đoàn công ty, team building, gala'),
    (N'Tour cao cấp', N'Tour dịch vụ cao cấp');

INSERT INTO dbo.Tour_Category (categoryName, [description], [status])
SELECT c.categoryName, c.[description], N'Active'
FROM @Categories c
WHERE NOT EXISTS (SELECT 1 FROM dbo.Tour_Category tc WHERE tc.categoryName = c.categoryName);

DECLARE @Regions TABLE (regionName NVARCHAR(100), [description] NVARCHAR(500));
INSERT INTO @Regions (regionName, [description]) VALUES
    (N'Miền Bắc', N'Các tuyến du lịch miền Bắc Việt Nam'),
    (N'Miền Trung', N'Các tuyến du lịch miền Trung và Tây Nguyên'),
    (N'Miền Nam', N'Các tuyến du lịch miền Nam Việt Nam');

INSERT INTO dbo.Region (regionName, [description], [status])
SELECT r.regionName, r.[description], N'Active'
FROM @Regions r
WHERE NOT EXISTS (SELECT 1 FROM dbo.Region rg WHERE rg.regionName = r.regionName);
GO

/* Tỉnh/thành cấp tỉnh để AddTour có dữ liệu dropdown, không insert phường/xã */
IF OBJECT_ID(N'dbo.Administrative_Unit', N'U') IS NOT NULL
BEGIN
    IF COL_LENGTH(N'dbo.Administrative_Unit', N'provinceCode') IS NULL ALTER TABLE dbo.Administrative_Unit ADD provinceCode VARCHAR(2) NULL;
    IF COL_LENGTH(N'dbo.Administrative_Unit', N'provinceName') IS NULL ALTER TABLE dbo.Administrative_Unit ADD provinceName NVARCHAR(100) NULL;
    IF COL_LENGTH(N'dbo.Administrative_Unit', N'wardType') IS NULL ALTER TABLE dbo.Administrative_Unit ADD wardType NVARCHAR(20) NULL;
    IF COL_LENGTH(N'dbo.Administrative_Unit', N'wardName') IS NULL ALTER TABLE dbo.Administrative_Unit ADD wardName NVARCHAR(150) NULL;
    IF COL_LENGTH(N'dbo.Administrative_Unit', N'isActive') IS NULL ALTER TABLE dbo.Administrative_Unit ADD isActive BIT NOT NULL CONSTRAINT DF_CustomerHomeSeed_AdminUnit_Active DEFAULT (1);
END;
GO

IF OBJECT_ID(N'dbo.Administrative_Unit', N'U') IS NOT NULL
BEGIN
    DECLARE @SeedProvinces TABLE (provinceCode VARCHAR(2), provinceName NVARCHAR(100));
    INSERT INTO @SeedProvinces VALUES
        ('01', N'Thành phố Hà Nội'), ('02', N'Thành phố Hải Phòng'), ('03', N'Tỉnh Quảng Ninh'),
        ('04', N'Tỉnh Ninh Bình'), ('05', N'Tỉnh Lào Cai'), ('06', N'Tỉnh Hà Giang'),
        ('31', N'Thành phố Đà Nẵng'), ('32', N'Thành phố Huế'), ('35', N'Tỉnh Quảng Nam'),
        ('38', N'Tỉnh Khánh Hòa'), ('39', N'Tỉnh Lâm Đồng'),
        ('61', N'Thành phố Hồ Chí Minh'), ('62', N'Tỉnh Bà Rịa - Vũng Tàu'),
        ('66', N'Thành phố Cần Thơ'), ('67', N'Tỉnh Kiên Giang'), ('68', N'Tỉnh Cà Mau');

    INSERT INTO dbo.Administrative_Unit (provinceCode, provinceName, wardType, wardName, isActive)
    SELECT p.provinceCode, p.provinceName, N'Tỉnh/Thành', N'Trung tâm', 1
    FROM @SeedProvinces p
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.Administrative_Unit au
        WHERE au.provinceName = p.provinceName
          AND au.isActive = 1
          AND (au.wardType IN (N'Tỉnh/Thành', N'Tỉnh', N'Thành phố') OR au.wardName = N'Trung tâm')
    );
END;
GO

/* =========================================================
   3. INSERT/UPDATE 10 TOUR DEMO
   ========================================================= */

DECLARE @SystemUserID INT = (SELECT TOP 1 userID FROM dbo.[User] ORDER BY userID);

IF OBJECT_ID('tempdb..#SeedTours') IS NOT NULL DROP TABLE #SeedTours;
CREATE TABLE #SeedTours (
    tourCode NVARCHAR(50), tourName NVARCHAR(255), categoryName NVARCHAR(100), regionName NVARCHAR(100),
    numberOfDay INT, numberOfNights INT, startPlace NVARCHAR(255), endPlace NVARCHAR(255),
    imageUrl NVARCHAR(500), introImageUrl NVARCHAR(500), adultPrice DECIMAL(18,2), singleRoomSurcharge DECIMAL(18,2),
    mainTransportType NVARCHAR(50), maxParticipants INT, departOffset INT, isFeatured BIT,
    highlight NVARCHAR(MAX), pickupAddress NVARCHAR(500)
);

INSERT INTO #SeedTours VALUES
(N'WV-HLNB-3N2D', N'Hà Nội - Hạ Long - Ninh Bình 3N2Đ', N'Tour khám phá', N'Miền Bắc', 3, 2, N'Thành phố Hà Nội', N'Tỉnh Quảng Ninh', N'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80', N'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1200&q=80', 3900000, 1200000, N'Xe Du Lịch', 45, 35, 1, N'Tham quan vịnh Hạ Long, Tràng An, Hang Múa.\nLịch trình 3 ngày gọn, phù hợp gia đình và nhóm bạn.\nKhởi hành từ Hà Nội, xe du lịch đời mới.', N'Nhà hát Lớn Hà Nội'),
(N'WV-SAPA-3N2D', N'Hà Nội - Sa Pa - Fansipan 3N2Đ', N'Tour miền núi', N'Miền Bắc', 3, 2, N'Thành phố Hà Nội', N'Tỉnh Lào Cai', N'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?auto=format&fit=crop&w=1200&q=80', N'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80', 4590000, 1500000, N'Xe Giường nằm', 40, 42, 1, N'Săn mây Sa Pa, chinh phục Fansipan.\nTham quan bản Cát Cát, nhà thờ đá, chợ đêm.\nPhù hợp khách thích khí hậu mát và cảnh núi.', N'Cổng Công viên Thống Nhất, Hà Nội'),
(N'WV-HAGIANG-4N3D', N'Hà Giang - Đồng Văn - Mã Pì Lèng 4N3Đ', N'Tour miền núi', N'Miền Bắc', 4, 3, N'Thành phố Hà Nội', N'Tỉnh Hà Giang', N'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80', N'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80', 5290000, 1800000, N'Xe Khách', 35, 55, 0, N'Cung đường cao nguyên đá, đèo Mã Pì Lèng, sông Nho Quế.\nLịch trình thiên nhiên và trải nghiệm văn hóa vùng cao.\nPhù hợp nhóm trẻ, khách thích khám phá.', N'Bến xe Mỹ Đình, Hà Nội'),
(N'WV-DNHA-3N2D', N'Đà Nẵng - Bà Nà Hills - Hội An 3N2Đ', N'Tour gia đình', N'Miền Trung', 3, 2, N'Thành phố Đà Nẵng', N'Tỉnh Quảng Nam', N'https://images.unsplash.com/photo-1566139397190-1ca967d5e58d?auto=format&fit=crop&w=1200&q=80', N'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1200&q=80', 4990000, 1600000, N'Xe Du Lịch', 29, 33, 1, N'Check-in Cầu Vàng, phố cổ Hội An, biển Mỹ Khê.\nLịch trình cân bằng vui chơi và nghỉ ngơi.\nPhù hợp gia đình, nhóm bạn và khách lần đầu đi Đà Nẵng.', N'Sân bay quốc tế Đà Nẵng'),
(N'WV-HUE-DN-3N2D', N'Huế - Đà Nẵng - Sơn Trà 3N2Đ', N'Tour văn hóa - lịch sử', N'Miền Trung', 3, 2, N'Thành phố Huế', N'Thành phố Đà Nẵng', N'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1200&q=80', N'https://images.unsplash.com/photo-1566438480900-0609be27a4be?auto=format&fit=crop&w=1200&q=80', 4290000, 1300000, N'Xe Du Lịch', 29, 48, 0, N'Tham quan Đại Nội, chùa Thiên Mụ, bán đảo Sơn Trà.\nKết hợp văn hóa Huế và nghỉ dưỡng biển Đà Nẵng.\nPhù hợp khách yêu lịch sử, ẩm thực miền Trung.', N'Trung tâm thành phố Huế'),
(N'WV-NHATRANG-3N2D', N'Nha Trang - Đảo Hòn Mun - VinWonders 3N2Đ', N'Tour biển đảo', N'Miền Trung', 3, 2, N'Tỉnh Khánh Hòa', N'Tỉnh Khánh Hòa', N'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80', N'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1200&q=80', 5690000, 1700000, N'Xe Du Lịch', 29, 62, 1, N'Tour biển đảo Nha Trang, vui chơi VinWonders.\nCó thời gian nghỉ biển và trải nghiệm hải sản.\nPhù hợp gia đình có trẻ em và nhóm bạn.', N'Trung tâm Nha Trang'),
(N'WV-DALAT-3N2D', N'Đà Lạt - Langbiang - Mongo Land 3N2Đ', N'Tour nghỉ dưỡng', N'Miền Trung', 3, 2, N'Thành phố Hồ Chí Minh', N'Tỉnh Lâm Đồng', N'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80', N'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?auto=format&fit=crop&w=1200&q=80', 3790000, 1000000, N'Xe Giường nằm', 40, 28, 0, N'Khí hậu mát, nhiều điểm check-in đẹp.\nLịch trình nhẹ, phù hợp nghỉ dưỡng ngắn ngày.\nKhởi hành từ TP.HCM, xe giường nằm tiện lợi.', N'Nhà văn hóa Thanh Niên, TP.HCM'),
(N'WV-PHUQUOC-4N3D', N'Phú Quốc - Grand World - Safari 4N3Đ', N'Tour biển đảo', N'Miền Nam', 4, 3, N'Thành phố Hồ Chí Minh', N'Tỉnh Kiên Giang', N'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80', N'https://images.unsplash.com/photo-1520454974749-611b7248ffdb?auto=format&fit=crop&w=1200&q=80', 8290000, 2600000, N'Xe Du Lịch', 29, 40, 1, N'Nghỉ dưỡng Phú Quốc, Grand World, Safari.\nTour phù hợp gia đình, cặp đôi và khách muốn nghỉ dưỡng biển.\nLịch trình có thời gian tự do trải nghiệm.', N'Sân bay Tân Sơn Nhất, TP.HCM'),
(N'WV-MIENTAY-2N1D', N'Cần Thơ - Chợ nổi Cái Răng - Cồn Sơn 2N1Đ', N'Tour văn hóa - lịch sử', N'Miền Nam', 2, 1, N'Thành phố Hồ Chí Minh', N'Thành phố Cần Thơ', N'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1200&q=80', N'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80', 2390000, 700000, N'Xe Khách', 45, 22, 0, N'Trải nghiệm chợ nổi Cái Răng, vườn trái cây và văn hóa miền Tây.\nTour ngắn ngày, chi phí hợp lý.\nPhù hợp gia đình và nhóm bạn cuối tuần.', N'Nhà văn hóa Thanh Niên, TP.HCM'),
(N'WV-VUNGTAU-2N1D', N'Vũng Tàu - Hồ Tràm - Team Building 2N1Đ', N'Tour team building', N'Miền Nam', 2, 1, N'Thành phố Hồ Chí Minh', N'Tỉnh Bà Rịa - Vũng Tàu', N'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80', N'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1200&q=80', 2890000, 900000, N'Xe Du Lịch', 45, 18, 0, N'Tour biển gần TP.HCM, phù hợp công ty và nhóm đông.\nCó khung chương trình team building và gala cơ bản.\nThời gian ngắn, dễ tổ chức cuối tuần.', N'Nhà văn hóa Thanh Niên, TP.HCM');

DECLARE @Code NVARCHAR(50), @Name NVARCHAR(255), @CategoryName NVARCHAR(100), @RegionName NVARCHAR(100),
        @Days INT, @Nights INT, @StartPlace NVARCHAR(255), @EndPlace NVARCHAR(255),
        @ImageUrl NVARCHAR(500), @IntroImageUrl NVARCHAR(500), @AdultPrice DECIMAL(18,2), @SingleRoom DECIMAL(18,2),
        @Transport NVARCHAR(50), @MaxParticipants INT, @DepartOffset INT, @Featured BIT,
        @Highlight NVARCHAR(MAX), @Pickup NVARCHAR(500), @CategoryID INT, @RegionID INT,
        @TourID INT, @ChildPrice DECIMAL(18,2), @InfantPrice DECIMAL(18,2),
        @StartDate DATE, @EndDate DATE, @BookingDeadline DATETIME;

DECLARE TourCursor CURSOR LOCAL FAST_FORWARD FOR
SELECT tourCode, tourName, categoryName, regionName, numberOfDay, numberOfNights, startPlace, endPlace,
       imageUrl, introImageUrl, adultPrice, singleRoomSurcharge, mainTransportType, maxParticipants,
       departOffset, isFeatured, highlight, pickupAddress
FROM #SeedTours;

OPEN TourCursor;
FETCH NEXT FROM TourCursor INTO @Code, @Name, @CategoryName, @RegionName, @Days, @Nights, @StartPlace, @EndPlace,
    @ImageUrl, @IntroImageUrl, @AdultPrice, @SingleRoom, @Transport, @MaxParticipants, @DepartOffset, @Featured,
    @Highlight, @Pickup;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @CategoryID = (SELECT TOP 1 tourCategoryID FROM dbo.Tour_Category WHERE categoryName = @CategoryName ORDER BY tourCategoryID);
    SET @RegionID = (SELECT TOP 1 regionID FROM dbo.Region WHERE regionName = @RegionName ORDER BY regionID);
    SET @ChildPrice = ROUND(@AdultPrice * 0.75 * 1.08, 0);
    SET @InfantPrice = ROUND(@AdultPrice * 0.50 * 1.08, 0);
    SET @StartDate = DATEADD(DAY, @DepartOffset, CAST(GETDATE() AS DATE));
    SET @EndDate = DATEADD(DAY, @Days - 1, @StartDate);
    SET @BookingDeadline = DATEADD(DAY, -3, CAST(@StartDate AS DATETIME));

    IF EXISTS (SELECT 1 FROM dbo.Tour WHERE tourCode = @Code)
    BEGIN
        UPDATE dbo.Tour
        SET tourCategoryID = @CategoryID,
            tourName = @Name,
            tourType = N'Package',
            numberOfDay = @Days,
            numberOfNights = @Nights,
            startPlace = @StartPlace,
            endPlace = @EndPlace,
            [image] = @ImageUrl,
            adultPrice = @AdultPrice,
            childrenPrice = @ChildPrice,
            infantPrice = @InfantPrice,
            singleRoomSurcharge = @SingleRoom,
            depositPercent = 0,
            vatPercent = 8,
            tourIntroduce = N'Tour demo hiển thị homepage WonderVN.',
            tourInclude = @Highlight,
            tourNonInclude = N'Chi phí cá nhân, chi phí phát sinh ngoài chương trình.',
            pickupAddress = @Pickup,
            mainTransportType = @Transport,
            childPolicyNote = N'Trẻ em 5-10 tuổi tính 75%; trẻ dưới 5 tuổi trẻ thứ 2 tính 50%; trẻ từ 10 tuổi tính như người lớn.',
            rate = 4.80,
            [status] = N'Active',
            isFeatured = @Featured,
            regionID = @RegionID,
            approvedByUserID = @SystemUserID,
            approvedAt = GETDATE(),
            updatedAt = GETDATE()
        WHERE tourCode = @Code;

        SET @TourID = (SELECT TOP 1 tourID FROM dbo.Tour WHERE tourCode = @Code ORDER BY tourID);
    END
    ELSE
    BEGIN
        INSERT INTO dbo.Tour (
            tourCategoryID, tourName, tourCode, tourType, numberOfDay, numberOfNights,
            startPlace, endPlace, [image], adultPrice, childrenPrice, infantPrice,
            singleRoomSurcharge, depositPercent, vatPercent, tourIntroduce, tourInclude, tourNonInclude,
            pickupAddress, mainTransportType, childPolicyNote, rate, [status], isFeatured,
            regionID, createdByUserID, approvedByUserID, approvedAt, createdAt, updatedAt
        ) VALUES (
            @CategoryID, @Name, @Code, N'Package', @Days, @Nights,
            @StartPlace, @EndPlace, @ImageUrl, @AdultPrice, @ChildPrice, @InfantPrice,
            @SingleRoom, 0, 8, N'Tour demo hiển thị homepage WonderVN.', @Highlight, N'Chi phí cá nhân, chi phí phát sinh ngoài chương trình.',
            @Pickup, @Transport, N'Trẻ em 5-10 tuổi tính 75%; trẻ dưới 5 tuổi trẻ thứ 2 tính 50%; trẻ từ 10 tuổi tính như người lớn.',
            4.80, N'Active', @Featured, @RegionID, @SystemUserID, @SystemUserID, GETDATE(), GETDATE(), NULL
        );
        SET @TourID = SCOPE_IDENTITY();
    END

    DELETE FROM dbo.Tour_Image
    WHERE tourID = @TourID
      AND (caption = N'INTRO_IMAGE' OR caption LIKE N'ITINERARY_DAY_%_IMAGE');

    INSERT INTO dbo.Tour_Image (tourID, imageUrl, caption, displayOrder, [status]) VALUES
        (@TourID, @IntroImageUrl, N'INTRO_IMAGE', 1, N'Active'),
        (@TourID, @ImageUrl, N'ITINERARY_DAY_1_IMAGE', 10, N'Active'),
        (@TourID, @IntroImageUrl, N'ITINERARY_DAY_2_IMAGE', 11, N'Active');

    DELETE FROM dbo.Tour_Itinerary WHERE tourID = @TourID;

    INSERT INTO dbo.Tour_Itinerary (tourID, dayNumber, title, [description], mealPlan, transportNote, [status])
    VALUES
        (@TourID, 1, N'Khởi hành - Nhận đoàn - Tham quan điểm nổi bật', N'Staff hướng dẫn khách tập trung, di chuyển theo lịch trình và tham quan các điểm chính trong ngày đầu tiên.', N'', N'', N'Active'),
        (@TourID, 2, N'Trải nghiệm địa phương - Tự do khám phá', N'Khách tham gia chương trình tham quan, trải nghiệm ẩm thực địa phương và có thời gian tự do theo lịch trình.', N'', N'', N'Active');

    IF @Days >= 3
        INSERT INTO dbo.Tour_Itinerary (tourID, dayNumber, title, [description], mealPlan, transportNote, [status])
        VALUES (@TourID, 3, N'Tham quan bổ sung - Kết thúc hành trình', N'Đoàn tiếp tục tham quan điểm còn lại, mua đặc sản địa phương và kết thúc chương trình theo đúng lịch.', N'', N'', N'Active');

    IF @Days >= 4
        INSERT INTO dbo.Tour_Itinerary (tourID, dayNumber, title, [description], mealPlan, transportNote, [status])
        VALUES (@TourID, 4, N'Nghỉ dưỡng - Trả khách', N'Khách có thêm thời gian nghỉ dưỡng, tự do chụp ảnh và di chuyển về điểm trả khách.', N'', N'', N'Active');

    DELETE FROM dbo.Tour_Scheduler
    WHERE tourID = @TourID
      AND ISNULL(quantity, 0) = 0
      AND scheduleStatus IN (N'Open', N'Planned', N'Closed');

    INSERT INTO dbo.Tour_Scheduler (
        tourID, scheduleTransportType, startDate, endDate, departureTime, expectedReturnTime,
        bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
        maxParticipantsPerBooking, adultPrice, childPrice, infantPrice, singleRoomSurcharge,
        depositPercent, vatPercent, cancellationPolicy, scheduleStatus, createdAt, updatedAt
    ) VALUES (
        @TourID, @Transport, CAST(@StartDate AS DATETIME), CAST(@EndDate AS DATETIME), CAST('06:00:00' AS TIME), CAST('18:00:00' AS TIME),
        @BookingDeadline, CEILING(@MaxParticipants * 0.5), @MaxParticipants, 0, 0,
        10, @AdultPrice, @ChildPrice, @InfantPrice, @SingleRoom,
        0, 8, N'Không áp dụng hủy sát ngày khởi hành. Vui lòng liên hệ nhân viên tư vấn để được hỗ trợ.', N'Open', GETDATE(), NULL
    );

    FETCH NEXT FROM TourCursor INTO @Code, @Name, @CategoryName, @RegionName, @Days, @Nights, @StartPlace, @EndPlace,
        @ImageUrl, @IntroImageUrl, @AdultPrice, @SingleRoom, @Transport, @MaxParticipants, @DepartOffset, @Featured,
        @Highlight, @Pickup;
END

CLOSE TourCursor;
DEALLOCATE TourCursor;

PRINT N'Đã seed 10 tour Active/Open cho Staff và Homepage.';
GO
