<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Thanh toán & Đặt Tour</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .checkout-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .error-box {
            background-color: #fee2e2;
            color: #b91c1c;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border: 1px solid #f87171;
        }

        .error-box ul {
            margin: 10px 0 0 0;
            padding-left: 20px;
        }

        .form-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .form-card h3 {
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 18px;
            color: #111827;
            border-bottom: 1px solid #f3f4f6;
            padding-bottom: 12px;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }

        .form-group {
            flex: 1;
            min-width: 250px;
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
            color: #374151;
        }

        .form-group input,
        .form-group textarea {
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-family: inherit;
            font-size: 15px;
            outline: none;
            transition: 0.2s;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .checkout-btn {
            width: 100%;
            padding: 16px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
        }

        .tour-name {
            font-size: 18px;
            font-weight: bold;
            color: #111827;
            margin-bottom: 10px;
        }

        .tour-price {
            color: #dc2626;
            font-weight: bold;
            font-size: 18px;
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main>
    <section class="section checkout-container">
        <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 40px;">
            <div>
                <p class="section-kicker">Hoàn tất thủ tục</p>
                <h2>Thông tin Đặt Tour</h2>
                <p>Vui lòng điền đầy đủ thông tin để hệ thống ghi nhận đơn hàng của bạn.</p>
            </div>
        </div>

        <c:if test="${not empty errorList or not empty error}">
            <div class="error-box">
                <strong>⚠️ Vui lòng kiểm tra lại các thông tin sau:</strong>
                <ul>
                    <c:if test="${not empty error}">
                        <li>${error}</li>
                    </c:if>

                    <c:forEach items="${errorList}" var="err">
                        <li>${err}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/booking" method="POST" novalidate>

            <%-- Dữ liệu tour được gửi từ booking.jsp sang checkout.jsp --%>
            <input type="hidden" name="tourScheduleID" value="${param.tourScheduleID}">
            <input type="hidden" name="unitPrice" value="${param.unitPrice}">
            <input type="hidden" name="tourName" value="${param.tourName}">

            <%-- Hiển thị thông tin tour đang đặt --%>
            <div class="form-card">
                <h3>Tour đang đặt</h3>

                <c:choose>
                    <c:when test="${not empty param.tourName}">
                        <div class="tour-name">${param.tourName}</div>
                    </c:when>
                    <c:otherwise>
                        <div class="tour-name">Hà Nội - Ninh Bình - Hạ Long 4N3Đ</div>
                    </c:otherwise>
                </c:choose>

                <p>
                    <strong>Tour Schedule ID:</strong>
                    ${param.tourScheduleID}
                </p>

                <p>
                    <strong>Đơn giá:</strong>
                    <span class="tour-price">${param.unitPrice} VNĐ / người</span>
                </p>
            </div>

            <div class="form-card">
                <h3>1. Thông tin liên hệ</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">Họ và tên đệm *</label>
                        <input type="text"
                               id="firstName"
                               name="firstName"
                               value="${firstName}"
                               placeholder="VD: Nguyễn Văn">
                    </div>

                    <div class="form-group">
                        <label for="lastName">Tên *</label>
                        <input type="text"
                               id="lastName"
                               name="lastName"
                               value="${lastName}"
                               placeholder="VD: A">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email"
                               id="email"
                               name="email"
                               value="${email}"
                               placeholder="nguyenvena@gmail.com">
                    </div>

                    <div class="form-group">
                        <label for="phone">Số điện thoại *</label>
                        <input type="text"
                               id="phone"
                               name="phone"
                               value="${phone}"
                               placeholder="0987654321">
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="address">Địa chỉ liên hệ</label>
                    <input type="text"
                           id="address"
                           name="address"
                           value="${address}"
                           placeholder="Số nhà, đường, quận, thành phố...">
                </div>

                <div class="form-group">
                    <label style="font-weight: normal; cursor: pointer; display: flex; align-items: center; gap: 8px; font-size: 15px;">
                        <input type="checkbox"
                               name="isBookedForOther"
                        ${not empty param.isBookedForOther ? 'checked' : ''}
                               style="width: 18px; height: 18px; cursor: pointer;">
                        Tôi đang đặt tour hộ cho người khác
                    </label>
                </div>
            </div>

            <div class="form-card">
                <h3>2. Chi tiết số lượng</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="numberAdult">Số người lớn *</label>
                        <input type="number"
                               id="numberAdult"
                               name="numberAdult"
                               value="${not empty param.numberAdult ? param.numberAdult : 1}"
                               min="1">
                    </div>

                    <div class="form-group">
                        <label for="numberChildren">Số trẻ em</label>
                        <input type="number"
                               id="numberChildren"
                               name="numberChildren"
                               value="${not empty param.numberChildren ? param.numberChildren : 0}"
                               min="0">
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="note">Ghi chú thêm</label>
                    <textarea id="note"
                              name="note"
                              rows="3"
                              placeholder="Ví dụ: Ăn chay, yêu cầu xe lăn, ghép phòng...">${note}</textarea>
                </div>

                <div class="form-group">
                    <label for="totalPrice">Tổng tiền tạm tính (VNĐ)</label>
                    <input type="number"
                           id="totalPrice"
                           name="totalPrice"
                           value="${param.unitPrice}"
                           readonly
                           style="background-color: #f9fafb; font-weight: bold; color: #111827;">
                </div>
            </div>

            <div style="text-align: center;">
                <button type="submit" class="primary-btn checkout-btn">
                    Xác nhận Thanh toán & Đặt Tour
                </button>
            </div>
        </form>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>