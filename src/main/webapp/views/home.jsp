<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Trang chủ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=1000">
</head>
<body>

<jsp:include page="/views/common/client-header.jsp" />

<main class="home-page">

    <section class="hero-v2">
        <div class="hero-bg-shape hero-shape-one"></div>
        <div class="hero-bg-shape hero-shape-two"></div>

        <div class="home-container hero-layout">
            <div class="hero-left">
                <div class="hero-pill">
                    <span>🇻🇳</span>
                    <strong>Khám phá Việt Nam cùng WonderVN</strong>
                </div>

                <h1>
                    Đặt tour, khách sạn,
                    thuê xe và dịch vụ cộng thêm
                    <span>dễ dàng hơn bao giờ hết</span>
                </h1>

                <p class="hero-desc">
                    Tìm chuyến đi phù hợp, chọn nơi lưu trú đẹp, thuê xe linh hoạt và quản lý hành trình
                    trong một hệ thống hiện đại, rõ giá, rõ lịch trình và thân thiện với khách hàng.
                </p>

                <div class="hero-actions">
                    <a class="hero-primary" href="${pageContext.request.contextPath}/tour">
                        Khám phá tour ngay
                    </a>
                    <a class="hero-secondary" href="${pageContext.request.contextPath}/accommodation">
                        Tìm khách sạn
                    </a>
                </div>

                <div class="hero-stats">
                    <div>
                        <strong>30+</strong>
                        <span>Tỉnh thành</span>
                    </div>
                    <div>
                        <strong>500+</strong>
                        <span>Dịch vụ du lịch</span>
                    </div>
                    <div>
                        <strong>24/7</strong>
                        <span>Hỗ trợ khách hàng</span>
                    </div>
                </div>

                <div class="search-panel">
                    <div class="search-tabs">
                        <button class="tab-btn active" type="button" data-tab="tour">Tour trọn gói</button>
                        <button class="tab-btn" type="button" data-tab="hotel">Khách sạn</button>
                        <button class="tab-btn" type="button" data-tab="vehicle">Thuê xe</button>
                        <button class="tab-btn" type="button" data-tab="service">Dịch vụ cộng thêm</button>
                    </div>
                    <form class="search-form" id="homeSearchForm" action="${pageContext.request.contextPath}/tour" method="get">
                        <input type="hidden" id="searchType" name="type" value="tour">

                        <label>
                            <span id="fieldOneLabel">Điểm khởi hành</span>
                            <select id="fieldOneInput" name="from">
                                <option>Hà Nội</option>
                                <option>TP. Hồ Chí Minh</option>
                                <option>Đà Nẵng</option>
                                <option>Hải Phòng</option>
                                <option>Cần Thơ</option>
                            </select>
                        </label>

                        <label>
                            <span id="fieldTwoLabel">Điểm đến</span>
                            <select id="fieldTwoInput" name="destination">
                                <option value="">Chọn điểm đến</option>
                                <option>Đà Nẵng</option>
                                <option>Hạ Long</option>
                                <option>Sa Pa</option>
                                <option>Ninh Bình</option>
                                <option>Phú Quốc</option>
                            </select>
                        </label>

                        <label>
                            <span id="fieldThreeLabel">Ngày đi</span>
                            <input id="fieldThreeInput" type="date" name="startDate">
                        </label>

                        <button class="primary-btn" id="searchSubmitBtn" type="submit">
                            Tìm tour
                        </button>
                    </form>
                </div>
            </div>

            <div class="hero-right">
                <div class="hero-photo-card">
                    <img src="${pageContext.request.contextPath}/assets/images/home/hero-bana.png"
                         alt="Cầu Vàng Bà Nà Hills"
                         onerror="this.src='https://images.unsplash.com/photo-1566139397190-1ca967d5e58d?auto=format&fit=crop&w=1200&q=80';">

                    <div class="photo-gradient"></div>

                    <div class="floating-badge top">
                        <span>⭐</span>
                        <div>
                            <strong>4.9/5</strong>
                            <small>Trải nghiệm nổi bật</small>
                        </div>
                    </div>

                    <div class="floating-badge bottom">
                        <span>📍</span>
                        <div>
                            <strong>Bà Nà Hills, Đà Nẵng</strong>
                            <small>Check-in Cầu Vàng cực hot</small>
                        </div>
                    </div>
                </div>
                <div class="mini-card mini-card-one">
                    <span>🏨</span>
                    <strong>Khách sạn đẹp</strong>
                    <small>Tìm nhanh theo tiện ích</small>
                </div>

                <div class="mini-card mini-card-two">
                    <span>🚗</span>
                    <strong>Thuê xe dễ dàng</strong>
                    <small>Nhận xe theo địa điểm</small>
                </div>
            </div>
        </div>
    </section>

    <section class="section quick-service-section">
        <div class="home-container">
            <div class="section-head">
                <div>
                    <p class="section-kicker">Dịch vụ WonderVN</p>
                    <h2>Chọn nhanh dịch vụ bạn cần</h2>
                    <p>Một hệ sinh thái cho tour, lưu trú, phương tiện và dịch vụ bổ sung.</p>
                </div>
            </div>

            <div class="service-grid">
                <a class="service-card" href="${pageContext.request.contextPath}/tour">
                    <span class="service-icon">🧳</span>
                    <h3>Tour trọn gói</h3>
                    <p>Lịch trình rõ ràng, giá minh bạch, phù hợp nhóm bạn và gia đình.</p>
                </a>

                <a class="service-card" href="${pageContext.request.contextPath}/accommodation">
                    <span class="service-icon">🏨</span>
                    <h3>Khách sạn & Homestay</h3>
                    <p>Lọc theo địa điểm, tiện ích, số khách, giá phòng và đánh giá.</p>
                </a>

                <a class="service-card" href="${pageContext.request.contextPath}/vehicle">
                    <span class="service-icon">🚗</span>
                    <h3>Thuê xe</h3>
                    <p>Xe máy, ô tô, SUV, xe du lịch với giá thuê nổi bật từng ngày.</p>
                </a>

                <a class="service-card" href="${pageContext.request.contextPath}/service">
                    <span class="service-icon">🎉</span>
                    <h3>Dịch vụ cộng thêm</h3>
                    <p>Vé vui chơi, nhà hàng, trải nghiệm và tiện ích đi kèm.</p>
                </a>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="home-container">
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
                    <div class="tour-image image-ha-long">
                        <span>Hot</span>
                    </div>
                    <div class="tour-body">
                        <h3>Hà Nội, Ninh Bình, Hạ Long 4N3Đ</h3>
                        <p>Khởi hành: TP. Hồ Chí Minh</p>
                        <p>Thời lượng: 4 ngày 3 đêm</p>
                        <p>Lịch gần nhất: 15/06/2026</p>
                        <div class="tour-price-row">
                            <div>
                                <span>Giá từ</span>
                                <strong>5.990.000đ</strong>
                            </div>
                            <a href="${pageContext.request.contextPath}/tour-detail?id=1">Xem chi tiết</a>
                        </div>
                    </div>
                </article>

                <article class="tour-card">
                    <div class="tour-image image-da-nang">
                        <span>Best choice</span>
                    </div>
                    <div class="tour-body">
                        <h3>Đà Nẵng, Hội An, Bà Nà Hills 3N2Đ</h3>
                        <p>Khởi hành: Hà Nội</p>
                        <p>Thời lượng: 3 ngày 2 đêm</p>
                        <p>Lịch gần nhất: 20/06/2026</p>
                        <div class="tour-price-row">
                            <div>
                                <span>Giá từ</span>
                                <strong>4.590.000đ</strong>
                            </div>
                            <a href="${pageContext.request.contextPath}/tour-detail?id=2">Xem chi tiết</a>
                        </div>
                    </div>
                </article>

                <article class="tour-card">
                    <div class="tour-image image-phu-quoc">
                        <span>New</span>
                    </div>
                    <div class="tour-body">
                        <h3>Phú Quốc, VinWonders, Grand World 3N2Đ</h3>
                        <p>Khởi hành: TP. Hồ Chí Minh</p>
                        <p>Thời lượng: 3 ngày 2 đêm</p>
                        <p>Lịch gần nhất: 25/06/2026</p>
                        <div class="tour-price-row">
                            <div>
                                <span>Giá từ</span>
                                <strong>6.490.000đ</strong>
                            </div>
                            <a href="${pageContext.request.contextPath}/tour-detail?id=3">Xem chi tiết</a>
                        </div>
                    </div>
                </article>

                <article class="tour-card">
                    <div class="tour-image image-sapa">
                        <span>Popular</span>
                    </div>
                    <div class="tour-body">
                        <h3>Sa Pa, Fansipan, Bản Cát Cát 3N2Đ</h3>
                        <p>Khởi hành: Hà Nội</p>
                        <p>Thời lượng: 3 ngày 2 đêm</p>
                        <p>Lịch gần nhất: 28/06/2026</p>
                        <div class="tour-price-row">
                            <div>
                                <span>Giá từ</span>
                                <strong>3.990.000đ</strong>
                            </div>
                            <a href="${pageContext.request.contextPath}/tour-detail?id=4">Xem chi tiết</a>
                        </div>
                    </div>
                </article>
            </div>
        </div>
    </section>

    <section class="section package-section">
        <div class="home-container">
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
                <article class="tour-card package-card" data-region="north">
                    <div class="tour-image image-moc-chau"><span>Miền Bắc</span></div>
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
                    <div class="tour-image image-cao-bang"><span>Miền Bắc</span></div>
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
                    <div class="tour-image image-da-nang"><span>Miền Trung</span></div>
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
                    <div class="tour-image image-phu-quoc"><span>Miền Nam</span></div>
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
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
<c:if test="${not empty sessionScope.successMessage}">
    <div id="successToast" class="success-toast">
        <div class="toast-body">
            <div class="toast-icon">✓</div>
            <div class="toast-content">
                <span class="toast-title">Đặt Tour Thành Công!</span>
                <p class="toast-desc">${sessionScope.successMessage}</p>
            </div>
            <button type="button" class="toast-close-btn" onclick="dismissToast()">×</button>
        </div>
        <div class="toast-progress"></div>
    </div>
    <c:remove var="successMessage" scope="session" />
</c:if>

</body>
</html>
