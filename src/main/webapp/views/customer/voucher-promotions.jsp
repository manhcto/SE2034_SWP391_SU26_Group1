<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Khuyến mãi | WonderVN</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f5f7fb;
            color: #0f172a;
        }

        .promotion-page {
            width: min(1180px, calc(100% - 32px));
            margin: 0 auto;
            padding: 32px 0 56px;
        }

        .promotion-hero {
            border: 1px solid #dbeafe;
            border-radius: 20px;
            padding: 34px;
            background: linear-gradient(135deg, #eff6ff 0%, #ffffff 58%, #ecfeff 100%);
            box-shadow: 0 18px 44px rgba(15, 23, 42, 0.08);
        }

        .hero-badge {
            width: fit-content;
            margin-bottom: 14px;
            padding: 8px 13px;
            border-radius: 999px;
            background: #ffffff;
            color: #1d4ed8;
            font-size: 13px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 10px 24px rgba(37, 99, 235, 0.12);
        }

        .promotion-hero h1 {
            margin: 0;
            color: #0f172a;
            font-size: clamp(32px, 4vw, 52px);
            font-weight: 900;
            line-height: 1.05;
        }

        .promotion-hero p {
            max-width: 620px;
            margin: 14px 0 0;
            color: #475569;
            font-size: 16px;
            font-weight: 600;
            line-height: 1.7;
        }

        .category-bar {
            margin: 22px 0 24px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .category-chip {
            min-height: 42px;
            padding: 0 18px;
            border: 1px solid #dbe3ef;
            border-radius: 999px;
            background: #ffffff;
            color: #334155;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 900;
            text-decoration: none;
            transition: 0.18s ease;
        }

        .category-chip:hover,
        .category-chip.active {
            border-color: #2563eb;
            background: #2563eb;
            color: #ffffff;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.22);
        }

        .save-alert {
            margin: 0 0 22px;
            padding: 14px 16px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 800;
        }

        .save-alert.success {
            border: 1px solid #bbf7d0;
            background: #f0fdf4;
            color: #166534;
        }

        .save-alert.info {
            border: 1px solid #bfdbfe;
            background: #eff6ff;
            color: #1d4ed8;
        }

        .save-alert.warning {
            border: 1px solid #fde68a;
            background: #fffbeb;
            color: #92400e;
        }

        .save-alert.error {
            border: 1px solid #fecaca;
            background: #fef2f2;
            color: #991b1b;
        }

        .voucher-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
        }

        .voucher-card {
            min-height: 100%;
            border: 1px solid #e5eaf3;
            border-radius: 18px;
            background: #ffffff;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.06);
        }

        .voucher-card-head {
            padding: 20px;
            background: #f8fafc;
            border-bottom: 1px solid #edf2f7;
        }

        .discount-text {
            margin: 0 0 14px;
            color: #1d4ed8;
            font-size: 28px;
            font-weight: 900;
            line-height: 1.15;
        }

        .voucher-code {
            width: fit-content;
            max-width: 100%;
            padding: 9px 12px;
            border: 1px dashed #93c5fd;
            border-radius: 12px;
            background: #eff6ff;
            color: #1e40af;
            font-size: 15px;
            font-weight: 900;
            letter-spacing: 0.8px;
            word-break: break-word;
        }

        .voucher-card-body {
            padding: 18px 20px 20px;
            display: flex;
            flex: 1;
            flex-direction: column;
            gap: 14px;
        }

        .voucher-desc {
            min-height: 44px;
            margin: 0;
            color: #475569;
            font-size: 14px;
            font-weight: 600;
            line-height: 1.6;
        }

        .voucher-meta {
            display: grid;
            gap: 10px;
        }

        .voucher-row {
            display: flex;
            justify-content: space-between;
            gap: 14px;
            color: #64748b;
            font-size: 13px;
            font-weight: 800;
        }

        .voucher-row strong {
            color: #0f172a;
            text-align: right;
        }

        .available-note {
            width: fit-content;
            padding: 7px 10px;
            border-radius: 999px;
            background: #dcfce7;
            color: #166534;
            font-size: 12px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            gap: 7px;
        }

        .available-note.upcoming {
            background: #fef3c7;
            color: #92400e;
        }

        .voucher-start-note {
            margin-top: -6px;
            color: #92400e;
            font-size: 12px;
            font-weight: 900;
            line-height: 1.5;
        }

        .condition-box {
            margin-top: auto;
            border-top: 1px solid #edf2f7;
            padding-top: 14px;
        }

        .condition-box summary {
            cursor: pointer;
            color: #1d4ed8;
            font-size: 13px;
            font-weight: 900;
            list-style: none;
        }

        .condition-box summary::-webkit-details-marker {
            display: none;
        }

        .condition-box summary i {
            margin-right: 6px;
        }

        .condition-list {
            margin: 12px 0 0;
            padding-left: 18px;
            color: #475569;
            font-size: 13px;
            font-weight: 600;
            line-height: 1.7;
        }

        .voucher-actions {
            margin-top: 14px;
        }

        .save-voucher-form {
            margin: 0;
        }

        .save-voucher-btn,
        .saved-voucher-btn {
            width: 100%;
            min-height: 44px;
            border: 0;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 900;
        }

        .save-voucher-btn {
            background: #2563eb;
            color: #ffffff;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.22);
        }

        .save-voucher-btn:hover {
            background: #1d4ed8;
        }

        .saved-voucher-btn {
            background: #e2e8f0;
            color: #475569;
            cursor: not-allowed;
        }

        .empty-state {
            border: 1px dashed #cbd5e1;
            border-radius: 18px;
            padding: 58px 24px;
            background: #ffffff;
            text-align: center;
            color: #64748b;
        }

        .empty-state i {
            margin-bottom: 14px;
            color: #94a3b8;
            font-size: 38px;
        }

        .empty-state h2 {
            margin: 0;
            color: #0f172a;
            font-size: 22px;
            font-weight: 900;
        }

        @media (max-width: 980px) {
            .voucher-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 640px) {
            .promotion-page {
                width: min(100% - 24px, 1180px);
                padding-top: 22px;
            }

            .promotion-hero {
                padding: 24px;
            }

            .voucher-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<jsp:include page="/views/common/client-header.jsp"/>

<main class="promotion-page">
    <section class="promotion-hero">
        <div class="hero-badge">
            <i class="fa-solid fa-ticket"></i>
            Ưu đãi WonderVN
        </div>
        <h1>Khuyến mãi</h1>
        <p>Khám phá ưu đãi hấp dẫn cho hành trình của bạn.</p>
    </section>

    <nav class="category-bar" aria-label="Lọc khuyến mãi">
        <a class="category-chip ${selectedType == 'All' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/vouchers?type=All">
            Tất cả
        </a>
        <a class="category-chip ${selectedType == 'Tour' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/vouchers?type=Tour">
            Tour
        </a>
        <a class="category-chip ${selectedType == 'Accommodation' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/vouchers?type=Accommodation">
            Lưu trú
        </a>
    </nav>

    <c:choose>
        <c:when test="${param.save == 'success'}">
            <div class="save-alert success">
                <i class="fa-solid fa-circle-check"></i>
                Lưu Voucher thành công.
            </div>
        </c:when>
        <c:when test="${param.save == 'exists'}">
            <div class="save-alert info">
                <i class="fa-solid fa-circle-info"></i>
                Voucher này đã được lưu trước đó.
            </div>
        </c:when>
        <c:when test="${param.save == 'unavailable'}">
            <div class="save-alert warning">
                <i class="fa-solid fa-triangle-exclamation"></i>
                Voucher hiện không còn khả dụng.
            </div>
        </c:when>
        <c:when test="${param.save == 'forbidden'}">
            <div class="save-alert error">
                <i class="fa-solid fa-circle-exclamation"></i>
                Chỉ khách hàng mới có thể lưu Voucher.
            </div>
        </c:when>
        <c:when test="${param.save == 'error'}">
            <div class="save-alert error">
                <i class="fa-solid fa-circle-exclamation"></i>
                Không thể lưu Voucher. Vui lòng thử lại.
            </div>
        </c:when>
    </c:choose>

    <c:choose>
        <c:when test="${empty voucherList}">
            <section class="empty-state">
                <i class="fa-regular fa-folder-open"></i>
                <h2>Hiện chưa có Voucher phù hợp.</h2>
            </section>
        </c:when>

        <c:otherwise>
            <section class="voucher-grid" aria-label="Danh sách khuyến mãi">
                <c:forEach items="${voucherList}" var="voucher">
                    <c:set var="applicableType" value="${empty voucher.applicableType ? 'All' : voucher.applicableType}"/>
                    <c:set var="applicableLabel" value="Toàn hệ thống"/>
                    <c:if test="${applicableType == 'Tour'}">
                        <c:set var="applicableLabel" value="Tour"/>
                    </c:if>
                    <c:if test="${applicableType == 'Accommodation'}">
                        <c:set var="applicableLabel" value="Lưu trú"/>
                    </c:if>
                    <c:set var="isSavedVoucher" value="${savedVoucherIds.contains(voucher.voucherID)}"/>
                    <c:set var="isUpcomingVoucher" value="${upcomingVoucherIds.contains(voucher.voucherID)}"/>

                    <article class="voucher-card">
                        <div class="voucher-card-head">
                            <h2 class="discount-text">
                                <c:choose>
                                    <c:when test="${voucher.percentDiscount != null && voucher.percentDiscount > 0}">
                                        Giảm <fmt:formatNumber value="${voucher.percentDiscount}" maxFractionDigits="2"/>%
                                    </c:when>
                                    <c:when test="${voucher.amountDiscount != null && voucher.amountDiscount > 0}">
                                        Giảm <fmt:formatNumber value="${voucher.amountDiscount}" type="number" maxFractionDigits="0"/> VNĐ
                                    </c:when>
                                    <c:otherwise>Ưu đãi đặc biệt</c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="voucher-code">
                                <c:out value="${voucher.code}"/>
                            </div>
                        </div>

                        <div class="voucher-card-body">
                            <p class="voucher-desc">
                                <c:choose>
                                    <c:when test="${not empty voucher.description}">
                                        <c:out value="${voucher.description}"/>
                                    </c:when>
                                    <c:otherwise>Ưu đãi từ WonderVN cho chuyến đi sắp tới của bạn.</c:otherwise>
                                </c:choose>
                            </p>

                            <c:choose>
                                <c:when test="${isUpcomingVoucher}">
                                    <div class="available-note upcoming">
                                        <i class="fa-solid fa-clock"></i>
                                        Sắp có hiệu lực
                                    </div>
                                    <div class="voucher-start-note">
                                        Có thể sử dụng từ <fmt:formatDate value="${voucher.startDate}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="available-note">
                                        <i class="fa-solid fa-circle-check"></i>
                                        Có thể sử dụng
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="voucher-meta">
                                <div class="voucher-row">
                                    <span>Phạm vi áp dụng</span>
                                    <strong><c:out value="${applicableLabel}"/></strong>
                                </div>

                                <div class="voucher-row">
                                    <span>Đơn tối thiểu</span>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${voucher.minOrderAmount != null && voucher.minOrderAmount > 0}">
                                                <fmt:formatNumber value="${voucher.minOrderAmount}" type="number" maxFractionDigits="0"/> VNĐ
                                            </c:when>
                                            <c:otherwise>Không yêu cầu</c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>

                                <div class="voucher-row">
                                    <span>Ngày hết hạn</span>
                                    <strong>
                                        <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy"/>
                                    </strong>
                                </div>
                            </div>

                            <details class="condition-box">
                                <summary>
                                    <i class="fa-solid fa-circle-info"></i>Xem điều kiện
                                </summary>
                                <ul class="condition-list">
                                    <li>Áp dụng cho phạm vi <c:out value="${applicableLabel}"/>.</li>
                                    <li>Mỗi mã được áp dụng theo điều kiện của WonderVN tại thời điểm đặt dịch vụ.</li>
                                    <li>Voucher còn hiệu lực đến ngày <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy"/>.</li>
                                </ul>
                            </details>

                            <div class="voucher-actions">
                                <c:choose>
                                    <c:when test="${isSavedVoucher}">
                                        <button class="saved-voucher-btn" type="button" disabled>
                                            <i class="fa-solid fa-check"></i>
                                            Đã lưu
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <form class="save-voucher-form"
                                              action="${pageContext.request.contextPath}/vouchers/save"
                                              method="post">
                                            <input type="hidden" name="voucherID" value="${voucher.voucherID}">
                                            <input type="hidden" name="type" value="${selectedType}">
                                            <button class="save-voucher-btn" type="submit">
                                                <i class="fa-solid fa-bookmark"></i>
                                                Lưu Voucher
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/views/common/client-footer.jsp"/>
</body>
</html>
