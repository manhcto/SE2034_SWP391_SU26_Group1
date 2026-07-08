<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Voucher | WonderVN Nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8fafc;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        .admin-main {
            flex: 1;
            min-width: 0;
        }

        .page-banner {
            background: #1d4ed8;
            border-radius: 14px;
            color: #ffffff;
            padding: 26px;
            box-shadow: 0 12px 30px rgba(29, 78, 216, 0.18);
        }

        .stat-card,
        .content-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
        }

        .stat-card {
            padding: 18px;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .stat-card h3 {
            margin: 0;
            font-size: 24px;
            font-weight: 800;
            color: #0f172a;
        }

        .stat-card p {
            margin: 0;
            color: #64748b;
            font-weight: 700;
            font-size: 12px;
            text-transform: uppercase;
        }

        .content-card {
            padding: 22px;
        }

        .form-label {
            font-weight: 700;
            color: #1e293b;
            font-size: 14px;
        }

        .badge-status {
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 800;
            padding: 7px 11px;
        }

        .status-active {
            background: #dcfce7;
            color: #166534;
        }

        .status-inactive {
            background: #fee2e2;
            color: #991b1b;
        }

        .discount-pill {
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 11px;
            background: #e0f2fe;
            color: #075985;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .table thead th {
            color: #64748b;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.02em;
            border-bottom: 1px solid #e2e8f0;
        }

        .table tbody td {
            vertical-align: middle;
            color: #1e293b;
            border-bottom: 1px solid #f1f5f9;
        }

        .voucher-code {
            font-weight: 900;
            color: #0f172a;
            letter-spacing: 0.04em;
        }

        .voucher-description {
            max-width: 270px;
            color: #64748b;
            font-size: 13px;
            line-height: 1.35;
        }

        @media (max-width: 992px) {
            .admin-layout {
                display: block;
            }
        }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp"/>

    <main class="admin-main">
        <jsp:include page="/views/common/admin-header.jsp"/>

        <div class="p-4">
            <div class="page-banner mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div class="d-flex align-items-center gap-3">
                    <i class="fa-solid fa-gift" style="font-size: 2.4rem;"></i>
                    <div>
                        <h1 class="h3 fw-bold m-0">Quản lý Voucher</h1>
                        <p class="m-0 mt-1 text-white-50">Quản lý danh sách và tạo mã giảm giá mới.</p>
                    </div>
                </div>
                <a href="#addVoucherForm" class="btn btn-light text-primary fw-bold">
                    <i class="fa-solid fa-plus me-1"></i>Thêm Voucher
                </a>
            </div>

            <c:if test="${not empty errors}">
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

            <c:set var="total" value="0"/>
            <c:set var="activeCount" value="0"/>
            <c:set var="inactiveCount" value="0"/>

            <c:forEach items="${voucherList}" var="voucher">
                <c:set var="total" value="${total + 1}"/>
                <c:if test="${voucher.status == 'Active'}">
                    <c:set var="activeCount" value="${activeCount + 1}"/>
                </c:if>
                <c:if test="${voucher.status != 'Active'}">
                    <c:set var="inactiveCount" value="${inactiveCount + 1}"/>
                </c:if>
            </c:forEach>

            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#dbeafe;color:#1d4ed8;">
                            <i class="fa-solid fa-ticket"></i>
                        </div>
                        <div>
                            <h3>${total}</h3>
                            <p>Tổng số Voucher</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#dcfce7;color:#166534;">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div>
                            <h3>${activeCount}</h3>
                            <p>Đang hoạt động</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#fee2e2;color:#991b1b;">
                            <i class="fa-solid fa-circle-xmark"></i>
                        </div>
                        <div>
                            <h3>${inactiveCount}</h3>
                            <p>Ngừng hoạt động</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-xl-4">
                    <div class="content-card position-sticky" style="top: 24px;" id="addVoucherForm">
                        <h2 class="h5 fw-bold mb-3">
                            <i class="fa-solid fa-plus text-primary me-2"></i>Thêm Voucher
                        </h2>

                        <form action="${pageContext.request.contextPath}/staff/voucher?action=insert" method="post">
                            <input type="hidden" name="action" value="insert">

                            <div class="mb-3">
                                <label class="form-label">Mã Voucher <span class="text-danger">*</span></label>
                                <input class="form-control text-uppercase" type="text" name="code" maxlength="50"
                                       value="${param.code}" placeholder="SUMMER26" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea class="form-control" name="description" rows="3" maxlength="500"><c:out value="${param.description}"/></textarea>
                            </div>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Giảm theo phần trăm (%)</label>
                                    <input class="form-control" type="number" name="percentDiscount"
                                           min="1" max="100" step="0.01" value="${param.percentDiscount}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giảm theo số tiền (VNĐ)</label>
                                    <input class="form-control" type="number" name="amountDiscount"
                                           min="0" step="0.01" value="${param.amountDiscount}">
                                </div>
                            </div>

                            <div class="mb-3 mt-3">
                                <label class="form-label">Giá trị đơn hàng tối thiểu</label>
                                <input class="form-control" type="number" name="minOrderAmount"
                                       min="0" step="0.01" value="${param.minOrderAmount}">
                            </div>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                                    <input class="form-control" type="number" name="quantity"
                                           min="1" step="1" value="${param.quantity}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                    <select class="form-select" name="status" required>
                                        <option value="Active" ${empty param.status || param.status == 'Active' ? 'selected' : ''}>Đang hoạt động</option>
                                        <option value="Inactive" ${param.status == 'Inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row g-3 mt-1">
                                <div class="col-md-6">
                                    <label class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                    <input class="form-control" type="date" name="startDate"
                                           value="${param.startDate}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                    <input class="form-control" type="date" name="endDate"
                                           value="${param.endDate}" required>
                                </div>
                            </div>

                            <button class="btn btn-primary fw-bold w-100 mt-4" type="submit">
                                <i class="fa-solid fa-floppy-disk me-1"></i>Lưu Voucher
                            </button>
                        </form>
                    </div>
                </div>

                <div class="col-xl-8">
                    <div class="content-card p-0 overflow-hidden">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 p-3 border-bottom">
                            <div>
                                <h2 class="h5 fw-bold mb-1">Danh sách Voucher</h2>
                                <p class="text-muted mb-0">Danh sách các mã giảm giá hiện có trong hệ thống.</p>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>VOUCHER</th>
                                    <th>MỨC GIẢM</th>
                                    <th>ĐƠN TỐI THIỂU</th>
                                    <th>SỐ LƯỢNG</th>
                                    <th>THỜI GIAN HIỆU LỰC</th>
                                    <th>TRẠNG THÁI</th>
                                    <th>NGÀY TẠO</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${empty voucherList}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-5">
                                                <i class="fa-regular fa-folder-open fs-2 d-block mb-2"></i>
                                                Chưa có Voucher nào.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${voucherList}" var="voucher">
                                            <tr>
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
                                                <td><strong>${voucher.quantity}</strong></td>
                                                <td class="text-muted">
                                                    <fmt:formatDate value="${voucher.startDate}" pattern="dd/MM/yyyy"/>
                                                    -
                                                    <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy"/>
                                                </td>
                                                <td>
                                                    <span class="badge-status ${voucher.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                                        <c:choose>
                                                            <c:when test="${voucher.status == 'Active'}">
                                                                <i class="fa-solid fa-circle-check"></i> Đang hoạt động
                                                            </c:when>
                                                            <c:when test="${voucher.status == 'Inactive'}">
                                                                <i class="fa-solid fa-circle-xmark"></i> Ngừng hoạt động
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fa-solid fa-circle-xmark"></i> <c:out value="${voucher.status}"/>
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
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
