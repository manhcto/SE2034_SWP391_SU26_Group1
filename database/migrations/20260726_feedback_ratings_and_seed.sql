USE [WonderVn]
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (
        SELECT 1
        FROM [dbo].[Feedback]
        GROUP BY [bookingID]
        HAVING COUNT(*) > 1
    )
        THROW 50031, N'Feedback đang có booking bị đánh giá trùng. Hãy xử lý dữ liệu trùng trước khi chạy migration.', 1;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE [object_id] = OBJECT_ID(N'[dbo].[Feedback]')
          AND [name] = N'UX_Feedback_BookingID'
    )
        CREATE UNIQUE INDEX [UX_Feedback_BookingID]
            ON [dbo].[Feedback] ([bookingID]);

    DECLARE @Customers TABLE (
        [slot] INT PRIMARY KEY,
        [userID] INT NOT NULL,
        [firstName] NVARCHAR(100) NOT NULL,
        [lastName] NVARCHAR(100) NOT NULL,
        [email] NVARCHAR(255) NOT NULL,
        [phone] NVARCHAR(20) NULL
    );

    INSERT INTO @Customers ([slot], [userID], [firstName], [lastName], [email], [phone])
    SELECT ROW_NUMBER() OVER (ORDER BY customer.[userID]),
           customer.[userID],
           customer.[firstName],
           customer.[lastName],
           customer.[email],
           customer.[phone]
    FROM (
        SELECT TOP (5) appUser.[userID], appUser.[firstName], appUser.[lastName],
               appUser.[email], appUser.[phone]
        FROM [dbo].[User] appUser
        INNER JOIN [dbo].[Role] appRole ON appRole.[roleID] = appUser.[roleID]
        WHERE appUser.[status] = N'Active'
          AND appRole.[roleName] = N'Customer'
        ORDER BY appUser.[userID]
    ) customer;

    IF (SELECT COUNT(*) FROM @Customers) < 5
        THROW 50032, N'Cần ít nhất 5 tài khoản Customer đang Active để seed feedback.', 1;

    DECLARE @Reviews TABLE (
        [slot] INT PRIMARY KEY,
        [rate] DECIMAL(3,2) NOT NULL,
        [content] NVARCHAR(1000) NOT NULL
    );

    INSERT INTO @Reviews ([slot], [rate], [content])
    VALUES
        (1, 5.00, N'Phòng sạch sẽ, nhân viên thân thiện và hỗ trợ rất nhanh. Tôi hài lòng với kỳ nghỉ này.'),
        (2, 4.00, N'Vị trí thuận tiện, không gian thoải mái và đúng như mô tả. Trải nghiệm nhìn chung rất tốt.'),
        (3, 5.00, N'Dịch vụ chu đáo, tiện ích đầy đủ và phòng được chuẩn bị kỹ trước khi nhận.'),
        (4, 4.00, N'Không gian yên tĩnh, giường ngủ thoải mái. Tôi sẽ cân nhắc quay lại trong chuyến đi sau.'),
        (5, 5.00, N'Mọi thứ gọn gàng, quy trình nhận phòng nhanh và mức giá phù hợp với chất lượng.');

    INSERT INTO [dbo].[Booking] (
        [bookingCode], [bookingType], [email], [phone],
        [numberAdult], [numberChildren], [numberInfant], [note],
        [firstName], [lastName], [userID], [status], [bookDate],
        [isBookedForOther], [totalPrice], [depositAmount], [remainingAmount]
    )
    SELECT CONCAT(N'FB-ACC-', RIGHT(N'000000' + CONVERT(NVARCHAR(10), accommodation.[accommodationID]), 6),
                  N'-', reviewSeed.[slot]),
           N'Accommodation',
           customer.[email],
           COALESCE(NULLIF(customer.[phone], N''), N'0900000000'),
           2, 0, 0, N'[FEEDBACK_SEED] Booking mẫu phục vụ đánh giá nơi lưu trú.',
           customer.[firstName], customer.[lastName], customer.[userID], N'Ended',
           DATEADD(DAY, -(30 + reviewSeed.[slot]), GETDATE()),
           0,
           COALESCE(roomSeed.[priceOfRoom], CAST(1000000 AS DECIMAL(18,2))),
           COALESCE(roomSeed.[priceOfRoom], CAST(1000000 AS DECIMAL(18,2))),
           CAST(0 AS DECIMAL(18,2))
    FROM [dbo].[Accommodation] accommodation
    CROSS JOIN @Reviews reviewSeed
    INNER JOIN @Customers customer ON customer.[slot] = reviewSeed.[slot]
    OUTER APPLY (
        SELECT TOP (1) room.[roomID], room.[priceOfRoom]
        FROM [dbo].[Room] room
        WHERE room.[accommodationID] = accommodation.[accommodationID]
        ORDER BY room.[roomID]
    ) roomSeed
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[Booking] existingBooking
        WHERE existingBooking.[bookingCode] =
              CONCAT(N'FB-ACC-', RIGHT(N'000000' + CONVERT(NVARCHAR(10), accommodation.[accommodationID]), 6),
                     N'-', reviewSeed.[slot])
    );

    INSERT INTO [dbo].[Booking_Detail] (
        [bookingID], [accommodationID], [roomID], [quantity],
        [unitPrice], [subTotal], [startDate], [endDate], [note]
    )
    SELECT booking.[bookingID],
           accommodation.[accommodationID],
           roomSeed.[roomID],
           1,
           COALESCE(roomSeed.[priceOfRoom], CAST(1000000 AS DECIMAL(18,2))),
           COALESCE(roomSeed.[priceOfRoom], CAST(1000000 AS DECIMAL(18,2))),
           DATEADD(DAY, -(20 + reviewSeed.[slot]), GETDATE()),
           DATEADD(DAY, -(19 + reviewSeed.[slot]), GETDATE()),
           N'[FEEDBACK_SEED] Chi tiết lưu trú đã hoàn tất.'
    FROM [dbo].[Accommodation] accommodation
    CROSS JOIN @Reviews reviewSeed
    INNER JOIN [dbo].[Booking] booking
        ON booking.[bookingCode] =
           CONCAT(N'FB-ACC-', RIGHT(N'000000' + CONVERT(NVARCHAR(10), accommodation.[accommodationID]), 6),
                  N'-', reviewSeed.[slot])
    OUTER APPLY (
        SELECT TOP (1) room.[roomID], room.[priceOfRoom]
        FROM [dbo].[Room] room
        WHERE room.[accommodationID] = accommodation.[accommodationID]
        ORDER BY room.[roomID]
    ) roomSeed
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[Booking_Detail] existingDetail
        WHERE existingDetail.[bookingID] = booking.[bookingID]
    );

    INSERT INTO [dbo].[Feedback] (
        [bookingID], [userID], [rate], [comment], [content], [status],
        [createdAt], [updatedAt], [image], [createDate]
    )
    SELECT booking.[bookingID],
           booking.[userID],
           reviewSeed.[rate],
           reviewSeed.[content],
           reviewSeed.[content],
           N'Visible',
           DATEADD(DAY, -(10 + reviewSeed.[slot]), GETDATE()),
           NULL,
           NULL,
           DATEADD(DAY, -(10 + reviewSeed.[slot]), GETDATE())
    FROM [dbo].[Accommodation] accommodation
    CROSS JOIN @Reviews reviewSeed
    INNER JOIN [dbo].[Booking] booking
        ON booking.[bookingCode] =
           CONCAT(N'FB-ACC-', RIGHT(N'000000' + CONVERT(NVARCHAR(10), accommodation.[accommodationID]), 6),
                  N'-', reviewSeed.[slot])
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[Feedback] existingFeedback
        WHERE existingFeedback.[bookingID] = booking.[bookingID]
    );

    COMMIT TRANSACTION;

    SELECT accommodation.[accommodationID],
           accommodation.[name],
           COUNT(feedback.[feedbackID]) AS [visibleFeedbackCount],
           CAST(AVG(CAST(feedback.[rate] AS DECIMAL(10,2))) AS DECIMAL(3,2)) AS [averageRate]
    FROM [dbo].[Accommodation] accommodation
    LEFT JOIN [dbo].[Booking_Detail] detail
        ON detail.[accommodationID] = accommodation.[accommodationID]
    LEFT JOIN [dbo].[Feedback] feedback
        ON feedback.[bookingID] = detail.[bookingID]
       AND feedback.[status] = N'Visible'
    GROUP BY accommodation.[accommodationID], accommodation.[name]
    ORDER BY accommodation.[accommodationID];
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
