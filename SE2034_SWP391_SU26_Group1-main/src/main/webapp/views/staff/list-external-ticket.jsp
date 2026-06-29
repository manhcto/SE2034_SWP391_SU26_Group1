<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Vé tham quan | WonderVN Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css" rel="stylesheet">

    <style>
        body { background-color: #f8fafc; }
        .stat-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); display: flex; align-items: center; gap: 15px; border: 1px solid #f1f5f9; }
        .stat-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
        .stat-info h3 { margin: 0; font-size: 22px; font-weight: 700; color: #1e293b; }
        .stat-info p { margin: 0; font-size: 13px; font-weight: 600; color: #64748b; text-transform: uppercase; }

        .card-table { background: white; border-radius: 12px; border: none; box-shadow: 0 2px 12px rgba(0,0,0,0.04); padding: 20px; margin-top: 20px;}
        table.dataTable thead th { border-bottom: 1px solid #e2e8f0; color: #64748b; font-size: 12px; font-weight: 700; text-transform: uppercase; padding: 15px 10px; }
        table.dataTable tbody td { border-bottom: 1px solid #f1f5f9; vertical-align: middle; padding: 12px 10px; font-size: 14px; color: #1e293b; }

        .badge-status { padding: 6px 12px; border-radius: 20px; font-weight: 600; font-size: 12px; display: inline-flex; align-items: center; gap: 4px; }
        .status-active { background: #dcfce7; color: #166534; }
        .status-inactive { background: #f1f5f9; color: #475569; }
        .type-pill { background: #f1f5f9; color: #334155; font-weight: 600; padding: 4px 10px; border-radius: 6px; font-size: 12px; border: 1px solid #e2e8f0;}
        .action-btn { background: none; border: none; font-size: 16px; margin: 0 4px; transition: 0.2s; cursor: pointer; text-decoration: none; display: inline-block;}
        .btn-view { color: #0ea5e9; } .btn-edit { color: #6366f1; } .btn-delete { color: #ef4444; }
        .action-btn:hover { transform: scale(1.15); }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp"/>

    <main class="admin-main">
        <jsp:include page="/views/common/admin-header.jsp"/>

        <div class="p-4">

            <div class="rounded-3 p-4 mb-4 d-flex justify-content-between align-items-center shadow-sm" style="background-color: #1e40af;">
                <div class="d-flex align-items-center gap-3">
                    <i class="fa-solid fa-ticket text-white" style="font-size: 2.5rem;"></i>
                    <div>
                        <h2 class="text-white m-0 fw-bold fs-3">Quản lý Vé tham quan</h2>
                        <p class="text-white-50 m-0 mt-1 fs-6">Quản lý các điểm tham quan, hoạt động giải trí, giá vé và trạng thái.</p>
                    </div>
                </div>
                <div class="d-flex gap-3">
                    <a href="${pageContext.request.contextPath}/staff/home" class="btn btn-light text-primary fw-bold px-3 py-2 rounded-2 d-flex align-items-center gap-2"><i class="fa-solid fa-house"></i> Staff Home</a>
                    <a href="${pageContext.request.contextPath}/staff/external-ticket?action=add" class="btn btn-light text-primary fw-bold px-3 py-2 rounded-2 d-flex align-items-center gap-2"><i class="fa-solid fa-plus"></i> Thêm trải nghiệm</a>
                </div>
            </div>

            <c:set var="total" value="0" />
            <c:set var="activeCount" value="0" />
            <c:set var="attractionCount" value="0" />
            <c:set var="activityCount" value="0" />

            <c:forEach items="${TICKET_LIST}" var="t">
                <c:set var="total" value="${total + 1}" />
                <c:if test="${t.status == 'Active'}"><c:set var="activeCount" value="${activeCount + 1}" /></c:if>
                <c:if test="${t.type == 'Attraction'}"><c:set var="attractionCount" value="${attractionCount + 1}" /></c:if>
                <c:if test="${t.type == 'Activity'}"><c:set var="activityCount" value="${activityCount + 1}" /></c:if>
            </c:forEach>

            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: #e0e7ff; color: #4f46e5;"><i class="fa-solid fa-layer-group"></i></div>
                        <div class="stat-info"><h3>${total}</h3><p>Tổng dịch vụ</p></div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: #dcfce7; color: #16a34a;"><i class="fa-solid fa-circle-check"></i></div>
                        <div class="stat-info"><h3>${activeCount}</h3><p>Đang hoạt động</p></div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: #dbeafe; color: #2563eb;"><i class="fa-solid fa-ferris-wheel"></i></div>
                        <div class="stat-info"><h3>${attractionCount}</h3><p>Tham quan</p></div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: #ffedd5; color: #ea580c;"><i class="fa-solid fa-person-swimming"></i></div>
                        <div class="stat-info"><h3>${activityCount}</h3><p>Hoạt động</p></div>
                    </div>
                </div>
            </div>

            <div class="card-table mb-3" style="padding: 15px 20px;">
                <div class="row g-3 align-items-center">
                    <div class="col-md-7 d-flex gap-2 align-items-center">
                        <div class="fw-bold text-secondary me-2"><i class="fa-solid fa-filter"></i> Lọc:</div>
                        <select id="filterType" class="form-select border-primary" style="width: 200px;">
                            <option value="">Tất cả phân loại</option>
                            <option value="Tham Quan">Điểm Tham Quan</option>
                            <option value="Hoạt Động">Hoạt Động</option>
                        </select>
                        <select id="filterStatus" class="form-select border-primary" style="width: 200px;">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Active">Đang hoạt động</option>
                            <option value="Inactive">Đã khóa</option>
                        </select>
                    </div>

                    <div class="col-md-5 text-end border-start">
                        <div class="d-flex justify-content-end gap-2">
                            <select id="bulkActionType" class="form-select border-secondary" style="width: 180px;">
                                <option value="" disabled selected>-- Chọn thao tác --</option>
                                <option value="active">Mở khóa (Active)</option>
                                <option value="inactive">Tạm khóa (Inactive)</option>
                                <option value="delete">Xóa bản ghi</option>
                            </select>
                            <button type="button" class="btn btn-secondary fw-bold" onclick="submitBulkAction()">Áp dụng</button>
                        </div>
                    </div>
                </div>
            </div>

            <form id="bulkForm" action="${pageContext.request.contextPath}/staff/external-ticket" method="POST">
                <input type="hidden" name="action" value="bulk">
                <input type="hidden" name="bulkActionType" id="hiddenBulkType">

                <div class="card-table">
                    <table id="ticketTable" class="table table-hover w-100">
                        <thead>
                        <tr>
                            <th width="3%" class="text-center"><input class="form-check-input border-secondary" type="checkbox" id="selectAll"></th>
                            <th width="5%" class="text-center">ID</th>
                            <th width="8%">Ảnh</th>
                            <th width="22%">Tên Dịch Vụ</th>
                            <th width="15%">Địa điểm</th>
                            <th width="10%">Phân Loại</th>
                            <th width="12%">Giá (VND)</th>
                            <th width="10%" class="text-center">Status</th>
                            <th width="12%" class="text-center">Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${TICKET_LIST}" var="t">
                            <tr>
                                <td class="text-center"><input class="form-check-input row-checkbox border-secondary" type="checkbox" name="ticketIds" value="${t.serviceID}"></td>
                                <td class="text-center fw-bold text-secondary">#${t.serviceID}</td>
                                <td><img src="${t.image}" alt="Img" style="width: 45px; height: 45px; border-radius: 8px; object-fit: cover;"></td>
                                <td class="fw-bold text-dark">${t.name}</td>
                                <td class="text-muted"><i class="fa-solid fa-location-dot text-danger"></i> ${t.address}</td>
                                <td>
                                    <c:if test="${t.type == 'Attraction'}"><span class="type-pill text-primary border-primary bg-transparent">Tham Quan</span></c:if>
                                    <c:if test="${t.type == 'Activity'}"><span class="type-pill text-warning border-warning bg-transparent">Hoạt Động</span></c:if>
                                </td>
                                <td class="fw-bold text-danger"><fmt:formatNumber value="${t.ticketPrice}" pattern="#,###" />đ</td>
                                <td class="text-center">
                                    <c:if test="${t.status == 'Active'}"><span class="badge-status status-active">Active</span></c:if>
                                    <c:if test="${t.status == 'Inactive'}"><span class="badge-status status-inactive">Inactive</span></c:if>
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/staff/external-ticket?action=view&id=${t.serviceID}" class="action-btn btn-view"><i class="fa-solid fa-eye"></i></a>
                                    <a href="${pageContext.request.contextPath}/staff/external-ticket?action=edit&id=${t.serviceID}" class="action-btn btn-edit"><i class="fa-solid fa-pen-to-square"></i></a>
                                    <a href="${pageContext.request.contextPath}/staff/external-ticket?action=delete&id=${t.serviceID}" class="action-btn btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa dịch vụ #${t.serviceID} không?');"><i class="fa-solid fa-trash-can"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </form>

        </div>
    </main>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function() {
        var table = $('#ticketTable').DataTable({
            "language": {
                "lengthMenu": "Hiển thị _MENU_ dòng",
                "search": "Tìm kiếm:",
                "zeroRecords": "Không tìm thấy dữ liệu",
                "info": "Đang hiển thị _START_ đến _END_ trên tổng số _TOTAL_ bản ghi",
                "infoEmpty": "Không có dữ liệu",
                "infoFiltered": "(lọc từ _MAX_ bản ghi)",
                "paginate": { "previous": "Trước", "next": "Sau" }
            },
            "order": [[1, "desc"]],
            "pageLength": 10,
            "columnDefs": [ { "orderable": false, "targets": 0 } ],
            "dom": '<"row mb-3"<"col-md-6"l><"col-md-6 d-flex justify-content-end"f>>rt<"row mt-3"<"col-md-6"i><"col-md-6"p>>'
        });

        // Liên kết bộ lọc trái
        $('#filterType').on('change', function() { table.column(5).search(this.value).draw(); });
        $('#filterStatus').on('change', function() { table.column(7).search(this.value).draw(); });

        // Nút Check All (Chọn tất cả vé hiển thị trên trang)
        $('#selectAll').on('click', function() {
            var isChecked = this.checked;
            $('.row-checkbox').each(function() {
                this.checked = isChecked;
            });
        });
    });

    // Hàm Xử lý Bulk Action khi bấm nút Áp Dụng
    function submitBulkAction() {
        var selectedAction = $('#bulkActionType').val();
        var checkedCount = $('.row-checkbox:checked').length;

        if (!selectedAction) {
            alert("Vui lòng chọn thao tác cần thực hiện (Mở khóa / Khóa / Xóa)!");
            return;
        }

        // KIỂM TRA XEM CÓ TÍCH CHỌN VÉ NÀO CHƯA
        if (checkedCount === 0) {
            alert("Vui lòng tích chọn ít nhất 1 vé ở cột bên trái để áp dụng!");
            return;
        }

        var confirmMsg = selectedAction === 'delete' ?
            "CẢNH BÁO: Bạn có chắc chắn muốn XÓA VĨNH VIỄN " + checkedCount + " vé đã chọn không?" :
            "Bạn muốn cập nhật trạng thái cho " + checkedCount + " vé đã chọn?";

        if (confirm(confirmMsg)) {
            $('#hiddenBulkType').val(selectedAction);
            $('#bulkForm').submit();
        }
    }
</script>

</body>
</html>