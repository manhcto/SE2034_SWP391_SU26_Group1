/*
    STAFF TOUR - SCHEMA PATCH + SEED DATA
    Chạy file này sau khi đã chọn đúng database WonderVn.
    Mục tiêu:
      1) Vá các cột còn thiếu mà luồng Staff Tour đang dùng.
      2) Insert dữ liệu danh mục, khu vực, tỉnh/thành du lịch.
      3) Insert 1 tour mẫu hoàn chỉnh để test List/Add/Edit/Detail.

    Lưu ý:
      - File này viết dạng an toàn để chạy lại nhiều lần.
      - Nếu DB của bạn đã đúng schema thì phần patch sẽ tự bỏ qua.
*/

USE [WonderVn];
GO

SET NOCOUNT ON;
GO

/* =========================================================
   1. ĐẢM BẢO CÁC BẢNG NỀN TỒN TẠI
   ========================================================= */

IF OBJECT_ID(N'dbo.Region', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Region (
        regionID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        regionName NVARCHAR(100) NOT NULL,
        [description] NVARCHAR(500) NULL,
        [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_StaffTourPatch_Region_Status DEFAULT (N'Active')
    );
END;
GO

IF OBJECT_ID(N'dbo.Tour_Category', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tour_Category (
        tourCategoryID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        categoryName NVARCHAR(100) NOT NULL,
        [description] NVARCHAR(500) NULL,
        [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_StaffTourPatch_TourCategory_Status DEFAULT (N'Active')
    );
END;
GO

IF OBJECT_ID(N'dbo.Administrative_Unit', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Administrative_Unit (
        administrativeUnitID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        provinceCode VARCHAR(2) NOT NULL,
        provinceName NVARCHAR(100) NOT NULL,
        wardType NVARCHAR(20) NOT NULL,
        wardName NVARCHAR(150) NOT NULL,
        isActive BIT NOT NULL CONSTRAINT DF_StaffTourPatch_AdminUnit_Active DEFAULT (1),
        createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_StaffTourPatch_AdminUnit_CreatedAt DEFAULT (SYSDATETIME())
    );
END;
GO

IF OBJECT_ID(N'dbo.Destination', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Destination (
        destinationID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        regionID INT NULL,
        destinationName NVARCHAR(255) NOT NULL,
        [description] NVARCHAR(MAX) NULL,
        [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_StaffTourPatch_Destination_Status DEFAULT (N'Active')
    );
END;
GO

/* =========================================================
   2. VÁ CỘT CÒN THIẾU CHO CÁC BẢNG NỀN
   ========================================================= */

IF COL_LENGTH(N'dbo.Region', N'regionName') IS NULL
    ALTER TABLE dbo.Region ADD regionName NVARCHAR(100) NULL;
IF COL_LENGTH(N'dbo.Region', N'description') IS NULL
    ALTER TABLE dbo.Region ADD [description] NVARCHAR(500) NULL;
IF COL_LENGTH(N'dbo.Region', N'status') IS NULL
    ALTER TABLE dbo.Region ADD [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_StaffTourPatch_Region_Status2 DEFAULT (N'Active');
GO

IF COL_LENGTH(N'dbo.Tour_Category', N'categoryName') IS NULL
    ALTER TABLE dbo.Tour_Category ADD categoryName NVARCHAR(100) NULL;
IF COL_LENGTH(N'dbo.Tour_Category', N'description') IS NULL
    ALTER TABLE dbo.Tour_Category ADD [description] NVARCHAR(500) NULL;
IF COL_LENGTH(N'dbo.Tour_Category', N'status') IS NULL
    ALTER TABLE dbo.Tour_Category ADD [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_StaffTourPatch_TourCategory_Status2 DEFAULT (N'Active');
GO

IF COL_LENGTH(N'dbo.Administrative_Unit', N'provinceCode') IS NULL
    ALTER TABLE dbo.Administrative_Unit ADD provinceCode VARCHAR(2) NULL;
IF COL_LENGTH(N'dbo.Administrative_Unit', N'provinceName') IS NULL
    ALTER TABLE dbo.Administrative_Unit ADD provinceName NVARCHAR(100) NULL;
IF COL_LENGTH(N'dbo.Administrative_Unit', N'wardType') IS NULL
    ALTER TABLE dbo.Administrative_Unit ADD wardType NVARCHAR(20) NULL;
IF COL_LENGTH(N'dbo.Administrative_Unit', N'wardName') IS NULL
    ALTER TABLE dbo.Administrative_Unit ADD wardName NVARCHAR(150) NULL;
IF COL_LENGTH(N'dbo.Administrative_Unit', N'isActive') IS NULL
    ALTER TABLE dbo.Administrative_Unit ADD isActive BIT NOT NULL CONSTRAINT DF_StaffTourPatch_AdminUnit_Active2 DEFAULT (1);
IF COL_LENGTH(N'dbo.Administrative_Unit', N'createdAt') IS NULL
    ALTER TABLE dbo.Administrative_Unit ADD createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_StaffTourPatch_AdminUnit_CreatedAt2 DEFAULT (SYSDATETIME());
GO

IF COL_LENGTH(N'dbo.Destination', N'regionID') IS NULL
    ALTER TABLE dbo.Destination ADD regionID INT NULL;
IF COL_LENGTH(N'dbo.Destination', N'destinationName') IS NULL
    ALTER TABLE dbo.Destination ADD destinationName NVARCHAR(255) NULL;
IF COL_LENGTH(N'dbo.Destination', N'description') IS NULL
    ALTER TABLE dbo.Destination ADD [description] NVARCHAR(MAX) NULL;
IF COL_LENGTH(N'dbo.Destination', N'status') IS NULL
    ALTER TABLE dbo.Destination ADD [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_StaffTourPatch_Destination_Status2 DEFAULT (N'Active');
GO

/* =========================================================
   3. VÁ CỘT CÒN THIẾU CHO TOUR / TOUR IMAGE / ITINERARY / SCHEDULER
   ========================================================= */

IF OBJECT_ID(N'dbo.Tour', N'U') IS NOT NULL
BEGIN
    IF COL_LENGTH(N'dbo.Tour', N'tourCategoryID') IS NULL ALTER TABLE dbo.Tour ADD tourCategoryID INT NULL;
    IF COL_LENGTH(N'dbo.Tour', N'tourName') IS NULL ALTER TABLE dbo.Tour ADD tourName NVARCHAR(255) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'tourCode') IS NULL ALTER TABLE dbo.Tour ADD tourCode NVARCHAR(50) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'tourType') IS NULL ALTER TABLE dbo.Tour ADD tourType NVARCHAR(30) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'numberOfDay') IS NULL ALTER TABLE dbo.Tour ADD numberOfDay INT NOT NULL CONSTRAINT DF_StaffTourPatch_Tour_NumberOfDay DEFAULT (1);
    IF COL_LENGTH(N'dbo.Tour', N'numberOfNights') IS NULL ALTER TABLE dbo.Tour ADD numberOfNights INT NULL;
    IF COL_LENGTH(N'dbo.Tour', N'startPlace') IS NULL ALTER TABLE dbo.Tour ADD startPlace NVARCHAR(255) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'endPlace') IS NULL ALTER TABLE dbo.Tour ADD endPlace NVARCHAR(255) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'image') IS NULL ALTER TABLE dbo.Tour ADD [image] NVARCHAR(500) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'adultPrice') IS NULL ALTER TABLE dbo.Tour ADD adultPrice DECIMAL(18,2) NOT NULL CONSTRAINT DF_StaffTourPatch_Tour_AdultPrice DEFAULT (0);
    IF COL_LENGTH(N'dbo.Tour', N'childrenPrice') IS NULL ALTER TABLE dbo.Tour ADD childrenPrice DECIMAL(18,2) NOT NULL CONSTRAINT DF_StaffTourPatch_Tour_ChildrenPrice DEFAULT (0);
    IF COL_LENGTH(N'dbo.Tour', N'infantPrice') IS NULL ALTER TABLE dbo.Tour ADD infantPrice DECIMAL(18,2) NOT NULL CONSTRAINT DF_StaffTourPatch_Tour_InfantPrice DEFAULT (0);
    IF COL_LENGTH(N'dbo.Tour', N'singleRoomSurcharge') IS NULL ALTER TABLE dbo.Tour ADD singleRoomSurcharge DECIMAL(18,2) NOT NULL CONSTRAINT DF_StaffTourPatch_Tour_SingleRoom DEFAULT (0);
    IF COL_LENGTH(N'dbo.Tour', N'depositPercent') IS NULL ALTER TABLE dbo.Tour ADD depositPercent INT NOT NULL CONSTRAINT DF_StaffTourPatch_Tour_Deposit DEFAULT (0);
    IF COL_LENGTH(N'dbo.Tour', N'vatPercent') IS NULL ALTER TABLE dbo.Tour ADD vatPercent INT NOT NULL CONSTRAINT DF_StaffTourPatch_Tour_Vat DEFAULT (8);
    IF COL_LENGTH(N'dbo.Tour', N'tourIntroduce') IS NULL ALTER TABLE dbo.Tour ADD tourIntroduce NVARCHAR(MAX) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'tourInclude') IS NULL ALTER TABLE dbo.Tour ADD tourInclude NVARCHAR(MAX) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'tourNonInclude') IS NULL ALTER TABLE dbo.Tour ADD tourNonInclude NVARCHAR(MAX) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'pickupPointName') IS NULL ALTER TABLE dbo.Tour ADD pickupPointName NVARCHAR(255) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'pickupAddress') IS NULL ALTER TABLE dbo.Tour ADD pickupAddress NVARCHAR(500) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'arriveBeforeMinutes') IS NULL ALTER TABLE dbo.Tour ADD arriveBeforeMinutes INT NULL;
    IF COL_LENGTH(N'dbo.Tour', N'pickupNote') IS NULL ALTER TABLE dbo.Tour ADD pickupNote NVARCHAR(500) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'mainTransportType') IS NULL ALTER TABLE dbo.Tour ADD mainTransportType NVARCHAR(50) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'childPolicyNote') IS NULL ALTER TABLE dbo.Tour ADD childPolicyNote NVARCHAR(MAX) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'rate') IS NULL ALTER TABLE dbo.Tour ADD rate DECIMAL(3,2) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'status') IS NULL ALTER TABLE dbo.Tour ADD [status] NVARCHAR(50) NOT NULL CONSTRAINT DF_StaffTourPatch_Tour_Status DEFAULT (N'Draft');
    IF COL_LENGTH(N'dbo.Tour', N'isFeatured') IS NULL ALTER TABLE dbo.Tour ADD isFeatured BIT NOT NULL CONSTRAINT DF_StaffTourPatch_Tour_Featured DEFAULT (0);
    IF COL_LENGTH(N'dbo.Tour', N'regionID') IS NULL ALTER TABLE dbo.Tour ADD regionID INT NULL;
    IF COL_LENGTH(N'dbo.Tour', N'createdByUserID') IS NULL ALTER TABLE dbo.Tour ADD createdByUserID INT NULL;
    IF COL_LENGTH(N'dbo.Tour', N'approvedByUserID') IS NULL ALTER TABLE dbo.Tour ADD approvedByUserID INT NULL;
    IF COL_LENGTH(N'dbo.Tour', N'approvedAt') IS NULL ALTER TABLE dbo.Tour ADD approvedAt DATETIME NULL;
    IF COL_LENGTH(N'dbo.Tour', N'rejectionReason') IS NULL ALTER TABLE dbo.Tour ADD rejectionReason NVARCHAR(MAX) NULL;
    IF COL_LENGTH(N'dbo.Tour', N'createdAt') IS NULL ALTER TABLE dbo.Tour ADD createdAt DATETIME NOT NULL CONSTRAINT DF_StaffTourPatch_Tour_CreatedAt DEFAULT (GETDATE());
    IF COL_LENGTH(N'dbo.Tour', N'updatedAt') IS NULL ALTER TABLE dbo.Tour ADD updatedAt DATETIME NULL;
