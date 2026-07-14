USE [WonderVn]
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

-- ============================================================
-- MIGRATION: 20260714_fix_schema_mismatch
-- Mục đích: Đồng bộ database schema với code Java hiện tại
-- Lỗi cần fix:
--   1. Invalid object name 'BlogPost'
--      -> Rename bảng BlogPost -> Blog (code dùng tên Blog)
--   2. Invalid column name 'content' trong Feedback
--      -> Rename cột cũ -> content hoặc thêm cột mới
--   3. Bảng Blog cần cột: blogID, title, slug, image, summary,
--      content, authorUserID, status, createdAt
--   4. Bảng Administrative_Unit cần tồn tại (edit-profile)
-- ============================================================

PRINT N'';
PRINT N'=== BẮT ĐẦU MIGRATION 20260714_fix_schema_mismatch ===';
PRINT N'';
GO

-- ============================================================
-- FIX 1: Rename BlogPost -> Blog (nếu cần)
-- ============================================================
PRINT N'[FIX 1] Kiểm tra bảng Blog/BlogPost...';
GO

IF OBJECT_ID(N'dbo.BlogPost', N'U') IS NOT NULL
   AND OBJECT_ID(N'dbo.Blog', N'U') IS NULL
BEGIN
    EXEC sp_rename N'dbo.BlogPost', N'Blog';
    PRINT N'[FIX 1] OK: Đã rename BlogPost -> Blog';
END
ELSE IF OBJECT_ID(N'dbo.Blog', N'U') IS NOT NULL
BEGIN
    PRINT N'[FIX 1] OK: Bảng Blog đã tồn tại, không cần thay đổi.';
END
ELSE
BEGIN
    -- Tạo bảng Blog mới hoàn toàn
    PRINT N'[FIX 1] Không tìm thấy Blog/BlogPost. Đang tạo bảng Blog mới...';
    CREATE TABLE [dbo].[Blog] (
        [blogID]         INT IDENTITY(1,1) PRIMARY KEY,
        [title]          NVARCHAR(500)  NOT NULL,
        [slug]           NVARCHAR(500)  NOT NULL UNIQUE,
        [image]          NVARCHAR(1000) NULL,
        [summary]        NVARCHAR(1000) NULL,
        [content]        NVARCHAR(MAX)  NULL,
        [authorUserID]   INT            NULL REFERENCES [dbo].[User]([userID]),
        [status]         NVARCHAR(50)   NOT NULL DEFAULT N'Draft',
        [createdAt]      DATETIME       NOT NULL DEFAULT GETDATE(),
        [updatedAt]      DATETIME       NULL
    );
    PRINT N'[FIX 1] OK: Bảng Blog đã được tạo.';
END
GO

-- Đảm bảo cột slug tồn tại trong Blog (nếu bảng đã tồn tại nhưng thiếu cột)
IF OBJECT_ID(N'dbo.Blog', N'U') IS NOT NULL
   AND NOT EXISTS (
       SELECT 1 FROM sys.columns
       WHERE object_id = OBJECT_ID(N'dbo.Blog') AND name = N'slug'
   )
BEGIN
    ALTER TABLE [dbo].[Blog] ADD [slug] NVARCHAR(500) NULL;
    PRINT N'[FIX 1b] Đã thêm cột slug vào bảng Blog.';
END
GO

-- Đảm bảo cột summary tồn tại trong Blog
IF OBJECT_ID(N'dbo.Blog', N'U') IS NOT NULL
   AND NOT EXISTS (
       SELECT 1 FROM sys.columns
       WHERE object_id = OBJECT_ID(N'dbo.Blog') AND name = N'summary'
   )
BEGIN
    ALTER TABLE [dbo].[Blog] ADD [summary] NVARCHAR(1000) NULL;
    PRINT N'[FIX 1c] Đã thêm cột summary vào bảng Blog.';
END
GO

-- Đảm bảo cột content tồn tại trong Blog
IF OBJECT_ID(N'dbo.Blog', N'U') IS NOT NULL
   AND NOT EXISTS (
       SELECT 1 FROM sys.columns
       WHERE object_id = OBJECT_ID(N'dbo.Blog') AND name = N'content'
   )
