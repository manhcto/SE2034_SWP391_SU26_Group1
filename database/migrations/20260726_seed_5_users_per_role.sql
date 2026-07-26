USE [WonderVn]
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @SeedUsers TABLE
(
    firstName NVARCHAR(100) NOT NULL,
    lastName  NVARCHAR(100) NOT NULL,
    dob       DATE NULL,
    email     NVARCHAR(255) NOT NULL,
    phone     NVARCHAR(20) NULL,
    gender    NVARCHAR(20) NULL,
    [address] NVARCHAR(500) NULL,
    [password] NVARCHAR(255) NOT NULL,
    roleName  NVARCHAR(100) NOT NULL
);

INSERT INTO @SeedUsers
    (firstName, lastName, dob, email, phone, gender, [address], [password], roleName)
VALUES
    (N'An',    N'Nguyễn', CAST(N'1990-01-15' AS DATE), N'admin.test01@wonder.vn',    N'0911000001', N'Male',   N'Hà Nội',          N'123', N'Admin'),
    (N'Bình',  N'Trần',   CAST(N'1991-02-16' AS DATE), N'admin.test02@wonder.vn',    N'0911000002', N'Male',   N'Hải Phòng',       N'123', N'Admin'),
    (N'Chi',   N'Lê',     CAST(N'1992-03-17' AS DATE), N'admin.test03@wonder.vn',    N'0911000003', N'Female', N'Đà Nẵng',         N'123', N'Admin'),
    (N'Dũng',  N'Phạm',   CAST(N'1993-04-18' AS DATE), N'admin.test04@wonder.vn',    N'0911000004', N'Male',   N'Thành phố Huế',   N'123', N'Admin'),
    (N'Giang', N'Võ',     CAST(N'1994-05-19' AS DATE), N'admin.test05@wonder.vn',    N'0911000005', N'Female', N'TP. Hồ Chí Minh', N'123', N'Admin'),

    (N'Hà',    N'Đỗ',     CAST(N'1995-06-20' AS DATE), N'staff.test01@wonder.vn',    N'0922000001', N'Female', N'Hà Nội',          N'123', N'Staff'),
    (N'Hùng',  N'Bùi',    CAST(N'1996-07-21' AS DATE), N'staff.test02@wonder.vn',    N'0922000002', N'Male',   N'Ninh Bình',       N'123', N'Staff'),
    (N'Lan',   N'Đặng',   CAST(N'1997-08-22' AS DATE), N'staff.test03@wonder.vn',    N'0922000003', N'Female', N'Quảng Ninh',      N'123', N'Staff'),
    (N'Minh',  N'Hoàng',  CAST(N'1998-09-23' AS DATE), N'staff.test04@wonder.vn',    N'0922000004', N'Male',   N'Đà Nẵng',         N'123', N'Staff'),
    (N'Nga',   N'Phan',   CAST(N'1999-10-24' AS DATE), N'staff.test05@wonder.vn',    N'0922000005', N'Female', N'TP. Hồ Chí Minh', N'123', N'Staff'),

    (N'Nam',   N'Vũ',     CAST(N'1990-11-25' AS DATE), N'guide.test01@wonder.vn',    N'0933000001', N'Male',   N'Lào Cai',         N'123', N'TourGuide'),
    (N'Ngọc',  N'Hồ',     CAST(N'1991-12-26' AS DATE), N'guide.test02@wonder.vn',    N'0933000002', N'Female', N'Hà Giang',        N'123', N'TourGuide'),
    (N'Phong', N'Ngô',    CAST(N'1992-01-27' AS DATE), N'guide.test03@wonder.vn',    N'0933000003', N'Male',   N'Quảng Bình',      N'123', N'TourGuide'),
    (N'Quỳnh', N'Dương',  CAST(N'1993-02-28' AS DATE), N'guide.test04@wonder.vn',    N'0933000004', N'Female', N'Lâm Đồng',        N'123', N'TourGuide'),
    (N'Sơn',   N'Lý',     CAST(N'1994-03-29' AS DATE), N'guide.test05@wonder.vn',    N'0933000005', N'Male',   N'Kiên Giang',      N'123', N'TourGuide'),

    (N'Thảo',  N'Đinh',   CAST(N'2000-04-10' AS DATE), N'customer.test01@wonder.vn', N'0944000001', N'Female', N'Hà Nội',          N'123', N'Customer'),
    (N'Thành', N'Đoàn',   CAST(N'2001-05-11' AS DATE), N'customer.test02@wonder.vn', N'0944000002', N'Male',   N'Hải Phòng',       N'123', N'Customer'),
    (N'Thu',   N'Mai',    CAST(N'2002-06-12' AS DATE), N'customer.test03@wonder.vn', N'0944000003', N'Female', N'Đà Nẵng',         N'123', N'Customer'),
    (N'Tuấn',  N'Tạ',     CAST(N'2003-07-13' AS DATE), N'customer.test04@wonder.vn', N'0944000004', N'Male',   N'Cần Thơ',         N'123', N'Customer'),
    (N'Vy',    N'Cao',    CAST(N'2004-08-14' AS DATE), N'customer.test05@wonder.vn', N'0944000005', N'Female', N'TP. Hồ Chí Minh', N'123', N'Customer');

IF EXISTS
(
    SELECT roleName FROM @SeedUsers
    EXCEPT
    SELECT roleName FROM [dbo].[Role]
)
    THROW 50001, N'Thiếu role cần thiết trong bảng dbo.Role.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO [dbo].[User]
        (firstName, lastName, dob, email, phone, gender, [address], [password], createAt, updateAt, [status], roleID)
    SELECT
        seed.firstName,
        seed.lastName,
        seed.dob,
        seed.email,
        seed.phone,
        seed.gender,
        seed.[address],
        seed.[password],
        GETDATE(),
        NULL,
        N'Active',
        role.roleID
    FROM @SeedUsers AS seed
    INNER JOIN [dbo].[Role] AS role
        ON role.roleName = seed.roleName
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM [dbo].[User] AS existingUser
        WHERE existingUser.email = seed.email
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

SELECT
    role.roleName,
    COUNT(*) AS seededUserCount
FROM [dbo].[User] AS appUser
INNER JOIN @SeedUsers AS seed
    ON seed.email = appUser.email
INNER JOIN [dbo].[Role] AS role
    ON role.roleID = appUser.roleID
GROUP BY role.roleName
ORDER BY role.roleName;
GO
