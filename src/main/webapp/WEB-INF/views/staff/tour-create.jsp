<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo tour mới - WonderVN Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-tour.css">
</head>
<body>
<div class="staff-layout">
    <jsp:include page="/WEB-INF/views/staff/layout/staff-navbar.jsp" />
    <main class="staff-main">
        <header class="staff-topbar">🔔 &nbsp; ◎</header>
        <section class="staff-content">
            <div class="breadcrumb">Quản lý tour / Tạo tour mới</div>
            <div class="page-header">
                <div>
                    <h1 class="page-title">Tạo tour mới</h1>
                    <div class="page-subtitle">Tour mới ở trạng thái Nháp. Giá được nhập theo từng lịch khởi hành.</div>
                </div>
            </div>

            <c:if test="${not empty systemError}">
                <div class="card info-box error-box"><c:out value="${systemError}" /></div>
            </c:if>

            <c:if test="${not empty fieldErrors}">
                <div class="card validation-summary">
                    <strong>Chưa thể tạo tour vì dữ liệu chưa hợp lệ:</strong>
                    <ul>
                        <c:forEach var="err" items="${fieldErrors}">
                            <li><c:out value="${err.value}" /></li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/staff/tours/create" id="tourCreateForm">
                <div class="form-full-width">
                    <div class="card card-section">
                        <h2 class="section-title"><span class="section-index">1</span>Thông tin cơ bản</h2>
                        <div class="form-grid grid-4">
                            <div class="form-group">
                                <label>Tên tour <span class="required">*</span></label>
                                <input class="form-control" name="tourName" value="${fn:escapeXml(old.tourName)}" placeholder="Hà Nội - Hạ Long 2N1Đ">
                                <c:if test="${not empty fieldErrors.tourName}"><small class="field-error"><c:out value="${fieldErrors.tourName}" /></small></c:if>
                            </div>
                            <div class="form-group">
                                <label>Mã tour</label>
                                <input class="form-control" value="Tự sinh khi lưu" readonly>
                                <small class="help-text">Không nhập tay mã tour.</small>
                            </div>
                            <div class="form-group">
                                <label>Danh mục <span class="required">*</span></label>
                                <select class="form-select" name="tourCategoryID">
                                    <option value="">Chọn danh mục</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.value}" ${old.tourCategoryID == category.value ? 'selected' : ''}><c:out value="${category.label}" /></option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty fieldErrors.tourCategoryID}"><small class="field-error"><c:out value="${fieldErrors.tourCategoryID}" /></small></c:if>
                            </div>
                            <div class="form-group">
                                <label>Khu vực <span class="required">*</span></label>
                                <select class="form-select" name="regionID" id="regionID">
                                    <option value="">Chọn khu vực</option>
                                    <c:forEach var="region" items="${regions}">
                                        <option value="${region.value}" ${old.regionID == region.value ? 'selected' : ''}><c:out value="${region.label}" /></option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty fieldErrors.regionID}"><small class="field-error"><c:out value="${fieldErrors.regionID}" /></small></c:if>
                            </div>
                        </div>

                        <div class="form-grid grid-4" style="margin-top:14px;">
                            <div class="form-group">
                                <label>Điểm khởi hành <span class="required">*</span></label>
                                <select class="form-select destination-select" name="departureDestinationID" id="departureDestinationID">
                                    <option value="">Chọn điểm khởi hành</option>
                                    <c:forEach var="d" items="${destinations}">
                                        <option value="${d.value}" data-region="${d.parentID}" ${old.departureDestinationID == d.value ? 'selected' : ''}><c:out value="${d.label}" /></option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty fieldErrors.departureDestinationID}"><small class="field-error"><c:out value="${fieldErrors.departureDestinationID}" /></small></c:if>
                            </div>
                            <div class="form-group">
                                <label>Điểm đến <span class="required">*</span></label>
                                <select class="form-select destination-select" name="destinationID" id="destinationID">
                                    <option value="">Chọn điểm đến</option>
                                    <c:forEach var="d" items="${destinations}">
                                        <option value="${d.value}" data-region="${d.parentID}" ${old.destinationID == d.value ? 'selected' : ''}><c:out value="${d.label}" /></option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty fieldErrors.destinationID}"><small class="field-error"><c:out value="${fieldErrors.destinationID}" /></small></c:if>
                            </div>
                            <div class="form-group">
                                <label>Điểm tập kết cụ thể <span class="required">*</span></label>
                                <input class="form-control" name="pickupPointName" value="${fn:escapeXml(old.pickupPointName)}" placeholder="Cổng chính Nhà hát Lớn Hà Nội">
                                <c:if test="${not empty fieldErrors.pickupPointName}"><small class="field-error"><c:out value="${fieldErrors.pickupPointName}" /></small></c:if>
                            </div>
                            <div class="form-group">
                                <label>Giờ tập kết <span class="required">*</span></label>
                                <input class="form-control" type="time" name="pickupTime" value="${old.pickupTime}">
                                <c:if test="${not empty fieldErrors.pickupTime}"><small class="field-error"><c:out value="${fieldErrors.pickupTime}" /></small></c:if>
                            </div>
                        </div>

                        <div class="form-grid grid-5" style="margin-top:14px;">
                            <div class="form-group">
                                <label>Số ngày <span class="required">*</span></label>
                                <input class="form-control" type="number" name="numberOfDays" value="${not empty old.numberOfDays ? old.numberOfDays : 2}" min="1" max="30">
                                <c:if test="${not empty fieldErrors.numberOfDays}"><small class="field-error"><c:out value="${fieldErrors.numberOfDays}" /></small></c:if>
                            </div>
                            <div class="form-group">
                                <label>Số đêm <span class="required">*</span></label>
                                <input class="form-control" type="number" name="numberOfNights" value="${not empty old.numberOfNights ? old.numberOfNights : 1}" min="0" max="29">
                                <c:if test="${not empty fieldErrors.numberOfNights}"><small class="field-error"><c:out value="${fieldErrors.numberOfNights}" /></small></c:if>
                            </div>
                            <div class="form-group">
                                <label>Phương tiện <span class="required">*</span></label>
                                <select class="form-select" name="mainTransportType" id="mainTransportType">
                                    <option value="">Chọn phương tiện</option>
                                    <option value="Ô tô" ${old.mainTransportType == 'Ô tô' ? 'selected' : ''}>Ô tô</option>
                                    <option value="Xe khách" ${old.mainTransportType == 'Xe khách' ? 'selected' : ''}>Xe khách</option>
                                    <option value="Xe giường nằm" ${old.mainTransportType == 'Xe giường nằm' ? 'selected' : ''}>Xe giường nằm</option>
                                    <option value="Đường sắt" ${old.mainTransportType == 'Đường sắt' ? 'selected' : ''}>Đường sắt</option>
                                </select>
                                <small class="help-text">Đường sắt không cần lái xe.</small>
                                <c:if test="${not empty fieldErrors.mainTransportType}"><small class="field-error"><c:out value="${fieldErrors.mainTransportType}" /></small></c:if>
                            </div>
                            <div class="form-group">
                                <label>Số chỗ <span class="required">*</span></label>
                                <input class="form-control" type="number" name="vehicleSeatCount" value="${old.vehicleSeatCount}" placeholder="29" min="1">
                                <c:if test="${not empty fieldErrors.vehicleSeatCount}"><small class="field-error"><c:out value="${fieldErrors.vehicleSeatCount}" /></small></c:if>
                            </div>
                            <div class="form-group"><label>Mô tả ngắn</label><input class="form-control" name="shortDescription" value="${fn:escapeXml(old.shortDescription)}" placeholder="Mô tả ngắn"></div>
                        </div>

                        <div class="form-grid grid-2" style="margin-top:14px;">
                            <div class="form-group"><label>Mô tả chi tiết</label><textarea name="description" placeholder="Mô tả chi tiết tour"><c:out value="${old.description}" /></textarea></div>
                            <div class="form-group">
                                <label>Ảnh tour</label>
                                <div class="upload-preview-row">
                                    <label class="upload-tile">
                                        <input type="file" name="coverImage" accept="image/*" class="image-input" data-preview="coverPreview">
                                        <span>+ Ảnh bìa</span>
                                        <img id="coverPreview" class="upload-preview-img" alt="Ảnh bìa" <c:if test="${not empty old.coverImageUrl}">src="${pageContext.request.contextPath}/${old.coverImageUrl}" style="display:block"</c:if>>
                                    </label>
                                    <label class="upload-tile">
                                        <input type="file" name="galleryImages" accept="image/*" multiple class="image-input" data-preview="galleryPreview">
                                        <span>+ Bộ ảnh</span>
                                    </label>
                                </div>
                                <div id="galleryPreview" class="gallery-preview"></div>
                                <small class="help-text">Chọn ảnh trực tiếp, không cần chép đường link. JPG/PNG/WEBP, tối đa 5MB/ảnh.</small>
                            </div>
                        </div>
                    </div>

                    <div class="card card-section">
                        <h2 class="section-title"><span class="section-index">2</span>Lịch khởi hành & vận hành</h2>
                        <p class="help-text">Nhập một lịch khởi hành rồi bấm thêm vào danh sách. Danh sách bên dưới là dữ liệu sẽ lưu.</p>
                        <input type="hidden" id="scheduleCount" name="scheduleCount" value="${fn:length(old.schedules)}">
                        <div id="scheduleHiddenContainer">
                            <c:forEach var="s" items="${old.schedules}" varStatus="st">
                                <c:set var="idx" value="${st.index + 1}" />
                                <div class="schedule-hidden-set" data-index="${idx}">
                                    <input type="hidden" name="tourScheduleID_${idx}" value="${s.tourScheduleID}">
                                    <input type="hidden" name="departureDate_${idx}" value="${s.departureDate}">
                                    <input type="hidden" name="returnDate_${idx}" value="${s.returnDate}">
                                    <input type="hidden" name="bookingCloseDate_${idx}" value="${s.bookingCloseDate}">
                                    <input type="hidden" name="minParticipants_${idx}" value="${s.minParticipants}">
                                    <input type="hidden" name="maxParticipants_${idx}" value="${s.maxParticipants}">
                                    <input type="hidden" name="guideStaffID_${idx}" value="${s.guideStaffID}">
                                    <input type="hidden" name="driverStaffID_${idx}" value="${s.driverStaffID}">
                                    <input type="hidden" name="adultPrice_${idx}" value="${s.adultPrice}">
                                    <input type="hidden" name="childPrice_${idx}" value="${s.childPrice}">
                                    <input type="hidden" name="infantPrice_${idx}" value="${s.infantPrice}">
                                    <input type="hidden" name="singleRoomSurcharge_${idx}" value="${s.singleRoomSurcharge}">
                                    <input type="hidden" name="depositPercent_${idx}" value="${s.depositPercent}">
                                </div>
                            </c:forEach>
                        </div>
                        <c:if test="${not empty fieldErrors.schedules}"><small class="field-error"><c:out value="${fieldErrors.schedules}" /></small></c:if>

                        <div class="schedule-draft-box">
                            <div class="form-grid grid-5">
                                <div class="form-group"><label>Ngày khởi hành</label><input class="form-control" type="date" id="draftDepartureDate"></div>
                                <div class="form-group"><label>Ngày về</label><input class="form-control" type="date" id="draftReturnDate"><small class="help-text">Tự khớp theo số ngày tour.</small></div>
                                <div class="form-group"><label>Hạn chót bán</label><input class="form-control" type="date" id="draftBookingCloseDate"><small class="help-text">Phải trước ngày khởi hành.</small></div>
                                <div class="form-group"><label>Số khách tối thiểu</label><input class="form-control" type="number" id="draftMinParticipants" value="10" min="1"></div>
                                <div class="form-group"><label>Số khách tối đa</label><input class="form-control" type="number" id="draftMaxParticipants" value="29" min="1"></div>
                            </div>
                            <div class="form-grid grid-4" style="margin-top:12px;">
                                <div class="form-group"><label>Hướng dẫn viên</label><select class="form-select" id="draftGuideStaffID"><option value="">Chọn hướng dẫn viên</option><c:forEach var="g" items="${guides}"><option value="${g.staffID}"><c:out value="${g.staffCode}" /> - <c:out value="${g.fullName}" /></option></c:forEach></select></div>
                                <div class="form-group"><label>Lái xe</label><select class="form-select" id="draftDriverStaffID"><option value="">Chọn lái xe</option><c:forEach var="d" items="${drivers}"><option value="${d.staffID}"><c:out value="${d.staffCode}" /> - <c:out value="${d.fullName}" /></option></c:forEach></select><small class="help-text">Tự tắt nếu chọn Đường sắt.</small></div>
                                <div class="form-group"><label>Giá người lớn</label><input class="form-control" id="draftAdultPrice" placeholder="3250000"></div>
                                <div class="form-group"><label>Giá trẻ em</label><input class="form-control" id="draftChildPrice" placeholder="2350000"></div>
                            </div>
                            <div class="form-grid grid-3" style="margin-top:12px;">
                                <div class="form-group"><label>Giá em bé</label><input class="form-control" id="draftInfantPrice" placeholder="550000"></div>
                                <div class="form-group"><label>Phụ thu phòng đơn</label><input class="form-control" id="draftSingleRoomSurcharge" placeholder="500000"></div>
                                <div class="form-group"><label>Đặt cọc (%)</label><input class="form-control" type="number" id="draftDepositPercent" value="30" min="0" max="100"></div>

                            </div>
                            <div class="schedule-draft-actions"><span id="draftPriceSummary" class="price-summary">Giá: chưa tính</span><button type="button" class="btn btn-outline-green" id="addScheduleDraftBtn">+ Thêm vào danh sách</button></div>
                        </div>

                        <table class="tour-table compact-table" style="margin-top:16px;">
                            <thead><tr><th>#</th><th>Khởi hành</th><th>Ngày về</th><th>Hạn chót bán</th><th>Tối thiểu</th><th>Đã đặt/Tối đa</th><th>Hướng dẫn viên</th><th>Lái xe</th><th>Giá người lớn</th><th></th></tr></thead>
                            <tbody id="schedulePreviewBody">
                            <c:choose>
                                <c:when test="${not empty old.schedules}">
                                    <c:forEach var="s" items="${old.schedules}" varStatus="st">
                                        <tr data-index="${st.index + 1}">
                                            <td>${st.index + 1}</td>
                                            <td><c:out value="${s.departureDate}" /></td>
                                            <td><c:out value="${s.returnDate}" /></td>
                                            <td><c:out value="${s.bookingCloseDate}" /></td>
                                            <td><c:out value="${s.minParticipants}" /></td>
                                            <td>0/<c:out value="${s.maxParticipants}" /></td>
                                            <td><c:out value="${s.guideStaffID}" /></td>
                                            <td><c:out value="${empty s.driverStaffID ? 'Không cần' : s.driverStaffID}" /></td>
                                            <td><c:out value="${s.adultPrice}" /> VND</td>
                                            <td><button type="button" class="table-action" onclick="removeScheduleRow(${st.index + 1})">Xóa</button></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise><tr id="emptyScheduleRow"><td colspan="10">Chưa có lịch khởi hành nào.</td></tr></c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <div class="card card-section">
                        <h2 class="section-title"><span class="section-index">3</span>Lịch trình theo ngày</h2>
                        <p class="help-text">Lịch trình là mẫu chương trình chung, không gắn ngày cụ thể. Khi bán nhiều lịch khác nhau, chương trình vẫn giữ nguyên.</p>
                        <c:if test="${not empty fieldErrors.transportDescription}"><small class="field-error"><c:out value="${fieldErrors.transportDescription}" /></small></c:if>
                        <c:if test="${not empty fieldErrors.experienceActivities}"><small class="field-error"><c:out value="${fieldErrors.experienceActivities}" /></small></c:if>
                        <div id="itineraryContainer" class="day-grid">
                            <c:forEach var="it" items="${old.itineraries}" varStatus="st">
                                <c:set var="dayNo" value="${empty it.dayNumber ? st.index + 1 : it.dayNumber}" />
                                <div class="day-card">
                                    <div class="day-card-header"><div class="day-title">Ngày ${dayNo}</div></div>
                                    <div class="form-group"><label>Di chuyển từ đâu đến đâu <span class="required">*</span></label><input class="form-control" name="transportDescription_${dayNo}" value="${fn:escapeXml(it.transportDescription)}" placeholder="Ví dụ: Hà Nội → Hạ Long"></div>
                                    <div class="form-group"><label>Hoạt động trải nghiệm <span class="required">*</span></label><textarea name="experienceActivities_${dayNo}" placeholder="Mỗi hoạt động một dòng"><c:out value="${it.experienceActivities}" /></textarea></div>
                                    <div class="form-group"><label>Lưu trú</label><input class="form-control" name="accommodationDescription_${dayNo}" value="${fn:escapeXml(it.accommodationDescription)}" placeholder="Ví dụ: Khách sạn 4 sao"></div>
                                    <div class="form-group"><label>Lưu ý</label><textarea name="note_${dayNo}" placeholder="Nhập lưu ý nếu có"><c:out value="${it.note}" /></textarea></div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="card card-section">
                        <h2 class="section-title"><span class="section-index">4</span>Dịch vụ cộng thêm</h2>
                        <p class="help-text">Dịch vụ khách có thể chọn mua thêm khi thanh toán. Không phải tài nguyên vận hành nội bộ.</p>
                        <input type="hidden" name="optionalServiceCount" value="3">
                        <div class="addon-list">
                            <label class="addon-item"><input type="checkbox" name="optionalServiceSelected_1" value="1"><div class="addon-thumb"></div><div><strong>Vé VinWonders Hạ Long</strong><small>Vé tham quan online</small><input type="hidden" name="optionalServiceCode_1" value="VINWONDERS_HL"><input type="hidden" name="optionalServiceName_1" value="Vé VinWonders Hạ Long"><input type="hidden" name="optionalServicePrice_1" value="550000"></div><span>550.000 VND</span></label>
                            <label class="addon-item"><input type="checkbox" name="optionalServiceSelected_2" value="1"><div class="addon-thumb"></div><div><strong>Vé cáp treo Nữ Hoàng</strong><small>Vé tham quan online</small><input type="hidden" name="optionalServiceCode_2" value="CAP_TREO_NU_HOANG"><input type="hidden" name="optionalServiceName_2" value="Vé cáp treo Nữ Hoàng"><input type="hidden" name="optionalServicePrice_2" value="350000"></div><span>350.000 VND</span></label>
                            <label class="addon-item"><input type="checkbox" name="optionalServiceSelected_3" value="1"><div class="addon-thumb"></div><div><strong>Vé cano cao tốc tham quan vịnh</strong><small>Vé tham quan online</small><input type="hidden" name="optionalServiceCode_3" value="CANO_HL"><input type="hidden" name="optionalServiceName_3" value="Vé cano cao tốc tham quan vịnh"><input type="hidden" name="optionalServicePrice_3" value="300000"></div><span>300.000 VND</span></label>
                        </div>
                    </div>

                    <div class="form-actions"><button class="btn" type="button">Lưu nháp</button><div class="form-actions-right"><a class="btn" href="${pageContext.request.contextPath}/staff/tours">Hủy</a><button class="btn btn-primary" type="submit">Tạo tour</button></div></div>
                </div>
            </form>
        </section>
    </main>
</div>
<jsp:include page="/WEB-INF/views/staff/fragments/system-error-modal.jsp" />
<script src="${pageContext.request.contextPath}/assets/js/tour-create.js" charset="UTF-8"></script>
</body>
</html>