END;
GO

IF OBJECT_ID(N'dbo.Tour_Image', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tour_Image (
        imageID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        tourID INT NOT NULL,
        imageUrl NVARCHAR(500) NOT NULL,
        caption NVARCHAR(255) NULL,
        displayOrder INT NOT NULL CONSTRAINT DF_StaffTourPatch_TourImage_Order DEFAULT (1),
        [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_StaffTourPatch_TourImage_Status DEFAULT (N'Active')
    );
END;
GO

IF COL_LENGTH(N'dbo.Tour_Image', N'imageUrl') IS NULL ALTER TABLE dbo.Tour_Image ADD imageUrl NVARCHAR(500) NULL;
IF COL_LENGTH(N'dbo.Tour_Image', N'caption') IS NULL ALTER TABLE dbo.Tour_Image ADD caption NVARCHAR(255) NULL;
IF COL_LENGTH(N'dbo.Tour_Image', N'displayOrder') IS NULL ALTER TABLE dbo.Tour_Image ADD displayOrder INT NOT NULL CONSTRAINT DF_StaffTourPatch_TourImage_Order2 DEFAULT (1);
IF COL_LENGTH(N'dbo.Tour_Image', N'status') IS NULL ALTER TABLE dbo.Tour_Image ADD [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_StaffTourPatch_TourImage_Status2 DEFAULT (N'Active');
GO

IF OBJECT_ID(N'dbo.Tour_Itinerary', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tour_Itinerary (
        itineraryID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        tourID INT NOT NULL,
        dayNumber INT NOT NULL,
        title NVARCHAR(255) NOT NULL,
        [description] NVARCHAR(MAX) NULL,
        mealPlan NVARCHAR(255) NULL,
        transportNote NVARCHAR(255) NULL,
        [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_StaffTourPatch_Itinerary_Status DEFAULT (N'Active')
    );
END;
GO

IF COL_LENGTH(N'dbo.Tour_Itinerary', N'description') IS NULL ALTER TABLE dbo.Tour_Itinerary ADD [description] NVARCHAR(MAX) NULL;
IF COL_LENGTH(N'dbo.Tour_Itinerary', N'mealPlan') IS NULL ALTER TABLE dbo.Tour_Itinerary ADD mealPlan NVARCHAR(255) NULL;
IF COL_LENGTH(N'dbo.Tour_Itinerary', N'transportNote') IS NULL ALTER TABLE dbo.Tour_Itinerary ADD transportNote NVARCHAR(255) NULL;
IF COL_LENGTH(N'dbo.Tour_Itinerary', N'status') IS NULL ALTER TABLE dbo.Tour_Itinerary ADD [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_StaffTourPatch_Itinerary_Status2 DEFAULT (N'Active');
GO

IF OBJECT_ID(N'dbo.Tour_Scheduler', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tour_Scheduler (
        tourScheduleID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        tourID INT NOT NULL,
        startDate DATETIME NOT NULL,
        endDate DATETIME NOT NULL,
        departureTime TIME NULL,
        expectedReturnTime TIME NULL,
        bookingDeadline DATETIME NULL,
        minParticipants INT NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_Min DEFAULT (1),
        maxParticipants INT NOT NULL,
        quantity INT NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_Quantity DEFAULT (0),
        bookedSeats INT NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_Booked DEFAULT (0),
        maxParticipantsPerBooking INT NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_MaxPerBooking DEFAULT (10),
        adultPrice DECIMAL(18,2) NULL,
        childPrice DECIMAL(18,2) NULL,
        infantPrice DECIMAL(18,2) NULL,
        singleRoomSurcharge DECIMAL(18,2) NULL,
        depositPercent INT NULL,
        vatPercent INT NULL,
        cancellationPolicy NVARCHAR(MAX) NULL,
        scheduleStatus NVARCHAR(30) NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_Status DEFAULT (N'Open'),
        createdAt DATETIME NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_CreatedAt DEFAULT (GETDATE()),
        updatedAt DATETIME NULL
    );
END;
GO

IF COL_LENGTH(N'dbo.Tour_Scheduler', N'departureTime') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD departureTime TIME NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'expectedReturnTime') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD expectedReturnTime TIME NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'bookingDeadline') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD bookingDeadline DATETIME NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'minParticipants') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD minParticipants INT NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_Min2 DEFAULT (1);
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'maxParticipants') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD maxParticipants INT NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_Max DEFAULT (1);
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'quantity') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD quantity INT NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_Quantity2 DEFAULT (0);
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'bookedSeats') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD bookedSeats INT NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_Booked2 DEFAULT (0);
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'maxParticipantsPerBooking') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD maxParticipantsPerBooking INT NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_MaxPerBooking2 DEFAULT (10);
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'adultPrice') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD adultPrice DECIMAL(18,2) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'childPrice') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD childPrice DECIMAL(18,2) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'infantPrice') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD infantPrice DECIMAL(18,2) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'singleRoomSurcharge') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD singleRoomSurcharge DECIMAL(18,2) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'depositPercent') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD depositPercent INT NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'vatPercent') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD vatPercent INT NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'cancellationPolicy') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD cancellationPolicy NVARCHAR(MAX) NULL;
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'scheduleStatus') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD scheduleStatus NVARCHAR(30) NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_Status2 DEFAULT (N'Open');
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'createdAt') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD createdAt DATETIME NOT NULL CONSTRAINT DF_StaffTourPatch_Scheduler_CreatedAt2 DEFAULT (GETDATE());
IF COL_LENGTH(N'dbo.Tour_Scheduler', N'updatedAt') IS NULL ALTER TABLE dbo.Tour_Scheduler ADD updatedAt DATETIME NULL;
GO

