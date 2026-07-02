<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Giỏ hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=1000">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            background: #f4f7fb;
            color: #0f172a;
        }

        .cart-section {
            padding: 36px 0 58px;
        }

        .cart-container {
            max-width: 1180px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .cart-title-area {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 24px;
        }

        .cart-title-area h1 {
            margin: 8px 0 8px;
            font-size: 34px;
            font-weight: 950;
            color: #0f172a;
        }

        .cart-title-area p {
            margin: 0;
            color: #64748b;
            font-weight: 650;
            line-height: 1.6;
        }

        .section-kicker {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border-radius: 999px;
            padding: 9px 16px;
            background: #e0f2fe;
            color: #0369a1;
            font-weight: 900;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .btn-soft-back {
            min-height: 48px;
            border-radius: 999px;
            padding: 12px 18px;
            background: #ffffff;
            color: #2563eb;
            border: 1px solid #bfdbfe;
            text-decoration: none;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            white-space: nowrap;
        }

        .cart-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 350px;
            gap: 24px;
            align-items: start;
        }

        .cart-card,
        .cart-summary {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
        }

        .cart-card {
            padding: 22px;
        }

        .cart-summary {
            padding: 22px;
            position: sticky;
            top: 94px;
        }

        .cart-item {
            display: grid;
            grid-template-columns: 28px 126px minmax(0, 1fr);
            gap: 16px;
            padding: 18px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .item-check {
            width: 18px;
            height: 18px;
            margin-top: 8px;
        }

        .item-image {
            width: 126px;
            height: 92px;
            border-radius: 16px;
            object-fit: cover;
            background: #e2e8f0;
        }

        .item-top {
            display: flex;
            justify-content: space-between;
            gap: 14px;
            align-items: flex-start;
        }

        .item-name {
            color: #0f172a;
            font-size: 18px;
            font-weight: 950;
            margin: 0 0 6px;
            line-height: 1.35;
        }

        .item-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 11px;
            border-radius: 999px;
            background: #eff6ff;
            color: #1d4ed8;
            font-size: 12px;
            font-weight: 900;
            margin-bottom: 8px;
        }

        .item-meta {
            color: #64748b;
            font-size: 14px;
            font-weight: 650;
            line-height: 1.6;
        }

        .item-price {
            color: #1d4ed8;
            font-size: 18px;
            font-weight: 950;
            text-align: right;
            white-space: nowrap;
        }

        .item-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 14px;
        }

        .quantity-form {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .quantity-form input {
            width: 78px;
            height: 38px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            padding: 0 10px;
            font-weight: 800;
            color: #0f172a;
        }

        .btn-mini {
            border: none;
            min-height: 38px;
            border-radius: 12px;
            padding: 8px 12px;
            font-size: 13px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-update {
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
        }

        .btn-remove {
            background: #fee2e2;
            color: #b91c1c;
        }

        .btn-detail {
            background: #f8fafc;
            color: #334155;
            border: 1px solid #e2e8f0;
        }

        .summary-title {
            font-size: 22px;
            font-weight: 950;
            color: #0f172a;
            margin-bottom: 16px;
        }

        .summary-line {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            padding: 11px 0;
            border-bottom: 1px solid #e2e8f0;
            color: #64748b;
            font-weight: 750;
        }

        .summary-line strong {
            color: #0f172a;
        }

        .summary-total {
            margin-top: 16px;
            padding: 16px;
            border-radius: 18px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
        }

        .summary-total-label {
            color: #1e3a8a;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .summary-total-value {
            color: #1d4ed8;
            font-size: 26px;
            font-weight: 950;
        }

        .btn-checkout {
            width: 100%;
            min-height: 52px;
            border: none;
            border-radius: 999px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            padding: 13px 22px;
            font-size: 15px;
            font-weight: 950;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            cursor: pointer;
            box-shadow: 0 14px 26px rgba(37, 99, 235, 0.24);
            margin-top: 16px;
        }

        .empty-cart {
            text-align: center;
            padding: 56px 20px;
        }

        .empty-cart i {
            font-size: 52px;
            color: #94a3b8;
            margin-bottom: 18px;
        }

        .empty-cart h2 {
            font-size: 28px;
            font-weight: 950;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .empty-cart p {
            color: #64748b;
            font-weight: 650;
            margin-bottom: 20px;
        }

        .status-box {
            border-radius: 16px;
            padding: 14px 16px;
            margin-bottom: 20px;
            font-weight: 800;
        }

        .status-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .status-warning {
            background: #fff7ed;
            color: #9a3412;
            border: 1px solid #fed7aa;
        }

        .summary-note {
            color: #64748b;
            font-size: 13px;
            font-weight: 650;
            line-height: 1.6;
            margin-top: 12px;
        }

        @media (max-width: 992px) {
            .cart-title-area {
                display: block;
            }

            .btn-soft-back {
                margin-top: 16px;
            }

            .cart-layout {
                grid-template-columns: 1fr;
            }

            .cart-summary {
                position: static;
            }
        }

        @media (max-width: 640px) {
            .cart-item {
                grid-template-columns: 24px 90px minmax(0, 1fr);
                gap: 12px;
            }

            .item-image {
                width: 90px;
                height: 76px;
            }

            .item-top {
                display: block;
            }

            .item-price {
                text-align: left;
                margin-top: 8px;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp"/>

<main class="home-page">
    <section class="cart-section">
        <div class="cart-container">

            <div class="cart-title-area">
                <div>
                    <p class="section-kicker">
                        <i class="fa-solid fa-cart-shopping"></i>
                        Giỏ hàng
                    </p>
                    <h1>Giỏ hàng của bạn</h1>
                    <p>Kiểm tra các dịch vụ đã chọn trước khi chuyển sang bước đặt chỗ.</p>
                </div>

                <a class="btn-soft-back" href="${pageContext.request.contextPath}/home">
                    <i class="fa-solid fa-house"></i>
                    Về trang chủ
                </a>
            </div>

            <c:if test="${param.status == 'cartAdded'}">
                <div class="status-box status-success">
                    <i class="fa-solid fa-circle-check me-2"></i>
                    Đã thêm dịch vụ vào giỏ hàng.
                </div>
            </c:if>

            <c:if test="${param.status == 'removed'}">
                <div class="status-box status-success">
                    <i class="fa-solid fa-trash-can me-2"></i>
                    Đã xóa dịch vụ khỏi giỏ hàng.
                </div>
            </c:if>

            <c:if test="${param.status == 'updated'}">
                <div class="status-box status-success">
                    <i class="fa-solid fa-pen-to-square me-2"></i>
                    Đã cập nhật số lượng.
                </div>
            </c:if>

            <c:if test="${param.status == 'selectRequired'}">
                <div class="status-box status-warning">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    Vui lòng chọn ít nhất một dịch vụ để tiếp tục đặt chỗ.
                </div>
            </c:if>

            <c:if test="${param.status == 'cartError'}">
                <div class="status-box status-warning">
                    <i class="fa-solid fa-circle-exclamation me-2"></i>
                    Chưa thể thêm dịch vụ vào giỏ hàng. Dịch vụ có thể không còn khả dụng.
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="cart-card empty-cart">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <h2>Giỏ hàng đang trống</h2>
                        <p>Bạn chưa thêm xe hoặc phòng nào vào giỏ hàng.</p>

                        <a class="btn-soft-back" href="${pageContext.request.contextPath}/vehicle">
                            <i class="fa-solid fa-car-side"></i>
                            Xem xe cho thuê
                        </a>

                        <a class="btn-soft-back" href="${pageContext.request.contextPath}/accommodation">
                            <i class="fa-solid fa-hotel"></i>
                            Xem nơi lưu trú
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="cart-layout">
                        <section class="cart-card">
                            <form id="bookingLinkForm" action="${pageContext.request.contextPath}/booking" method="get">
                                <input type="hidden" name="source" value="cart">
                            </form>

                            <c:forEach items="${cartItems}" var="item">
                                <article class="cart-item">
                                    <input class="item-check"
                                           type="checkbox"
                                           form="bookingLinkForm"
                                           name="cartItemID"
                                           value="${item.cartItemID}"
                                           data-subtotal="${item.subTotal}">

                                    <img class="item-image"
                                         src="${empty item.image ? 'https://placehold.co/300x220?text=WonderVN' : item.image}"
                                         alt="${item.itemName}"
                                         onerror="this.src='https://placehold.co/300x220?text=WonderVN';">

                                    <div>
                                        <div class="item-top">
                                            <div>
                                                <div class="item-badge">
                                                    <c:choose>
                                                        <c:when test="${item.itemType == 'Vehicle'}">
                                                            <i class="fa-solid fa-car-side"></i>
                                                            Xe
                                                        </c:when>

                                                        <c:when test="${item.itemType == 'Room'}">
                                                            <i class="fa-solid fa-bed"></i>
                                                            Phòng
                                                        </c:when>

                                                        <c:otherwise>
                                                            <i class="fa-solid fa-suitcase"></i>
                                                            Dịch vụ
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <h3 class="item-name">${item.itemName}</h3>

                                                <div class="item-meta">
                                                    <c:if test="${not empty item.providerName}">
                                                        <div>
                                                            <i class="fa-solid fa-location-dot me-1"></i>
                                                                ${item.providerName}
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${not empty item.detailText}">
                                                        <div>${item.detailText}</div>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="item-price">
                                                <fmt:formatNumber value="${item.subTotal}" type="number" maxFractionDigits="0"/> VNĐ
                                            </div>
                                        </div>

                                        <div class="item-actions">
                                            <div class="quantity-form">
                                                <form action="${pageContext.request.contextPath}/cart/update" method="post" class="quantity-form">
                                                    <input type="hidden" name="cartItemID" value="${item.cartItemID}">
                                                    <input type="number" name="quantity" value="${item.quantity}" min="1">
                                                    <button type="submit" class="btn-mini btn-update">
                                                        <i class="fa-solid fa-rotate"></i>
                                                        Cập nhật
                                                    </button>
                                                </form>
                                            </div>

                                            <div class="d-flex gap-2 flex-wrap">
                                                <a class="btn-mini btn-detail"
                                                   href="${pageContext.request.contextPath}${item.detailUrl}">
                                                    <i class="fa-solid fa-eye"></i>
                                                    Xem lại
                                                </a>

                                                <form action="${pageContext.request.contextPath}/cart/remove" method="post" class="m-0">
                                                    <input type="hidden" name="cartItemID" value="${item.cartItemID}">
                                                    <button type="submit" class="btn-mini btn-remove">
                                                        <i class="fa-solid fa-trash-can"></i>
                                                        Xóa
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </section>

                        <aside class="cart-summary">
                            <div class="summary-title">Tóm tắt giỏ hàng</div>

                            <div class="summary-line">
                                <span>Tổng số mục</span>
                                <strong>${cartItems.size()}</strong>
                            </div>

                            <div class="summary-line">
                                <span>Đã chọn</span>
                                <strong id="selectedCount">0</strong>
                            </div>

                            <div class="summary-total">
                                <div class="summary-total-label">Tạm tính mục đã chọn</div>
                                <div class="summary-total-value" id="selectedTotal">0 VNĐ</div>
                            </div>

                            <button type="submit" form="bookingLinkForm" class="btn-checkout" id="checkoutBtn">
                                <i class="fa-solid fa-credit-card"></i>
                                Đặt đơn
                            </button>

                            <div class="summary-note">
                                Xe sẽ chọn ngày thuê ở bước đặt đơn. Phòng sẽ giữ nguyên ngày nhận/trả phòng đã chọn khi thêm vào giỏ hàng.
                            </div>
                        </aside>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp"/>

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const checkboxes = document.querySelectorAll(".item-check");
        const selectedCount = document.getElementById("selectedCount");
        const selectedTotal = document.getElementById("selectedTotal");
        const checkoutBtn = document.getElementById("checkoutBtn");
        const bookingLinkForm = document.getElementById("bookingLinkForm");
        const formatter = new Intl.NumberFormat("vi-VN");

        function updateSummary() {
            let count = 0;
            let total = 0;

            checkboxes.forEach(function (checkbox) {
                if (checkbox.checked) {
                    count++;
                    total += Number(checkbox.dataset.subtotal || 0);
                }
            });

            if (selectedCount) {
                selectedCount.textContent = count;
            }

            if (selectedTotal) {
                selectedTotal.textContent = formatter.format(total) + " VNĐ";
            }
        }

        checkboxes.forEach(function (checkbox) {
            checkbox.addEventListener("change", updateSummary);
        });

        if (bookingLinkForm) {
            bookingLinkForm.addEventListener("submit", function (event) {
                let hasSelected = false;

                checkboxes.forEach(function (checkbox) {
                    if (checkbox.checked) {
                        hasSelected = true;
                    }
                });

                if (!hasSelected) {
                    event.preventDefault();
                    window.location.href = "${pageContext.request.contextPath}/cart?status=selectRequired";
                }
            });
        }

        if (checkoutBtn) {
            checkoutBtn.addEventListener("click", updateSummary);
        }

        updateSummary();
    });
</script>

</body>
</html>