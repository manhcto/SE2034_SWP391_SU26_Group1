<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Thêm nhật ký tiến độ tour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css" rel="stylesheet">
</head>
<body>
<div class="workspace-layout">
    <aside class="workspace-sidebar">
        <div class="brand-box">
            <div class="brand-logo guide">TG</div>
            <h2>WonderVN</h2>
            <p>Khu vực hướng dẫn viên</p>
        </div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/guide/home"><i class="fa-solid fa-house"></i><span>Trang chủ hướng dẫn viên</span></a>
        <div class="nav-section-title">Nhiệm vụ tour</div>
        <a class="sidebar-link active guide" href="${pageContext.request.contextPath}/guide/assignment"><i class="fa-solid fa-clipboard-list"></i><span>Tour được phân công</span></a>
        <div class="nav-section-title">Tài khoản</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i><span>Đăng xuất</span></a>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Thêm nhật ký tiến độ tour</h1>
                <p>Ghi nhật ký lịch trình theo thời gian thực như đã đón khách, đã đến nơi, đã khởi hành hoặc báo cáo sự cố.</p>
            </div>
            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${assignment.assignmentID}">
                    <i class="fa-solid fa-arrow-left"></i>Quay lại tour
                </a>
            </div>
        </div>

        <section class="panel mb-4">
            <div class="panel-header">
                <div>
                    <h2>${assignment.tourName}</h2>
                    <p><fmt:formatDate value="${assignment.departureDate}" pattern="dd/MM/yyyy"/> · ${assignment.meetingPoint}</p>
                </div>
            </div>
            <div class="panel-body">
                <form method="post" action="${pageContext.request.contextPath}/guide/assignment">
                    <input type="hidden" name="action" value="addProgressLog">
                    <input type="hidden" name="assignmentID" value="${assignment.assignmentID}">

                    <div class="row g-4">
                        <div class="col-md-4">
                            <label class="form-label">Trạng thái tiến độ</label>
                            <select class="form-select" name="progressStatus" required>
                                <option value="Pickup Completed">Đã đón khách</option>
                                <option value="Departed">Đã khởi hành</option>
                                <option value="Arrived">Đã đến nơi</option>
                                <option value="Activity Completed">Hoàn thành hoạt động</option>
                                <option value="Returning">Đang quay về</option>
                                <option value="Completed">Hoàn thành tour</option>
                                <option value="Issue">Có vấn đề phát sinh</option>
                                <option value="Update">Cập nhật</option>
                            </select>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label">Tiêu đề</label>
                            <input class="form-control" name="title" placeholder="VD: Đã đến điểm đón khách">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Nội dung</label>
                            <textarea class="form-control" name="content" rows="6" placeholder="VD: Đoàn đã có mặt 18/20 khách, xe chuẩn bị khởi hành."></textarea>
                        </div>
                    </div>

                    <div class="top-actions mt-4">
                        <button class="top-action-btn btn-guide-action" type="submit">
                            <i class="fa-solid fa-floppy-disk"></i>Lưu nhật ký
                        </button>
                        <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${assignment.assignmentID}">Hủy</a>
                    </div>
                </form>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Nhật ký gần đây</h2>
                    <p>Các nhật ký đã được ghi cho phân công này.</p>
                </div>
            </div>
            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle data-table">
                        <thead>
                        <tr>
                            <th>Thời gian</th>
                            <th>Trạng thái</th>
                            <th>Tiêu đề</th>
                            <th>Nội dung</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="log" items="${progressLogs}">
                            <tr>
                                <td><fmt:formatDate value="${log.logTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><span class="status-pill status-progress">${log.progressStatusLabel}</span></td>
                                <td>${empty log.title ? 'Cập nhật tour' : log.title}</td>
                                <td>${empty log.content ? 'Không có nội dung' : log.content}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty progressLogs}">
                            <tr><td colspan="4" class="text-center text-muted py-5">Chưa có nhật ký nào.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