BEGIN
    ALTER TABLE [dbo].[Blog] ADD [content] NVARCHAR(MAX) NULL;
    PRINT N'[FIX 1d] Đã thêm cột content vào bảng Blog.';
END
GO

-- Tạo View BlogPost để tương thích ngược (trường hợp code cũ vẫn reference)
IF OBJECT_ID(N'dbo.BlogPost', N'U') IS NULL
   AND OBJECT_ID(N'dbo.Blog', N'U') IS NOT NULL
   AND OBJECT_ID(N'dbo.BlogPost', N'V') IS NULL
BEGIN
    EXEC(N'CREATE VIEW dbo.BlogPost AS SELECT * FROM dbo.Blog');
    PRINT N'[FIX 1e] Tạo view BlogPost để tương thích ngược.';
END
GO

-- ============================================================
-- FIX 2: Cột 'content' trong bảng Feedback
-- ============================================================
PRINT N'';
PRINT N'[FIX 2] Kiểm tra cột content trong bảng Feedback...';
GO

IF OBJECT_ID(N'dbo.Feedback', N'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM sys.columns
        WHERE object_id = OBJECT_ID(N'dbo.Feedback') AND name = N'content'
    )
    BEGIN
        -- Kiểm tra các tên cột thay thế phổ biến
        DECLARE @oldColName NVARCHAR(100) = NULL;

        SELECT @oldColName = name FROM sys.columns
        WHERE object_id = OBJECT_ID(N'dbo.Feedback')
          AND name IN (N'comment', N'feedbackContent', N'feedbackText', N'description', N'feedbackComment', N'reviewContent', N'text')
        ORDER BY
            CASE name
                WHEN N'comment'         THEN 1
                WHEN N'feedbackContent' THEN 2
                WHEN N'feedbackText'    THEN 3
                WHEN N'description'     THEN 4
                WHEN N'feedbackComment' THEN 5
                WHEN N'reviewContent'   THEN 6
                WHEN N'text'            THEN 7
                ELSE 99
            END;

        IF @oldColName IS NOT NULL
        BEGIN
            PRINT N'[FIX 2] Tìm thấy cột: ' + @oldColName + N' -> rename thành content';
            DECLARE @renameSql NVARCHAR(500) = N'EXEC sp_rename N''dbo.Feedback.' + @oldColName + N''', N''content'', N''COLUMN''';
            EXEC sp_executesql @renameSql;
            PRINT N'[FIX 2] OK: Đã rename ' + @oldColName + N' -> content';
        END
        ELSE
        BEGIN
            -- Không tìm được cột phù hợp -> thêm cột mới
            ALTER TABLE [dbo].[Feedback] ADD [content] NVARCHAR(2000) NULL;
            PRINT N'[FIX 2] OK: Đã thêm cột content (NULL) vào bảng Feedback.';
            PRINT N'         LƯU Ý: Dữ liệu cũ cần được migrate thủ công nếu có tên cột khác.';
        END
    END
    ELSE
    BEGIN
        PRINT N'[FIX 2] OK: Cột content đã tồn tại trong Feedback.';
    END
END
ELSE
BEGIN
    PRINT N'[FIX 2] CẢNH BÁO: Bảng Feedback không tồn tại!';
END
GO

-- ============================================================
-- FIX 3: Bảng Administrative_Unit (cần cho edit-profile)
-- ============================================================
PRINT N'';
PRINT N'[FIX 3] Kiểm tra bảng Administrative_Unit...';
GO

