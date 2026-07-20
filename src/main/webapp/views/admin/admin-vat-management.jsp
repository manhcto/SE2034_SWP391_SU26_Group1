<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý VAT | WonderVN Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *{box-sizing:border-box}body{margin:0;background:#f4f7fb;font-family:"Be Vietnam Pro",Arial,sans-serif;color:#0f172a}.admin-layout{display:flex;min-height:100vh}.main-content{margin-left:292px;width:calc(100% - 292px);padding:34px 42px}.topbar{display:flex;justify-content:space-between;align-items:flex-start;gap:18px;margin-bottom:22px}.topbar h1{font-size:34px;font-weight:900;margin:0}.topbar p{color:#64748b;margin:6px 0 0;font-weight:600}.content-card{background:#fff;border:1px solid #e2e8f0;border-radius:22px;padding:24px;box-shadow:0 10px 28px rgba(15,23,42,.08);margin-bottom:22px}.section-title{font-size:18px;font-weight:900;margin:0 0 16px}.stat{border:1px solid #fed7aa;background:#fff7ed;border-radius:18px;padding:18px}.stat small{color:#9a3412;font-weight:900;text-transform:uppercase}.stat strong{display:block;font-size:32px;font-weight:900;color:#ea580c;margin-top:4px}.rule-box{border:1px solid #bfdbfe;background:#eff6ff;color:#1e40af;border-radius:18px;padding:18px;font-weight:700}.rule-box li{margin-bottom:7px}.form-label{font-weight:900;color:#334155}.form-control,.form-select{border-radius:14px;border:1px solid #cbd5e1;min-height:46px;font-weight:700}.btn-main{border:none;border-radius:14px;background:#ea580c;color:#fff;padding:12px 18px;font-weight:900;text-decoration:none;display:inline-flex;align-items:center;gap:8px}.btn-main:hover{background:#c2410c;color:#fff}.btn-soft{border:1px solid #e2e8f0;border-radius:14px;background:#fff;color:#334155;padding:11px 15px;font-weight:900;text-decoration:none;display:inline-flex;align-items:center;gap:8px}.btn-soft:hover{background:#f8fafc;color:#0f172a}.btn-danger-soft{border:1px solid #fecdd3;border-radius:12px;background:#fff1f2;color:#be123c;padding:9px 12px;font-weight:900}.table thead th{background:#f8fafc;color:#334155;font-size:13px;font-weight:900;text-transform:uppercase;border-bottom:1px solid #e2e8f0;padding:14px;white-space:nowrap}.table tbody td{padding:14px;vertical-align:middle;font-size:14px}.status-badge{display:inline-flex;border-radius:999px;padding:6px 11px;font-size:12px;font-weight:900}.status-Active{background:#dcfce7;color:#166534}.status-Inactive{background:#fee2e2;color:#991b1b}.vat-code{font-weight:900;color:#ea580c}.muted{color:#64748b}@media(max-width:992px){.main-content{margin-left:0;width:100%;padding:24px}.topbar{display:block}}
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp">
        <jsp:param name="activeAdminMenu" value="vat"/>
    </jsp:include>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Quản lý VAT</h1>
                <p>Quản lý thuế theo từng khoảng thời gian hiệu lực để TourSchedule lưu đúng VAT tại thời điểm khởi hành.</p>
            </div>
            <a class="btn-soft" href="${pageContext.request.contextPath}/admin/home"><i class="fa-solid fa-arrow-left"></i> Admin Home</a>
        </div>

        <c:if test="${message == 'created'}"><div class="alert alert-success fw-bold">Tạo kỳ VAT mới thành công.</div></c:if>
        <c:if test="${message == 'createFail'}"><div class="alert alert-danger fw-bold">Tạo kỳ VAT thất bại.</div></c:if>
        <c:if test="${message == 'deactivated'}"><div class="alert alert-success fw-bold">Đã ngừng áp dụng kỳ VAT tương lai.</div></c:if>
        <c:if test="${message == 'deactivateFail'}"><div class="alert alert-warning fw-bold">Chỉ được ngừng áp dụng kỳ VAT Active có ngày bắt đầu ở tương lai.</div></c:if>
        <c:if test="${message == 'invalidAction'}"><div class="alert alert-danger fw-bold">Thao tác VAT không hợp lệ.</div></c:if>
        <c:if test="${not empty errors}">
            <div class="alert alert-danger">
                <div class="fw-bold mb-2">Cần kiểm tra:</div>
                <ul class="mb-0">
                    <c:forEach var="error" items="${errors}"><li>${error}</li></c:forEach>
                </ul>
            </div>
        </c:if>

        <section class="content-card">
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="stat h-100">
                        <small>VAT hiện hành hôm nay</small>
                        <strong>${currentVat}%</strong>
                        <div class="muted fw-bold">Áp dụng theo ngày hệ thống ${todayIso}.</div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="rule-box h-100">
                        <div class="fw-bold mb-2">Quy tắc nghiệp vụ</div>
                        <ul class="mb-0 ps-3">
                            <li>Mỗi bản ghi VAT bắt buộc có ngày bắt đầu và ngày kết thúc hiệu lực.</li>
                            <li>Không tạo hai kỳ VAT Active bị chồng lấn thời gian.</li>
                            <li>Không xóa VAT để còn truy cứu lịch sử, chứng từ và giá tour đã bán.</li>
                            <li>TourSchedule lưu snapshot VAT theo ngày khởi hành, nên về sau đổi thuế không làm lệch lịch cũ.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </section>

        <section class="content-card">
            <h5 class="section-title">Tạo kỳ VAT mới</h5>
            <form method="post" action="${pageContext.request.contextPath}/admin/vat" class="row g-3">
                <input type="hidden" name="action" value="create">
                <div class="col-lg-2 col-md-6">
                    <label class="form-label">VAT (%)</label>
                    <select name="vatPercent" class="form-select" required>
                        <c:forEach var="percent" begin="0" end="10">
                            <option value="${percent}" ${not empty draftVat && draftVat.vatPercent == percent ? 'selected' : ''}>${percent}%</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-lg-2 col-md-6">
                    <label class="form-label">Năm kê khai</label>
                    <input type="number" name="effectiveYear" class="form-control" min="2025" max="2035" step="1" value="${empty draftVatYear ? currentYear : draftVatYear}" required>
                </div>
                <div class="col-lg-2 col-md-6">
                    <label class="form-label">Quý hiệu lực</label>
                    <select name="effectiveQuarter" class="form-select" required>
                        <option value="1" ${empty draftVatQuarter || draftVatQuarter == 1 ? 'selected' : ''}>Quý 1 (01-03)</option>
                        <option value="2" ${draftVatQuarter == 2 ? 'selected' : ''}>Quý 2 (04-06)</option>
                        <option value="3" ${draftVatQuarter == 3 ? 'selected' : ''}>Quý 3 (07-09)</option>
                        <option value="4" ${draftVatQuarter == 4 ? 'selected' : ''}>Quý 4 (10-12)</option>
                    </select>
                </div>
                <div class="col-lg-6 col-md-12">
                    <label class="form-label">Căn cứ pháp lý hệ thống</label>
                    <input type="text" class="form-control" value="${systemLegalDocument}" readonly>
                    <div class="form-text fw-bold">Không cho nhập tay để tránh sửa căn cứ tùy tiện. Khi có nghị quyết/nghị định mới, cập nhật cấu hình hệ thống.</div>
                </div>
                <div class="col-lg-10">
                    <label class="form-label">Ghi chú nghiệp vụ</label>
                    <input type="text" name="description" class="form-control" maxlength="1000" value="${empty draftVat ? '' : draftVat.description}" placeholder="Phạm vi áp dụng, loại dịch vụ, lý do tạo kỳ VAT mới...">
                </div>
                <div class="col-lg-2 d-flex align-items-end">
                    <button class="btn-main w-100 justify-content-center" type="submit"><i class="fa-solid fa-plus"></i> Tạo VAT</button>
                </div>
            </form>
        </section>

        <section class="content-card">
            <h5 class="section-title">Lịch sử VAT</h5>
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead>
                    <tr>
                        <th>VAT</th>
                        <th>Hiệu lực</th>
                        <th>Căn cứ pháp lý</th>
                        <th>Người tạo</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="rate" items="${vatRates}">
                        <tr>
                            <td class="vat-code">${rate.vatPercent}%</td>
                            <td><fmt:formatDate value="${rate.effectiveFrom}" pattern="dd-MM-yyyy"/> đến <fmt:formatDate value="${rate.effectiveTo}" pattern="dd-MM-yyyy"/></td>
                            <td><strong>${rate.legalDocument}</strong><br><small class="muted">${empty rate.description ? '-' : rate.description}</small></td>
                            <td>${empty rate.createdByName ? '-' : rate.createdByName}</td>
                            <td><span class="status-badge status-${rate.status}">${rate.displayStatus}</span></td>
                            <td class="text-end">
                                <c:if test="${rate.status == 'Active'}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/vat" class="d-inline">
                                        <input type="hidden" name="action" value="deactivate">
                                        <input type="hidden" name="vatRateID" value="${rate.vatRateID}">
                                        <button class="btn-danger-soft" type="submit"><i class="fa-solid fa-ban"></i> Ngừng nếu chưa hiệu lực</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
