<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân - WonderVN Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-tour.css">
</head>
<body>
<div class="staff-layout">
    <jsp:include page="/WEB-INF/views/staff/layout/staff-navbar.jsp" />

    <main class="staff-main">
        <header class="staff-topbar">🔔 &nbsp; ◎</header>

        <section class="staff-content">
            <div class="breadcrumb">Staff / Hồ sơ cá nhân</div>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Hồ sơ cá nhân</h1>
                    <div class="page-subtitle">Trang này chỉ dùng để xem/cập nhật thông tin cá nhân của tài khoản staff đang đăng nhập. Phân công nhân sự tour nằm ở menu Phân công nhân sự.</div>
                </div>
                <a class="btn" href="${pageContext.request.contextPath}/staff/assignments">Phân công nhân sự →</a>
            </div>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success"><c:out value="${param.success}" /></div>
            </c:if>
            <c:if test="${not empty systemError}">
                <div class="alert alert-error"><c:out value="${systemError}" /></div>
            </c:if>
            <c:if test="${not empty fieldErrors.profile}">
                <div class="alert alert-error"><c:out value="${fieldErrors.profile}" /></div>
            </c:if>

            <c:choose>
                <c:when test="${empty profile}">
                    <div class="card card-section">Chưa có hồ sơ nhân viên để hiển thị.</div>
                </c:when>
                <c:otherwise>
                    <div class="profile-layout-grid">
                        <aside class="card card-section profile-summary-card">
                            <div class="profile-avatar-large"><c:out value="${profile.avatarText}" /></div>
                            <h2><c:out value="${profile.fullName}" /></h2>
                            <p><c:out value="${profile.staffCode}" /> · <c:out value="${profile.staffTypeText}" /></p>
                            <div class="profile-info-list">
                                <div><span>Email</span><strong><c:out value="${profile.email}" /></strong></div>
                                <div><span>Số điện thoại</span><strong><c:out value="${profile.phone}" /></strong></div>
                                <div><span>Chức vụ</span><strong><c:out value="${profile.position}" /></strong></div>
                                <div><span>Khu vực</span><strong><c:out value="${profile.workRegionText}" /></strong></div>
                                <div><span>Trạng thái</span><strong><c:out value="${profile.workStatusText}" /></strong></div>
                            </div>
                        </aside>

                        <form class="card card-section" method="post" action="${pageContext.request.contextPath}/staff/profile">
                            <input type="hidden" name="userID" value="${profile.userID}">
                            <input type="hidden" name="staffID" value="${profile.staffID}">

                            <h2 class="section-title"><span class="section-index">1</span> Thông tin cá nhân</h2>
                            <div class="form-grid grid-2">
                                <div class="form-group">
                                    <label>Họ <span class="required">*</span></label>
                                    <input class="form-control" name="lastName" value="${profile.lastName}" required>
                                    <c:if test="${not empty fieldErrors.lastName}"><small class="field-error"><c:out value="${fieldErrors.lastName}" /></small></c:if>
                                </div>
                                <div class="form-group">
                                    <label>Tên <span class="required">*</span></label>
                                    <input class="form-control" name="firstName" value="${profile.firstName}" required>
                                    <c:if test="${not empty fieldErrors.firstName}"><small class="field-error"><c:out value="${fieldErrors.firstName}" /></small></c:if>
                                </div>
                                <div class="form-group">
                                    <label>Email</label>
                                    <input class="form-control" value="${profile.email}" readonly>
                                    <small class="form-hint">Email đăng nhập không sửa tại trang hồ sơ.</small>
                                </div>
                                <div class="form-group">
                                    <label>Số điện thoại</label>
                                    <input class="form-control" name="phone" value="${profile.phone}">
                                    <c:if test="${not empty fieldErrors.phone}"><small class="field-error"><c:out value="${fieldErrors.phone}" /></small></c:if>
                                </div>
                                <div class="form-group">
                                    <label>Giới tính</label>
                                    <select class="form-select" name="gender">
                                        <option value="">Chưa cập nhật</option>
                                        <option value="Male" ${profile.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                        <option value="Female" ${profile.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                        <option value="Other" ${profile.gender == 'Other' ? 'selected' : ''}>Khác</option>
                                    </select>
                                    <c:if test="${not empty fieldErrors.gender}"><small class="field-error"><c:out value="${fieldErrors.gender}" /></small></c:if>
                                </div>
                                <div class="form-group">
                                    <label>Ngày vào làm</label>
                                    <input class="form-control" value="${profile.hireDate}" readonly>
                                </div>
                            </div>

                            <h2 class="section-title section-title-spaced"><span class="section-index">2</span> Thông tin nghiệp vụ</h2>
                            <div class="form-grid grid-2">
                                <div class="form-group">
                                    <label>Chức vụ</label>
                                    <input class="form-control" name="position" value="${profile.position}">
                                </div>
                                <div class="form-group">
                                    <label>Khu vực làm việc</label>
                                    <select class="form-select" name="workRegion">
                                        <option value="">Chưa cập nhật</option>
                                        <option value="North" ${profile.workRegion == 'North' ? 'selected' : ''}>Miền Bắc</option>
                                        <option value="Central" ${profile.workRegion == 'Central' ? 'selected' : ''}>Miền Trung</option>
                                        <option value="South" ${profile.workRegion == 'South' ? 'selected' : ''}>Miền Nam</option>
                                        <option value="All" ${profile.workRegion == 'All' ? 'selected' : ''}>Toàn quốc</option>
                                    </select>
                                    <c:if test="${not empty fieldErrors.workRegion}"><small class="field-error"><c:out value="${fieldErrors.workRegion}" /></small></c:if>
                                </div>
                                <div class="form-group">
                                    <label>Số GPLX</label>
                                    <input class="form-control" name="licenseNumber" value="${profile.licenseNumber}">
                                </div>
                                <div class="form-group">
                                    <label>Hạng bằng lái</label>
                                    <input class="form-control" name="licenseClass" value="${profile.licenseClass}">
                                </div>
                                <div class="form-group">
                                    <label>Số thẻ HDV</label>
                                    <input class="form-control" name="guideLicenseNo" value="${profile.guideLicenseNo}">
                                </div>
                                <div class="form-group">
                                    <label>Ngôn ngữ</label>
                                    <input class="form-control" name="languages" value="${profile.languages}" placeholder="Vietnamese, English...">
                                </div>
                            </div>

                            <div class="form-actions">
                                <button class="btn btn-primary" type="submit" id="saveProfileBtn">Lưu hồ sơ</button>
                                <a class="btn" href="${pageContext.request.contextPath}/staff/profile">Hủy thay đổi</a>
                            </div>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>
</body>
</html>