/* =========================================================
   4. SEED DANH MỤC TOUR
   ========================================================= */

UPDATE dbo.Tour_Category
SET categoryName = N'Danh mục tour ' + CAST(tourCategoryID AS NVARCHAR(20))
WHERE categoryName IS NULL OR LTRIM(RTRIM(categoryName)) = N'';

UPDATE dbo.Tour_Category
SET [status] = N'Active'
WHERE [status] IS NULL OR LTRIM(RTRIM([status])) = N'';
GO

DECLARE @Categories TABLE (categoryName NVARCHAR(100), [description] NVARCHAR(500));
INSERT INTO @Categories (categoryName, [description]) VALUES
    (N'Tour gia đình', N'Tour phù hợp gia đình, nhóm nhỏ và khách đi nghỉ cuối tuần'),
    (N'Tour nghỉ dưỡng', N'Tour nghỉ dưỡng biển, resort, thư giãn'),
    (N'Tour khám phá', N'Tour tham quan, trải nghiệm, khám phá điểm đến'),
    (N'Tour biển đảo', N'Tour biển đảo, du thuyền, nghỉ dưỡng ven biển'),
    (N'Tour văn hóa - lịch sử', N'Tour tham quan di tích, văn hóa, lịch sử địa phương'),
    (N'Tour miền núi', N'Tour vùng cao, trekking nhẹ, săn mây, khám phá thiên nhiên'),
    (N'Tour team building', N'Tour đoàn công ty, team building, gala dinner'),
    (N'Tour cao cấp', N'Tour dịch vụ cao cấp, khách sạn/resort tiêu chuẩn cao');

