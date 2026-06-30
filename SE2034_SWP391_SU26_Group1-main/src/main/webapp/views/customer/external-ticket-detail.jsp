<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="todayStr" value="${now}" pattern="yyyy-MM-dd" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${ticket.name} | WonderVN</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body { background-color: #f4f7f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

        .main-gallery { border-radius: 16px; overflow: hidden; margin-bottom: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .main-gallery img { width: 100%; height: 450px; object-fit: cover; }

        .content-card { background: white; border-radius: 16px; padding: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); margin-bottom: 25px; }
        .ticket-title { font-size: 28px; font-weight: 800; color: #0f172a; margin-bottom: 15px; line-height: 1.4; }

        .highlight-badge { background: #e0f2fe; color: #0369a1; padding: 6px 12px; border-radius: 8px; font-weight: 700; font-size: 14px; display: inline-flex; align-items: center; gap: 6px; }
        .rating-box { display: inline-flex; align-items: center; gap: 8px; font-weight: 700; color: #1e293b; font-size: 16px; }
        .rating-score { color: white; background: #0ea5e9; padding: 4px 10px; border-radius: 8px; border-bottom-right-radius: 2px; font-size: 16px;}

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 25px 0; padding: 20px; background: #f8fafc; border-radius: 12px; }
        .info-item { display: flex; align-items: flex-start; gap: 12px; }
        .info-icon { font-size: 20px; color: #64748b; margin-top: 2px; }
        .info-text h6 { margin: 0; font-size: 14px; color: #64748b; font-weight: 600; margin-bottom: 4px; }
        .info-text p { margin: 0; font-size: 15px; color: #0f172a; font-weight: 600; }

        .sticky-wrapper { position: sticky; top: 30px; }
        .booking-card { background: white; border-radius: 16px; padding: 25px; box-shadow: 0 10px 40px rgba(0,0,0,0.08); border: 1px solid #f1f5f9; }
        .price-header { display: flex; flex-direction: column; border-bottom: 1px solid #e2e8f0; padding-bottom: 20px; margin-bottom: 20px; }
        .price-title { font-size: 14px; color: #64748b; font-weight: 600; text-transform: uppercase; margin-bottom: 5px; }
        .price-value { font-size: 32px; color: #ea580c; font-weight: 800; }

        .form-label { font-weight: 700; color: #1e293b; font-size: 14px; }
        .custom-input { border-radius: 10px; padding: 12px; border: 1.5px solid #cbd5e1; font-weight: 600; }
        .custom-input:focus { border-color: #0ea5e9; box-shadow: 0 0 0 4px rgba(14,165,233,0.1); }

        .qty-selector { display: flex; align-items: center; justify-content: space-between; padding: 10px 15px; border: 1.5px solid #cbd5e1; border-radius: 10px; }
        .btn-qty { background: #f1f5f9; border: none; width: 32px; height: 32px; border-radius: 8px; font-weight: bold; color: #0f172a; transition: 0.2s; }
        .btn-qty:hover { background: #e2e8f0; }
        .qty-input { border: none; width: 40px; text-align: center; font-weight: 800; font-size: 18px; color: #0f172a; padding: 0; outline: none; background: transparent; }

        .total-box { display: flex; justify-content: space-between; align-items: center; margin: 25px 0 15px 0; }
        .btn-book { background: #0ea5e9; color: white; font-weight: 800; font-size: 18px; padding: 15px; border-radius: 12px; width: 100%; transition: 0.3s; border: none; }
        .btn-book:hover { background: #0284c7; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(14,165,233,0.3); }
    </style>
</head>
<body>

<jsp:include page="/views/common/client-header.jsp" />

<div class="container py-3">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0 fw-semibold" style="font-size: 14px;">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none text-muted">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/external-ticket" class="text-decoration-none text-muted">Trải nghiệm</a></li>
            <li class="breadcrumb-item active text-dark" aria-current="page">${ticket.name}</li>
        </ol>
    </nav>
</div>

<div class="container pb-5">
    <div class="row g-4">

        <div class="col-lg-7 col-xl-8">
            <div class="main-gallery">
                <img src="${ticket.image}" alt="${ticket.name}">
            </div>

            <div class="content-card">
                <div class="d-flex flex-wrap gap-2 mb-3">
                    <span class="highlight-badge"><i class="fa-solid fa-check-circle"></i> Đối tác chính thức</span>
                    <c:if test="${ticket.type == 'Attraction'}"><span class="highlight-badge bg-light text-secondary border"><i class="fa-solid fa-ferris-wheel"></i> Điểm tham quan</span></c:if>
                    <c:if test="${ticket.type == 'Activity'}"><span class="highlight-badge bg-light text-secondary border"><i class="fa-solid fa-person-swimming"></i> Tour & Hoạt động</span></c:if>
                </div>

                <h1 class="ticket-title">${ticket.name}</h1>

                <div class="rating-box mb-4">
                    <div class="rating-score">${ticket.rate}/10</div>
                    <span>Xuất sắc</span>
                    <span class="text-muted fw-normal" style="font-size: 14px;">(${ticket.reviewCount} lượt đánh giá)</span>
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <i class="fa-solid fa-location-dot info-icon text-danger"></i>
                        <div class="info-text">
                            <h6>Địa chỉ</h6>
                            <p>${ticket.address}</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fa-regular fa-clock info-icon text-primary"></i>
                        <div class="info-text">
                            <h6>Thời gian hoạt động</h6>
                            <p>${ticket.timeOpen} - ${ticket.timeClose}</p>
                            <p class="text-muted fs-7 mt-1" style="font-weight: 500;">(${ticket.dayOfWeekOpen})</p>
                        </div>
                    </div>
                </div>

                <h4 class="fw-bold text-dark mt-4 mb-3">Bạn sẽ trải nghiệm những gì?</h4>
                <div class="text-secondary" style="line-height: 1.8; text-align: justify; font-size: 15px;">
                    ${ticket.description}
                </div>
            </div>
        </div>

        <div class="col-lg-5 col-xl-4">
            <div class="sticky-wrapper">
                <div class="booking-card">

                    <div class="price-header">
                        <span class="price-title">Giá vé ưu đãi</span>
                        <div class="price-value">
                            <span id="basePriceDisplay"><fmt:formatNumber value="${ticket.ticketPrice}" pattern="#,###" /></span> <span style="font-size: 16px;">VND</span>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/cart/add" method="POST">
                        <input type="hidden" name="serviceId" value="${ticket.serviceID}">

                        <div class="mb-4">
                            <label class="form-label"><i class="fa-regular fa-calendar text-primary me-1"></i> Chọn ngày tham gia</label>
                            <input type="date" class="form-control custom-input" name="bookingDate" id="bookingDate"
                                   min="${todayStr}" value="${todayStr}" required>
                        </div>

                        <c:set var="childPrice" value="${ticket.ticketPrice * 0.75}" />

                        <div class="mb-3">
                            <label class="form-label d-flex justify-content-between align-items-center">
                                <span><i class="fa-solid fa-person text-primary me-1"></i> Người lớn</span>
                                <span class="text-danger fw-bold"><fmt:formatNumber value="${ticket.ticketPrice}" pattern="#,###" />đ</span>
                            </label>
                            <div class="qty-selector">
                                <button type="button" class="btn-qty" onclick="changeQty('adultQty', -1)">-</button>
                                <input type="number" name="adultQuantity" id="adultQty" class="qty-input" value="1" min="1" max="20" readonly>
                                <button type="button" class="btn-qty" onclick="changeQty('adultQty', 1)">+</button>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label d-flex justify-content-between align-items-center">
                                <span><i class="fa-solid fa-child text-info me-1"></i> Trẻ em (1m - 1.4m)</span>
                                <span class="text-danger fw-bold"><fmt:formatNumber value="${childPrice}" pattern="#,###" />đ</span>
                            </label>
                            <div class="qty-selector">
                                <button type="button" class="btn-qty" onclick="changeQty('childQty', -1)">-</button>
                                <input type="number" name="childQuantity" id="childQty" class="qty-input" value="0" min="0" max="20" readonly>
                                <button type="button" class="btn-qty" onclick="changeQty('childQty', 1)">+</button>
                            </div>
                        </div>

                        <div class="total-box">
                            <span class="fw-bold text-secondary">Tổng thanh toán:</span>
                            <span class="fs-4 fw-bold text-dark"><span id="totalPriceDisplay">0</span> ₫</span>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" name="submitAction" value="add_cart" class="btn btn-outline-info fw-bold py-2" style="width: 45%; border-radius: 12px; border-width: 2px;">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                            </button>
                            <button type="submit" name="submitAction" value="buy_now" class="btn-book m-0" style="width: 55%;">
                                Đặt ngay
                            </button>
                        </div>
                    </form>

                    <div class="text-center mt-3">
                        <small class="text-muted"><i class="fa-solid fa-bolt text-warning"></i> Xác nhận tức thì. Đổi trả linh hoạt.</small>
                    </div>

                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const adultPrice = ${ticket.ticketPrice};
    const childPrice = ${ticket.ticketPrice * 0.75};

    const adultQtyInput = document.getElementById('adultQty');
    const childQtyInput = document.getElementById('childQty');
    const totalDisplay = document.getElementById('totalPriceDisplay');

    function formatCurrency(number) {
        return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    function updateTotal() {
        let adultQty = parseInt(adultQtyInput.value);
        let childQty = parseInt(childQtyInput.value);

        let total = (adultPrice * adultQty) + (childPrice * childQty);
        totalDisplay.innerText = formatCurrency(total);
    }

    function changeQty(inputId, amount) {
        let inputEl = document.getElementById(inputId);
        let currentQty = parseInt(inputEl.value);
        let newQty = currentQty + amount;

        let minAllow = (inputId === 'adultQty') ? 1 : 0;

        if (newQty >= minAllow && newQty <= 20) {
            inputEl.value = newQty;
            updateTotal();
        }
    }

    document.addEventListener("DOMContentLoaded", updateTotal);
</script>

</body>
</html>