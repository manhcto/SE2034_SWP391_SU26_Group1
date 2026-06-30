<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Booking</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=1000">

    <style>
        .booking-section {
            padding-top: 38px;
            padding-bottom: 34px;
        }

        .booking-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .booking-title-area {
            width: 100%;
            display: flex;
            justify-content: center;
            text-align: center;
            margin-bottom: 28px;
        }

        .booking-title-area > div {
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .booking-title-area .section-kicker {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: auto;
            min-width: 130px;
            padding: 10px 28px;
            margin: 0 auto 12px;
        }

        .booking-title-area h2 {
            width: 100%;
            text-align: center;
            margin: 0 auto 12px;
        }

        .booking-title-area p {
            width: 100%;
            text-align: center;
            max-width: 720px;
            margin: 0 auto;
            color: #64748b;
        }

        .booking-card {
            width: 100%;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            margin: 0 auto;
        }

        .booking-card h3 {
            margin-top: 0;
            margin-bottom: 14px;
            font-size: 24px;
            color: #111827;
            text-align: left;
        }

        .booking-card > p {
            color: #374151;
            line-height: 1.7;
            text-align: left;
            margin: 0 0 22px;
        }

        .booking-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin: 22px 0;
            padding: 20px;
            border-radius: 10px;
            background: #f8fafc;
            border: 1px solid #e5e7eb;
        }

        .booking-info p {
            margin: 0;
            color: #334155;
            text-align: center;
        }

        .price-note {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 10px;
            padding: 16px;
            margin: 20px 0;
            color: #374151;
            font-weight: 700;
            text-align: center;
        }

        .price-note span {
            color: #2563eb;
            font-weight: 800;
        }

        .booking-actions {
            margin-top: 24px;
            width: 100%;
            text-align: center;
        }

        .booking-actions button {
            width: 100%;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: #ffffff;
            padding: 16px;
            font-size: 16px;
            font-weight: 800;
            cursor: pointer;
            transition: 0.2s ease;
            box-shadow: 0 14px 26px rgba(37, 99, 235, 0.22);
        }

        .booking-actions button:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 18px 34px rgba(37, 99, 235, 0.28);
        }

        @media (max-width: 768px) {
            .booking-section {
                padding-top: 28px;
                padding-bottom: 28px;
            }

            .booking-container {
                padding: 0 16px;
            }

            .booking-info {
                grid-template-columns: 1fr;
            }

            .booking-card {
                padding: 24px;
            }

            .booking-card h3,
            .booking-card > p {
                text-align: center;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main class="home-page">
    <section class="section booking-section">
        <div class="booking-container">
            <div class="section-head booking-title-area">
                <div>
                    <p class="section-kicker">Booking</p>
                    <h2>Đặt Tour Ngay</h2>
                    <p>Vui lòng kiểm tra thông tin tour trước khi chuyển sang bước Checkout.</p>
                </div>
            </div>

            <div class="booking-card">
                <h3>Hà Nội - Ninh Bình - Hạ Long 4N3Đ</h3>

                <p>
                    Hành trình khám phá miền Bắc với các điểm đến nổi bật như Hà Nội,
                    Ninh Bình và Vịnh Hạ Long. Tour phù hợp cho gia đình, nhóm bạn và khách du lịch muốn
                    trải nghiệm lịch trình rõ ràng, thuận tiện.
                </p>

                <div class="booking-info">
                    <p><strong>Khởi hành:</strong> TP. Hồ Chí Minh</p>
                    <p><strong>Thời lượng:</strong> 4 ngày 3 đêm</p>
                    <p><strong>Ngày đi:</strong> 15/06/2026</p>
                    <p><strong>Số chỗ còn nhận:</strong> 20</p>
                </div>

                <div class="price-note">
                    <span>Giá tour sẽ được hệ thống tính theo lịch trình đã chọn.</span>
                </div>

                <form action="${pageContext.request.contextPath}/views/customer/checkout.jsp"
                      method="get"
                      class="booking-actions">

                    <input type="hidden" name="tourScheduleID" value="1">
                    <input type="hidden" name="tourName" value="Hà Nội - Ninh Bình - Hạ Long 4N3Đ">

                    <button type="submit">
                        Tiếp tục đến Checkout
                    </button>
                </form>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>