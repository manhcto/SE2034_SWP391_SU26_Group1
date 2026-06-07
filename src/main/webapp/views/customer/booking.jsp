<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .booking-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .booking-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 6px 16px rgba(0,0,0,0.06);
        }

        .booking-card h3 {
            margin-top: 0;
            font-size: 24px;
            color: #111827;
        }

        .booking-card p {
            color: #374151;
            line-height: 1.6;
        }

        .booking-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin: 20px 0;
        }

        .booking-info p {
            margin: 0;
        }

        .price {
            font-size: 24px;
            color: #dc2626;
            font-weight: bold;
            margin: 20px 0;
        }

        .booking-actions {
            margin-top: 24px;
        }

        .booking-actions button {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: #ffffff;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .booking-actions button:hover {
            background: #1d4ed8;
        }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/common/homepage/header.jsp" />

<main>
    <section class="booking-container">
        <div class="section-head" style="justify-content:center; text-align:center;">
            <div>
                <p class="section-kicker">Booking</p>
                <h2>Đặt Tour Ngay</h2>
                <p>Đây là trang Booking trước khi khách chuyển sang bước Checkout.</p>
            </div>
        </div>

        <div class="booking-card">
            <h3>Hà Nội - Ninh Bình - Hạ Long 4N3Đ</h3>

            <p>
                Hành trình khám phá miền Bắc với các điểm đến nổi bật:
                Hà Nội, Ninh Bình và Vịnh Hạ Long.
            </p>

            <div class="booking-info">
                <p><strong>Mã lịch trình:</strong> TS-001</p>
                <p><strong>Tour Schedule ID:</strong> 1</p>
                <p><strong>Khởi hành:</strong> TP. Hồ Chí Minh</p>
                <p><strong>Thời lượng:</strong> 4 ngày 3 đêm</p>
                <p><strong>Ngày đi:</strong> 15/06/2026</p>
                <p><strong>Số chỗ còn nhận:</strong> 20</p>
            </div>

            <div class="price">
                5.990.000 VNĐ / người
            </div>

            <form action="${pageContext.request.contextPath}/views/customer/checkout.jsp" method="get" class="booking-actions">
                <input type="hidden" name="tourScheduleID" value="1">
                <input type="hidden" name="unitPrice" value="5990000">
                <input type="hidden" name="tourName" value="Hà Nội - Ninh Bình - Hạ Long 4N3Đ">

                <button type="submit">Tiếp tục đến Checkout</button>
            </form>
        </div>
    </section>
</main>

<jsp:include page="/WEB-INF/common/homepage/footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>