IF OBJECT_ID(N'dbo.Administrative_Unit', N'U') IS NULL
BEGIN
    PRINT N'[FIX 3] Đang tạo bảng Administrative_Unit...';

    CREATE TABLE [dbo].[Administrative_Unit] (
        [administrativeUnitID] INT IDENTITY(1,1) PRIMARY KEY,
        [provinceCode]         NVARCHAR(10)   NOT NULL,
        [provinceName]         NVARCHAR(100)  NOT NULL,
        [wardType]             NVARCHAR(20)   NOT NULL DEFAULT N'Phường',
        [wardName]             NVARCHAR(100)  NOT NULL,
        [isActive]             BIT            NOT NULL DEFAULT 1
    );

    -- Seed dữ liệu cơ bản cho 10 tỉnh thành phố lớn
    INSERT INTO [dbo].[Administrative_Unit] (provinceCode, provinceName, wardType, wardName, isActive)
    VALUES
    -- Hà Nội
    (N'01', N'Hà Nội', N'Phường', N'Phường Trung Hòa', 1),
    (N'01', N'Hà Nội', N'Phường', N'Phường Dịch Vọng', 1),
    (N'01', N'Hà Nội', N'Phường', N'Phường Mỹ Đình', 1),
    (N'01', N'Hà Nội', N'Phường', N'Phường Hoàn Kiếm', 1),
    (N'01', N'Hà Nội', N'Phường', N'Phường Ba Đình', 1),
    (N'01', N'Hà Nội', N'Phường', N'Phường Hai Bà Trưng', 1),
    -- TP. Hồ Chí Minh
    (N'79', N'TP. Hồ Chí Minh', N'Phường', N'Phường Bến Nghé', 1),
    (N'79', N'TP. Hồ Chí Minh', N'Phường', N'Phường Bến Thành', 1),
    (N'79', N'TP. Hồ Chí Minh', N'Phường', N'Phường Phú Nhuận', 1),
    (N'79', N'TP. Hồ Chí Minh', N'Phường', N'Phường Tân Bình', 1),
    (N'79', N'TP. Hồ Chí Minh', N'Phường', N'Phường Bình Thạnh', 1),
    -- Đà Nẵng
    (N'48', N'Đà Nẵng', N'Phường', N'Phường Hải Châu', 1),
    (N'48', N'Đà Nẵng', N'Phường', N'Phường Thanh Khê', 1),
    (N'48', N'Đà Nẵng', N'Phường', N'Phường Ngũ Hành Sơn', 1),
    (N'48', N'Đà Nẵng', N'Phường', N'Phường Liên Chiểu', 1),
    -- Khánh Hòa / Nha Trang
    (N'56', N'Khánh Hòa', N'Phường', N'Phường Vạn Thắng', 1),
    (N'56', N'Khánh Hòa', N'Phường', N'Phường Lộc Thọ', 1),
    -- Cần Thơ
    (N'92', N'Cần Thơ', N'Phường', N'Phường Ninh Kiều', 1),
    (N'92', N'Cần Thơ', N'Phường', N'Phường Cái Khế', 1),
    -- Lào Cai / Sa Pa
    (N'10', N'Lào Cai', N'Phường', N'Phường Sa Pa', 1),
    (N'10', N'Lào Cai', N'Phường', N'Phường Lào Cai', 1),
    -- Quảng Ninh / Hạ Long
    (N'22', N'Quảng Ninh', N'Phường', N'Phường Bãi Cháy', 1),
    (N'22', N'Quảng Ninh', N'Phường', N'Phường Hồng Gai', 1),
    -- Lâm Đồng / Đà Lạt
    (N'68', N'Lâm Đồng', N'Phường', N'Phường Xuân Hương - Đà Lạt', 1),
    (N'68', N'Lâm Đồng', N'Phường', N'Phường 1 - Đà Lạt', 1),
    -- Kiên Giang / Phú Quốc
    (N'91', N'Kiên Giang', N'Phường', N'Phường Vĩnh Thanh - Phú Quốc', 1),
    (N'91', N'Kiên Giang', N'Phường', N'Phường Dương Đông - Phú Quốc', 1),
    -- Thừa Thiên Huế
    (N'46', N'Thừa Thiên Huế', N'Phường', N'Phường Thuận Hóa', 1),
    (N'46', N'Thừa Thiên Huế', N'Phường', N'Phường Phú Hội', 1);

    PRINT N'[FIX 3] OK: Đã tạo bảng Administrative_Unit với 30 đơn vị hành chính mẫu.';
END
ELSE
BEGIN
    PRINT N'[FIX 3] OK: Bảng Administrative_Unit đã tồn tại.';
