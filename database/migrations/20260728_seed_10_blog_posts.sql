USE [WonderVn];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @AuthorID INT = (
    SELECT TOP (1) u.userID
    FROM dbo.[User] u
    JOIN dbo.[Role] r ON r.roleID = u.roleID
    WHERE u.[status] = N'Active'
      AND r.roleName IN (N'Staff', N'Admin')
    ORDER BY CASE r.roleName WHEN N'Staff' THEN 0 ELSE 1 END, u.userID
);

DECLARE @PublishedAt DATETIME = GETDATE();

BEGIN TRY
    BEGIN TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM dbo.Blog WHERE slug = N'cam-nang-du-lich-ha-noi-3-ngay')
        INSERT dbo.Blog
            (title, slug, summary, content, image, category, [status], authorID, publishedAt, createAt, updateAt)
        VALUES
            (N'Cẩm nang du lịch Hà Nội trong 3 ngày',
             N'cam-nang-du-lich-ha-noi-3-ngay',
             N'Lịch trình tham khảo giúp bạn khám phá khu phố cổ, các công trình lịch sử và ẩm thực Hà Nội.',
             N'Ngày đầu tiên, bạn có thể tham quan Hồ Hoàn Kiếm, đền Ngọc Sơn và phố cổ. Ngày thứ hai phù hợp để ghé Văn Miếu, Hoàng thành Thăng Long và hồ Tây. Ngày cuối cùng nên dành cho bảo tàng, mua quà và thưởng thức phở, bún chả, cà phê trứng. Hãy đặt chỗ sớm vào cuối tuần và chuẩn bị giày đi bộ thoải mái.',
             N'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80',
             N'Diem den', N'Published', @AuthorID, DATEADD(DAY, -9, @PublishedAt), DATEADD(DAY, -9, @PublishedAt), NULL);

    IF NOT EXISTS (SELECT 1 FROM dbo.Blog WHERE slug = N'kinh-nghiem-du-lich-da-nang-4-ngay-3-dem')
        INSERT dbo.Blog
            (title, slug, summary, content, image, category, [status], authorID, publishedAt, createAt, updateAt)
        VALUES
            (N'Kinh nghiệm du lịch Đà Nẵng 4 ngày 3 đêm',
             N'kinh-nghiem-du-lich-da-nang-4-ngay-3-dem',
             N'Gợi ý lịch trình kết hợp biển Mỹ Khê, bán đảo Sơn Trà, Bà Nà Hills và phố cổ Hội An.',
             N'Đà Nẵng thích hợp cho chuyến đi ngắn nhờ giao thông thuận tiện và nhiều điểm tham quan gần nhau. Bạn nên dành một ngày cho Sơn Trà và biển Mỹ Khê, một ngày tại Bà Nà Hills, một ngày khám phá Hội An và ngày còn lại để thưởng thức ẩm thực địa phương. Nên mang kem chống nắng, áo khoác mỏng và kiểm tra dự báo thời tiết trước chuyến đi.',
             N'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1200&q=80',
             N'Kinh nghiem', N'Published', @AuthorID, DATEADD(DAY, -8, @PublishedAt), DATEADD(DAY, -8, @PublishedAt), NULL);

    IF NOT EXISTS (SELECT 1 FROM dbo.Blog WHERE slug = N'da-lat-mua-mua-di-dau-an-gi')
        INSERT dbo.Blog
            (title, slug, summary, content, image, category, [status], authorID, publishedAt, createAt, updateAt)
        VALUES
            (N'Đà Lạt mùa mưa: đi đâu và ăn gì?',
             N'da-lat-mua-mua-di-dau-an-gi',
             N'Những trải nghiệm phù hợp trong ngày mưa cùng các món nóng đặc trưng của thành phố cao nguyên.',
             N'Mùa mưa Đà Lạt thường có mưa vào buổi chiều, vì vậy bạn nên tham quan ngoài trời từ sáng sớm. Khi trời mưa, các quán cà phê có không gian đẹp, bảo tàng và khu trưng bày là lựa chọn phù hợp. Buổi tối có thể thưởng thức lẩu gà lá é, bánh căn hoặc sữa đậu nành nóng. Luôn mang áo mưa nhẹ và giày chống trượt.',
             N'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
             N'Diem den', N'Published', @AuthorID, DATEADD(DAY, -7, @PublishedAt), DATEADD(DAY, -7, @PublishedAt), NULL);

    IF NOT EXISTS (SELECT 1 FROM dbo.Blog WHERE slug = N'bi-quyet-du-lich-phu-quoc-tiet-kiem')
        INSERT dbo.Blog
            (title, slug, summary, content, image, category, [status], authorID, publishedAt, createAt, updateAt)
        VALUES
            (N'Bí quyết du lịch Phú Quốc tiết kiệm',
             N'bi-quyet-du-lich-phu-quoc-tiet-kiem',
             N'Cách chọn thời điểm, nơi lưu trú và lịch tham quan để kiểm soát chi phí cho chuyến đi Phú Quốc.',
             N'Để tiết kiệm, hãy đặt vé máy bay và phòng trước từ bốn đến sáu tuần. Chọn nơi lưu trú gần khu vực bạn muốn khám phá để giảm chi phí di chuyển. Bạn có thể kết hợp các điểm cùng hướng trong một ngày và ưu tiên quán ăn địa phương. Luôn kiểm tra chính sách hủy phòng, phụ thu và giờ nhận phòng trước khi thanh toán.',
             N'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
             N'Meo du lich', N'Published', @AuthorID, DATEADD(DAY, -6, @PublishedAt), DATEADD(DAY, -6, @PublishedAt), NULL);

    IF NOT EXISTS (SELECT 1 FROM dbo.Blog WHERE slug = N'kham-pha-ninh-binh-mua-lua-chin')
        INSERT dbo.Blog
            (title, slug, summary, content, image, category, [status], authorID, publishedAt, createAt, updateAt)
        VALUES
            (N'Khám phá Ninh Bình mùa lúa chín',
             N'kham-pha-ninh-binh-mua-lua-chin',
             N'Thời gian đẹp để tham quan Tam Cốc, Tràng An và ngắm những cánh đồng lúa vàng.',
             N'Mùa lúa chín tại Ninh Bình thường tạo nên cảnh quan nổi bật dọc các tuyến sông và chân núi đá vôi. Bạn nên đi thuyền vào sáng sớm để tránh nắng và đông khách. Ngoài Tam Cốc, có thể kết hợp Tràng An, Hang Múa hoặc cố đô Hoa Lư. Hãy tôn trọng khu vực canh tác và không tự ý đi vào ruộng của người dân.',
             N'https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=80',
             N'Diem den', N'Published', @AuthorID, DATEADD(DAY, -5, @PublishedAt), DATEADD(DAY, -5, @PublishedAt), NULL);

    IF NOT EXISTS (SELECT 1 FROM dbo.Blog WHERE slug = N'am-thuc-hue-nhung-mon-nen-thu')
        INSERT dbo.Blog
            (title, slug, summary, content, image, category, [status], authorID, publishedAt, createAt, updateAt)
        VALUES
            (N'Ẩm thực Huế: những món bạn nên thử',
             N'am-thuc-hue-nhung-mon-nen-thu',
             N'Danh sách các món đặc trưng từ bún bò, cơm hến đến các loại bánh truyền thống của xứ Huế.',
             N'Ẩm thực Huế nổi bật với hương vị đậm đà và cách trình bày tinh tế. Bún bò Huế, cơm hến, bánh bèo, bánh nậm và bánh lọc là những món dễ tìm. Khi chọn quán, hãy xem giờ mở cửa và hỏi trước mức độ cay. Buổi tối, bạn có thể kết hợp tham quan khu trung tâm với việc thưởng thức chè Huế.',
             N'https://images.unsplash.com/photo-1559314809-0d155014e29e?auto=format&fit=crop&w=1200&q=80',
             N'Am thuc', N'Published', @AuthorID, DATEADD(DAY, -4, @PublishedAt), DATEADD(DAY, -4, @PublishedAt), NULL);

    IF NOT EXISTS (SELECT 1 FROM dbo.Blog WHERE slug = N'cach-chuan-bi-hanh-ly-cho-chuyen-di-dai-ngay')
        INSERT dbo.Blog
            (title, slug, summary, content, image, category, [status], authorID, publishedAt, createAt, updateAt)
        VALUES
            (N'Cách chuẩn bị hành lý cho chuyến đi dài ngày',
             N'cach-chuan-bi-hanh-ly-cho-chuyen-di-dai-ngay',
             N'Mẹo sắp xếp quần áo, giấy tờ và đồ dùng cần thiết để hành lý gọn nhẹ nhưng vẫn đầy đủ.',
             N'Hãy lập danh sách theo từng nhóm gồm giấy tờ, quần áo, đồ vệ sinh cá nhân, thuốc và thiết bị điện tử. Ưu tiên trang phục có thể phối nhiều cách và cuộn quần áo để tiết kiệm diện tích. Giấy tờ quan trọng nên có bản sao điện tử. Không để tiền, hộ chiếu hoặc thuốc cần dùng trong hành lý ký gửi.',
             N'https://images.unsplash.com/photo-1553531384-cc64ac80f931?auto=format&fit=crop&w=1200&q=80',
             N'Meo du lich', N'Published', @AuthorID, DATEADD(DAY, -3, @PublishedAt), DATEADD(DAY, -3, @PublishedAt), NULL);

    IF NOT EXISTS (SELECT 1 FROM dbo.Blog WHERE slug = N'luu-y-an-toan-khi-du-lich-tu-tuc')
        INSERT dbo.Blog
            (title, slug, summary, content, image, category, [status], authorID, publishedAt, createAt, updateAt)
        VALUES
            (N'Những lưu ý an toàn khi du lịch tự túc',
             N'luu-y-an-toan-khi-du-lich-tu-tuc',
             N'Các bước đơn giản giúp bạn chủ động xử lý lịch trình, tài sản và tình huống khẩn cấp.',
             N'Trước chuyến đi, hãy lưu thông tin nơi ở, số điện thoại hỗ trợ và chia sẻ lịch trình cho người thân. Không mang quá nhiều tiền mặt và tránh để toàn bộ giấy tờ ở một chỗ. Khi thuê xe hoặc tham gia hoạt động ngoài trời, cần kiểm tra thiết bị bảo hộ và điều kiện thời tiết. Luôn sử dụng dịch vụ có thông tin minh bạch.',
             N'https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=1200&q=80',
             N'Kinh nghiem', N'Published', @AuthorID, DATEADD(DAY, -2, @PublishedAt), DATEADD(DAY, -2, @PublishedAt), NULL);

    IF NOT EXISTS (SELECT 1 FROM dbo.Blog WHERE slug = N'kinh-nghiem-chon-noi-luu-tru-phu-hop')
        INSERT dbo.Blog
            (title, slug, summary, content, image, category, [status], authorID, publishedAt, createAt, updateAt)
        VALUES
            (N'Kinh nghiệm chọn nơi lưu trú phù hợp',
             N'kinh-nghiem-chon-noi-luu-tru-phu-hop',
             N'Các tiêu chí nên kiểm tra khi chọn khách sạn, homestay hoặc khu nghỉ dưỡng cho chuyến đi.',
             N'Vị trí, ngân sách và mục đích chuyến đi là ba tiêu chí quan trọng nhất. Bạn nên kiểm tra loại phòng, sức chứa, tiện nghi, giờ nhận trả phòng và chính sách hủy. Đọc kỹ mô tả thay vì chỉ xem ảnh, đồng thời kiểm tra khoảng cách thực tế đến điểm tham quan. Với nhóm đông người, cần xác nhận rõ số giường và phụ thu.',
             N'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80',
             N'Kinh nghiem', N'Published', @AuthorID, DATEADD(DAY, -1, @PublishedAt), DATEADD(DAY, -1, @PublishedAt), NULL);

    IF NOT EXISTS (SELECT 1 FROM dbo.Blog WHERE slug = N'du-lich-ben-vung-tu-nhung-hanh-dong-nho')
        INSERT dbo.Blog
            (title, slug, summary, content, image, category, [status], authorID, publishedAt, createAt, updateAt)
        VALUES
            (N'Du lịch bền vững từ những hành động nhỏ',
             N'du-lich-ben-vung-tu-nhung-hanh-dong-nho',
             N'Những thói quen đơn giản giúp giảm rác thải và tôn trọng văn hóa tại điểm đến.',
             N'Bạn có thể mang theo bình nước cá nhân, hạn chế đồ nhựa dùng một lần và ưu tiên các dịch vụ địa phương. Không xả rác, không lấy hiện vật tự nhiên và luôn tuân thủ quy định tại khu bảo tồn. Khi chụp ảnh người dân hoặc không gian tín ngưỡng, hãy xin phép trước. Một chuyến đi có trách nhiệm giúp điểm đến được gìn giữ lâu dài.',
             N'https://images.unsplash.com/photo-1530789253388-582c481c54b0?auto=format&fit=crop&w=1200&q=80',
             N'Meo du lich', N'Published', @AuthorID, @PublishedAt, @PublishedAt, NULL);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO

SELECT blogID, title, slug, [status], authorID, publishedAt
FROM dbo.Blog
WHERE slug IN (
    N'cam-nang-du-lich-ha-noi-3-ngay',
    N'kinh-nghiem-du-lich-da-nang-4-ngay-3-dem',
    N'da-lat-mua-mua-di-dau-an-gi',
    N'bi-quyet-du-lich-phu-quoc-tiet-kiem',
    N'kham-pha-ninh-binh-mua-lua-chin',
    N'am-thuc-hue-nhung-mon-nen-thu',
    N'cach-chuan-bi-hanh-ly-cho-chuyen-di-dai-ngay',
    N'luu-y-an-toan-khi-du-lich-tu-tuc',
    N'kinh-nghiem-chon-noi-luu-tru-phu-hop',
    N'du-lich-ben-vung-tu-nhung-hanh-dong-nho'
)
ORDER BY publishedAt DESC;
GO
