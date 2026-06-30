<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Khám phá Trải nghiệm | WonderVN</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

        /* 1. THANH TÌM KIẾM CHUẨN UX */
        .search-box-container { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); margin-bottom: 25px; }
        .search-input { border-radius: 50px; padding: 12px 25px; border: 1.5px solid #e2e8f0; font-size: 16px; background-color: #f8fafc; transition: 0.3s; }
        .search-input:focus { box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.15); border-color: #0ea5e9; background-color: white; }

        /* 2. CARD SẢN PHẨM (Hiệu ứng Hover dịch chuyển & Fix chiều cao đồng đều) */
        .ticket-card { background: white; border-radius: 16px; border: none; overflow: hidden; transition: all 0.3s ease; box-shadow: 0 2px 10px rgba(0,0,0,0.04); height: 100%; display: flex; flex-direction: column; position: relative;}
        .ticket-card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,0,0,0.12); }

        .ticket-img-wrapper { position: relative; height: 200px; overflow: hidden; }
        .ticket-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease; }
        .ticket-card:hover .ticket-img { transform: scale(1.05); }

        /* Badge Trạng thái Đang mở / Tạm ngưng góc trái ảnh */
        .status-badge { position: absolute; top: 15px; left: 15px; padding: 6px 12px; border-radius: 30px; font-weight: 700; font-size: 12px; backdrop-filter: blur(4px); box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .status-open { background: rgba(255, 255, 255, 0.95); color: #16a34a; }
        .status-closed { background: rgba(255, 255, 255, 0.95); color: #ef4444; }

        /* Giới hạn tên dịch vụ đúng 2 dòng cố định (60px) không lo lệch Card */
        .ticket-title { font-size: 18px; font-weight: 700; color: #1e293b; margin: 12px 0; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 54px; line-height: 1.5; }

        /* Làm nổi bật phần giá tiền */
        .price-label { font-size: 12px; color: #64748b; font-weight: 600; text-transform: uppercase; margin-bottom: -5px;}
        .price-text { color: #ea580c; font-size: 22px; font-weight: 800; }

        /* Nút Đặt/Xem chi tiết Call-To-Action sống động khi Hover */
        .btn-cta { background: #f1f5f9; color: #0ea5e9; font-weight: 700; border-radius: 10px; width: 100%; padding: 10px; transition: 0.3s; border: 1px solid transparent; text-align: center; text-decoration: none; display: block; }
        .ticket-card:hover .btn-cta { background: #0ea5e9; color: white; box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3); }

        /* 3. BỘ LỌC SIDEBAR */
        .filter-box { background: white; border-radius: 16px; padding: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); }
        .filter-title { font-weight: 800; font-size: 16px; color: #0f172a; border-bottom: 2px solid #f1f5f9; padding-bottom: 12px; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;}
        .form-check-label { color: #475569; font-weight: 500; font-size: 15px; cursor: pointer; }
        .form-check-input { cursor: pointer; }

        /* 4. PHÂN TRANG (Pagination) */
        .custom-pagination .page-link { color: #475569; border: none; font-weight: 600; padding: 10px 18px; margin: 0 4px; border-radius: 10px; transition: 0.2s; text-decoration: none;}
        .custom-pagination .page-link:hover { background: #e0f2fe; color: #0ea5e9; }
        .custom-pagination .page-item.active .page-link { background: #0ea5e9; color: white; box-shadow: 0 4px 10px rgba(14, 165, 233, 0.3); }
    </style>
</head>
<body>

<jsp:include page="/views/common/client-header.jsp" />

<div class="container py-5">

    <div class="search-box-container mb-4">
        <form onsubmit="return false;"> <div class="position-relative">
            <i class="fa-solid fa-magnifying-glass position-absolute top-50 start-0 translate-middle-y ms-4 text-muted fs-5"></i>
            <input type="text" id="searchInput" class="form-control search-input ps-5" placeholder="Nhập tên từ khóa cần tìm... (VD: VinWonders, Thủy cung, Bảo tàng, Vườn thú)">
        </div>
        </form>
    </div>

    <div class="row g-4">

        <div class="col-lg-3">
            <div class="filter-box position-sticky" style="top: 20px;">
                <h4 class="fw-bold mb-4"><i class="fa-solid fa-sliders"></i> Bộ Lọc</h4>

                <div class="mb-4">
                    <div class="filter-title"><i class="fa-solid fa-layer-group text-success"></i> Loại hình tham quan</div>
                    <div class="form-check mb-2">
                        <input class="form-check-input filter-type" type="checkbox" value="AmusementPark" id="typePark">
                        <label class="form-check-label" for="typePark">Công viên giải trí</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input filter-type" type="checkbox" value="Museum" id="typeMuseum">
                        <label class="form-check-label" for="typeMuseum">Bảo tàng & Trưng bày</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input filter-type" type="checkbox" value="Zoo" id="typeZoo">
                        <label class="form-check-label" for="typeZoo">Sở thú & Thủy cung</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input filter-type" type="checkbox" value="Nature" id="typeNature">
                        <label class="form-check-label" for="typeNature">Thiên nhiên & Vườn</label>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="filter-title"><i class="fa-solid fa-location-dot text-danger"></i> Tỉnh / Thành phố</div>
                    <div class="form-check mb-2">
                        <input class="form-check-input filter-location" type="checkbox" value="hà nội" id="locHN"><label class="form-check-label" for="locHN">Hà Nội</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input filter-location" type="checkbox" value="hồ chí minh" id="locHCM"><label class="form-check-label" for="locHCM">TP. Hồ Chí Minh</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input filter-location" type="checkbox" value="đà nẵng" id="locDN"><label class="form-check-label" for="locDN">Đà Nẵng</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input filter-location" type="checkbox" value="phú quốc" id="locPQ"><label class="form-check-label" for="locPQ">Phú Quốc</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input filter-location" type="checkbox" value="nha trang" id="locNT"><label class="form-check-label" for="locNT">Nha Trang</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input filter-location" type="checkbox" value="sapa" id="locSP"><label class="form-check-label" for="locSP">Sapa / Lào Cai</label>
                    </div>
                </div>

                <div>
                    <div class="filter-title"><i class="fa-solid fa-star text-warning"></i> Đánh giá của khách</div>
                    <div class="form-check mb-2"><input class="form-check-input filter-rating" type="radio" name="rating" value="4.5" id="rate45"><label class="form-check-label" for="rate45">Từ 4.5 sao trở lên</label></div>
                    <div class="form-check mb-2"><input class="form-check-input filter-rating" type="radio" name="rating" value="4.0" id="rate40"><label class="form-check-label" for="rate40">Từ 4.0 sao trở lên</label></div>
                    <div class="form-check mb-2"><input class="form-check-input filter-rating" type="radio" name="rating" value="0" id="rateAll" checked><label class="form-check-label" for="rateAll">Tất cả đánh giá</label></div>
                </div>
            </div>
        </div>

        <div class="col-lg-9">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold text-dark m-0">Tìm thấy <span id="resultCount" class="text-primary fs-4">${TICKET_LIST.size()}</span> địa điểm phù hợp</h5>
            </div>

            <div class="row g-4 mb-5" id="ticketContainer">
                <c:forEach items="${TICKET_LIST}" var="t">
                    <div class="col-md-6 col-xl-4 ticket-wrapper" data-address="${t.address.toLowerCase()}" data-rating="${t.rate}" data-type="${t.type}">
                        <div class="ticket-card">

                            <div class="ticket-img-wrapper">
                                <c:choose>
                                    <c:when test="${t.status == 'Active'}">
                                        <div class="status-badge status-open"><i class="fa-solid fa-circle-check"></i> Đang mở cửa</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="status-badge status-closed"><i class="fa-solid fa-circle-xmark"></i> Tạm ngưng</div>
                                    </c:otherwise>
                                </c:choose>
                                <img src="${t.image}" alt="Img" class="ticket-img">
                            </div>

                            <div class="p-3 d-flex flex-column flex-grow-1">
                                <div class="d-flex align-items-center gap-1 text-warning fw-bold fs-6">
                                    <i class="fa-solid fa-star"></i> ${t.rate}
                                    <span class="text-muted fw-normal" style="font-size: 13px;">(${t.reviewCount} lượt)</span>
                                </div>

                                <h3 class="ticket-title" title="${t.name}">${t.name}</h3>

                                <div class="text-muted mb-3" style="font-size: 14px;">
                                    <i class="fa-solid fa-location-dot text-danger"></i> ${t.address}
                                </div>

                                <div class="mt-auto">
                                    <div class="price-label">🔥 Giá vé từ</div>
                                    <div class="price-text mb-3"><fmt:formatNumber value="${t.ticketPrice}" pattern="#,###" /> VNĐ</div>

                                    <a href="${pageContext.request.contextPath}/external-ticket-detail?id=${t.serviceID}" class="btn btn-cta">
                                        Xem chi tiết <i class="fa-solid fa-arrow-right ms-1"></i>
                                    </a>
                                </div>
                            </div>

                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${maxPage > 1}">
                <nav aria-label="Page navigation" class="mt-5">
                    <ul class="pagination custom-pagination justify-content-center">

                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/external-ticket?search=${searchKeyword}&page=${currentPage - 1}">
                                <i class="fa-solid fa-chevron-left"></i> Trước
                            </a>
                        </li>

                        <c:forEach begin="1" end="${maxPage}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/external-ticket?search=${searchKeyword}&page=${i}">
                                        ${i}
                                </a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${currentPage == maxPage ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/external-ticket?search=${searchKeyword}&page=${currentPage + 1}">
                                Sau <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </li>

                    </ul>
                </nav>
            </c:if>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('searchInput');
        const typeCheckboxes = document.querySelectorAll('.filter-type'); // Lọc Loại hình
        const locationCheckboxes = document.querySelectorAll('.filter-location'); // Lọc Vị trí
        const ratingRadios = document.querySelectorAll('.filter-rating'); // Lọc Sao
        const allTickets = document.querySelectorAll('.ticket-wrapper');
        const resultCountText = document.getElementById('resultCount');

        function applyFilters() {
            // Lấy từ khóa
            let searchKey = searchInput.value.toLowerCase().trim();

            // Lấy mảng Loại hình đã tích
            let selectedTypes = Array.from(typeCheckboxes).filter(cb => cb.checked).map(cb => cb.value);

            // Lấy mảng Địa điểm đã tích
            let selectedLocations = Array.from(locationCheckboxes).filter(cb => cb.checked).map(cb => cb.value.toLowerCase());

            // Lấy Mức sao
            let selectedRating = 0;
            const activeRating = document.querySelector('.filter-rating:checked');
            if (activeRating) selectedRating = parseFloat(activeRating.value);

            let visibleCount = 0;

            allTickets.forEach(ticket => {
                let ticketName = ticket.querySelector('.ticket-title').innerText.toLowerCase();
                let ticketAddress = ticket.getAttribute('data-address');
                let ticketRating = parseFloat(ticket.getAttribute('data-rating'));
                let ticketType = ticket.getAttribute('data-type'); // Thu thập Loại hình của vé

                // 1. Đối chiếu Từ khóa
                let searchMatch = ticketName.includes(searchKey);

                // 2. Đối chiếu Loại hình tham quan
                let typeMatch = true;
                if (selectedTypes.length > 0) {
                    typeMatch = selectedTypes.includes(ticketType);
                }

                // 3. Đối chiếu Địa điểm
                let locationMatch = true;
                if (selectedLocations.length > 0) {
                    // Xử lý riêng chữ "Sapa" cho tiện vì địa chỉ là Lào Cai
                    if (selectedLocations.includes("sapa") && (ticketAddress.includes("sapa") || ticketAddress.includes("lào cai"))) {
                        locationMatch = true;
                    } else {
                        locationMatch = selectedLocations.some(loc => ticketAddress.includes(loc));
                    }
                }

                // 4. Đối chiếu Sao
                let ratingMatch = ticketRating >= selectedRating;

                // CHỐT: Phải qua đủ 4 khiên lọc thì mới hiện lên!
                if (searchMatch && typeMatch && locationMatch && ratingMatch) {
                    ticket.style.display = 'block';
                    visibleCount++;
                } else {
                    ticket.style.display = 'none';
                }
            });

            if (resultCountText) resultCountText.innerText = visibleCount;
        }

        // Đăng ký bộ lắng nghe sự kiện cho tất cả
        searchInput.addEventListener('input', applyFilters);
        typeCheckboxes.forEach(cb => cb.addEventListener('change', applyFilters));
        locationCheckboxes.forEach(cb => cb.addEventListener('change', applyFilters));
        ratingRadios.forEach(radio => radio.addEventListener('change', applyFilters));
    });
</script>
</body>
</html>