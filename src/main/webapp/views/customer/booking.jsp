<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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

        .error-box {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: 16px 18px;
            margin-bottom: 22px;
            font-weight: 700;
        }

        .error-box ul {
            margin: 10px 0 0;
            padding-left: 20px;
        }

        .booking-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 16px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            color: #374151;
            font-size: 14px;
            font-weight: 800;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 12px 13px;
            font: inherit;
            outline: none;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .checkbox-line {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #374151;
            font-weight: 700;
            margin: 4px 0 18px;
        }

        .checkbox-line input {
            width: 18px;
            height: 18px;
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

            .booking-form-grid {
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
                <c:choose>
                    <c:when test="${not empty selectedTour and not empty selectedSchedule}">
                        <h3>${selectedTour.tourName}</h3>

                        <p>
                            Mã tour: <strong>${selectedTour.tourCode}</strong>. Vui lòng kiểm tra lịch khởi hành,
                            số chỗ còn nhận và giá tour trước khi chuyển sang bước nhập thông tin booking.
                        </p>

                        <div class="booking-info">
                            <p><strong>Khởi hành:</strong> ${selectedTour.startPlace}</p>
                            <p><strong>Điểm đến:</strong> ${selectedTour.endPlace}</p>
                            <p><strong>Thời lượng:</strong> ${selectedTour.numberOfDay} ngày <c:if test="${not empty selectedTour.numberOfNights}">${selectedTour.numberOfNights} đêm</c:if></p>
                            <p><strong>Ngày đi:</strong> <fmt:formatDate value="${selectedSchedule.startDate}" pattern="dd/MM/yyyy" /></p>
                            <p><strong>Ngày về:</strong> <fmt:formatDate value="${selectedSchedule.endDate}" pattern="dd/MM/yyyy" /></p>
                            <p><strong>Số chỗ còn nhận:</strong> ${selectedSchedule.remainingSeats}</p>
                        </div>

                        <div class="price-note">
                            Giá người lớn: <span><fmt:formatNumber value="${selectedSchedule.adultPrice}" pattern="#,#00" />đ</span>
                            <br>
                            Giá trẻ em: <span><fmt:formatNumber value="${selectedSchedule.childPrice}" pattern="#,#00" />đ</span>
                        </div>

                        <form action="${pageContext.request.contextPath}/views/customer/checkout.jsp"
                              method="get"
                              class="booking-actions">

                            <input type="hidden" name="tourScheduleID" value="${selectedSchedule.tourScheduleID}">
                            <input type="hidden" name="tourName" value="${selectedTour.tourName}">

                            <button type="submit">
                                Tiếp tục đến Checkout
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <h3>Chưa chọn lịch khởi hành</h3>
                        <p>Bạn cần chọn một lịch khởi hành còn mở bán trước khi đặt tour.</p>
                        <div class="booking-actions">
                            <a href="${pageContext.request.contextPath}/tour" style="display:block;width:100%;border-radius:8px;background:#2563eb;color:#fff;padding:16px;font-weight:800;text-decoration:none;">
                                Quay lại danh sách tour
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>