INSERT INTO dbo.Tour_Category (categoryName, [description], [status])
SELECT c.categoryName, c.[description], N'Active'
FROM @Categories c
WHERE NOT EXISTS (SELECT 1 FROM dbo.Tour_Category tc WHERE tc.categoryName = c.categoryName);
GO

/* =========================================================
   5. SEED KHU VỰC
   ========================================================= */

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

/* =========================================================
   6. SEED TỈNH/THÀNH DU LỊCH CHO DROPDOWN ĐIỂM ĐI / ĐIỂM ĐẾN
   ========================================================= */

DECLARE @Provinces TABLE (
    provinceCode VARCHAR(2),
    provinceName NVARCHAR(100)
);

INSERT INTO @Provinces (provinceCode, provinceName) VALUES
    -- Miền Bắc
    ('01', N'Thành phố Hà Nội'),
    ('02', N'Thành phố Hải Phòng'),
    ('03', N'Tỉnh Quảng Ninh'),
    ('04', N'Tỉnh Ninh Bình'),
    ('05', N'Tỉnh Lào Cai'),
    ('06', N'Tỉnh Hà Giang'),
    ('07', N'Tỉnh Sơn La'),
    ('08', N'Tỉnh Cao Bằng'),
    ('09', N'Tỉnh Điện Biên'),
    ('10', N'Tỉnh Phú Thọ'),
    ('11', N'Tỉnh Bắc Ninh'),
    ('12', N'Tỉnh Hòa Bình'),

    -- Miền Trung
    ('31', N'Thành phố Đà Nẵng'),
    ('32', N'Thành phố Huế'),
    ('33', N'Tỉnh Quảng Bình'),
    ('34', N'Tỉnh Quảng Trị'),
    ('35', N'Tỉnh Quảng Nam'),
    ('36', N'Tỉnh Quảng Ngãi'),
    ('37', N'Tỉnh Bình Định'),
    ('38', N'Tỉnh Khánh Hòa'),
    ('39', N'Tỉnh Lâm Đồng'),
    ('40', N'Tỉnh Đắk Lắk'),
    ('41', N'Tỉnh Thanh Hóa'),
    ('42', N'Tỉnh Nghệ An'),

    -- Miền Nam
    ('61', N'Thành phố Hồ Chí Minh'),
    ('62', N'Tỉnh Bà Rịa - Vũng Tàu'),
    ('63', N'Tỉnh Đồng Nai'),
    ('64', N'Tỉnh Tây Ninh'),
    ('65', N'Tỉnh An Giang'),
    ('66', N'Thành phố Cần Thơ'),
    ('67', N'Tỉnh Kiên Giang'),
    ('68', N'Tỉnh Cà Mau'),
    ('69', N'Tỉnh Bến Tre'),
    ('70', N'Tỉnh Tiền Giang'),
    ('71', N'Tỉnh Sóc Trăng'),
    ('72', N'Tỉnh Đồng Tháp');

