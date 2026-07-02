<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách tour - WonderVN Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-tour.css">
</head>
<body>
<div class="staff-layout">
    <jsp:include page="/WEB-INF/views/staff/layout/staff-navbar.jsp" />

    <main class="staff-main">
        <header class="staff-topbar">🔔 &nbsp; ◎</header>

        <section class="staff-content">
            <div class="page-header">
                <div>
                    <h1 class="page-title">Danh sách tour</h1>
                    <div class="page-subtitle">Quản lý các tour do công ty tự tạo, tự bán và tự vận hành.</div>
                </div>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/staff/tours/create">+ Tạo tour mới</a>
            </div>

            <form class="card filter-card" method="get" action="${pageContext.request.contextPath}/staff/tours">
                <div class="filter-row">
                    <input class="form-control" name="keyword" value="${keyword}" placeholder="Tìm theo mã tour hoặc tên tour...">

                    <select class="form-select" name="status">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Draft" ${status == 'Draft' ? 'selected' : ''}>Nháp</option>
                        <option value="PendingApproval" ${status == 'PendingApproval' ? 'selected' : ''}>Chờ duyệt</option>
                        <option value="Selling" ${status == 'Selling' ? 'selected' : ''}>Đang bán</option>
                        <option value="SoldOut" ${status == 'SoldOut' ? 'selected' : ''}>Đã bán</option>
                        <option value="Approved" ${status == 'Approved' ? 'selected' : ''}>Approved cũ</option>
                        <option value="Rejected" ${status == 'Rejected' ? 'selected' : ''}>Bị từ chối</option>
                        <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                        <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                    </select>

                    <select class="form-select" name="regionID">
                        <option value="">Tất cả khu vực</option>
                        <c:forEach var="region" items="${regions}">
                            <option value="${region.value}" ${regionID == region.value ? 'selected' : ''}>
                                <c:out value="${region.label}" />
                            </option>
                        </c:forEach>
                    </select>

                    <select class="form-select" name="categoryID">
                        <option value="">Tất cả danh mục</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.value}" ${categoryID == category.value ? 'selected' : ''}>
                                <c:out value="${category.label}" />
                            </option>
                        </c:forEach>
                    </select>

                    <button class="btn" type="submit">Lọc</button>
                </div>
            </form>

            <div class="card table-card">
                <table class="tour-table">
                    <thead>
                    <tr>
                        <th>Mã tour</th>
                        <th>Tên tour</th>
                        <th>Danh mục</th>
                        <th>Khu vực</th>
                        <th>Thời lượng</th>
                        <th>Lịch</th>
                        <th>Trạng thái</th>
                        <th>Cập nhật</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${empty tours}">
                            <tr>
                                <td colspan="9">Chưa có tour nào.</td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="tour" items="${tours}">
                                <tr>
                                    <td><strong><c:out value="${tour.tourCode}" /></strong></td>
                                    <td>
                                        <strong><c:out value="${tour.tourName}" /></strong>
                                        <br>
                                        <small><c:out value="${tour.destination}" /></small>
                                    </td>
                                    <td><c:out value="${tour.tourCategoryName}" /></td>
                                    <td><c:out value="${tour.regionName}" /></td>
                                    <td><c:out value="${tour.numberOfDays}" /> ngày <c:out value="${tour.numberOfNights}" /> đêm</td>
                                    <td><c:out value="${tour.scheduleCount}" /> lịch</td>
                                    <td>
                                        <span class="status-pill ${tour.statusCssClass}">
                                            <c:out value="${tour.tourStatusText}" />
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty tour.updatedAt}">
                                                <fmt:formatDate value="${tour.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatDate value="${tour.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-links">
                                            <a href="${pageContext.request.contextPath}/staff/tours/view?id=${tour.tourID}">Xem</a>
                                            <c:if test="${tour.tourStatus == 'Draft' || tour.tourStatus == 'Rejected' || tour.tourStatus == 'Selling' || tour.tourStatus == 'Approved'}">
                                                <a href="${pageContext.request.contextPath}/staff/tours/edit?id=${tour.tourID}">Sửa</a>
                                            </c:if>

                                            <c:if test="${tour.tourStatus == 'Draft' || tour.tourStatus == 'Rejected'}">
                                                <form method="post" action="${pageContext.request.contextPath}/staff/tours/submit" style="display:inline">
                                                    <input type="hidden" name="tourID" value="${tour.tourID}">
                                                    <button type="submit">Gửi duyệt</button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<jsp:include page="/WEB-INF/views/staff/fragments/system-error-modal.jsp" />
</body>
</html>
