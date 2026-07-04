<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Admin Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f4f7fb;
            font-family: "Be Vietnam Pro", Arial, sans-serif;
            color: #0f172a;
        }
        .badge-role-admin{
            background:#fecaca;
            color:#111827;
            font-weight:700;
        }

        .badge-role-staff{
            background:#dbeafe;
            color:#111827;
            font-weight:700;
        }

        .badge-role-guide{
            background:#fef3c7;
            color:#111827;
            font-weight:700;
        }

        .badge-role-customer{
            background:#e5e7eb;
            color:#111827;
            font-weight:700;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        .admin-sidebar {
            width: 292px;
            background: #0f172a;
            color: #ffffff;
            position: fixed;
            inset: 0 auto 0 0;
            overflow-y: auto;
            padding: 26px 18px;
            box-shadow: 8px 0 26px rgba(15, 23, 42, 0.18);
        }

        .brand-box {
            padding: 8px 10px 22px;
            margin-bottom: 12px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.25);
        }

        .brand-logo {
            width: 54px;
            height: 54px;
            border-radius: 18px;
            background: linear-gradient(135deg, #f97316, #ef4444);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
            font-size: 20px;
            margin-bottom: 12px;
            box-shadow: 0 12px 24px rgba(239, 68, 68, 0.22);
        }

        .brand-box h2 {
            font-size: 26px;
            font-weight: 900;
            margin: 0;
            letter-spacing: -0.6px;
        }

        .brand-box p {
            color: #cbd5e1;
            margin: 5px 0 0;
            font-size: 14px;
        }

        .nav-section-title {
            font-size: 11px;
            text-transform: uppercase;
            color: #94a3b8;
            letter-spacing: 1.2px;
            margin: 22px 12px 10px;
            font-weight: 900;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 14px;
            border-radius: 15px;
            color: #e2e8f0;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 8px;
            transition: all 0.2s ease;
        }

        .sidebar-link i {
            width: 22px;
            text-align: center;
            font-size: 16px;
        }

        .sidebar-link:hover {
            background: #1e293b;
            color: #ffffff;
            transform: translateX(4px);
        }

        .sidebar-link.active {
            background: linear-gradient(135deg, #f97316, #ef4444);
            color: #ffffff;
            box-shadow: 0 10px 22px rgba(239, 68, 68, 0.20);
        }

        .admin-user {
            margin-top: 26px;
            border-top: 1px solid rgba(148, 163, 184, 0.25);
            padding: 18px 8px 4px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .avatar {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: linear-gradient(135deg, #f97316, #ef4444);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
            color: white;
        }

        .admin-user small {
            color: #94a3b8;
        }

        .main-content {
            margin-left: 292px;
            width: calc(100% - 292px);
            padding: 34px 42px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 26px;
        }

        .topbar h1 {
            font-size: 34px;
            font-weight: 900;
            margin: 0;
            letter-spacing: -0.8px;
        }

        .topbar p {
            color: #64748b;
            margin: 6px 0 0;
            font-size: 15px;
        }

        .top-actions {
            display: flex;
            gap: 12px;
        }

        .top-action-btn {
            border: none;
            border-radius: 16px;
            padding: 12px 18px;
            text-decoration: none;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08);
            white-space: nowrap;
        }

        .btn-client {
            background: #ffffff;
            color: #0f172a;
        }

        .btn-staff {
            background: #0f172a;
            color: #ffffff;
        }

        .btn-client:hover {
            background: #f8fafc;
            color: #ef4444;
        }

        .btn-staff:hover {
            background: #1e293b;
            color: #ffffff;
        }

        .hero {
            background:
                    radial-gradient(circle at top right, rgba(249, 115, 22, 0.28), transparent 30%),
                    linear-gradient(135deg, #0f172a, #991b1b);
            color: white;
            border-radius: 30px;
            padding: 36px;
            box-shadow: 0 18px 38px rgba(15, 23, 42, 0.18);
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.18);
            padding: 8px 13px;
            border-radius: 999px;
            font-weight: 800;
            margin-bottom: 16px;
        }

        .hero h2 {
            font-size: 38px;
            font-weight: 900;
            margin-bottom: 12px;
            letter-spacing: -0.8px;
        }

        .hero p {
            color: #fee2e2;
            margin-bottom: 0;
            max-width: 850px;
            line-height: 1.8;
            font-weight: 500;
        }

        .stat-card {
            border: none;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            height: 100%;
            background: white;
            transition: all 0.25s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 18px 38px rgba(15, 23, 42, 0.12);
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: white;
            margin-bottom: 16px;
        }

        .icon-red {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }

        .icon-orange {
            background: linear-gradient(135deg, #f97316, #f59e0b);
        }

        .icon-blue {
            background: linear-gradient(135deg, #2563eb, #4e46dc);
        }

        .icon-green {
            background: linear-gradient(135deg, #16a34a, #22c55e);
        }

        .stat-card h3 {
            font-size: 28px;
            font-weight: 900;
            margin-bottom: 4px;
        }

        .stat-card p {
            color: #64748b;
            margin-bottom: 0;
            font-weight: 600;
        }

        .section-title {
            font-weight: 900;
            margin: 34px 0 18px;
            font-size: 24px;
        }

        .module-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            padding: 24px;
            min-height: 210px;
            height: 100%;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            transition: all 0.25s ease;
            text-decoration: none;
            color: #0f172a;
            display: block;
            position: relative;
            overflow: hidden;
        }

        .module-card::after {
            content: "";
            position: absolute;
            right: -35px;
            bottom: -35px;
            width: 110px;
            height: 110px;
            border-radius: 50%;
            background: rgba(239, 68, 68, 0.08);
        }

        .module-card:hover {
            transform: translateY(-7px);
            border-color: #ef4444;
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.14);
            color: #0f172a;
        }

        .module-icon {
            width: 62px;
            height: 62px;
            border-radius: 20px;
            background: #fef2f2;
            color: #ef4444;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 18px;
        }

        .module-card h5 {
            font-weight: 900;
            margin-bottom: 9px;
            font-size: 18px;
        }

        .module-card p {
            color: #64748b;
            margin-bottom: 18px;
            font-size: 14px;
            line-height: 1.6;
        }

        .module-open {
            font-weight: 900;
            color: #ef4444;
            font-size: 14px;
        }

        .admin-card {
            border: 2px solid rgba(239, 68, 68, 0.22);
            background:
                    radial-gradient(circle at top right, rgba(239, 68, 68, 0.10), transparent 30%),
                    white;
        }

        .staff-view-card {
            border: 2px solid rgba(37, 99, 235, 0.18);
            background:
                    radial-gradient(circle at top right, rgba(37, 99, 235, 0.08), transparent 30%),
                    white;
        }

        @media (max-width: 992px) {
            .admin-sidebar {
                position: static;
                width: 100%;
                height: auto;
            }

            .admin-layout {
                display: block;
            }

            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 24px;
            }

            .topbar {
                display: block;
            }

            .top-actions {
                margin-top: 16px;
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>

<div class="admin-layout">

    <aside class="admin-sidebar">
        <div class="brand-logo">AD</div>
        <h3 class="mt-3">WonderVN</h3>

        <c:choose>

            <c:when test="${sessionScope.user.roleID == 1}">
                <a class="sidebar-link"
                   href="${pageContext.request.contextPath}/admin/home">
                    Trang Admin
                </a>

                <a class="sidebar-link active"
                   href="${pageContext.request.contextPath}/admin/user">
                    Quản lí người dùng
                </a>
            </c:when>

            <c:when test="${sessionScope.user.roleID == 2}">
                <a class="sidebar-link active"
                   href="${pageContext.request.contextPath}/admin/user">
                    Xem người dùng
                </a>
            </c:when>

        </c:choose>

    </aside>

    <main class="main-content">

        <div class="hero">
            <h2>Quản Lí Người Dùng</h2>
            <p>Quản lí người dùng, vai trò và phân quyền của WonderVN.</p>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-3"><div class="stat-card"><h3>${totalUsers}</h3><p>Tổng người dùng</p></div></div>
            <div class="col-md-3"><div class="stat-card"><h3>${staffCount}</h3><p>Nhân viên</p></div></div>
            <div class="col-md-3"><div class="stat-card"><h3>${tourGuideCount}</h3><p>Hướng dẫn viên</p></div></div>
            <div class="col-md-3"><div class="stat-card"><h3>${customerCount}</h3><p>Khách hàng</p></div></div>
        </div>

        <div class="user-table">

            <form method="get" class="row g-3 mb-4">
                <div class="col-md-4">
                    <input class="form-control" name="keyword" placeholder="Tìm theo tên/ email/ số điện thoại">
                </div>
                <div class="col-md-2">
                    <select class="form-select" name="role">
                        <option value="">Tất cả vai trò</option>
                        <option value="1">Admin</option>
                        <option value="2">Nhân viên</option>
                        <option value="3">Hướng dân viên</option>
                        <option value="4">Khách hàng</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select class="form-select" name="status">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Active">Hoạt động</option>
                        <option value="Inactive">Xóa bởi người dùng</option>
                        <option value="Blocked">Xóa bởi Admin</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button class="btn btn-danger w-100">Tìm</button>
                </div>
            </form>

            <table class="table table-hover align-middle">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <c:if test="${sessionScope.user.roleID == 1}">
                        <th>Action</th>
                    </c:if>
                </tr>
                </thead>
                <tbody>

                <c:forEach items="${users}" var="u" varStatus="loop">
                    <tr>

                        <td>${(currentPage-1)*10 + loop.index + 1}</td>

                        <td>${u.firstName} ${u.lastName}</td>
                        <td>${u.email}</td>
                        <td>${u.phone}</td>

                        <td style="color: black">
                            <c:choose>
                                <c:when test="${u.roleID==1}"><span class="badge badge-role-admin">Admin</span></c:when>
                                <c:when test="${u.roleID==2}"><span class="badge badge-role-staff">Nhân viên</span></c:when>
                                <c:when test="${u.roleID==3}"><span class="badge badge-role-guide">Hướng dẫn viên</span></c:when>
                                <c:otherwise><span class="badge badge-role-customer">Khách hàng</span></c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${u.status == 'Active'}">Hoạt động</c:when>
                                <c:when test="${u.status == 'Inactive'}">Xóa bởi người dùng</c:when>
                                <c:when test="${u.status == 'Blocked'}">Đã bị admin xóa</c:when>
                                <c:otherwise>${u.status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <fmt:formatDate value="${u.createAt}" pattern="dd/MM/yyyy"/>
                        </td>

                        <c:if test="${sessionScope.user.roleID == 1}">
                            <td>
                                <c:if test="${u.userID != sessionScope.user.userID
                     && u.roleID != 1
                     && u.status == 'Active'}">

                                    <button class="btn btn-outline-primary btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#editModal${u.userID}">
                                        Sửa
                                    </button>

                                    <a class="btn btn-outline-danger btn-sm"
                                       href="${pageContext.request.contextPath}/admin/user/block?id=${u.userID}"
                                       onclick="return confirm('Bạn có chắc muốn khóa tài khoản này?')">
                                        Chặn
                                    </a>

                                </c:if>

                            </td>
                        </c:if>

                    </tr>

                    <c:if test="${sessionScope.user.roleID == 1}">
                    <div class="modal fade"
                         id="editModal${u.userID}">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="${pageContext.request.contextPath}/admin/user/update" method="post">

                                    <div class="modal-header">
                                        <h5>Sửa người dùng</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>

                                    <div class="modal-body">

                                        <input type="hidden" name="userID" value="${u.userID}">

                                        <div class="mb-3">
                                            <label>Vai trò</label>
                                            <select class="form-select" name="roleID">
                                                <option value="1">Admin</option>
                                                <option value="2">Nhân viên</option>
                                                <option value="3">Hướng dẫn viên</option>
                                                <option value="4">Khách hàng</option>
                                            </select>
                                        </div>



                                    </div>

                                    <div class="modal-footer">
                                        <button class="btn btn-danger">Lưu thay đổi</button>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>
                    </c:if>

                </c:forEach>

                </tbody>
            </table>

            <nav>
                <ul class="pagination justify-content-center">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i==currentPage?'active':''}">
                            <a class="page-link" href="?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>

        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
