<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa tour - WonderVN Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-tour.css">
</head>
<body>
<div class="staff-layout">
    <jsp:include page="/WEB-INF/views/staff/layout/staff-navbar.jsp" />
    <main class="staff-main">
        <header class="staff-topbar">🔔 &nbsp; ◎</header>
        <section class="staff-content">
            <div class="breadcrumb">Quản lý tour / Chỉnh sửa tour</div>
            <div class="page-header">
                <div>
                    <h1 class="page-title">Chỉnh sửa tour</h1>
                    <div class="page-subtitle">
                        Mã tour: <strong><c:out value="${tour.tourCode}" /></strong> ·
                        Trạng thái: <span class="status-pill ${tour.statusCssClass}"><c:out value="${tour.tourStatusText}" /></span>
                    </div>
                </div>
                <a class="btn" href="${pageContext.request.contextPath}/staff/tours/view?id=${tour.tourID}">Xem chi tiết</a>
            </div>

            <c:if test="${not empty systemError}"><div class="card info-box error-box"><c:out value="${systemError}" /></div></c:if>
            <c:if test="${not tour.canEditBasic}">
                <div class="card info-box" style="margin-bottom:16px; border-color:#93c5fd;">
                    Tour đã qua bước duyệt. Bạn chỉ được thêm/sửa lịch khởi hành và giá nếu lịch đó chưa bị khóa.
                </div>
            </c:if>

            <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/staff/tours/edit">
                <input type="hidden" name="tourID" value="${tour.tourID}">
                <input type="hidden" name="existingCoverImageUrl" value="${tour.coverImageUrl}">
                <c:forEach var="img" items="${tour.imageUrls}"><input type="hidden" name="existingImageUrls" value="${img}"></c:forEach>
                <c:if test="${not tour.canEditBasic}">
                    <input type="hidden" name="mainTransportType" value="${tour.mainTransportType}">
                    <input type="hidden" name="vehicleSeatCount" value="${tour.vehicleSeatCount}">
                    <input type="hidden" name="numberOfDays" value="${tour.numberOfDays}">
                    <input type="hidden" name="numberOfNights" value="${tour.numberOfNights}">
                </c:if>

                <div class="form-full-width">
                    <div class="card card-section">
                        <h2 class="section-title"><span class="section-index">1</span>Thông tin cơ bản</h2>
                        <div class="form-grid grid-4">
                            <div class="form-group"><label>Tên tour</label><input class="form-control" name="tourName" value="${tour.tourName}" ${tour.canEditBasic ? '' : 'disabled'}></div>
                            <div class="form-group"><label>Mã tour</label><input class="form-control" value="${tour.tourCode}" readonly></div>
                            <div class="form-group"><label>Danh mục hiện tại</label><input class="form-control" value="${tour.tourCategoryName}" disabled></div>
                            <div class="form-group"><label>Khu vực hiện tại</label><input class="form-control" value="${tour.regionName}" disabled></div>
                        </div>

                        <c:if test="${tour.canEditBasic}">
                            <div class="form-grid grid-4" style="margin-top:14px;">
                                <div class="form-group"><label>Danh mục mới</label><select class="form-select" name="tourCategoryID"><option value="0">Giữ nguyên nếu không đổi</option><c:forEach var="category" items="${categories}"><option value="${category.value}"><c:out value="${category.label}" /></option></c:forEach></select></div>
                                <div class="form-group"><label>Khu vực mới</label><select class="form-select" name="regionID"><option value="">Giữ nguyên nếu không đổi</option><c:forEach var="region" items="${regions}"><option value="${region.value}"><c:out value="${region.label}" /></option></c:forEach></select></div>
                                <div class="form-group"><label>Điểm khởi hành mới</label><select class="form-select" name="departureDestinationID"><option value="">Giữ nguyên nếu không đổi</option><c:forEach var="d" items="${destinations}"><option value="${d.value}"><c:out value="${d.label}" /></option></c:forEach></select></div>
                                <div class="form-group"><label>Điểm đến mới</label><select class="form-select" name="destinationID"><option value="">Giữ nguyên nếu không đổi</option><c:forEach var="d" items="${destinations}"><option value="${d.value}"><c:out value="${d.label}" /></option></c:forEach></select></div>
                            </div>
                        </c:if>

                        <div class="form-grid grid-5" style="margin-top:14px;">
                            <div class="form-group"><label>Điểm tập kết</label><input class="form-control" name="pickupPointName" value="${tour.pickupPointName}" ${tour.canEditBasic ? '' : 'disabled'}></div>
                            <div class="form-group"><label>Giờ tập kết</label><input class="form-control" type="time" name="pickupTime" value="${tour.pickupTime}" ${tour.canEditBasic ? '' : 'disabled'}></div>
                            <div class="form-group"><label>Số ngày</label><input class="form-control" type="number" name="numberOfDays" value="${tour.numberOfDays}" ${tour.canEditBasic ? '' : 'disabled'}></div>
                            <div class="form-group"><label>Số đêm</label><input class="form-control" type="number" name="numberOfNights" value="${tour.numberOfNights}" ${tour.canEditBasic ? '' : 'disabled'}></div>
                            <div class="form-group"><label>Số chỗ</label><input class="form-control" type="number" name="vehicleSeatCount" value="${tour.vehicleSeatCount}" ${tour.canEditBasic ? '' : 'disabled'}></div>
                        </div>
                        <div class="form-grid grid-3" style="margin-top:14px;">
                            <div class="form-group"><label>Phương tiện</label><select class="form-select" name="mainTransportType" id="mainTransportType" ${tour.canEditBasic ? '' : 'disabled'}><option value="${tour.mainTransportType}">${tour.mainTransportType}</option><option value="Ô tô">Ô tô</option><option value="Xe khách">Xe khách</option><option value="Xe giường nằm">Xe giường nằm</option><option value="Đường sắt">Đường sắt</option></select></div>
                            <div class="form-group"><label>Mô tả ngắn</label><input class="form-control" name="shortDescription" value="${tour.shortDescription}" ${tour.canEditBasic ? '' : 'disabled'}></div>
                            <div class="form-group">
                                <label>Đổi/thêm ảnh</label>
                                <div class="upload-preview-row">
                                    <label class="upload-tile"><input type="file" name="coverImage" accept="image/*" class="image-input" data-preview="coverPreview" ${tour.canEditBasic ? '' : 'disabled'}><span>+ Ảnh bìa mới</span><c:if test="${not empty tour.coverImageUrl}"><img id="coverPreview" class="upload-preview-img" src="${pageContext.request.contextPath}/${tour.coverImageUrl}" alt="Ảnh bìa"></c:if></label>
                                    <label class="upload-tile"><input type="file" name="galleryImages" accept="image/*" multiple class="image-input" data-preview="galleryPreview" ${tour.canEditBasic ? '' : 'disabled'}><span>+ Thêm ảnh</span></label>
                                </div>
                                <div id="galleryPreview" class="gallery-preview"><c:forEach var="img" items="${tour.imageUrls}"><img src="${pageContext.request.contextPath}/${img}" alt="Ảnh tour"></c:forEach></div>
                            </div>
                        </div>
                        <div class="form-group" style="margin-top:14px;"><label>Mô tả chi tiết</label><textarea name="description" ${tour.canEditBasic ? '' : 'disabled'}>${tour.description}</textarea></div>
                    </div>

                    <div class="card card-section">
                        <h2 class="section-title"><span class="section-index">2</span>Lịch khởi hành & giá</h2>
                        <p class="help-text">Ngày chốt bán là hạn cuối nhận booking. Nếu hết hạn mà chưa đủ khách tối thiểu, hệ thống hiển thị cảnh báo để staff báo khách.</p>
                        <input type="hidden" id="scheduleCount" name="scheduleCount" value="${fn:length(tour.schedules)}">
                        <div id="scheduleHiddenContainer"></div>

                        <table class="tour-table compact-table">
                            <thead><tr><th>#</th><th>Khởi hành</th><th>Về</th><th>Hạn chót bán</th><th>Tối thiểu</th><th>Đã đặt/Tối đa</th><th>Guide</th><th>Lái xe</th><th>Giá</th><th>Trạng thái</th></tr></thead>
                            <tbody id="schedulePreviewBody">
                            <c:forEach var="s" items="${tour.schedules}" varStatus="st">
                                <tr data-index="${st.count}">
                                    <td>${st.count}<input type="hidden" name="tourScheduleID_${st.count}" value="${s.tourScheduleID}"><c:if test="${not s.editable}"><input type="hidden" name="scheduleSkip_${st.count}" value="1"></c:if></td>
                                    <td><c:choose><c:when test="${s.editable}"><input class="table-input" type="date" name="departureDate_${st.count}" value="${s.departureDate}"></c:when><c:otherwise>${s.departureDate}</c:otherwise></c:choose></td>
                                    <td><c:choose><c:when test="${s.editable}"><input class="table-input" type="date" name="returnDate_${st.count}" value="${s.returnDate}"></c:when><c:otherwise>${s.returnDate}</c:otherwise></c:choose></td>
                                    <td><c:choose><c:when test="${s.editable}"><input class="table-input" type="date" name="bookingCloseDate_${st.count}" value="${s.bookingCloseDate}"></c:when><c:otherwise><div>${s.bookingCloseDate}</div><small class="help-text">${s.saleDeadlineText}</small></c:otherwise></c:choose></td>
                                    <td><c:choose><c:when test="${s.editable}"><input class="table-input small" type="number" name="minParticipants_${st.count}" value="${s.minParticipants}"></c:when><c:otherwise>${s.minParticipants}</c:otherwise></c:choose></td>
                                    <td><span class="capacity ${s.minimumStatusCssClass}">${s.capacityText}</span><br><small>${s.minimumStatusText}</small><c:if test="${not empty s.saleWarning}"><br><small class="field-error">${s.saleWarning}</small></c:if><c:if test="${s.editable}"><input type="hidden" name="maxParticipants_${st.count}" value="${s.maxParticipants}"></c:if></td>
                                    <td><c:choose><c:when test="${s.editable}"><select class="table-input" name="guideStaffID_${st.count}"><option value="${s.guideStaffID}">${s.guideDisplay}</option><c:forEach var="g" items="${guides}"><option value="${g.staffID}">${g.staffCode} - ${g.fullName}</option></c:forEach></select></c:when><c:otherwise>${s.guideDisplay}</c:otherwise></c:choose></td>
                                    <td><c:choose><c:when test="${s.editable}"><select class="table-input" name="driverStaffID_${st.count}"><option value="${s.driverStaffID}">${s.driverDisplay}</option><c:forEach var="d" items="${drivers}"><option value="${d.staffID}">${d.staffCode} - ${d.fullName}</option></c:forEach></select></c:when><c:otherwise>${s.driverDisplay}</c:otherwise></c:choose></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.editable}">
                                                <div class="price-edit-grid">
                                                    <input class="table-input" name="adultPrice_${st.count}" value="${s.adultPrice}" placeholder="Người lớn">
                                                    <input class="table-input" name="childPrice_${st.count}" value="${s.childPrice}" placeholder="Trẻ em">
                                                    <input class="table-input" name="infantPrice_${st.count}" value="${s.infantPrice}" placeholder="Em bé">
                                                    <input class="table-input" name="singleRoomSurcharge_${st.count}" value="${s.singleRoomSurcharge}" placeholder="Phụ thu">
                                                    <input class="table-input" type="number" name="depositPercent_${st.count}" value="${s.depositPercent}" placeholder="Cọc %">
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="price-summary" data-tooltip="${s.priceTooltip}">${s.displayPriceText} VND</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><span class="status-pill ${s.scheduleStatusCssClass}">${s.scheduleStatusText}</span><c:if test="${not s.editable}"><br><small>${s.lockedReason}</small></c:if></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>

                        <c:if test="${tour.canAddOrEditSchedule}">
                            <div class="schedule-draft-box" style="margin-top:16px;">
                                <h3>Thêm lịch khởi hành mới</h3>
                                <div class="form-grid grid-5">
                                    <div class="form-group"><label>Ngày khởi hành</label><input class="form-control" type="date" id="draftDepartureDate"></div>
                                    <div class="form-group"><label>Ngày về</label><input class="form-control" type="date" id="draftReturnDate"></div>
                                    <div class="form-group"><label>Hạn chót bán</label><input class="form-control" type="date" id="draftBookingCloseDate"></div>
                                    <div class="form-group"><label>Tối thiểu</label><input class="form-control" type="number" id="draftMinParticipants" value="10"></div>
                                    <div class="form-group"><label>Tối đa</label><input class="form-control" type="number" id="draftMaxParticipants" value="${tour.vehicleSeatCount}"></div>
                                </div>
                                <div class="form-grid grid-4" style="margin-top:12px;"><div class="form-group"><label>Guide</label><select class="form-select" id="draftGuideStaffID"><option value="">Chọn</option><c:forEach var="g" items="${guides}"><option value="${g.staffID}">${g.staffCode} - ${g.fullName}</option></c:forEach></select></div><div class="form-group"><label>Lái xe</label><select class="form-select" id="draftDriverStaffID"><option value="">Chọn</option><c:forEach var="d" items="${drivers}"><option value="${d.staffID}">${d.staffCode} - ${d.fullName}</option></c:forEach></select></div><div class="form-group"><label>Giá người lớn</label><input class="form-control" id="draftAdultPrice"></div><div class="form-group"><label>Giá trẻ em</label><input class="form-control" id="draftChildPrice"></div></div>
                                <div class="form-grid grid-3" style="margin-top:12px;"><div class="form-group"><label>Giá em bé</label><input class="form-control" id="draftInfantPrice"></div><div class="form-group"><label>Phụ thu phòng đơn</label><input class="form-control" id="draftSingleRoomSurcharge"></div><div class="form-group"><label>Đặt cọc</label><input class="form-control" type="number" id="draftDepositPercent" value="30"></div></div>
                                <div class="schedule-draft-actions"><span id="draftPriceSummary" class="price-summary">Giá: chưa tính</span><button type="button" class="btn btn-outline-green" id="addScheduleDraftBtn">+ Thêm lịch mới</button></div>
                            </div>
                        </c:if>
                    </div>

                    <div class="card card-section">
                        <h2 class="section-title"><span class="section-index">3</span>Lịch trình theo ngày</h2>
                        <p class="help-text">Chỉ Draft/Rejected được sửa lịch trình mẫu.</p>
                        <c:choose>
                            <c:when test="${tour.canEditItinerary}"><div id="itineraryContainer" class="day-grid"></div></c:when>
                            <c:otherwise><div class="day-grid"><c:forEach var="it" items="${tour.itineraries}"><div class="day-card"><div class="day-card-header"><div class="day-title">Ngày ${it.dayNumber}</div></div><p><strong>Di chuyển:</strong> ${it.transportDescription}</p><p><strong>Hoạt động:</strong> ${it.experienceActivities}</p><p><strong>Lưu trú:</strong> ${it.accommodationDescription}</p><p><strong>Lưu ý:</strong> ${it.note}</p></div></c:forEach></div></c:otherwise>
                        </c:choose>
                    </div>

                    <div class="form-actions"><a class="btn" href="${pageContext.request.contextPath}/staff/tours/view?id=${tour.tourID}">Hủy</a><button class="btn btn-primary" type="submit">Lưu thay đổi</button></div>
                </div>
            </form>
        </section>
    </main>
</div>
<script>
window.initialItineraries = [
<c:forEach var="it" items="${tour.itineraries}" varStatus="st">
{transportDescription: `${it.transportDescription}`, experienceActivities: `${it.experienceActivities}`, accommodationDescription: `${it.accommodationDescription}`, note: `${it.note}`} ${st.last ? '' : ','}
</c:forEach>
];
</script>
<script src="${pageContext.request.contextPath}/assets/js/tour-create.js"></script>
</body>
</html>