INSERT INTO dbo.Administrative_Unit (provinceCode, provinceName, wardType, wardName, isActive, createdAt)
SELECT p.provinceCode, p.provinceName, N'Tỉnh/Thành', N'Trung tâm', 1, SYSDATETIME()
FROM @Provinces p
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Administrative_Unit au
    WHERE au.provinceName = p.provinceName
      AND au.isActive = 1
      AND (
            au.wardType IN (N'Tỉnh/Thành', N'Tỉnh', N'Thành phố')
            OR au.wardName = N'Trung tâm'
          )
);

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

/* =========================================================
   7. SEED DESTINATION THAM KHẢO
   ========================================================= */

DECLARE @NorthRegionID INT = (SELECT TOP 1 regionID FROM dbo.Region WHERE regionName = N'Miền Bắc' ORDER BY regionID);
DECLARE @CentralRegionID INT = (SELECT TOP 1 regionID FROM dbo.Region WHERE regionName = N'Miền Trung' ORDER BY regionID);
DECLARE @SouthRegionID INT = (SELECT TOP 1 regionID FROM dbo.Region WHERE regionName = N'Miền Nam' ORDER BY regionID);

DECLARE @Destinations TABLE (regionID INT, destinationName NVARCHAR(255), [description] NVARCHAR(MAX));
INSERT INTO @Destinations (regionID, destinationName, [description]) VALUES
    (@NorthRegionID, N'Hạ Long', N'Điểm đến biển đảo nổi bật tại Quảng Ninh'),
    (@NorthRegionID, N'Ninh Bình', N'Tam Cốc, Tràng An, Bái Đính, Hang Múa'),
    (@NorthRegionID, N'Sa Pa', N'Thị trấn vùng cao nổi tiếng tại Lào Cai'),
    (@NorthRegionID, N'Hà Giang', N'Cao nguyên đá, đèo Mã Pì Lèng, sông Nho Quế'),
    (@CentralRegionID, N'Đà Nẵng', N'Thành phố biển, Bà Nà Hills, Sơn Trà'),
    (@CentralRegionID, N'Hội An', N'Phố cổ, trải nghiệm văn hóa và ẩm thực'),
    (@CentralRegionID, N'Huế', N'Cố đô, di sản văn hóa, ẩm thực miền Trung'),
    (@CentralRegionID, N'Nha Trang', N'Tour biển đảo, nghỉ dưỡng, vui chơi'),
    (@CentralRegionID, N'Đà Lạt', N'Thành phố cao nguyên, khí hậu mát mẻ'),
    (@SouthRegionID, N'Phú Quốc', N'Tour biển đảo, nghỉ dưỡng cao cấp'),
    (@SouthRegionID, N'Cần Thơ', N'Chợ nổi Cái Răng, văn hóa miền Tây'),
    (@SouthRegionID, N'Vũng Tàu', N'Tour biển gần TP.HCM'),
    (@SouthRegionID, N'Cà Mau', N'Đất Mũi, rừng ngập mặn, trải nghiệm miền Tây');

