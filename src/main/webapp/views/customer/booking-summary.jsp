<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Tóm tắt booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .summary-container {
            max-width: 950px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .summary-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 28px;
            margin-bottom: 24px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
        }

        .summary-card h3 {
            margin-top: 0;
            margin-bottom: 18px;
            color: #111827;
            font-size: 20px;
            border-bottom: 1px solid #f3f4f6;
            padding-bottom: 12px;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px 28px;
        }

        .summary-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .summary-label {
            color: #6b7280;
            font-size: 14px;
        }

        .summary-value {
            color: #111827;
            font-size: 16px;
            font-weight: 600;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 6px 12px;
            border-radius: 999px;
            background: #fef3c7;
            color: #92400e;
            font-weight: 700;
            font-size: 14px;
        }

        .total-price {
            color: #dc2626;
            font-size: 24px;
            font-weight: 800;
        }

        .identity-preview {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .identity-preview img {
            width: 160px;
            height: 96px;
            border-radius: 10px;
            object-fit: cover;
            border: 1px solid #d1d5db;
            background: #f3f4f6;
        }

        .identity-preview a {
            color: #2563eb;
            font-weight: 800;
            text-decoration: none;
        }

        .error-box {
            background-color: #fee2e2;
            color: #b91c1c;
            padding: 16px 20px;
            border-radius: 8px;
            border: 1px solid #f87171;
            margin-bottom: 24px;
        }

        .summary-actions {
            display: flex;
            gap: 14px;
            justify-content: center;
            align-items: center;
            margin-top: 28px;
            flex-wrap: wrap;
        }

        .summary-btn {
            min-width: 170px;
            height: 48px;
            padding: 0 22px;
            border-radius: 999px;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            line-height: 1;
            cursor: pointer;
            transition: 0.2s;
            box-sizing: border-box;
        }

        .summary-btn-primary {
            background: #2563eb;
            color: #ffffff;
            border: 1px solid #2563eb;
        }

        .summary-btn-primary:hover {
            background: #1d4ed8;
            border-color: #1d4ed8;
        }

        .summary-btn-outline {
            background: #ffffff;
            color: #2563eb;
            border: 1px solid #2563eb;
        }

        .summary-btn-outline:hover {
            background: #eff6ff;
        }

        @media (max-width: 768px) {
            .summary-grid {
                grid-template-columns: 1fr;
            }

            .summary-actions {
                flex-direction: column;
            }

            .summary-btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main>
    <section class="summary-container">
        <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 36px;">
            <div>
                <p class="section-kicker">Booking Summary</p>
                <h2>Tóm tắt đơn booking</h2>
                <p>Thông tin dưới đây được lấy từ dữ liệu đơn hàng đã lưu trong hệ thống.</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="error-box">
                    ${error}
            </div>
        </c:if>

        <c:if test="${not empty bookingSummary}">
            <div class="summary-card">
                <h3>1. Thông tin đơn đặt tour</h3>

                <div class="summary-grid">
                    <div class="summary-item">
                        <span class="summary-label">Mã booking</span>
                        <span class="summary-value">${bookingSummary.bookingCode}</span>
                    </div>

                    <div class="summary-item">
                        <span class="summary-label">Trạng thái</span>
                        <span class="summary-value">
                            <span class="status-badge">
                                <c:choose>
                                    <c:when test="${bookingSummary.status == 'Đang xử lý' || bookingSummary.status == 'Pending'}">Đang xử lý</c:when>
                                    <%-- Trạng thái "Đã duyệt" đã bỏ: đơn cũ hiển thị là Hoàn thành --%>
                                    <c:when test="${bookingSummary.status == 'Đã duyệt' || bookingSummary.status == 'Confirmed'}">Hoàn thành</c:when>
                                    <c:when test="${bookingSummary.status == 'Đã hủy' || bookingSummary.status == 'Cancelled'}">Đã hủy</c:when>
                                    <c:when test="${bookingSummary.status == 'Hoàn thành' || bookingSummary.status == 'Completed'}">Hoàn thành</c:when>
                                    <c:otherwise>${bookingSummary.status}</c:otherwise>
                                </c:choose>
                            </span>
                        </span>
                    </div>

                    <div class="summary-item">
                        <span class="summary-label">Ngày đặt</span>
                        <span class="summary-value">
                            <fmt:formatDate value="${bookingSummary.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </div>

                    <div class="summary-item">
                        <span class="summary-label">Loại booking</span>
                        <span class="summary-value">${bookingSummary.bookingType}</span>
                    </div>
                </div>
            </div>

            <div class="summary-card">
                <h3>2. Thông tin khách hàng</h3>

                <div class="summary-grid">
                    <div class="summary-item">
                        <span class="summary-label">Họ tên</span>
                        <span class="summary-value">${bookingSummary.firstName} ${bookingSummary.lastName}</span>
                    </div>

                    <div class="summary-item">
                        <span class="summary-label">Email</span>
                        <span class="summary-value">${bookingSummary.email}</span>
                    </div>

                    <div class="summary-item">
                        <span class="summary-label">Số điện thoại</span>
                        <span class="summary-value">${bookingSummary.phone}</span>
                    </div>

                    <div class="summary-item">
                        <span class="summary-label">CCCD / CMND</span>
                        <span class="summary-value">
                            <c:choose>
                                <c:when test="${not empty bookingSummary.identityNumber}">
                                    ${bookingSummary.identityNumber}
                                </c:when>
                                <c:otherwise>Không có</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="summary-item">
                        <span class="summary-label">Địa chỉ</span>
                        <span class="summary-value">
                            <c:choose>
                                <c:when test="${not empty bookingSummary.address}">
                                    ${bookingSummary.address}
                                </c:when>
                                <c:otherwise>Không có</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="summary-item">
                        <span class="summary-label">Ảnh CCCD / CMND</span>
                        <c:choose>
                            <c:when test="${not empty bookingSummary.identityImageUrl}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(bookingSummary.identityImageUrl, 'http')}">
                                        <c:set var="identityImageSrc" value="${bookingSummary.identityImageUrl}"/>
                                    </c:when>
                                    <c:when test="${fn:startsWith(bookingSummary.identityImageUrl, '/')}">
                                        <c:set var="identityImageSrc" value="${pageContext.request.contextPath}${bookingSummary.identityImageUrl}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="identityImageSrc" value="${pageContext.request.contextPath}/${bookingSummary.identityImageUrl}"/>
                                    </c:otherwise>
                                </c:choose>

                                <div class="identity-preview">
                                    <a href="${identityImageSrc}" target="_blank" rel="noopener">
                                        <img src="${identityImageSrc}" alt="Ảnh CCCD">
                                    </a>
                                    <a href="${identityImageSrc}" target="_blank" rel="noopener">Mở ảnh</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <span class="summary-value">Không có</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="summary-card">
                <c:choose>
                    <c:when test="${bookingSummary.bookingType == 'Accommodation'}">
                        <h3>3. Thông tin lưu trú</h3>

                        <div class="summary-grid">
                            <div class="summary-item">
                                <span class="summary-label">Cơ sở lưu trú</span>
                                <span class="summary-value">${bookingSummary.itemName}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Loại phòng</span>
                                <span class="summary-value">${bookingSummary.roomType}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Accommodation ID</span>
                                <span class="summary-value">${bookingSummary.accommodationID}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Room ID</span>
                                <span class="summary-value">${bookingSummary.roomID}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Ngày nhận phòng</span>
                                <span class="summary-value">
                                    <fmt:formatDate value="${bookingSummary.startDate}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Ngày trả phòng</span>
                                <span class="summary-value">
                                    <fmt:formatDate value="${bookingSummary.endDate}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <h3>3. Thông tin tour</h3>

                        <div class="summary-grid">
                            <div class="summary-item">
                                <span class="summary-label">Tên tour</span>
                                <span class="summary-value">${bookingSummary.tourName}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Tour Schedule ID</span>
                                <span class="summary-value">${bookingSummary.tourScheduleID}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Điểm khởi hành</span>
                                <span class="summary-value">${bookingSummary.startPlace}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Điểm đến</span>
                                <span class="summary-value">${bookingSummary.endPlace}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Ngày bắt đầu</span>
                                <span class="summary-value">
                                    <fmt:formatDate value="${bookingSummary.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Ngày kết thúc</span>
                                <span class="summary-value">
                                    <fmt:formatDate value="${bookingSummary.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="summary-card">
                <h3>4. Chi tiết thanh toán</h3>

                <div class="summary-grid">
                    <c:choose>
                        <c:when test="${bookingSummary.bookingType == 'Accommodation'}">
                            <div class="summary-item">
                                <span class="summary-label">Số phòng</span>
                                <span class="summary-value">${bookingSummary.quantity}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Đơn giá/phòng/đêm</span>
                                <span class="summary-value">
                                    <fmt:formatNumber value="${bookingSummary.unitPrice}" type="number" maxFractionDigits="0"/> VNĐ
                                </span>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="summary-item">
                                <span class="summary-label">Số người lớn</span>
                                <span class="summary-value">${bookingSummary.numberAdult}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Số trẻ em</span>
                                <span class="summary-value">${bookingSummary.numberChildren}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Tổng số khách</span>
                                <span class="summary-value">${bookingSummary.quantity}</span>
                            </div>

                            <div class="summary-item">
                                <span class="summary-label">Đơn giá trung bình</span>
                                <span class="summary-value">
                                    <fmt:formatNumber value="${bookingSummary.unitPrice}" type="number" maxFractionDigits="0"/> VNĐ
                                </span>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="summary-item">
                        <span class="summary-label">Tạm tính</span>
                        <span class="summary-value">
                            <fmt:formatNumber value="${bookingSummary.subTotal}" type="number" maxFractionDigits="0"/> VNĐ
                        </span>
                    </div>

                    <div class="summary-item">
                        <span class="summary-label">Tổng tiền</span>
                        <span class="summary-value total-price">
                            <fmt:formatNumber value="${bookingSummary.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                        </span>
                    </div>
                </div>
            </div>

            <div class="summary-card">
                <h3>5. Ghi chú</h3>

                <p>
                    <c:choose>
                        <c:when test="${not empty bookingSummary.note}">
                            ${bookingSummary.note}
                        </c:when>
                        <c:otherwise>Không có ghi chú.</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <div class="summary-actions">
                <a href="${pageContext.request.contextPath}/payment?bookingID=${bookingSummary.bookingID}"
                   class="summary-btn summary-btn-primary">
                    Tiếp tục thanh toán
                </a>

                <a href="${pageContext.request.contextPath}/views/home.jsp"
                   class="summary-btn summary-btn-outline">
                    Về trang chủ
                </a>

                <a href="${pageContext.request.contextPath}/booking-list"
                   class="summary-btn summary-btn-outline">
                    Xem danh sách booking
                </a>
            </div>
        </c:if>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>
