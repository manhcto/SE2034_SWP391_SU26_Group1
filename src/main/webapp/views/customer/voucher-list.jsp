<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Voucher của tôi | WonderVN</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f5f7fb;
            color: #0f172a;
        }

        .voucher-tabs {
            padding: 0 24px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .voucher-tab {
            min-height: 42px;
            padding: 0 16px;
            border: 1px solid #dbe3ef;
            border-radius: 999px;
            background: #ffffff;
            color: #334155;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            font-weight: 900;
            text-decoration: none;
            transition: 0.18s ease;
        }

        .voucher-tab:hover,
        .voucher-tab.active {
            border-color: #2563eb;
            background: #2563eb;
            color: #ffffff;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.2);
        }

        .voucher-tab-count {
            min-width: 24px;
            height: 24px;
            padding: 0 7px;
            border-radius: 999px;
            background: rgba(15, 23, 42, 0.08);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        .voucher-tab.active .voucher-tab-count {
            background: rgba(255, 255, 255, 0.22);
        }

        .voucher-body {
            padding: 24px;
        }

        .voucher-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .voucher-card {
            border: 1px solid #e5eaf3;
            border-radius: 16px;
            background: #ffffff;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .voucher-top {
            padding: 18px;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 14px;
            background: #f8fafc;
            border-bottom: 1px solid #edf2f7;
        }

        .discount-title {
            margin: 0 0 10px;
            color: #1d4ed8;
            font-size: 24px;
            font-weight: 900;
            line-height: 1.2;
        }

        .voucher-code-box {
            width: fit-content;
            max-width: 100%;
            padding: 8px 11px;
            border: 1px dashed #93c5fd;
            border-radius: 11px;
            background: #eff6ff;
            color: #1e40af;
            font-size: 14px;
            font-weight: 900;
            letter-spacing: 0.7px;
            word-break: break-word;
        }

        .voucher-code-value {
            text-transform: uppercase;
        }

        .voucher-desc {
            margin: 10px 0 0;
            color: #64748b;
            font-size: 13px;
            font-weight: 600;
            line-height: 1.5;
        }

        .status-badge {
            flex: 0 0 auto;
            padding: 7px 10px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .status-badge.available {
            background: #dcfce7;
            color: #166534;
        }

        .status-badge.used {
            background: #e0e7ff;
            color: #3730a3;
        }

        .status-badge.unavailable {
            background: #fee2e2;
            color: #991b1b;
        }

        .voucher-meta {
            padding: 16px 18px 18px;
            display: grid;
            gap: 12px;
        }

        .voucher-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            color: #64748b;
            font-size: 12px;
            font-weight: 800;
        }

        .voucher-row strong {
            color: #0f172a;
            text-align: right;
        }

        .reason-note {
            padding: 10px 12px;
            border-radius: 12px;
            background: #fff7ed;
            color: #9a3412;
            font-size: 12px;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .copy-code-btn {
            min-height: 38px;
            border: 1px solid #bfdbfe;
            border-radius: 12px;
            background: #eff6ff;
            color: #1d4ed8;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 12px;
            font-weight: 900;
        }

        .copy-code-btn:hover {
            background: #dbeafe;
        }

        .empty-box {
            padding: 54px 24px;
            text-align: center;
        }

        .empty-box i {
            color: #94a3b8;
            font-size: 34px;
            margin-bottom: 14px;
        }

        .empty-box h3 {
            margin: 0;
            color: #0f172a;
            font-size: 20px;
            font-weight: 900;
        }

        .empty-box p {
            margin: 8px 0 0;
            color: #64748b;
            font-size: 14px;
            font-weight: 600;
        }

        @media (max-width: 760px) {
            .voucher-tabs {
                padding: 0 18px;
            }

            .voucher-body {
                padding: 18px;
            }

            .voucher-grid {
                grid-template-columns: 1fr;
            }

            .voucher-top {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>
<jsp:include page="/views/common/client-header.jsp"/>

<main class="account-page">
    <div class="account-shell">
        <jsp:include page="/views/common/account-sidebar.jsp"/>

        <section class="account-content">
            <article class="account-panel">
                <div class="account-panel-head">
                    <p class="account-kicker">Tài khoản</p>
                    <h1 class="account-title">Voucher của tôi</h1>
                    <p class="account-subtitle">Các Voucher bạn đã lưu trên WonderVN.</p>
                </div>

                <nav class="voucher-tabs" aria-label="Trạng thái Voucher">
                    <a class="voucher-tab ${currentStatus == 'available' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/my-vouchers?status=available">
                        Có thể sử dụng
                        <span class="voucher-tab-count">${availableCount}</span>
                    </a>
                    <a class="voucher-tab ${currentStatus == 'used' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/my-vouchers?status=used">
                        Đã dùng
                        <span class="voucher-tab-count">${usedCount}</span>
                    </a>
                    <a class="voucher-tab ${currentStatus == 'unavailable' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/my-vouchers?status=unavailable">
                        Không còn hiệu lực
                        <span class="voucher-tab-count">${unavailableCount}</span>
                    </a>
                </nav>

                <c:choose>
                    <c:when test="${empty voucherList}">
                        <div class="empty-box">
                            <i class="fa-solid fa-ticket"></i>
                            <h3>
                                <c:choose>
                                    <c:when test="${currentStatus == 'used'}">Bạn chưa sử dụng Voucher nào.</c:when>
                                    <c:when test="${currentStatus == 'unavailable'}">Bạn chưa có Voucher nào không còn hiệu lực.</c:when>
                                    <c:otherwise>Bạn chưa có Voucher nào có thể sử dụng.</c:otherwise>
                                </c:choose>
                            </h3>
                            <p>Các Voucher đã lưu sẽ được phân loại tự động tại đây.</p>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="voucher-body">
                            <div class="voucher-grid">
                                <c:forEach items="${voucherList}" var="voucher">
                                    <c:set var="applicableType" value="${empty voucher.applicableType ? 'All' : voucher.applicableType}"/>
                                    <c:set var="displayStatus" value="${empty voucher.displayStatus ? 'unavailable' : voucher.displayStatus}"/>

                                    <c:set var="applicableLabel" value="Toàn hệ thống"/>
                                    <c:if test="${applicableType == 'Tour'}">
                                        <c:set var="applicableLabel" value="Tour"/>
                                    </c:if>
                                    <c:if test="${applicableType == 'Accommodation'}">
                                        <c:set var="applicableLabel" value="Lưu trú"/>
                                    </c:if>

                                    <article class="voucher-card">
                                        <div class="voucher-top">
                                            <div>
                                                <h2 class="discount-title">
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

                                                <div class="voucher-code-box">
                                                    <span class="voucher-code-value"><c:out value="${voucher.code}"/></span>
                                                </div>

                                                <p class="voucher-desc">
                                                    <c:choose>
                                                        <c:when test="${not empty voucher.description}">
                                                            <c:out value="${voucher.description}"/>
                                                        </c:when>
                                                        <c:otherwise>Ưu đãi từ WonderVN cho chuyến đi sắp tới của bạn.</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>

                                            <span class="status-badge ${displayStatus}">
                                                <c:choose>
                                                    <c:when test="${displayStatus == 'used'}">
                                                        <i class="fa-solid fa-circle-check"></i>Đã dùng
                                                    </c:when>
                                                    <c:when test="${displayStatus == 'available'}">
                                                        <i class="fa-solid fa-ticket"></i>Có thể sử dụng
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fa-solid fa-circle-exclamation"></i>Không còn hiệu lực
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

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
                                                <strong><fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy"/></strong>
                                            </div>

                                            <div class="voucher-row">
                                                <span>Ngày lưu</span>
                                                <strong><fmt:formatDate value="${voucher.savedAt}" pattern="dd/MM/yyyy"/></strong>
                                            </div>

                                            <c:if test="${displayStatus == 'used' && not empty voucher.usedAt}">
                                                <div class="voucher-row">
                                                    <span>Ngày sử dụng</span>
                                                    <strong><fmt:formatDate value="${voucher.usedAt}" pattern="dd/MM/yyyy"/></strong>
                                                </div>
                                            </c:if>

                                            <c:if test="${displayStatus == 'unavailable'}">
                                                <div class="reason-note">
                                                    <i class="fa-solid fa-circle-info"></i>
                                                    <span>
                                                        <c:choose>
                                                            <c:when test="${voucher.unavailableReason == 'INACTIVE'}">Tạm ngừng áp dụng</c:when>
                                                            <c:when test="${voucher.unavailableReason == 'NOT_STARTED'}">Chưa đến thời gian sử dụng</c:when>
                                                            <c:when test="${voucher.unavailableReason == 'EXPIRED'}">Đã hết hạn</c:when>
                                                            <c:when test="${voucher.unavailableReason == 'OUT_OF_STOCK'}">Đã hết lượt sử dụng</c:when>
                                                            <c:otherwise>Không còn khả dụng</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            </c:if>

                                            <button class="copy-code-btn" type="button">
                                                <i class="fa-solid fa-copy"></i>
                                                Sao chép mã
                                            </button>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </article>
        </section>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp"/>

<script>
    document.addEventListener('click', function (event) {
        const button = event.target.closest('.copy-code-btn');
        if (!button) {
            return;
        }

        const card = button.closest('.voucher-card');
        const codeElement = card ? card.querySelector('.voucher-code-value') : null;
        const code = codeElement ? codeElement.textContent.trim() : '';
        if (!code || !navigator.clipboard) {
            return;
        }

        const originalText = button.innerHTML;
        navigator.clipboard.writeText(code).then(function () {
            button.innerHTML = '<i class="fa-solid fa-check"></i>Đã sao chép';
            window.setTimeout(function () {
                button.innerHTML = originalText;
            }, 1600);
        });
    });
</script>
</body>
</html>
