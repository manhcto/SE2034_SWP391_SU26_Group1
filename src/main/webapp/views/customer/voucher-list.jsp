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

        .voucher-code {
            margin: 0;
            color: #0f172a;
            font-size: 20px;
            font-weight: 900;
            letter-spacing: 0.7px;
            text-transform: uppercase;
            line-height: 1.2;
        }

        .voucher-desc {
            margin: 7px 0 0;
            color: #64748b;
            font-size: 13px;
            font-weight: 600;
            line-height: 1.5;
        }

        .discount-pill {
            min-width: 86px;
            min-height: 40px;
            padding: 0 12px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #2563eb;
            color: #ffffff;
            font-size: 13px;
            font-weight: 900;
            white-space: nowrap;
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

        .copy-code {
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
            letter-spacing: 0.35px;
            text-transform: uppercase;
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
            .voucher-grid {
                grid-template-columns: 1fr;
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
                    <p class="account-subtitle">Các mã ưu đãi đang hoạt động có thể dùng khi đặt tour hoặc đặt phòng.</p>
                </div>

                <c:choose>
                    <c:when test="${empty voucherList}">
                        <div class="empty-box">
                            <i class="fa-solid fa-ticket"></i>
                            <h3>Chưa có voucher khả dụng</h3>
                            <p>Khi có mã ưu đãi mới, chúng sẽ xuất hiện tại đây.</p>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="voucher-body">
                            <div class="voucher-grid">
                                <c:forEach items="${voucherList}" var="voucher">
                                    <article class="voucher-card">
                                        <div class="voucher-top">
                                            <div>
                                                <h2 class="voucher-code">${voucher.code}</h2>
                                                <p class="voucher-desc">
                                                    <c:choose>
                                                        <c:when test="${not empty voucher.description}">
                                                            ${voucher.description}
                                                        </c:when>
                                                        <c:otherwise>Ưu đãi từ WonderVN</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>

                                            <div class="discount-pill">
                                                <c:choose>
                                                    <c:when test="${voucher.percentDiscount != null && voucher.percentDiscount > 0}">
                                                        <fmt:formatNumber value="${voucher.percentDiscount}" maxFractionDigits="0"/>%
                                                    </c:when>
                                                    <c:when test="${voucher.amountDiscount != null && voucher.amountDiscount > 0}">
                                                        <fmt:formatNumber value="${voucher.amountDiscount}" type="number" maxFractionDigits="0"/> VND
                                                    </c:when>
                                                    <c:otherwise>Ưu đãi</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="voucher-meta">
                                            <div class="voucher-row">
                                                <span>Đơn tối thiểu</span>
                                                <strong>
                                                    <c:choose>
                                                        <c:when test="${voucher.minOrderAmount != null}">
                                                            <fmt:formatNumber value="${voucher.minOrderAmount}" type="number" maxFractionDigits="0"/> VND
                                                        </c:when>
                                                        <c:otherwise>Không giới hạn</c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </div>

                                            <div class="voucher-row">
                                                <span>Còn lại</span>
                                                <strong>${voucher.quantity} mã</strong>
                                            </div>

                                            <div class="voucher-row">
                                                <span>Hiệu lực</span>
                                                <strong>
                                                    <fmt:formatDate value="${voucher.startDate}" pattern="dd/MM/yyyy"/>
                                                    -
                                                    <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy"/>
                                                </strong>
                                            </div>

                                            <div class="copy-code">
                                                <i class="fa-solid fa-ticket"></i>
                                                ${voucher.code}
                                            </div>
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
</body>
</html>
