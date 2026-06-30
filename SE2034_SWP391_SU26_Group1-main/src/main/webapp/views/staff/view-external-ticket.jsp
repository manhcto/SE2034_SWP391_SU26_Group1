<%--
  Created by IntelliJ IDEA.
  User: trung123
  Date: 6/25/2026
  Time: 4:32 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Trải nghiệm | WonderVN Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 25px; }
        .page-title { font-size: 24px; font-weight: 700; color: #1c2930; margin-bottom: 5px; }
        .page-subtitle { font-size: 14px; color: #687176; }

        .btn-back { background: white; border: 1px solid #cbd5e1; color: #1c2930; font-weight: 600; border-radius: 8px; padding: 8px 16px; }
        .btn-edit { background: #3b5998; color: white; font-weight: 600; border-radius: 8px; padding: 8px 16px; border: none; text-decoration: none;}
        .btn-edit:hover { background: #2d4373; color: white;}

        /* Bố cục thẻ thông tin chi tiết */
        .detail-card { background: white; border-radius: 12px; border: none; box-shadow: 0 2px 12px rgba(0,0,0,0.04); overflow: hidden; margin-bottom: 20px;}
        .img-container { height: 100%; min-height: 400px; padding: 20px;}
        .main-img { width: 100%; height: 100%; object-fit: cover; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }

        .info-container { padding: 30px; }
        .info-title { font-size: 28px; font-weight: 800; color: #1e293b; margin-bottom: 15px; }

        /* Cụm Badge */
        .badge-status { padding: 6px 12px; border-radius: 20px; font-weight: 600; font-size: 12px; display: inline-flex; align-items: center; gap: 4px; }
        .status-active { background: #dcfce7; color: #166534; }
        .status-inactive { background: #f1f5f9; color: #475569; }
        .type-pill { background: #f1f5f9; color: #334155; font-weight: 700; padding: 6px 12px; border-radius: 6px; font-size: 12px; border: 1px solid #e2e8f0; margin-right: 10px;}

        /* Bảng thông số (Dùng CSS Grid) */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 25px; margin-bottom: 25px; padding: 20px; background: #f8fafc; border-radius: 12px; border: 1px solid #e2e8f0; }
        .info-item { display: flex; flex-direction: column; gap: 5px; }
        .info-label { font-size: 13px; font-weight: 600; color: #64748b; text-transform: uppercase; }
        .info-value { font-size: 16px; font-weight: 600; color: #0f172a; display: flex; align-items: center; gap: 8px;}
        .info-value i { color: #0ea5e9; font-size: 18px; width: 20px;}

        .desc-box { line-height: 1.6; color: #475569; text-align: justify; }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp"/>

    <main class="admin-main">
        <jsp:include page="/views/common/admin-header.jsp"/>

        <div class="p-4">

            <div class="page-header">
                <div>
                    <h1 class="page-title">Chi tiết Dịch vụ #${ticket.serviceID}</h1>
                    <p class="page-subtitle">Xem thông tin chi tiết về điểm tham quan hoặc hoạt động này.</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/staff/external-ticket?action=list" class="btn btn-back">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/external-ticket?action=edit&id=${ticket.serviceID}" class="btn btn-edit">
                        <i class="fa-solid fa-pen-to-square"></i> Cập nhật
                    </a>
                </div>
            </div>

            <div class="detail-card">
                <div class="row g-0">
                    <div class="col-lg-5 img-container">
                        <img src="${ticket.image}" alt="Img" class="main-img">
                    </div>

                    <div class="col-lg-7 info-container">
                        <div class="d-flex align-items-center mb-3">
                            <span class="type-pill">
                                <c:choose>
                                    <c:when test="${ticket.type == 'Attraction'}"><i class="fa-solid fa-ferris-wheel text-primary"></i> Tham Quan</c:when>
                                    <c:when test="${ticket.type == 'Activity'}"><i class="fa-solid fa-person-swimming text-warning"></i> Hoạt Động</c:when>
                                </c:choose>
                            </span>
                            <c:if test="${ticket.status == 'Active'}"><span class="badge-status status-active"><i class="fa-solid fa-circle-check"></i> Đang hoạt động</span></c:if>
                            <c:if test="${ticket.status == 'Inactive'}"><span class="badge-status status-inactive"><i class="fa-solid fa-lock"></i> Đã khóa</span></c:if>
                        </div>

                        <h2 class="info-title">${ticket.name}</h2>
                        <div class="text-muted fw-bold mb-4"><i class="fa-solid fa-location-dot text-danger"></i> ${ticket.address}</div>

                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label">Giá vé</span>
                                <span class="info-value" style="color: #ef4444; font-size: 20px;"><i class="fa-solid fa-tags" style="color: #ef4444;"></i> <fmt:formatNumber value="${ticket.ticketPrice}" pattern="#,###" /> VNĐ</span>
                            </div>

                            <div class="info-item">
                                <span class="info-label">Hotline hỗ trợ</span>
                                <span class="info-value"><i class="fa-solid fa-phone"></i> ${ticket.phone}</span>
                            </div>

                            <div class="info-item">
                                <span class="info-label">Đánh giá chung</span>
                                <span class="info-value">
                                    <i class="fa-solid fa-star text-warning"></i>
                                    ${ticket.rate} / 5.0 <span style="font-size: 13px; color: #64748b; font-weight: 500;">(${ticket.reviewCount} lượt đánh giá)</span>
                                </span>
                            </div>

                            <div class="info-item">
                                <span class="info-label">Thời gian mở cửa</span>
                                <span class="info-value"><i class="fa-regular fa-clock"></i> ${ticket.timeOpen} - ${ticket.timeClose}</span>
                            </div>

                            <div class="info-item" style="grid-column: span 2;">
                                <span class="info-label">Ngày hoạt động</span>
                                <span class="info-value"><i class="fa-regular fa-calendar-days"></i> ${ticket.dayOfWeekOpen}</span>
                            </div>
                        </div>

                        <div class="mt-4">
                            <h5 class="fw-bold text-dark mb-3">Mô tả trải nghiệm</h5>
                            <div class="desc-box">
                                ${ticket.description}
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
