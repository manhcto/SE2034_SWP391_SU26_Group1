<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Xác nhận đặt phòng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --dark: #0f172a;
            --muted: #64748b;
            --border: #e2e8f0;
            --soft: #f8fafc;
            --bg: #f3f6fb;
            --shadow: 0 18px 44px rgba(15, 23, 42, 0.10);
        }

        body {
            margin: 0;
            background: var(--bg);
            color: #1e293b;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        }

        .booking-page {
            padding: 32px 0 60px;
        }

        .page-head {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 22px;
        }

        .page-kicker {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: #eaf1ff;
            color: #1d4ed8;
            font-weight: 900;
            margin-bottom: 12px;
        }

        .page-title {
            margin: 0;
            color: var(--dark);
            font-size: 34px;
            line-height: 1.18;
            font-weight: 950;
        }

        .page-subtitle {
            color: var(--muted);
            margin: 10px 0 0;
            font-weight: 650;
            line-height: 1.6;
        }

        .booking-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 380px;
            gap: 24px;
            align-items: start;
        }

        .form-card,
        .summary-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 26px;
            box-shadow: var(--shadow);
        }

        .form-card {
            padding: 28px;
        }

        .summary-card {
            position: sticky;
            top: 96px;
            overflow: hidden;
        }

        .summary-image {
            height: 190px;
            background: #e2e8f0;
        }

        .summary-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .summary-body {
            padding: 22px;
        }

        .form-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 18px;
            color: var(--dark);
            font-size: 21px;
            font-weight: 950;
        }

        .booking-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .field label {
            display: block;
            margin-bottom: 7px;
            color: #27364f;
            font-size: 13px;
            font-weight: 900;
        }

        .form-control,
        .form-select {
            height: 52px;
            border-radius: 16px;
            border: 1px solid #dbe3ef;
            background: var(--soft);
            color: var(--dark);
            font-weight: 700;
        }

        textarea.form-control {
            min-height: 112px;
            padding-top: 14px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #7aa2ff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        .summary-title {
            color: var(--dark);
            font-size: 22px;
            font-weight: 950;
            line-height: 1.3;
            margin-bottom: 6px;
        }

        .summary-place {
            color: #16a34a;
            font-weight: 850;
            margin-bottom: 16px;
        }

        .summary-line {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 11px 0;
            border-bottom: 1px solid #e2e8f0;
            color: #526079;
            font-weight: 750;
        }

        .summary-line span:first-child {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .summary-line i {
            width: 18px;
            color: var(--primary);
        }

        .summary-line strong {
            color: var(--dark);
            text-align: right;
        }

        .summary-total {
            margin-top: 18px;
            padding: 16px;
            border-radius: 20px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
        }

        .summary-total-label {
            color: #1e3a8a;
            font-weight: 900;
            margin-bottom: 5px;
        }

        .summary-total-value {
            color: #1d4ed8;
            font-size: 28px;
            font-weight: 950;
        }

        .form-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
        }

        .btn-submit-booking,
        .btn-soft-back {
            min-height: 52px;
            border-radius: 16px;
            padding: 13px 20px;
            font-weight: 900;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
        }

        .btn-submit-booking {
            border: none;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            min-width: 180px;
        }

        .btn-soft-back {
            border: 1px solid #cbd5e1;
            background: #ffffff;
            color: var(--dark);
        }

        @media (max-width: 992px) {
            .booking-layout {
                grid-template-columns: 1fr;
            }

            .summary-card {
                position: static;
            }
        }

        @media (max-width: 640px) {
            .page-head,
            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .booking-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<jsp:include page="/views/common/client-header.jsp"/>

<main class="container booking-page">
    <div class="page-head">
        <div>
            <div class="page-kicker">
                <i class="fa-solid fa-clipboard-check"></i>
                Xác nhận thông tin
            </div>
            <h1 class="page-title">Hoàn tất thông tin đặt phòng</h1>
            <p class="page-subtitle">
                Thông tin được tự động lấy từ tài khoản của bạn. Bạn có thể chỉnh lại trước khi gửi yêu cầu đặt phòng.
            </p>
        </div>

        <a class="btn-soft-back" href="${detailUrl}">
            <i class="fa-solid fa-arrow-left"></i>
            Quay lại phòng
        </a>
    </div>

    <c:if test="${param.status == 'invalidCustomerInfo'}">
        <div class="alert alert-danger rounded-4 border-0 shadow-sm">
            <i class="fa-solid fa-circle-exclamation me-2"></i>
            Vui lòng nhập đầy đủ thông tin khách hàng. CCCD/CMND phải gồm 9 hoặc 12 chữ số.
        </div>
    </c:if>

    <div class="booking-layout">
        <section class="form-card">
            <h2 class="form-section-title">
                <i class="fa-solid fa-user-shield"></i>
                Thông tin khách lưu trú
            </h2>

            <form action="${pageContext.request.contextPath}/booking/accommodation" method="post" novalidate>
                <input type="hidden" name="accommodationID" value="${accommodation.serviceID}">
                <input type="hidden" name="roomID" value="${room.roomID}">
                <input type="hidden" name="checkIn" value="${checkIn}">
                <input type="hidden" name="checkOut" value="${checkOut}">
                <input type="hidden" name="adults" value="${adults}">
                <input type="hidden" name="children" value="${children}">
                <input type="hidden" name="rooms" value="${rooms}">
                <input type="hidden" name="guests" value="${guests}">

                <div class="booking-form-grid">
                    <div class="field">
                        <label for="firstName">Họ</label>
                        <input class="form-control" id="firstName" name="firstName" value="${user.firstName}" required>
                    </div>

                    <div class="field">
                        <label for="lastName">Tên</label>
                        <input class="form-control" id="lastName" name="lastName" value="${user.lastName}" required>
                    </div>

                    <div class="field">
                        <label for="email">Email</label>
                        <input class="form-control" id="email" type="email" name="email" value="${user.email}" required>
                    </div>

                    <div class="field">
                        <label for="phone">Số điện thoại</label>
                        <input class="form-control" id="phone" name="phone" value="${user.phone}" required>
                    </div>

                    <div class="field">
                        <label for="identityNumber">CCCD / CMND</label>
                        <input class="form-control"
                               id="identityNumber"
                               name="identityNumber"
                               inputmode="numeric"
                               pattern="^[0-9]{9}$|^[0-9]{12}$"
                               placeholder="Nhập 9 hoặc 12 chữ số"
                               required>
                    </div>

                    <div class="field">
                        <label for="bookedFor">Người đại diện nhận phòng</label>
                        <input class="form-control" id="bookedFor" value="${user.firstName} ${user.lastName}" readonly>
                    </div>

                    <div class="field full">
                        <label for="address">Địa chỉ liên hệ</label>
                        <input class="form-control" id="address" name="address" value="${user.address}" placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành" required>
                    </div>

                    <div class="field full">
                        <label for="note">Ghi chú cho nơi lưu trú</label>
                        <textarea class="form-control" id="note" name="note" placeholder="Ví dụ: nhận phòng muộn, cần phòng yên tĩnh, hỗ trợ trẻ em..."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <a class="btn-soft-back" href="${detailUrl}">
                        Hủy
                    </a>
                    <button class="btn-submit-booking" type="submit">
                        <i class="fa-solid fa-calendar-check"></i>
                        Đặt phòng
                    </button>
                </div>
            </form>
        </section>

        <aside class="summary-card">
            <div class="summary-image">
                <img src="${room.image}"
                     alt="${room.roomType}"
                     onerror="this.src='https://placehold.co/800x450?text=WonderVN+Room';">
            </div>

            <div class="summary-body">
                <div class="summary-title">${room.roomType}</div>
                <div class="summary-place">
                    <i class="fa-solid fa-location-dot me-1"></i>
                    ${accommodation.name}
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-calendar-check"></i> Nhận phòng</span>
                    <strong>${checkIn}</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-calendar-xmark"></i> Trả phòng</span>
                    <strong>${checkOut}</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-moon"></i> Số đêm</span>
                    <strong>${nights} đêm</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-bed"></i> Số phòng</span>
                    <strong>${rooms} phòng</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-user-group"></i> Số khách</span>
                    <strong>${adults} người lớn, ${children} trẻ em</strong>
                </div>

                <div class="summary-total">
                    <div class="summary-total-label">Tổng tiền tạm tính</div>
                    <div class="summary-total-value">
                        <fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="0"/> đ
                    </div>
                </div>
            </div>
        </aside>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
