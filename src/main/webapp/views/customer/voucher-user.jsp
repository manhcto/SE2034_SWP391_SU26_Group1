<%--
  Created by IntelliJ IDEA.
  User: trung123
  Date: 6/22/2026
  Time: 11:11 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khuyến Mãi & Ưu Đãi | WonderVN</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body { background-color: #f7f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

        /* --- TRAVELOKA HERO BANNER --- */
        .promo-hero {
            background: linear-gradient(90deg, #0286FF 0%, #01A0FF 100%);
            padding: 40px 0 80px 0;
            color: white;
            text-align: center;
            position: relative;
        }
        .promo-hero h1 { font-weight: 800; font-size: 32px; margin-bottom: 10px; }
        .promo-hero p { font-size: 16px; opacity: 0.9; }

        /* --- CATEGORY TABS (TẤT CẢ, KHÁCH SẠN, TOUR...) --- */
        .category-tabs {
            background: white;
            border-radius: 100px;
            padding: 8px 16px;
            display: inline-flex;
            gap: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            position: relative;
            margin-top: -30px; /* Kéo tab lùi lên đè vào banner xanh */
            z-index: 10;
        }
        .tab-item {
            padding: 10px 20px;
            border-radius: 100px;
            color: #687176;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s ease;
            border: none;
            background: transparent;
        }
        .tab-item:hover { background: #f1f5f9; color: #0194f3; }
        .tab-item.active { background: #EBF5FF; color: #0194f3; border: 1px solid #0194f3; }

        /* --- FILTER & SORT ROW --- */
        .filter-sort-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 30px 0 20px 0;
            padding-bottom: 15px;
            border-bottom: 1px solid #e1e4e8;
        }
        .filter-sort-row h3 { font-size: 20px; font-weight: 700; color: #1c2930; margin: 0; }
        .sort-dropdown {
            padding: 8px 16px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            color: #1c2930;
            font-weight: 600;
            outline: none;
            cursor: pointer;
        }

        /* --- VOUCHER CARD (GIỐNG TRAVELOKA) --- */
        .voucher-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e1e4e8;
            transition: all 0.2s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .voucher-card:hover { transform: translateY(-4px); box-shadow: 0 8px 16px rgba(0,0,0,0.1); }

        /* Phần Ảnh */
        .vc-image-wrapper { position: relative; height: 160px; width: 100%; background: #e2e8f0; }
        .vc-image-wrapper img { width: 100%; height: 100%; object-fit: cover; }
        .vc-badge {
            position: absolute;
            bottom: -15px;
            right: 15px;
            background: #FF5E1F;
            color: white;
            font-weight: 800;
            font-size: 20px;
            padding: 8px 16px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(255, 94, 31, 0.3);
            border: 2px solid white;
        }

        /* Phần Nội dung */
        .vc-body { padding: 25px 20px 20px 20px; flex: 1; display: flex; flex-direction: column; }
        .vc-title { font-size: 16px; font-weight: 700; color: #1c2930; margin-bottom: 8px; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .vc-desc { font-size: 13px; color: #687176; margin-bottom: 15px; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }

        .vc-meta { margin-top: auto; display: flex; justify-content: space-between; align-items: center; background: #F7F9FA; padding: 10px; border-radius: 8px; margin-bottom: 15px; }
        .vc-meta-item { text-align: left; }
        .vc-meta-label { font-size: 11px; color: #96a0a5; font-weight: 600; text-transform: uppercase; margin-bottom: 2px; }
        .vc-meta-value { font-size: 13px; color: #1c2930; font-weight: 700; }

        /* Nút Copy */
        .vc-btn {
            width: 100%;
            background: #0194f3;
            color: white;
            font-weight: 700;
            border: none;
            padding: 10px;
            border-radius: 8px;
            transition: 0.2s;
        }
        .vc-btn:hover { background: #007ce8; color: white; }
    </style>
</head>
<body>

<jsp:include page="/views/common/client-header.jsp" />

<section class="promo-hero">
    <div class="container">
        <h1>Mã giảm giá WonderVN ở gần đây chứ đâu xa!</h1>
        <p>Áp mã liền tay, đặt vé du lịch và phòng khách sạn ngay!</p>
    </div>
</section>

<main class="container">
    <div class="d-flex justify-content-center">
        <div class="category-tabs">
            <button class="tab-item active" onclick="filterVouchers('All', this)">
                <i class="fa-solid fa-border-all"></i> Tất cả
            </button>
            <button class="tab-item" onclick="filterVouchers('Hotel', this)">
                <i class="fa-solid fa-hotel"></i> Khách sạn
            </button>
            <button class="tab-item" onclick="filterVouchers('Tour', this)">
                <i class="fa-solid fa-route"></i> Vé vui chơi & Tour
            </button>
        </div>
    </div>

    <div class="filter-sort-row">
        <h3 id="categoryTitle"><i class="fa-solid fa-fire text-danger"></i> Tất cả khuyến mãi</h3>
        <div class="d-flex gap-2">
            <select class="sort-dropdown" id="sortSelect" onchange="sortVouchers()">
                <option value="default">Sắp xếp: Mặc định</option>
                <option value="discountDesc">Mức giảm: Cao đến thấp</option>
                <option value="expiringSoon">Hạn sử dụng: Sắp hết hạn</option>
            </select>
        </div>
    </div>

    <div class="row g-4 mb-5" id="voucherGrid">
        <c:forEach items="${VOUCHER_LIST}" var="v">
            <c:if test="${v.status == 'Active'}">
                <div class="col-lg-4 col-md-6 voucher-item"
                     data-category="${v.applyFor}"
                     data-discount="${v.percentDiscount}"
                     data-enddate="${v.endDate}">

                    <div class="voucher-card" style="border: 1px solid #e1e4e8; border-radius: 8px; overflow: hidden; display: flex; flex-direction: column; height: 100%; background: white;">
                        <div class="vc-image" style="height: 180px; width: 100%; background: #f1f5f9;">
                            <c:choose>
                                <c:when test="${not empty v.image}">
                                    <img src="${v.image}" style="width: 100%; height: 100%; object-fit: cover;" alt="Voucher Image">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&w=800&q=80" style="width: 100%; height: 100%; object-fit: cover;" alt="Default Image">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="vc-body" style="padding: 16px; flex: 1; display: flex; flex-direction: column;">
                            <h4 style="font-size: 16px; font-weight: 700; color: #1c2930; margin-bottom: 8px; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    ${v.voucherName} - Giảm <fmt:formatNumber value="${v.percentDiscount}" pattern="#" />%
                            </h4>

                            <p style="font-size: 13px; color: #687176; margin-bottom: auto; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    ${not empty v.description ? v.description : 'Ưu đãi đặc biệt áp dụng cho hệ thống WonderVN.'}
                            </p>

                            <div style="display: flex; justify-content: space-between; margin-top: 15px; border-top: 1px solid #f1f5f9; padding-top: 12px;">
                                <div style="font-size: 12px; color: #687176;">
                                    Thời gian khuyến mãi<br>
                                    <strong style="color: #1c2930; font-size: 13px;">Đến <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy"/></strong>
                                </div>
                                <div style="font-size: 12px; color: #687176;">
                                    Mã sử dụng<br>
                                    <strong style="color: #1c2930; font-size: 13px;">${v.voucherCode}</strong>
                                </div>
                            </div>

                            <button onclick="copyCode('${v.voucherCode}', this)" style="width: 100%; background: #0194f3; color: white; border-radius: 6px; padding: 12px; margin-top: 16px; font-weight: bold; border: none; transition: 0.2s;">
                                Lấy Khuyến Mãi
                            </button>
                        </div>
                    </div>

                </div>
            </c:if>
        </c:forEach>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<script>
    let currentCategory = 'All';

    // 1. CHỨC NĂNG LỌC THEO TAB
    function filterVouchers(category, btnElement) {
        currentCategory = category;

        // Đổi màu Tab active
        document.querySelectorAll('.tab-item').forEach(btn => btn.classList.remove('active'));
        btnElement.classList.add('active');

        // Đổi Title
        const titles = {
            'All': '<i class="fa-solid fa-fire text-danger"></i> Tất cả khuyến mãi',
            'Hotel': '<i class="fa-solid fa-hotel text-info"></i> Khuyến mãi Khách sạn',
            'Tour': '<i class="fa-solid fa-route text-primary"></i> Khuyến mãi Tour'
        };
        document.getElementById('categoryTitle').innerHTML = titles[category];

        // Chạy hàm Render
        applyFilterAndSort();
    }

    // 2. CHỨC NĂNG SẮP XẾP (SORT)
    function sortVouchers() {
        applyFilterAndSort();
    }

    // 3. HÀM XỬ LÝ CHUNG (KẾT HỢP LỌC VÀ SẮP XẾP CÙNG LÚC)
    function applyFilterAndSort() {
        const grid = document.getElementById('voucherGrid');
        let items = Array.from(grid.getElementsByClassName('voucher-item'));
        const sortType = document.getElementById('sortSelect').value;

        // Bước A: Lọc (Filter)
        items.forEach(item => {
            const itemCat = item.getAttribute('data-category');
            if (currentCategory === 'All' || itemCat === currentCategory || itemCat === 'All') {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });

        // Bước B: Lấy danh sách các item đang hiển thị để đem đi Sắp xếp
        let visibleItems = items.filter(item => item.style.display === 'block');

        if (sortType === 'discountDesc') {
            // Sắp xếp Giảm giá từ Cao -> Thấp
            visibleItems.sort((a, b) => parseFloat(b.getAttribute('data-discount')) - parseFloat(a.getAttribute('data-discount')));
        } else if (sortType === 'expiringSoon') {
            // Sắp xếp Ngày hết hạn gần nhất lên đầu
            visibleItems.sort((a, b) => new Date(a.getAttribute('data-enddate')) - new Date(b.getAttribute('data-enddate')));
        }

        // Bước C: Vẽ lại DOM theo thứ tự mới
        visibleItems.forEach(item => grid.appendChild(item));
    }

    // 4. CHỨC NĂNG COPY MÃ
    function copyCode(code, btn) {
        navigator.clipboard.writeText(code).then(() => {
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fa-solid fa-check"></i> Đã sao chép';
            btn.style.background = '#28a745'; // Đổi màu xanh lá

            // Trả lại trạng thái cũ sau 2 giây
            setTimeout(() => {
                btn.innerHTML = originalText;
                btn.style.background = '#0194f3';
            }, 2000);
        });
    }
</script>
</body>
</html>
