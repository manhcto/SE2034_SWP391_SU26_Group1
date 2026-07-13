<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Chi tiết booking</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --dark: #0f172a;
            --text: #1e293b;
            --muted: #64748b;
            --bg: #f3f6fb;
            --border: #e2e8f0;
            --soft: #f8fafc;
            --shadow: 0 16px 36px rgba(15, 23, 42, 0.08);
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--text);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        .admin-main {
            flex: 1;
            min-width: 0;
            padding: 28px;
        }

        .staff-page-topbar {
            background: white;
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 22px 24px;
            box-shadow: var(--shadow);
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .staff-page-topbar h1 {
            margin: 0;
            color: var(--dark);
            font-size: 28px;
            font-weight: 900;
        }

        .staff-page-topbar p {
            margin: 6px 0 0;
            color: var(--muted);
            font-weight: 600;
        }

        .btn-main {
            border: none;
            border-radius: 14px;
            background: var(--primary);
            color: white;
            padding: 12px 18px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .detail-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 24px;
            box-shadow: var(--shadow);
            padding: 24px;
            margin-bottom: 22px;
        }

        .detail-card h3 {
            margin: 0 0 18px;
            color: var(--dark);
            font-size: 20px;
            font-weight: 900;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        .detail-item {
            background: var(--soft);
            border: 1px solid #eef2f7;
            border-radius: 16px;
            padding: 14px;
        }

        .detail-label {
            display: block;
            color: var(--muted);
            font-size: 13px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .detail-value {
            color: var(--dark);
            font-weight: 900;
            overflow-wrap: anywhere;
        }

        .status-pill {
            display: inline-flex;
            border-radius: 999px;
            padding: 7px 12px;
            font-size: 13px;
            font-weight: 900;
        }

        .status-pending { background: #fef3c7; color: #92400e; }
        .status-confirmed { background: #dbeafe; color: #1d4ed8; }
        .status-completed { background: #dcfce7; color: #166534; }
        .status-cancelled { background: #fee2e2; color: #991b1b; }

        .identity-wrap {
            display: grid;
            grid-template-columns: 1fr 260px;
            gap: 18px;
            align-items: start;
        }

        .identity-image-box {
            border: 1px solid var(--border);
            border-radius: 16px;
            background: var(--soft);
            padding: 10px;
            max-width: 260px;
        }

        .identity-image {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 12px;
            display: block;
        }

        .empty-note {
            color: var(--muted);
            font-weight: 700;
        }

        @media (max-width: 992px) {
            .admin-layout {
                display: block;
            }

            .admin-main {
                padding: 18px;
            }

            .detail-grid,
            .identity-wrap {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp"/>

    <main class="admin-main">
        <div class="staff-page-topbar">
            <div>
                <h1>Chi tiết booking</h1>
                <p>Xem thông tin booking, khách hàng và giấy tờ lưu trú.</p>
            </div>
            <a class="btn-main" href="${pageContext.request.contextPath}/staff/booking">
                <i class="fa-solid fa-arrow-left"></i>
                Quay lại
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger fw-bold">${error}</div>
        </c:if>

        <c:if test="${not empty bookingDetail}">
            <div class="detail-card">
                <h3><i class="fa-solid fa-receipt"></i> 1. Thông tin booking</h3>
                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">Mã booking</span>
                        <span class="detail-value">${bookingDetail.bookingCode}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Loại booking</span>
                        <span class="detail-value">${bookingDetail.bookingType}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Trạng thái</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${bookingDetail.status == 'Đang xử lý' || bookingDetail.status == 'Pending'}">
                                    <span class="status-pill status-pending">Đang xử lý</span>
                                </c:when>
                                <c:when test="${bookingDetail.status == 'Đã duyệt' || bookingDetail.status == 'Confirmed'}">
                                    <span class="status-pill status-confirmed">Đã duyệt</span>
                                </c:when>
                                <c:when test="${bookingDetail.status == 'Hoàn thành' || bookingDetail.status == 'Completed'}">
                                    <span class="status-pill status-completed">Hoàn thành</span>
                                </c:when>
                                <c:when test="${bookingDetail.status == 'Đã hủy' || bookingDetail.status == 'Cancelled'}">
                                    <span class="status-pill status-cancelled">Đã hủy</span>
                                </c:when>
                                <c:otherwise>${bookingDetail.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Ngày đặt</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${bookingDetail.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Tổng tiền</span>
                        <span class="detail-value text-danger">
                            <fmt:formatNumber value="${bookingDetail.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Dịch vụ</span>
                        <span class="detail-value">${bookingDetail.itemName}</span>
                    </div>
                </div>
            </div>

            <div class="detail-card">
                <h3><i class="fa-solid fa-user"></i> 2. Thông tin khách hàng</h3>
                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">Họ tên</span>
                        <span class="detail-value">${bookingDetail.firstName} ${bookingDetail.lastName}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Email</span>
                        <span class="detail-value">${bookingDetail.email}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Số điện thoại</span>
                        <span class="detail-value">${bookingDetail.phone}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Địa chỉ</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${not empty bookingDetail.address}">${bookingDetail.address}</c:when>
                                <c:otherwise>Chưa cập nhật</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Người lớn</span>
                        <span class="detail-value">${bookingDetail.numberAdult}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Trẻ em</span>
                        <span class="detail-value">${bookingDetail.numberChildren}</span>
                    </div>
                </div>
            </div>

            <div class="detail-card">
                <h3><i class="fa-solid fa-circle-info"></i> 3. Chi tiết dịch vụ</h3>
                <div class="detail-grid">
                    <c:choose>
                        <c:when test="${bookingDetail.bookingType == 'Accommodation'}">
                            <div class="detail-item">
                                <span class="detail-label">Nơi lưu trú</span>
                                <span class="detail-value">${bookingDetail.accommodationName}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Loại phòng</span>
                                <span class="detail-value">${bookingDetail.roomType}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Số phòng</span>
                                <span class="detail-value">${bookingDetail.quantity}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Ngày nhận phòng</span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${bookingDetail.startDate}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Ngày trả phòng</span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${bookingDetail.endDate}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="detail-item">
                                <span class="detail-label">Tên tour</span>
                                <span class="detail-value">${bookingDetail.tourName}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Điểm khởi hành</span>
                                <span class="detail-value">${bookingDetail.startPlace}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Điểm đến</span>
                                <span class="detail-value">${bookingDetail.endPlace}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Ngày bắt đầu</span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${bookingDetail.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Ngày kết thúc</span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${bookingDetail.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <c:if test="${bookingDetail.bookingType == 'Accommodation'}">
                <div class="detail-card">
                    <h3><i class="fa-solid fa-id-card"></i> 4. Căn cước công dân</h3>
                    <div class="identity-wrap">
                        <div class="detail-grid">
                            <div class="detail-item">
                                <span class="detail-label">Số CCCD / CMND</span>
                                <span class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty bookingDetail.identityNumber}">
                                            ${bookingDetail.identityNumber}
                                        </c:when>
                                        <c:otherwise>Chưa có</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty bookingDetail.identityImageUrl}">
                                <a class="identity-image-box" href="${pageContext.request.contextPath}/${bookingDetail.identityImageUrl}" target="_blank">
                                    <img class="identity-image"
                                         src="${pageContext.request.contextPath}/${bookingDetail.identityImageUrl}"
                                         alt="Ảnh CCCD / CMND">
                                </a>
                            </c:when>
                            <c:otherwise>
                                <div class="identity-image-box empty-note">Chưa có ảnh CCCD / CMND.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <div class="detail-card">
                <h3><i class="fa-solid fa-note-sticky"></i> Ghi chú</h3>
                <div class="detail-value">
                    <c:choose>
                        <c:when test="${not empty bookingDetail.note}">${bookingDetail.note}</c:when>
                        <c:otherwise>Không có ghi chú.</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </main>
</div>
</body>
</html>
