<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Trang chủ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>
<body>
<c:choose>

    <c:when test="${sessionScope.user != null
                    && sessionScope.user.roleID ==4}">

        <jsp:include page="/views/common/customer-header.jsp"/>

    </c:when>

    <c:otherwise>

        <jsp:include page="/views/common/client-header.jsp"/>

    </c:otherwise>

</c:choose>

<main>
    <section class="hero">
        <div class="container hero-grid">
            <div class="hero-content">
                <p class="eyebrow">Khám phá Việt Nam cùng WonderVN</p>
                <h1>Đặt tour, khách sạn, thuê xe và dịch vụ cộng thêm dễ dàng</h1>
                <p class="hero-desc">WonderVN giúp bạn tìm chuyến đi phù hợp, rõ lịch trình, rõ giá và dễ theo dõi trong một hệ thống.</p>

                <div class="search-panel">
                    <div class="search-tabs">
                        <button class="tab-btn active" type="button" data-tab="tour">Tour trọn gói</button>
                        <button class="tab-btn" type="button" data-tab="hotel">Khách sạn</button>
                        <button class="tab-btn" type="button" data-tab="vehicle">Thuê xe</button>
                        <button class="tab-btn" type="button" data-tab="service">Dịch vụ cộng thêm</button>
                    </div>

                    <form class="search-form" action="${pageContext.request.contextPath}/search" method="get">
                        <input type="hidden" id="searchType" name="type" value="tour">

                        <label>
                            <span>Điểm khởi hành</span>
                            <select name="from">
                                <option>TP. Hồ Chí Minh</option>
                                <option>Hà Nội</option>
                                <option>Đà Nẵng</option>
                                <option>Cần Thơ</option>
                                <option>Hải Phòng</option>
                            </select>
                        </label>

                        <label>
                            <span>Điểm đến</span>
                            <select name="to">
                                <option value="">Chọn điểm đến</option>
                                <option>Đà Nẵng</option>
                                <option>Đà Lạt</option>
                                <option>Phú Quốc</option>
                                <option>Nha Trang</option>
                                <option>Hạ Long</option>
                                <option>Sa Pa</option>
                            </select>
                        </label>

                        <label>
                            <span>Ngày đi</span>
                            <input type="date" name="startDate">
                        </label>

                        <button class="primary-btn" type="submit">Tìm kiếm</button>
                    </form>
                </div>
            </div>

            <div class="hero-art">✈</div>
        </div>
    </section>

    <section class="section">
        <div class="section-head">
            <div>
                <p class="section-kicker">Tour nổi bật</p>
                <h2>Hành trình được nhiều khách quan tâm</h2>
                <p>Các tour nổi bật do WonderVN trực tiếp thiết kế và quản lý.</p>
            </div>
            <a class="outline-btn" href="${pageContext.request.contextPath}/tour">Xem thêm</a>
        </div>

        <div class="tour-grid">
            <article class="tour-card">
                <div class="tour-image image-ha-long"></div>
                <div class="tour-body">
                    <h3>Hà Nội, Ninh Bình, Hạ Long 4N3Đ</h3>
                    <p>Khởi hành: TP. Hồ Chí Minh</p>
                    <p>Thời lượng: 4 ngày 3 đêm</p>
                    <p>Lịch gần nhất: 15/06/2026</p>
                    <div class="tour-price-row">
                        <div><span>Giá từ</span><strong>5.990.000đ</strong></div>
                        <a href="${pageContext.request.contextPath}/tour-detail?id=1">Xem chi tiết</a>
                    </div>
                </div>
            </article>

            <article class="tour-card">
                <div class="tour-image image-da-nang"></div>
                <div class="tour-body">
                    <h3>Đà Nẵng, Hội An, Bà Nà Hills 3N2Đ</h3>
                    <p>Khởi hành: Hà Nội</p>
                    <p>Thời lượng: 3 ngày 2 đêm</p>
                    <p>Lịch gần nhất: 20/06/2026</p>
                    <div class="tour-price-row">
                        <div><span>Giá từ</span><strong>4.590.000đ</strong></div>
                        <a href="${pageContext.request.contextPath}/tour-detail?id=2">Xem chi tiết</a>
                    </div>
                </div>
            </article>

            <article class="tour-card">
                <div class="tour-image image-phu-quoc"></div>
                <div class="tour-body">
                    <h3>Phú Quốc, VinWonders, Grand World 3N2Đ</h3>
                    <p>Khởi hành: TP. Hồ Chí Minh</p>
                    <p>Thời lượng: 3 ngày 2 đêm</p>
                    <p>Lịch gần nhất: 25/06/2026</p>
                    <div class="tour-price-row">
                        <div><span>Giá từ</span><strong>6.490.000đ</strong></div>
                        <a href="${pageContext.request.contextPath}/tour-detail?id=3">Xem chi tiết</a>
                    </div>
                </div>
            </article>

            <article class="tour-card">
                <div class="tour-image image-sapa"></div>
                <div class="tour-body">
                    <h3>Sa Pa, Fansipan, Bản Cát Cát 3N2Đ</h3>
                    <p>Khởi hành: Hà Nội</p>
                    <p>Thời lượng: 3 ngày 2 đêm</p>
                    <p>Lịch gần nhất: 28/06/2026</p>
                    <div class="tour-price-row">
                        <div><span>Giá từ</span><strong>3.990.000đ</strong></div>
                        <a href="${pageContext.request.contextPath}/tour-detail?id=4">Xem chi tiết</a>
                    </div>
                </div>
            </article>
        </div>
    </section>

    <section class="section package-section">
        <div class="section-head">
            <div>
                <p class="section-kicker">Tour trọn gói WonderVN</p>
                <h2>Tour do công ty trực tiếp tạo và quản lý</h2>
                <p>Mỗi tour có lịch khởi hành, số chỗ, giá bán và chương trình rõ ràng.</p>
            </div>
            <a class="outline-btn" href="${pageContext.request.contextPath}/tours">Xem thêm</a>
        </div>

        <div class="filter-list">
            <button class="filter-btn active" type="button" data-region="all">Tất cả</button>
            <button class="filter-btn" type="button" data-region="north">Miền Bắc</button>
            <button class="filter-btn" type="button" data-region="central">Miền Trung</button>
            <button class="filter-btn" type="button" data-region="south">Miền Nam</button>
            <button class="filter-btn" type="button" data-region="international">Nước ngoài</button>
        </div>

        <div class="tour-grid">
            <%-- Sau này thay các card mẫu bằng vòng lặp JSTL từ requestScope.packageTours --%>
            <article class="tour-card package-card" data-region="north">
                <div class="tour-image image-moc-chau"></div>
                <div class="tour-body">
                    <h3>Mộc Châu, Nông Trường Chè, Rừng Thông Bản Áng</h3>
                    <p>Mã chương trình: <strong>NDHAN120</strong></p>
                    <p>Khởi hành: Hà Nội</p>
                    <p>Thời lượng: 2 ngày 1 đêm</p>
                    <div class="date-list"><span>13/06</span><span>20/06</span><span>27/06</span></div>
                    <div class="tour-price-row">
                        <div><span>Giá từ</span><strong>2.190.000đ</strong></div>
                        <a href="${pageContext.request.contextPath}/tour-detail?id=5">Xem chi tiết</a>
                    </div>
                </div>
            </article>

            <article class="tour-card package-card" data-region="north">
                <div class="tour-image image-cao-bang"></div>
                <div class="tour-body">
                    <h3>Tinh Hoa Cực Bắc, Lạng Sơn, Cao Bằng</h3>
                    <p>Mã chương trình: <strong>NDSGN150</strong></p>
                    <p>Khởi hành: TP. Hồ Chí Minh</p>
                    <p>Thời lượng: 6 ngày 5 đêm</p>
                    <div class="date-list"><span>02/06</span><span>09/06</span><span>16/06</span></div>
                    <div class="tour-price-row">
                        <div><span>Giá từ</span><strong>13.190.000đ</strong></div>
                        <a href="${pageContext.request.contextPath}/tour-detail?id=6">Xem chi tiết</a>
                    </div>
                </div>
            </article>

            <article class="tour-card package-card" data-region="central">
                <div class="tour-image image-da-nang"></div>
                <div class="tour-body">
                    <h3>Đà Nẵng, Hội An, Huế 4N3Đ</h3>
                    <p>Mã chương trình: <strong>WVNMT221</strong></p>
                    <p>Khởi hành: Hà Nội</p>
                    <p>Thời lượng: 4 ngày 3 đêm</p>
                    <div class="date-list"><span>18/06</span><span>09/07</span><span>23/07</span></div>
                    <div class="tour-price-row">
                        <div><span>Giá từ</span><strong>7.990.000đ</strong></div>
                        <a href="${pageContext.request.contextPath}/tour-detail?id=7">Xem chi tiết</a>
                    </div>
                </div>
            </article>

            <article class="tour-card package-card" data-region="south">
                <div class="tour-image image-phu-quoc"></div>
                <div class="tour-body">
                    <h3>Phú Quốc, Hòn Thơm, Sunset Town 3N2Đ</h3>
                    <p>Mã chương trình: <strong>WVNPQ330</strong></p>
                    <p>Khởi hành: TP. Hồ Chí Minh</p>
                    <p>Thời lượng: 3 ngày 2 đêm</p>
                    <div class="date-list"><span>21/06</span><span>05/07</span><span>19/07</span></div>
                    <div class="tour-price-row">
                        <div><span>Giá từ</span><strong>6.290.000đ</strong></div>
                        <a href="${pageContext.request.contextPath}/tour-detail?id=8">Xem chi tiết</a>
                    </div>
                </div>
            </article>
        </div>

        <div class="popular-searches">
            <span>Tìm kiếm nổi bật:</span>
            <a href="#">Hà Giang</a>
            <a href="#">Quảng Ninh</a>
            <a href="#">Lào Cai</a>
            <a href="#">Ninh Bình</a>
            <a href="#">Cao Bằng</a>
        </div>
    </section>

    <section class="section">
        <div class="section-head">
            <div>
                <p class="section-kicker">Dịch vụ cộng thêm</p>
                <h2>Hoàn thiện chuyến đi theo nhu cầu</h2>
                <p>Các dịch vụ có thể đặt riêng hoặc thêm vào lịch trình của khách.</p>
            </div>
        </div>

        <div class="service-grid">
            <a class="service-card" href="${pageContext.request.contextPath}/accommodation">
                <span>🏨</span>
                <h3>Khách sạn</h3>
                <p>Đặt phòng theo ngày đi và nhu cầu lưu trú.</p>
            </a>

            <article class="service-card">
                <span>🚗</span>
                <h3>Thuê xe</h3>
                <p>Xe du lịch có tài xế, hỗ trợ đón trả theo lịch.</p>
            </article>

            <article class="service-card">
                <span>🎟️</span>
                <h3>Vé vui chơi</h3>
                <p>Hỗ trợ đặt vé tham quan, khu vui chơi, trải nghiệm.</p>
            </article>

            <article class="service-card">
                <span>🍽️</span>
                <h3>Nhà hàng</h3>
                <p>Gợi ý bữa ăn phù hợp với lịch trình của đoàn.</p>
            </article>
            <article class="service-card"><span>🏨</span><h3>Khách sạn</h3><p>Đặt phòng theo ngày đi và nhu cầu lưu trú.</p></article>
            <article class="service-card"><span>🚗</span><h3>Thuê xe</h3><p>Xe du lịch có tài xế, hỗ trợ đón trả theo lịch.</p></article>
            <article class="service-card"><span>🎟️</span><h3>Vé vui chơi</h3><p>Hỗ trợ đặt vé tham quan, khu vui chơi, trải nghiệm.</p></article>
            <article class="service-card"><span>🍽️</span><h3>Nhà hàng</h3><p>Gợi ý bữa ăn phù hợp với lịch trình của đoàn.</p></article>
        </div>
    </section>