END
GO

-- ============================================================
-- FIX 4: Kiểm tra Blog constraint status
-- Code query WHERE status = N'Published'
-- ============================================================
PRINT N'';
PRINT N'[FIX 4] Kiểm tra constraint status trên bảng Blog...';
GO

-- Xóa constraint cũ nếu không bao gồm 'Published'
IF EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name LIKE N'%Blog%Status%' OR name LIKE N'%CK_Blog%'
)
BEGIN
    DECLARE @constraintName NVARCHAR(200);
    DECLARE constraintCursor CURSOR FOR
        SELECT cc.name
        FROM sys.check_constraints cc
        JOIN sys.objects o ON cc.parent_object_id = o.object_id
        WHERE o.name = N'Blog'
          AND (cc.name LIKE N'%Status%' OR cc.name LIKE N'%status%');

    OPEN constraintCursor;
    FETCH NEXT FROM constraintCursor INTO @constraintName;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Kiểm tra nếu constraint không chứa 'Published' thì drop
        DECLARE @constraintDef NVARCHAR(MAX);
        SELECT @constraintDef = cc.[definition]
        FROM sys.check_constraints cc WHERE cc.name = @constraintName;

        IF @constraintDef NOT LIKE N'%Published%'
        BEGIN
            EXEC(N'ALTER TABLE dbo.Blog DROP CONSTRAINT [' + @constraintName + N']');
            PRINT N'[FIX 4] Đã xóa constraint cũ: ' + @constraintName;
        END
        FETCH NEXT FROM constraintCursor INTO @constraintName;
    END
    CLOSE constraintCursor;
    DEALLOCATE constraintCursor;
END
GO

-- Đảm bảo constraint mới cho phép tất cả status cần thiết
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints cc
    JOIN sys.objects o ON cc.parent_object_id = o.object_id
    WHERE o.name = N'Blog' AND cc.name = N'CK_Blog_Status_Full'
)
AND OBJECT_ID(N'dbo.Blog', N'U') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Blog] WITH CHECK
    ADD CONSTRAINT [CK_Blog_Status_Full]
    CHECK ([status] IN (N'Draft', N'Pending', N'Published', N'Rejected', N'Active', N'Inactive'));
    PRINT N'[FIX 4] OK: Đã thêm constraint CK_Blog_Status_Full.';
END
GO

-- ============================================================
-- DIAGNOSTIC: In thông tin debug để kiểm tra
-- ============================================================
PRINT N'';
PRINT N'=== DIAGNOSTIC: Cấu trúc bảng Feedback ===';
SELECT
    c.name          AS ColumnName,
    t.name          AS DataType,
    c.max_length    AS MaxLength,
    c.is_nullable   AS IsNullable
FROM sys.columns c
JOIN sys.types t ON c.system_type_id = t.system_type_id AND t.is_user_defined = 0
WHERE c.object_id = OBJECT_ID(N'dbo.Feedback')
ORDER BY c.column_id;
GO

PRINT N'';
PRINT N'=== DIAGNOSTIC: Bảng và View Blog/BlogPost ===';
SELECT
    o.name      AS ObjectName,
    o.type_desc AS ObjectType
FROM sys.objects o
WHERE o.name IN (N'Blog', N'BlogPost')
  AND o.type IN ('U', 'V')
ORDER BY o.name;
GO

PRINT N'';
PRINT N'=== DIAGNOSTIC: Cột trong bảng Blog ===';
SELECT
    c.name          AS ColumnName,
    t.name          AS DataType,
    c.max_length    AS MaxLength,
    c.is_nullable   AS IsNullable
FROM sys.columns c
JOIN sys.types t ON c.system_type_id = t.system_type_id AND t.is_user_defined = 0
WHERE c.object_id = OBJECT_ID(N'dbo.Blog')
ORDER BY c.column_id;
GO

PRINT N'';
PRINT N'=== MIGRATION 20260714_fix_schema_mismatch HOÀN THÀNH ===';
PRINT N'Hãy restart Tomcat sau khi chạy script này.';
GO