INSERT INTO dbo.Destination (regionID, destinationName, [description], [status])
SELECT d.regionID, d.destinationName, d.[description], N'Active'
FROM @Destinations d
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Destination des WHERE des.destinationName = d.destinationName
);
GO

/* =========================================================
   8. SEED 1 TOUR MẪU HOÀN CHỈNH
   ========================================================= */

DECLARE @CategoryID INT = (
    SELECT TOP 1 tourCategoryID
    FROM dbo.Tour_Category
    WHERE categoryName = N'Tour khám phá'
    ORDER BY tourCategoryID
);

DECLARE @RegionID INT = (
    SELECT TOP 1 regionID
    FROM dbo.Region
    WHERE regionName = N'Miền Bắc'
    ORDER BY regionID
);

DECLARE @SeedTourID INT;

IF OBJECT_ID(N'dbo.Tour', N'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.Tour WHERE tourCode = N'TOUR-SEED-HLNB-3N2D')
    BEGIN
        INSERT INTO dbo.Tour (
            tourCategoryID, tourName, tourCode, tourType,
            numberOfDay, numberOfNights, startPlace, endPlace, [image],
            adultPrice, childrenPrice, infantPrice, singleRoomSurcharge,
            depositPercent, vatPercent,
            tourIntroduce, tourInclude, tourNonInclude,
            pickupPointName, pickupAddress, arriveBeforeMinutes, pickupNote,
            mainTransportType, childPolicyNote, rate, [status], isFeatured,
            regionID, createdByUserID, approvedByUserID, approvedAt, rejectionReason,
            createdAt, updatedAt
        )
        VALUES (
            @CategoryID,
            N'Hà Nội - Hạ Long - Ninh Bình 3N2Đ',
            N'TOUR-SEED-HLNB-3N2D',
            N'Package',
            3,
            2,
            N'Thành phố Hà Nội',
            N'Tỉnh Quảng Ninh',
            N'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80',
            3900000,
            3159000,
            2106000,
            1200000,
            0,
            8,
            N'Tour Hà Nội - Hạ Long - Ninh Bình 3 ngày 2 đêm phù hợp cho khách gia đình, nhóm bạn và đoàn công ty muốn trải nghiệm miền Bắc trong thời gian ngắn.',
            N'Điểm nổi bật: tham quan Hạ Long, trải nghiệm cảnh quan núi đá vôi, kết hợp Ninh Bình, lịch trình gọn, phù hợp cuối tuần.',
            N'',
            NULL,
            N'Nhà hát Lớn Hà Nội, Quận Hoàn Kiếm, Hà Nội',
            30,
            NULL,
            N'Xe Du Lịch',
            N'',
            NULL,
            N'Draft',
            0,
            @RegionID,
            NULL,
            NULL,
            NULL,
            NULL,
            GETDATE(),
            NULL
        );

        SET @SeedTourID = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SELECT @SeedTourID = tourID
        FROM dbo.Tour
        WHERE tourCode = N'TOUR-SEED-HLNB-3N2D';
    END;
END;
GO

DECLARE @SeedTourID2 INT = (SELECT TOP 1 tourID FROM dbo.Tour WHERE tourCode = N'TOUR-SEED-HLNB-3N2D' ORDER BY tourID);

IF @SeedTourID2 IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.Tour_Image WHERE tourID = @SeedTourID2 AND caption = N'INTRO_IMAGE')
        INSERT INTO dbo.Tour_Image (tourID, imageUrl, caption, displayOrder, [status])
        VALUES (@SeedTourID2, N'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80', N'INTRO_IMAGE', 1, N'Active');

    IF NOT EXISTS (SELECT 1 FROM dbo.Tour_Image WHERE tourID = @SeedTourID2 AND caption = N'ITINERARY_DAY_1_IMAGE')
        INSERT INTO dbo.Tour_Image (tourID, imageUrl, caption, displayOrder, [status])
        VALUES (@SeedTourID2, N'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80', N'ITINERARY_DAY_1_IMAGE', 11, N'Active');

    IF NOT EXISTS (SELECT 1 FROM dbo.Tour_Image WHERE tourID = @SeedTourID2 AND caption = N'ITINERARY_DAY_2_IMAGE')
        INSERT INTO dbo.Tour_Image (tourID, imageUrl, caption, displayOrder, [status])
        VALUES (@SeedTourID2, N'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1200&q=80', N'ITINERARY_DAY_2_IMAGE', 12, N'Active');

    IF NOT EXISTS (SELECT 1 FROM dbo.Tour_Image WHERE tourID = @SeedTourID2 AND caption = N'ITINERARY_DAY_3_IMAGE')
        INSERT INTO dbo.Tour_Image (tourID, imageUrl, caption, displayOrder, [status])
        VALUES (@SeedTourID2, N'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80', N'ITINERARY_DAY_3_IMAGE', 13, N'Active');

    IF NOT EXISTS (SELECT 1 FROM dbo.Tour_Itinerary WHERE tourID = @SeedTourID2 AND dayNumber = 1)
        INSERT INTO dbo.Tour_Itinerary (tourID, dayNumber, title, [description], mealPlan, transportNote, [status])
        VALUES (
            @SeedTourID2,
            1,
            N'Hà Nội - Hạ Long',
            N'05:30 tập trung tại Nhà hát Lớn Hà Nội. 06:00 khởi hành đi Hạ Long, trên đường dừng nghỉ ngắn và nghe giới thiệu lịch trình.',
            N'Đến Hạ Long, dùng bữa trưa tại nhà hàng địa phương. Sau đó nhận phòng khách sạn và nghỉ ngơi.',
            N'Tham quan khu vực Bãi Cháy hoặc tự do dạo biển. Ăn tối, sau đó khách tự do khám phá Hạ Long về đêm.',
            N'Active'
        );

    IF NOT EXISTS (SELECT 1 FROM dbo.Tour_Itinerary WHERE tourID = @SeedTourID2 AND dayNumber = 2)
        INSERT INTO dbo.Tour_Itinerary (tourID, dayNumber, title, [description], mealPlan, transportNote, [status])
        VALUES (
            @SeedTourID2,
            2,
            N'Tham quan vịnh Hạ Long',
            N'Dùng bữa sáng tại khách sạn. Di chuyển ra bến tàu, lên du thuyền tham quan vịnh Hạ Long, ngắm cảnh núi đá vôi và các điểm nổi bật trên vịnh.',
            N'Dùng bữa trưa trên tàu hoặc nhà hàng theo chương trình. Tiếp tục tham quan, chụp ảnh và nghỉ ngơi.',
            N'Về khách sạn, ăn tối. Buổi tối tự do mua sắm, dạo chợ đêm hoặc nghỉ ngơi.',
            N'Active'
        );

    IF NOT EXISTS (SELECT 1 FROM dbo.Tour_Itinerary WHERE tourID = @SeedTourID2 AND dayNumber = 3)
        INSERT INTO dbo.Tour_Itinerary (tourID, dayNumber, title, [description], mealPlan, transportNote, [status])
        VALUES (
            @SeedTourID2,
            3,
            N'Hạ Long - Ninh Bình - Hà Nội',
            N'Sau bữa sáng, trả phòng khách sạn và di chuyển về Ninh Bình. Tham quan khu vực Tràng An hoặc Hang Múa tùy lịch trình vận hành.',
            N'Dùng bữa trưa tại Ninh Bình. Nghỉ ngơi ngắn trước khi quay về Hà Nội.',
            N'Khởi hành về Hà Nội. Dự kiến 18:30 về đến điểm hẹn ban đầu, kết thúc chương trình.',
            N'Active'
        );

    IF NOT EXISTS (SELECT 1 FROM dbo.Tour_Scheduler WHERE tourID = @SeedTourID2 AND startDate = '2026-08-15')
        INSERT INTO dbo.Tour_Scheduler (
            tourID, startDate, endDate, departureTime, expectedReturnTime,
            bookingDeadline, minParticipants, maxParticipants, quantity, bookedSeats,
            maxParticipantsPerBooking, adultPrice, childPrice, infantPrice,
            singleRoomSurcharge, depositPercent, vatPercent, cancellationPolicy,
            scheduleStatus, createdAt, updatedAt
        )
        VALUES (
            @SeedTourID2,
            '2026-08-15',
            '2026-08-17',
            '06:00:00',
            '18:30:00',
            '2026-08-10',
            23,
            45,
            0,
            0,
            10,
            3900000,
            3159000,
            2106000,
            1200000,
            0,
            8,
            N'Lịch khởi hành mẫu dùng để test màn hình staff tour.',
            N'Open',
            GETDATE(),
            NULL
        );
END;
GO

PRINT N'Đã hoàn tất vá schema thiếu cột và seed dữ liệu Staff Tour.';
GO
