<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    ...
    <meta charset="UTF-8">
    <title>Quản lý Mã giảm giá | WonderVN Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

    <style>
        * { box-sizing: border-box; }
        body { margin: 0; background: #f4f7fb; font-family: 'Be Vietnam Pro', Arial, sans-serif; color: #0f172a; }
        .admin-layout { display: flex; min-height: 100vh; }

        /* SIDEBAR */
        .sidebar { width: 292px; background: #0f172a; color: white; position: fixed; inset: 0 auto 0 0; overflow-y: auto; padding: 26px 18px; box-shadow: 8px 0 26px rgba(15, 23, 42, 0.18); z-index: 100; }
        .sidebar::-webkit-scrollbar { width: 7px; }
        .sidebar::-webkit-scrollbar-thumb { background: #334155; border-radius: 20px; }
        .brand-box { padding: 8px 10px 22px; margin-bottom: 12px; border-bottom: 1px solid rgba(148, 163, 184, 0.25); }
        .brand-logo { width: 52px; height: 52px; border-radius: 18px; background: linear-gradient(135deg, #06b6d4, #4e46dc); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 20px; margin-bottom: 12px; }
        .brand-box h2 { font-size: 26px; font-weight: 800; margin: 0; letter-spacing: -0.6px; }
        .brand-box p { color: #cbd5e1; margin: 5px 0 0; font-size: 14px; }
        .nav-section-title { font-size: 11px; text-transform: uppercase; color: #94a3b8; letter-spacing: 1.2px; margin: 22px 12px 10px; font-weight: 800; }
        .sidebar-link { display: flex; align-items: center; gap: 12px; padding: 13px 14px; border-radius: 15px; color: #e2e8f0; text-decoration: none; font-size: 14px; font-weight: 700; margin-bottom: 8px; transition: all 0.2s ease; }
        .sidebar-link i { width: 22px; text-align: center; font-size: 16px; }
        .sidebar-link:hover { background: #1e293b; color: white; transform: translateX(4px); }
        .sidebar-link.active { background: linear-gradient(135deg, #06b6d4, #4e46dc); color: white; box-shadow: 0 10px 22px rgba(6, 182, 212, 0.22); }
        .admin-user { margin-top: 26px; border-top: 1px solid rgba(148, 163, 184, 0.25); padding: 18px 8px 4px; display: flex; align-items: center; gap: 12px; }
        .avatar { width: 46px; height: 46px; border-radius: 50%; background: linear-gradient(135deg, #06b6d4, #22c55e); display: flex; align-items: center; justify-content: center; font-weight: 800; color: white; }
        .admin-user small { color: #94a3b8; }

        /* MAIN CONTENT */
        .main-content { margin-left: 292px; width: calc(100% - 292px); padding: 34px 42px; }
        .topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 26px; }
        .topbar h1 { font-size: 32px; font-weight: 800; margin: 0; letter-spacing: -0.8px; }
        .topbar p { color: #64748b; margin: 6px 0 0; font-size: 15px; }
        .top-actions { display: flex; gap: 12px; }
        .top-action-btn { border: none; border-radius: 16px; padding: 12px 18px; text-decoration: none; font-weight: 800; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08); cursor: pointer; transition: 0.2s; }
        .btn-home { background: white; color: #0f172a; }
        .btn-primary-custom { background: linear-gradient(135deg, #4e46dc, #06b6d4); color: white; }
        .btn-primary-custom:hover { transform: translateY(-2px); box-shadow: 0 12px 24px rgba(78, 70, 220, 0.2); color: white;}

        /* TABLE CARD */
        .content-card { background: white; border-radius: 24px; border: 1px solid #e2e8f0; padding: 30px; box-shadow: 0 10px 28px rgba(15, 23, 42, 0.04); }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 14px; }
        th, td { border-bottom: 1px solid #e2e8f0; padding: 16px 10px; text-align: left; }
        th { background-color: #f8fafc; color: #64748b; font-weight: 700; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px;}
        tbody tr:hover { background-color: #f8fafc; }

        .status-badge { padding: 6px 12px; border-radius: 999px; font-size: 12px; font-weight: 700; display: inline-flex; align-items: center; gap: 5px;}
        .status-active { color: #16a34a; background: #dcfce7; }
        .status-inactive { color: #dc2626; background: #fee2e2; }

        .btn-icon { background: none; border: none; cursor: pointer; font-size: 18px; margin: 0 5px; transition: 0.2s; text-decoration: none; display: inline-block; }
        .btn-edit { color: #4e46dc; }
        .btn-edit:hover { color: #3730a3; transform: scale(1.15); }
        .btn-delete { color: #ef4444; }
        .btn-delete:hover { color: #b91c1c; transform: scale(1.15); }

        /* DATATABLES */
        .dataTables_wrapper .dataTables_paginate .paginate_button.current { background: #4e46dc !important; color: white !important; border: none; border-radius: 12px;}
        .dataTables_wrapper .dataTables_filter input { border: 1px solid #cbd5e1; border-radius: 12px; padding: 8px 14px; outline: none; margin-left: 10px;}
        .dataTables_wrapper .dataTables_filter input:focus { border-color: #4e46dc; box-shadow: 0 0 0 3px rgba(78, 70, 220, 0.1); }
        .dataTables_wrapper .dataTables_length select { border-radius: 8px; padding: 4px 8px; border: 1px solid #cbd5e1;}

        /* MODAL */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); z-index: 1050; justify-content: center; align-items: center; backdrop-filter: blur(4px); }
        .modal-content { background: white; padding: 34px; border-radius: 24px; width: 850px; max-width: 95%; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); border: 1px solid #e2e8f0; max-height: 90vh;
            overflow-y: auto;}
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; border-bottom: 1px solid #e2e8f0; padding-bottom: 16px; }
        .modal-header h3 { margin: 0; color: #0f172a; font-weight: 800; font-size: 22px;}
        .close-btn { font-size: 28px; cursor: pointer; color: #94a3b8; border: none; background: none; transition: 0.2s;}
        .close-btn:hover { color: #0f172a; transform: rotate(90deg);}

        .form-group { margin-bottom: 18px; position: relative; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 700; font-size: 14px; color: #475569; }
        .form-control { width: 100%; padding: 12px 16px; border: 1px solid #cbd5e1; border-radius: 14px; font-size: 14px; transition: 0.3s; font-family: inherit;}
        .form-control:focus { outline: none; border-color: #4e46dc; box-shadow: 0 0 0 4px rgba(78, 70, 220, 0.1); }
        .modal-footer { margin-top: 28px; text-align: right; display: flex; justify-content: flex-end; gap: 12px;}

        .btn-cancel { background: #f1f5f9; color: #475569; border-radius: 14px; padding: 12px 24px; border: none; font-weight: 700; cursor: pointer; transition: 0.2s;}
        .btn-cancel:hover { background: #e2e8f0; }
        .btn-submit { background: #4e46dc; color: white; border-radius: 14px; padding: 12px 24px; border: none; font-weight: 700; cursor: pointer; transition: 0.2s;}
        .btn-submit:hover { background: #3730a3; transform: translateY(-2px); box-shadow: 0 10px 15px -3px rgba(78,70,220,0.3);}

        /* ================= CSS REAL-TIME VALIDATION ================= */
        .input-error { border-color: #ef4444 !important; box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.1) !important; background-color: #fef2f2; }
        .input-success { border-color: #22c55e !important; box-shadow: 0 0 0 4px rgba(34, 197, 94, 0.1) !important; background-color: #f0fdf4; }

        .feedback-msg { font-size: 13px; font-weight: 600; margin-top: 6px; display: none; }
        .feedback-error { color: #ef4444; display: block; }
        .feedback-success { color: #16a34a; display: block; }
    </style>
</head>

<body>
<div class="admin-layout">

    <aside class="sidebar">
        <div class="brand-box">
            <div class="brand-logo">WV</div>
            <h2>WonderVN</h2>
            <p>Travel ERP System</p>
        </div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/home">
            <i class="fa-solid fa-house"></i><span>Trang chủ quản trị</span>
        </a>

        <div class="nav-section-title">Quản trị hệ thống</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fa-solid fa-chart-line"></i><span>Dashboard</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/user">
            <i class="fa-solid fa-users"></i><span>Quản lý người dùng</span>
        </a>

        <div class="nav-section-title">Dịch vụ du lịch</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/tour">
            <i class="fa-solid fa-map-location-dot"></i><span>Quản lý Tour</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/accommodation?action=list">
            <i class="fa-solid fa-hotel"></i><span>Quản lý lưu trú</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/vehicle?action=list">
            <i class="fa-solid fa-car-side"></i><span>Quản lý phương tiện</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/service">
            <i class="fa-solid fa-briefcase"></i><span>Quản lý dịch vụ</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/external-ticket">
            <i class="fa-solid fa-ticket"></i><span>Vé tham quan bên ngoài</span>
        </a>

        <div class="nav-section-title">Vận hành</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking">
            <i class="fa-solid fa-calendar-check"></i><span>Quản lý đặt chỗ</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/payment">
            <i class="fa-solid fa-credit-card"></i><span>Quản lý thanh toán</span>
        </a>
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/staff/voucher">
            <i class="fa-solid fa-gift"></i><span>Quản lý Voucher</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/assignment">
            <i class="fa-solid fa-user-tie"></i><span>Điều phối hướng dẫn viên</span>
        </a>

        <div class="nav-section-title">Nội dung & CSKH</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/blog">
            <i class="fa-solid fa-newspaper"></i><span>Quản lý Blog</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/feedback">
            <i class="fa-solid fa-comments"></i><span>Đánh giá khách hàng</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/notification">
            <i class="fa-solid fa-bell"></i><span>Cấu hình thông báo</span>
        </a>

        <div class="admin-user">
            <div class="avatar">AD</div>
            <div>
                <div class="fw-bold">Quản trị viên</div>
                <small>Admin / Staff</small>
            </div>
        </div>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Quản lý Mã giảm giá (Vouchers)</h1>
                <p>Tạo, cập nhật và theo dõi các chiến dịch ưu đãi của WonderVN.</p>
            </div>
            <div class="top-actions">
                <a class="top-action-btn btn-home" href="${pageContext.request.contextPath}/admin/home">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
                <button class="top-action-btn btn-primary-custom" onclick="openModal('insert')">
                    <i class="fa-solid fa-plus"></i> Thêm Voucher Mới
                </button>
            </div>
        </div>

        <div class="content-card">
            <table id="voucherTable">
                <thead>
                <tr>
                    <th>Mã Voucher</th>
                    <th>Tên chiến dịch</th>
                    <th>Hình ảnh</th>    <th>Mô tả</th>       <th>Giảm</th>
                    <th>Thời gian áp dụng</th>
                    <th>Số lượng</th>
                    <th>Áp dụng cho</th>
                    <th>Trạng thái</th>
                    <th data-orderable="false" style="text-align: center;">Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${VOUCHER_LIST}" var="v">
                    <tr>
                        <td><strong style="color: #0f172a;">${v.voucherCode}</strong></td>
                        <td>${v.voucherName}</td>

                        <td>
                            <c:choose>
                                <c:when test="${not empty v.image}">
                                    <img src="${v.image}" alt="Img" style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid #e2e8f0;">
                                </c:when>
                                <c:otherwise>
                                    <div style="width: 50px; height: 50px; background: #f1f5f9; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #94a3b8; font-size: 20px;">
                                        <i class="fa-regular fa-image"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td style="max-width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${v.description}">
                                ${not empty v.description ? v.description : '<i style="color: #94a3b8;">Chưa có mô tả</i>'}
                        </td>
                        <td style="color: #4e46dc; font-weight: 800; font-size: 16px;">
                            <fmt:formatNumber value="${v.percentDiscount}" pattern="#" />%
                        </td>
                        <td style="color: #64748b;"><i class="fa-regular fa-calendar me-1"></i> ${v.startDate} <i class="fa-solid fa-arrow-right mx-1" style="font-size:10px;"></i> ${v.endDate}</td>
                        <td><strong>${v.quantity}</strong></td>
                        <td>
                            <span class="status-badge ${v.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                <c:if test="${v.status == 'Active'}"><i class="fa-solid fa-circle-check"></i></c:if>
                                <c:if test="${v.status == 'Inactive'}"><i class="fa-solid fa-circle-xmark"></i></c:if>
                                ${v.status}
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${v.applyFor == 'All'}"><span class="badge bg-secondary">Tất cả dịch vụ</span></c:when>
                                <c:when test="${v.applyFor == 'Hotel'}"><span class="badge bg-info text-dark"><i class="fa-solid fa-hotel"></i> Lưu trú (Hotel)</span></c:when>
                                <c:when test="${v.applyFor == 'Tour'}"><span class="badge bg-primary"><i class="fa-solid fa-route"></i> Vé & Tour</span></c:when>
                                <c:when test="${v.applyFor == 'Vehicle'}"><span class="badge bg-warning text-dark"><i class="fa-solid fa-car"></i> Thuê xe</span></c:when>
                            </c:choose>
                        </td>

                        <td style="text-align: center;">
                            <button class="btn-icon btn-edit" title="Cập nhật"
                                    data-id="${v.voucherId}"
                                    data-code="${v.voucherCode}"
                                    data-name="${v.voucherName}"
                                    data-percent="${v.percentDiscount}"
                                    data-start="${v.startDate}"
                                    data-end="${v.endDate}"
                                    data-qty="${v.quantity}"
                                    data-status="${v.status}"
                                    data-apply="${v.applyFor}"
                                    data-image="${v.image}"
                                    data-desc="${v.description}"
                                    onclick="openModal('update', this)">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </button>

                            <c:if test="${v.status == 'Active'}">
                                <a href="${pageContext.request.contextPath}/staff/voucher?action=delete&id=${v.voucherId}"
                                   class="btn-icon btn-delete" title="Vô hiệu hóa"
                                   onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa mã ${v.voucherCode}?');">
                                    <i class="fa-solid fa-trash-can"></i>
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </main>
</div>

<div class="modal-overlay" id="voucherModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="modalTitle"><i class="fa-solid fa-plus-circle text-primary me-2"></i> Thêm Voucher Mới</h3>
            <button class="close-btn" onclick="closeModal()">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/staff/voucher" method="POST" id="voucherForm" onsubmit="return validateVoucherForm()">
            <input type="hidden" name="action" id="formAction" value="insert">
            <input type="hidden" name="voucherId" id="voucherId">

            <div class="row">

                <div class="col-md-6">
                    <div class="form-group">
                        <label>Mã Voucher (Code):</label>
                        <input type="text" name="voucherCode" id="voucherCode" class="form-control" placeholder="VD: SUMMER26" autocomplete="off">
                        <div id="codeFeedback" class="feedback-msg"></div>
                    </div>

                    <div class="form-group">
                        <label>Tên chiến dịch:</label>
                        <input type="text" name="voucherName" id="voucherName" class="form-control" placeholder="VD: Chào Hè Sôi Động" autocomplete="off">
                        <div id="nameFeedback" class="feedback-msg"></div>
                    </div>

                    <div class="form-group">
                        <label>Áp dụng cho dịch vụ:</label>
                        <select name="applyFor" id="applyFor" class="form-control">
                            <option value="All">All (Áp dụng toàn hệ thống)</option>
                            <option value="Hotel">Hotel (Dịch vụ Lưu trú / Khách sạn)</option>
                            <option value="Tour">Tour (Vé vui chơi và Tour du lịch)</option>
                            <option value="Vehicle">Vehicle (Dịch vụ Thuê xe)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Hình ảnh minh họa (URL link):</label>
                        <input type="text" name="image" id="image" class="form-control" placeholder="Dán link ảnh vào đây...">
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="row">
                        <div class="col-6 form-group">
                            <label>Phần trăm giảm (%):</label>
                            <input type="number" name="percentDiscount" id="percentDiscount" class="form-control" placeholder="1-100">
                            <div id="percentFeedback" class="feedback-msg"></div>
                        </div>
                        <div class="col-6 form-group">
                            <label>Số lượng phát hành:</label>
                            <input type="number" name="quantity" id="quantity" class="form-control" placeholder=">= 1">
                            <div id="quantityFeedback" class="feedback-msg"></div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-6 form-group">
                            <label>Ngày bắt đầu:</label>
                            <input type="date" name="startDate" id="startDate" class="form-control" required>
                            <div id="startDateFeedback" class="feedback-msg"></div>
                        </div>
                        <div class="col-6 form-group">
                            <label>Ngày kết thúc:</label>
                            <input type="date" name="endDate" id="endDate" class="form-control" required>
                            <div id="endDateFeedback" class="feedback-msg"></div>
                        </div>
                    </div>

                    <div class="form-group" id="statusGroup" style="display: none;">
                        <label>Trạng thái hoạt động:</label>
                        <select name="status" id="status" class="form-control">
                            <option value="Active">Active (Đang hoạt động)</option>
                            <option value="Inactive">Inactive (Vô hiệu hóa)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Mô tả chi tiết:</label>
                        <textarea name="description" id="description" class="form-control" rows="4" placeholder="Nhập điều kiện áp dụng, mô tả..."></textarea>
                    </div>
                </div>
            </div> <div class="modal-footer" style="border-top: 1px solid #e2e8f0; padding-top: 20px; margin-top: 10px;">
            <button type="button" class="btn-cancel" onclick="closeModal()">Hủy thao tác</button>
            <button type="submit" class="btn-submit" id="btnSubmit">Lưu Dữ Liệu</button>
        </div>
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // ================= KHỞI TẠO DATATABLES =================
    $(document).ready(function() {
        $('#voucherTable').DataTable({
            "language": {
                "search": "Tìm kiếm:",
                "lengthMenu": "Hiển thị _MENU_ dòng",
                "info": "Hiển thị _START_ - _END_ của _TOTAL_ mã",
                "paginate": { "next": "Tiếp", "previous": "Trước" },
                "zeroRecords": "Không tìm thấy dữ liệu!"
            },
            "pageLength": 10,
            "order": [[ 5, "asc" ]]
        });
    });

    // ================= QUẢN LÝ POPUP & RESET TRẠNG THÁI =================
    function openModal(action, btn = null) {
        document.getElementById('voucherModal').style.display = 'flex';
        document.getElementById('formAction').value = action;
        resetValidationUI();
        let today = new Date().toISOString().split('T')[0];

        if (action === 'insert') {
            document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-plus-circle" style="color:#4e46dc;"></i> Thêm Voucher Mới';
            document.getElementById('btnSubmit').innerText = 'Tạo Voucher';
            document.getElementById('voucherCode').readOnly = false;
            document.getElementById('statusGroup').style.display = 'none';
            document.getElementById('endDate').setAttribute('min', today);

            // Reset Form
            document.getElementById('voucherForm').reset();
            document.getElementById('voucherId').value = '';
            document.getElementById('formAction').value = 'insert';
        } else {
            document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-pen-to-square" style="color:#4e46dc;"></i> Cập nhật Voucher';
            document.getElementById('btnSubmit').innerText = 'Lưu Thay Đổi';
            document.getElementById('voucherCode').readOnly = true;
            document.getElementById('statusGroup').style.display = 'block';
            document.getElementById('endDate').removeAttribute('min');

            // Bóc tách dữ liệu từ thuộc tính data-* của nút bấm
            document.getElementById('voucherId').value = btn.getAttribute('data-id');
            document.getElementById('voucherCode').value = btn.getAttribute('data-code');
            document.getElementById('voucherName').value = btn.getAttribute('data-name');
            document.getElementById('percentDiscount').value = parseFloat(btn.getAttribute('data-percent'));
            document.getElementById('startDate').value = btn.getAttribute('data-start');
            document.getElementById('endDate').value = btn.getAttribute('data-end');
            document.getElementById('quantity').value = btn.getAttribute('data-qty');
            document.getElementById('status').value = btn.getAttribute('data-status');
            document.getElementById('applyFor').value = btn.getAttribute('data-apply');
            document.getElementById('image').value = btn.getAttribute('data-image') || '';
            document.getElementById('description').value = btn.getAttribute('data-desc') || '';
        }
    }

    function closeModal() {
        document.getElementById('voucherModal').style.display = 'none';
    }

    // ================= REAL-TIME INLINE VALIDATION =================
    const regexCode = /^[A-Z0-9]+$/;
    const regexName = /^[a-zA-Z0-9\sàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ]+$/;

    // Hàm đổi màu sắc, icon dựa vào trạng thái hợp lệ hay không
    function setInputStatus(inputEl, feedbackEl, message, status) {
        inputEl.classList.remove('input-error', 'input-success');
        feedbackEl.classList.remove('feedback-error', 'feedback-success');

        if (status === 'error') {
            inputEl.classList.add('input-error');
            feedbackEl.classList.add('feedback-error');
            feedbackEl.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i> ' + message;
        } else if (status === 'success') {
            inputEl.classList.add('input-success');
            feedbackEl.classList.add('feedback-success');
            feedbackEl.innerHTML = '<i class="fa-solid fa-circle-check"></i> ' + message;
        } else {
            feedbackEl.innerHTML = '';
        }
    }

    function resetValidationUI() {
        const inputs = document.querySelectorAll('.form-control');
        const feedbacks = document.querySelectorAll('.feedback-msg');
        inputs.forEach(el => el.classList.remove('input-error', 'input-success'));
        feedbacks.forEach(el => { el.innerHTML = ''; el.classList.remove('feedback-error', 'feedback-success'); });
    }

    // Gắn sự kiện "input" (bắt từng phím gõ) cho các ô
    document.getElementById('voucherCode').addEventListener('input', function() {
        if (this.readOnly) return; // Nếu đang trong chế độ Sửa (Readonly) thì bỏ qua
        let val = this.value.trim();
        let fb = document.getElementById('codeFeedback');
        if (!val) { setInputStatus(this, fb, 'Không được để trống', 'error'); return; }
        if (!regexCode.test(val)) setInputStatus(this, fb, 'Chỉ chứa chữ IN HOA và SỐ, không dấu, không khoảng trắng', 'error');
        else setInputStatus(this, fb, 'Mã hợp lệ', 'success');
    });

    document.getElementById('voucherName').addEventListener('input', function() {
        let val = this.value.trim();
        let fb = document.getElementById('nameFeedback');
        if (!val) { setInputStatus(this, fb, 'Không được để trống', 'error'); return; }
        if (!regexName.test(val)) setInputStatus(this, fb, 'Không được chứa ký tự đặc biệt (@, #, $...)', 'error');
        else setInputStatus(this, fb, 'Tên hợp lệ', 'success');
    });

    document.getElementById('percentDiscount').addEventListener('input', function() {
        let val = parseFloat(this.value);
        let fb = document.getElementById('percentFeedback');
        if (isNaN(val)) { setInputStatus(this, fb, 'Vui lòng nhập số', 'error'); return; }
        if (!Number.isInteger(val) || val < 1 || val > 100) setInputStatus(this, fb, 'Phải là số nguyên từ 1 đến 100', 'error');
        else setInputStatus(this, fb, 'Hợp lệ', 'success');
    });

    document.getElementById('quantity').addEventListener('input', function() {
        let val = parseFloat(this.value);
        let fb = document.getElementById('quantityFeedback');
        if (isNaN(val)) { setInputStatus(this, fb, 'Vui lòng nhập số', 'error'); return; }
        if (!Number.isInteger(val) || val < 1) setInputStatus(this, fb, 'Phải là số nguyên lớn hơn hoặc bằng 1', 'error');
        else setInputStatus(this, fb, 'Hợp lệ', 'success');
    });
    // ================= KIỂM TRA NGÀY THÁNG BẰNG JS =================
    function validateDates() {
        let startVal = document.getElementById('startDate').value;
        let endVal = document.getElementById('endDate').value;
        let startFb = document.getElementById('startDateFeedback');
        let endFb = document.getElementById('endDateFeedback');
        let startInput = document.getElementById('startDate');
        let endInput = document.getElementById('endDate');

        // Chỉ kiểm tra khi người dùng đã chọn cả 2 ngày
        if (startVal && endVal) {
            let sDate = new Date(startVal);
            let eDate = new Date(endVal);

            if (eDate <= sDate) {
                // Ngày kết thúc nhỏ hơn hoặc bằng ngày bắt đầu -> BÁO LỖI
                setInputStatus(endInput, endFb, 'Ngày kết thúc phải diễn ra sau ngày bắt đầu', 'error');
                return false;
            } else {
                // Ngày hợp lệ -> HIỆN XANH
                setInputStatus(endInput, endFb, 'Thời gian hợp lệ', 'success');
                setInputStatus(startInput, startFb, 'Thời gian hợp lệ', 'success');
                return true;
            }
        }
        return true;
    }

    // Bắt sự kiện mỗi khi người dùng thay đổi ngày trên lịch
    document.getElementById('startDate').addEventListener('change', validateDates);
    document.getElementById('endDate').addEventListener('change', validateDates);
    // Hàm chốt chặn cuối cùng khi ấn nút LƯU
    function validateVoucherForm() {
        // Chủ động "chọc" vào tất cả các ô để ép chúng chạy hàm kiểm tra và hiện đỏ/xanh nếu người dùng chưa kịp gõ gì mà đã bấm Lưu
        document.getElementById('voucherCode').dispatchEvent(new Event('input'));
        document.getElementById('voucherName').dispatchEvent(new Event('input'));
        document.getElementById('percentDiscount').dispatchEvent(new Event('input'));
        document.getElementById('quantity').dispatchEvent(new Event('input'));

        // Kiểm tra xem có ô nào bị dính class "input-error" màu đỏ không
        const errors = document.querySelectorAll('.input-error');
        if (errors.length > 0) {
            // Có lỗi! Tự động focus (trỏ con chuột) vào ô nhập sai đầu tiên
            errors[0].focus();
            return false; // Chặn không cho form gửi đi
        }
        // (Các code check lỗi cũ của bạn ở trên...)

        // THÊM CHỐT CHẶN NGÀY VÀO ĐÂY
        if (!validateDates()) {
            document.getElementById('endDate').focus();
            return false;
        }

        return true; // Hoàn hảo, gửi dữ liệu xuống Controller!
    }
</script>

<c:if test="${param.error == 'invalid_code'}">
    <script>alert("HỆ THỐNG TỪ CHỐI: Mã voucher không hợp lệ (Phải viết hoa liền không dấu)!");</script>
</c:if>
<c:if test="${param.error == 'invalid_number'}">
    <script>alert("HỆ THỐNG TỪ CHỐI: Phần trăm hoặc số lượng phải là số nguyên dương lớn hơn hoặc bằng 1!");</script>
</c:if>
<c:if test="${param.error == 'invalid_date'}">
    <script>alert("HỆ THỐNG TỪ CHỐI: Ngày kết thúc không hợp lệ!");</script>
</c:if>
<c:if test="${param.error == 'system_error'}">
    <script>alert("LỖI HỆ THỐNG: Vui lòng kiểm tra lại kiểu dữ liệu nhập vào!");</script>
</c:if>

</body>
</html>