</main>

<jsp:include page="common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

<c:if test="${not empty sessionScope.successMessage}">
    <div id="successToast" class="success-toast">
        <div class="toast-body">
            <div class="toast-icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                </svg>
            </div>
            <div class="toast-content">
                <span class="toast-title">Đặt Tour Thành Công!</span>
                <p class="toast-desc">${sessionScope.successMessage}</p>
            </div>
            <button type="button" class="toast-close-btn" onclick="dismissToast()">×</button>
        </div>
        <div class="toast-progress"></div>
    </div>

    <style>
        .success-toast {
            position: fixed;
            top: 30px;
            right: 30px;
            background-color: #ffffff;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            padding: 16px;
            z-index: 9999;
            min-width: 320px;
            max-width: 400px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            animation: slideInToast 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
        }

        .toast-body {
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .toast-icon {
            color: #10b981;
            width: 28px;
            height: 28px;
            flex-shrink: 0;
        }

        .toast-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .toast-title {
            font-weight: 700;
            color: #0f172a;
            font-size: 15px;
        }

        .toast-desc {
            color: #64748b;
            font-size: 13.5px;
            margin: 0;
            line-height: 1.4;
        }

        .toast-close-btn {
            background: none;
            border: none;
            color: #94a3b8;
            font-size: 20px;
            cursor: pointer;
            padding: 0 4px;
            line-height: 1;
            transition: color 0.2s;
        }

        .toast-close-btn:hover {
            color: #475569;
        }

        .toast-progress {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 4px;
            background-color: #10b981;
            width: 100%;
            animation: progressCount 5s linear forwards;
        }

        @keyframes slideInToast {
            from {
                transform: translateX(120%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOutToast {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(120%);
                opacity: 0;
            }
        }

        @keyframes progressCount {
            from { width: 100%; }
            to { width: 0%; }
        }
    </style>

    <script>
        function dismissToast() {
            const toast = document.getElementById('successToast');
            if (toast) {
                toast.style.animation = 'slideOutToast 0.4s ease-in forwards';
                setTimeout(() => {
                    toast.remove();
                }, 400);
            }
        }
        setTimeout(dismissToast, 5000);
    </script>

    <c:remove var="successMessage" scope="session" />
</c:if>
</body>
</html>