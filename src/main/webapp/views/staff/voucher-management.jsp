<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Voucher | WonderVN Nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --dark: #0f172a;
            --text: #1e293b;
            --muted: #64748b;
            --bg: #f3f6fb;
            --soft: #f8fafc;
            --border: #e2e8f0;
            --success: #16a34a;
            --danger: #dc2626;
            --shadow: 0 16px 36px rgba(15, 23, 42, 0.08);
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--text);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        .admin-main {
            flex: 1;
            min-width: 0;
        }

        .staff-voucher-page {
            padding: 28px;
        }

        .staff-page-topbar {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 22px 24px;
            box-shadow: var(--shadow);
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .staff-page-topbar h1 {
            margin: 0;
            color: var(--dark);
            font-size: 28px;
            font-weight: 900;
            letter-spacing: 0;
        }

        .staff-page-topbar p {
            margin: 6px 0 0;
            color: var(--muted);
            font-weight: 600;
        }

        .btn-main {
            border: none;
            border-radius: 14px;
            background: var(--primary);
            color: #ffffff;
            padding: 12px 18px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
            cursor: pointer;
            min-height: 46px;
        }

        .btn-main:hover {
            background: var(--primary-dark);
            color: #ffffff;
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 22px;
        }

        .stat-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 20px;
            box-shadow: var(--shadow);
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            flex: 0 0 auto;
        }

        .stat-card .label {
            color: var(--muted);
            font-weight: 700;
            margin-bottom: 4px;
        }

        .stat-card .value {
            font-size: 30px;
            font-weight: 900;
            color: var(--dark);
            line-height: 1;
        }

        .toolbar,
        .table-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 22px;
            box-shadow: var(--shadow);
        }

        .toolbar {
            padding: 18px;
            margin-bottom: 22px;
        }

        .form-control,
        .form-select {
            border-radius: 13px;
            border: 1px solid #dbe3ef;
            min-height: 46px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        textarea.form-control {
            min-height: 96px;
        }

        .table-card {
            overflow: hidden;
        }

        .table-card-header {
            padding: 18px 20px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
        }

        .table-card-header h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 900;
            color: var(--dark);
        }

        .table-card-header p {
            margin: 4px 0 0;
            color: var(--muted);
            font-weight: 600;
        }

        .voucher-table {
            margin: 0;
            width: 100%;
        }

        .voucher-table thead th {
            color: var(--muted);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0;
            border-bottom: 1px solid var(--border);
            background: #f8fafc;
            padding: 14px 16px;
            white-space: nowrap;
        }

        .voucher-table tbody td {
            vertical-align: middle;
            color: var(--text);
            border-bottom: 1px solid #f1f5f9;
            padding: 16px;
        }

        .voucher-table th:nth-child(1),
        .voucher-table td:nth-child(1) {
            min-width: 240px;
        }

        .voucher-table th:nth-child(5),
        .voucher-table td:nth-child(5) {
            min-width: 190px;
        }

        .voucher-code {
            font-weight: 900;
            color: var(--dark);
            letter-spacing: 0;
        }

        .voucher-description {
            max-width: 320px;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.35;
            margin-top: 3px;
        }

        .badge-soft,
        .discount-pill {
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 800;
            padding: 7px 11px;
            white-space: nowrap;
        }

        .discount-pill {
            background: #e0f2fe;
            color: #075985;
        }

        .badge-active {
            background: #dcfce7;
            color: #166534;
        }

        .badge-inactive {
            background: #fee2e2;
            color: #991b1b;
        }

        .action-btn {
            border-radius: 12px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
        }

        .modal-content {
            border: 0;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 24px 70px rgba(15, 23, 42, 0.22);
        }

        .modal-header {
            background: linear-gradient(135deg, #0f172a 0%, #2563eb 100%);
            color: #ffffff;
            border: 0;
            padding: 20px 24px;
        }

        .modal-title {
            font-weight: 900;
            letter-spacing: 0;
        }

        .modal-header .btn-close {
            filter: invert(1) grayscale(100%) brightness(200%);
            opacity: 0.9;
        }

        .modal-body {
            padding: 24px;
            max-height: calc(100vh - 220px);
            overflow-y: auto;
        }

        .modal-footer {
            border-top: 1px solid var(--border);
            background: var(--soft);
            padding: 16px 24px;
        }

        @media (max-width: 992px) {
            .admin-layout {
                display: block;
            }

            .staff-voucher-page {
                padding: 18px;
            }

            .staff-page-topbar {
                align-items: stretch;
                flex-direction: column;
            }

            .btn-main {
                width: 100%;
            }

            .stat-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp"/>

    <main class="admin-main">
        <jsp:include page="/views/common/admin-header.jsp"/>

        <div class="staff-voucher-page">
            <c:set var="isEditMode" value="${editMode == true}"/>
            <c:set var="isSubmittedForm" value="${submittedForm == true}"/>
            <c:set var="shouldOpenAddModal" value="${isSubmittedForm && !isEditMode}"/>
            <c:set var="shouldOpenEditModal" value="${isEditMode}"/>

            <c:set var="addCode" value="${shouldOpenAddModal ? param.code : ''}"/>
            <c:set var="addDescription" value="${shouldOpenAddModal ? param.description : ''}"/>
            <c:set var="addPercentDiscount" value="${shouldOpenAddModal ? param.percentDiscount : ''}"/>
            <c:set var="addAmountDiscount" value="${shouldOpenAddModal ? param.amountDiscount : ''}"/>
            <c:set var="addMinOrderAmount" value="${shouldOpenAddModal ? param.minOrderAmount : ''}"/>
            <c:set var="addQuantity" value="${shouldOpenAddModal ? param.quantity : ''}"/>
            <c:set var="addStatus" value="${shouldOpenAddModal ? param.status : 'Active'}"/>
            <c:set var="addApplicableType" value="${shouldOpenAddModal ? param.applicableType : 'All'}"/>
            <c:set var="addStartDate" value="${shouldOpenAddModal ? param.startDate : ''}"/>
            <c:set var="addEndDate" value="${shouldOpenAddModal ? param.endDate : ''}"/>

            <c:if test="${isEditMode && not empty editVoucher}">
                <fmt:formatDate value="${editVoucher.startDate}" pattern="yyyy-MM-dd" var="editStartDateValue"/>
                <fmt:formatDate value="${editVoucher.endDate}" pattern="yyyy-MM-dd" var="editEndDateValue"/>
            </c:if>
            <c:set var="editVoucherID" value="${isSubmittedForm ? param.voucherID : (isEditMode ? editVoucher.voucherID : '')}"/>
            <c:set var="editCode" value="${isSubmittedForm ? param.code : (isEditMode ? editVoucher.code : '')}"/>
            <c:set var="editDescription" value="${isSubmittedForm ? param.description : (isEditMode ? editVoucher.description : '')}"/>
            <c:set var="editPercentDiscount" value="${isSubmittedForm ? param.percentDiscount : (isEditMode ? editVoucher.percentDiscount : '')}"/>
            <c:set var="editAmountDiscount" value="${isSubmittedForm ? param.amountDiscount : (isEditMode ? editVoucher.amountDiscount : '')}"/>
            <c:set var="editMinOrderAmount" value="${isSubmittedForm ? param.minOrderAmount : (isEditMode ? editVoucher.minOrderAmount : '')}"/>
            <c:set var="editQuantity" value="${isSubmittedForm ? param.quantity : (isEditMode ? editVoucher.quantity : '')}"/>
            <c:set var="editStatus" value="${isSubmittedForm ? param.status : (isEditMode ? editVoucher.status : 'Active')}"/>
            <c:set var="editApplicableType" value="${isSubmittedForm ? param.applicableType : (isEditMode ? editVoucher.applicableType : 'All')}"/>
            <c:set var="editStartDate" value="${isSubmittedForm ? param.startDate : (isEditMode ? editStartDateValue : '')}"/>
            <c:set var="editEndDate" value="${isSubmittedForm ? param.endDate : (isEditMode ? editEndDateValue : '')}"/>

            <div class="staff-page-topbar">
                <div>
                    <h1>Quản lý Voucher</h1>
                    <p>Quản lý danh sách và tạo mã giảm giá mới.</p>
                </div>

                <button class="btn-main" type="button" data-bs-toggle="modal" data-bs-target="#addVoucherModal">
                    <i class="fa-solid fa-plus"></i>
                    Thêm Voucher
                </button>
            </div>

            <c:if test="${not empty errors && !shouldOpenAddModal && !shouldOpenEditModal}">
                <div class="alert alert-danger fw-semibold">
                    <div class="mb-1">Vui lòng kiểm tra lại thông tin Voucher.</div>
                    <ul class="mb-0">
                        <c:forEach items="${errors}" var="error">
                            <li><c:out value="${error}"/></li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <c:if test="${param.success == 'insert'}">
                <div class="alert alert-success fw-semibold">
                    Thêm Voucher thành công.
                </div>
            </c:if>

            <c:if test="${param.success == 'update'}">
                <div class="alert alert-success fw-semibold">
                    Cập nhật Voucher thành công.
                </div>
            </c:if>

            <c:set var="total" value="0"/>
            <c:set var="activeCount" value="0"/>
            <c:set var="inactiveCount" value="0"/>

            <c:forEach items="${voucherList}" var="voucher">
                <c:set var="total" value="${total + 1}"/>
                <c:choose>
                    <c:when test="${voucher.status == 'Active'}">
                        <c:set var="activeCount" value="${activeCount + 1}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="inactiveCount" value="${inactiveCount + 1}"/>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <div class="stat-grid">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#dbeafe;color:#1d4ed8;">
                        <i class="fa-solid fa-ticket"></i>
                    </div>
                    <div>
                        <div class="label">Tổng số Voucher</div>
                        <div class="value">${total}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon" style="background:#dcfce7;color:#166534;">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <div>
                        <div class="label">Đang hoạt động</div>
                        <div class="value">${activeCount}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon" style="background:#fee2e2;color:#991b1b;">
                        <i class="fa-solid fa-circle-xmark"></i>
                    </div>
                    <div>
                        <div class="label">Ngừng hoạt động</div>
                        <div class="value">${inactiveCount}</div>
                    </div>
                </div>
            </div>

            <div class="toolbar">
                <div class="row g-3">
                    <div class="col-lg-4">
                        <input type="text" class="form-control" id="voucherSearch"
                               placeholder="Tìm theo mã Voucher hoặc mô tả...">
                    </div>

                    <div class="col-lg-2">
                        <select class="form-select" id="voucherStatusFilter">
                            <option value="">Tất cả trạng thái</option>
                            <option value="active">Hoạt động</option>
                            <option value="inactive">Ngừng</option>
                        </select>
                    </div>

                    <div class="col-lg-2">
                        <select class="form-select" id="voucherDiscountFilter">
                            <option value="">Tất cả mức giảm</option>
                            <option value="percent">Theo phần trăm</option>
                            <option value="amount">Theo số tiền</option>
                        </select>
                    </div>

                    <div class="col-lg-2">
                        <select class="form-select" id="voucherApplicableFilter">
                            <option value="">Tất cả phạm vi</option>
                            <option value="all">Toàn hệ thống</option>
                            <option value="tour">Tour</option>
                            <option value="accommodation">Lưu trú</option>
                        </select>
                    </div>

                    <div class="col-lg-2">
                        <button class="btn btn-outline-secondary w-100 fw-bold" type="button" onclick="resetVoucherFilter()">
                            <i class="fa-solid fa-rotate-left me-1"></i>
                            Xóa lọc
                        </button>
                    </div>
                </div>
            </div>

            <div class="table-card">
                <div class="table-card-header">
                    <div>
                        <h2>Danh sách Voucher</h2>
                        <p>Danh sách các mã giảm giá hiện có trong hệ thống.</p>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table voucher-table" id="voucherTable">
                        <thead>
                        <tr>
                            <th>Mã Voucher</th>
                            <th>Phạm vi áp dụng</th>
                            <th>Mức giảm</th>
                            <th>Đơn tối thiểu</th>
                            <th>LƯỢT SỬ DỤNG</th>
                            <th>Thời gian hiệu lực</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty voucherList}">
                                <tr>
                                    <td colspan="9" class="text-center text-muted py-5">
                                        <i class="fa-regular fa-folder-open fs-2 d-block mb-2"></i>
                                        Chưa có Voucher nào.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${voucherList}" var="voucher">
                                    <c:set var="rowStatus" value="${voucher.status == 'Active' ? 'active' : 'inactive'}"/>
                                    <c:set var="rowDiscount" value="${voucher.percentDiscount != null && voucher.percentDiscount > 0 ? 'percent' : (voucher.amountDiscount != null && voucher.amountDiscount > 0 ? 'amount' : 'none')}"/>
                                    <c:set var="rowApplicable" value="${empty voucher.applicableType ? 'All' : voucher.applicableType}"/>
                                    <c:set var="rowApplicableFilter" value="${rowApplicable == 'Tour' ? 'tour' : (rowApplicable == 'Accommodation' ? 'accommodation' : 'all')}"/>
                                    <tr data-search="${fn:escapeXml(voucher.code)} ${fn:escapeXml(voucher.description)}"
                                        data-status="${rowStatus}"
                                        data-discount="${rowDiscount}"
                                        data-applicable="${rowApplicableFilter}">
                                        <td>
                                            <div class="voucher-code"><c:out value="${voucher.code}"/></div>
                                            <div class="voucher-description">
                                                <c:choose>
                                                    <c:when test="${not empty voucher.description}">
                                                        <c:out value="${voucher.description}"/>
                                                    </c:when>
                                                    <c:otherwise>Chưa có mô tả</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${rowApplicable == 'All'}">Toàn hệ thống</c:when>
                                                <c:when test="${rowApplicable == 'Tour'}">Tour</c:when>
                                                <c:when test="${rowApplicable == 'Accommodation'}">Lưu trú</c:when>
                                                <c:otherwise><c:out value="${rowApplicable}"/></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="discount-pill">
                                                <i class="fa-solid fa-tag"></i>
                                                <c:choose>
                                                    <c:when test="${voucher.percentDiscount != null && voucher.percentDiscount > 0}">
                                                        <fmt:formatNumber value="${voucher.percentDiscount}" maxFractionDigits="2"/>%
                                                    </c:when>
                                                    <c:when test="${voucher.amountDiscount != null && voucher.amountDiscount > 0}">
                                                        <fmt:formatNumber value="${voucher.amountDiscount}" type="number" maxFractionDigits="0"/> VNĐ
                                                    </c:when>
                                                    <c:otherwise>Chưa thiết lập</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${voucher.minOrderAmount != null}">
                                                    <fmt:formatNumber value="${voucher.minOrderAmount}" type="number" maxFractionDigits="0"/> VNĐ
                                                </c:when>
                                                <c:otherwise>Không yêu cầu</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <strong>${voucher.usedCount} / ${voucher.quantity}</strong>
                                            <div class="text-muted small">Đã dùng / tổng lượt</div>
                                        </td>
                                        <td class="text-muted">
                                            <fmt:formatDate value="${voucher.startDate}" pattern="dd/MM/yyyy"/>
                                            -
                                            <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <span class="badge-soft ${voucher.status == 'Active' ? 'badge-active' : 'badge-inactive'}">
                                                <c:choose>
                                                    <c:when test="${voucher.status == 'Active'}">
                                                        <i class="fa-solid fa-circle-check"></i>Hoạt động
                                                    </c:when>
                                                    <c:when test="${voucher.status == 'Inactive'}">
                                                        <i class="fa-solid fa-circle-xmark"></i>Ngừng
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fa-solid fa-circle-xmark"></i><c:out value="${voucher.status}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty voucher.createdAt}">
                                                    <fmt:formatDate value="${voucher.createdAt}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a class="btn btn-sm btn-outline-primary action-btn"
                                               href="${pageContext.request.contextPath}/staff/voucher?action=edit&voucherID=${voucher.voucherID}">
                                                <i class="fa-solid fa-pen-to-square"></i>Chỉnh sửa
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<div class="modal fade" id="addVoucherModal" tabindex="-1" aria-labelledby="addVoucherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <form class="modal-content" action="${pageContext.request.contextPath}/staff/voucher?action=insert" method="post">
            <input type="hidden" name="action" value="insert">

            <div class="modal-header">
                <h5 class="modal-title" id="addVoucherModalLabel">
                    <i class="fa-solid fa-plus me-2"></i>Thêm Voucher
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>

            <div class="modal-body">
                <c:if test="${not empty errors && shouldOpenAddModal}">
                    <div class="alert alert-danger fw-semibold">
                        <div class="mb-1">Vui lòng kiểm tra lại thông tin Voucher.</div>
                        <ul class="mb-0">
                            <c:forEach items="${errors}" var="error">
                                <li><c:out value="${error}"/></li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Mã Voucher <span class="text-danger">*</span></label>
                        <input class="form-control text-uppercase" type="text" name="code" maxlength="50"
                               value="${fn:escapeXml(addCode)}" placeholder="SUMMER26" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Trạng thái <span class="text-danger">*</span></label>
                        <select class="form-select" name="status" required>
                            <option value="Active" ${empty addStatus || addStatus == 'Active' ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="Inactive" ${addStatus == 'Inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Phạm vi áp dụng <span class="text-danger">*</span></label>
                        <select class="form-select" name="applicableType" required>
                            <option value="All" ${empty addApplicableType || addApplicableType == 'All' ? 'selected' : ''}>Toàn hệ thống</option>
                            <option value="Tour" ${addApplicableType == 'Tour' ? 'selected' : ''}>Tour</option>
                            <option value="Accommodation" ${addApplicableType == 'Accommodation' ? 'selected' : ''}>Lưu trú</option>
                        </select>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-bold">Mô tả</label>
                        <textarea class="form-control" name="description" rows="3" maxlength="500"><c:out value="${addDescription}"/></textarea>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Giảm theo phần trăm (%)</label>
                        <input class="form-control" type="number" name="percentDiscount"
                               min="1" max="100" step="0.01" value="${fn:escapeXml(addPercentDiscount)}">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Giảm theo số tiền (VNĐ)</label>
                        <input class="form-control" type="number" name="amountDiscount"
                               min="0" step="0.01" value="${fn:escapeXml(addAmountDiscount)}">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Giá trị đơn hàng tối thiểu</label>
                        <input class="form-control" type="number" name="minOrderAmount"
                               min="0" step="0.01" value="${fn:escapeXml(addMinOrderAmount)}">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Số lượng <span class="text-danger">*</span></label>
                        <input class="form-control" type="number" name="quantity"
                               min="1" step="1" value="${fn:escapeXml(addQuantity)}" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Ngày bắt đầu <span class="text-danger">*</span></label>
                        <input class="form-control" type="date" name="startDate"
                               value="${fn:escapeXml(addStartDate)}" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Ngày kết thúc <span class="text-danger">*</span></label>
                        <input class="form-control" type="date" name="endDate"
                               value="${fn:escapeXml(addEndDate)}" required>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">Hủy</button>
                <button class="btn-main" type="submit">
                    <i class="fa-solid fa-plus"></i>Thêm Voucher
                </button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="editVoucherModal" tabindex="-1" aria-labelledby="editVoucherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <form class="modal-content" action="${pageContext.request.contextPath}/staff/voucher?action=update" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="voucherID" value="${fn:escapeXml(editVoucherID)}">

            <div class="modal-header">
                <h5 class="modal-title" id="editVoucherModalLabel">
                    <i class="fa-solid fa-pen-to-square me-2"></i>Chỉnh sửa Voucher
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>

            <div class="modal-body">
                <c:if test="${not empty errors && shouldOpenEditModal}">
                    <div class="alert alert-danger fw-semibold">
                        <div class="mb-1">Vui lòng kiểm tra lại thông tin Voucher.</div>
                        <ul class="mb-0">
                            <c:forEach items="${errors}" var="error">
                                <li><c:out value="${error}"/></li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Mã Voucher <span class="text-danger">*</span></label>
                        <input class="form-control text-uppercase" type="text" name="code" maxlength="50"
                               value="${fn:escapeXml(editCode)}" placeholder="SUMMER26" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Trạng thái <span class="text-danger">*</span></label>
                        <select class="form-select" name="status" required>
                            <option value="Active" ${empty editStatus || editStatus == 'Active' ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="Inactive" ${editStatus == 'Inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Phạm vi áp dụng <span class="text-danger">*</span></label>
                        <select class="form-select" name="applicableType" required>
                            <option value="All" ${empty editApplicableType || editApplicableType == 'All' ? 'selected' : ''}>Toàn hệ thống</option>
                            <option value="Tour" ${editApplicableType == 'Tour' ? 'selected' : ''}>Tour</option>
                            <option value="Accommodation" ${editApplicableType == 'Accommodation' ? 'selected' : ''}>Lưu trú</option>
                        </select>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-bold">Mô tả</label>
                        <textarea class="form-control" name="description" rows="3" maxlength="500"><c:out value="${editDescription}"/></textarea>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Giảm theo phần trăm (%)</label>
                        <input class="form-control" type="number" name="percentDiscount"
                               min="1" max="100" step="0.01" value="${fn:escapeXml(editPercentDiscount)}">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Giảm theo số tiền (VNĐ)</label>
                        <input class="form-control" type="number" name="amountDiscount"
                               min="0" step="0.01" value="${fn:escapeXml(editAmountDiscount)}">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Giá trị đơn hàng tối thiểu</label>
                        <input class="form-control" type="number" name="minOrderAmount"
                               min="0" step="0.01" value="${fn:escapeXml(editMinOrderAmount)}">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Số lượng <span class="text-danger">*</span></label>
                        <input class="form-control" type="number" name="quantity"
                               min="1" step="1" value="${fn:escapeXml(editQuantity)}" required>
                        <div class="form-text">
                            Đã sử dụng:
                            <c:choose>
                                <c:when test="${isEditMode && not empty editVoucher}">
                                    ${editVoucher.usedCount}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                            lượt.
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Ngày bắt đầu <span class="text-danger">*</span></label>
                        <input class="form-control" type="date" name="startDate"
                               value="${fn:escapeXml(editStartDate)}" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Ngày kết thúc <span class="text-danger">*</span></label>
                        <input class="form-control" type="date" name="endDate"
                               value="${fn:escapeXml(editEndDate)}" required>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <a class="btn btn-light fw-bold" href="${pageContext.request.contextPath}/staff/voucher">Hủy</a>
                <button class="btn-main" type="submit">
                    <i class="fa-solid fa-floppy-disk"></i>Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function normalizeVoucherText(value) {
        return (value || '').toLowerCase().trim();
    }

    function filterVoucherTable() {
        const keyword = normalizeVoucherText(document.getElementById('voucherSearch').value);
        const status = normalizeVoucherText(document.getElementById('voucherStatusFilter').value);
        const discount = normalizeVoucherText(document.getElementById('voucherDiscountFilter').value);
        const applicable = normalizeVoucherText(document.getElementById('voucherApplicableFilter').value);

        document.querySelectorAll('#voucherTable tbody tr[data-search]').forEach(function (row) {
            const rowText = normalizeVoucherText(row.dataset.search);
            const rowStatus = normalizeVoucherText(row.dataset.status);
            const rowDiscount = normalizeVoucherText(row.dataset.discount);
            const rowApplicable = normalizeVoucherText(row.dataset.applicable);

            const matchKeyword = !keyword || rowText.includes(keyword);
            const matchStatus = !status || rowStatus === status;
            const matchDiscount = !discount || rowDiscount === discount;
            const matchApplicable = !applicable || rowApplicable === applicable;

            row.style.display = matchKeyword && matchStatus && matchDiscount && matchApplicable ? '' : 'none';
        });
    }

    function resetVoucherFilter() {
        document.getElementById('voucherSearch').value = '';
        document.getElementById('voucherStatusFilter').value = '';
        document.getElementById('voucherDiscountFilter').value = '';
        document.getElementById('voucherApplicableFilter').value = '';
        filterVoucherTable();
    }

    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('voucherSearch').addEventListener('input', filterVoucherTable);
        document.getElementById('voucherStatusFilter').addEventListener('change', filterVoucherTable);
        document.getElementById('voucherDiscountFilter').addEventListener('change', filterVoucherTable);
        document.getElementById('voucherApplicableFilter').addEventListener('change', filterVoucherTable);

        if (${shouldOpenEditModal ? 'true' : 'false'}) {
            new bootstrap.Modal(document.getElementById('editVoucherModal')).show();
            return;
        }

        if (${shouldOpenAddModal ? 'true' : 'false'}) {
            new bootstrap.Modal(document.getElementById('addVoucherModal')).show();
        }
    });
</script>

</body>
</html>
