<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Blog | WonderVN Staff</title>
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

        .admin-main.with-admin-sidebar {
            margin-left: 292px;
            width: calc(100% - 292px);
        }

        .page-banner {
            background: #0f766e;
            border-radius: 14px;
            color: #ffffff;
            padding: 26px;
            box-shadow: 0 12px 30px rgba(15, 118, 110, 0.18);
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

        .image-preview {
            width: 100%;
            height: 170px;
            border-radius: 12px;
            object-fit: cover;
            background: #e2e8f0;
            border: 1px solid #e2e8f0;
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

        .status-published {
            background: #dcfce7;
            color: #166534;
        }

        .status-draft {
            background: #f1f5f9;
            color: #475569;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-rejected {
            background: #fee2e2;
            color: #b91c1c;
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

        .post-title {
            max-width: 310px;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.35;
        }

        .action-btn {
            border: 1px solid #dbe5f2;
            background: #ffffff;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 8px;
            color: #475569;
            transition: background-color 0.2s ease, border-color 0.2s ease;
        }

        .action-btn:hover {
            background: #f1f5f9;
        }

        .btn-view {
            color: #0284c7;
        }

        .btn-edit {
            color: #4f46e5;
        }

        .btn-delete {
            color: #dc2626;
        }

        .btn-approve {
            color: #15803d;
        }

        .btn-reject {
            color: #dc2626;
        }

        .action-group {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 8px;
        }

        .action-form {
            display: inline-flex;
            margin: 0;
        }

        .blog-modal {
            position: fixed;
            inset: 0;
            z-index: 1200;
            padding: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(15, 23, 42, 0.58);
        }

        .blog-dialog {
            width: min(780px, 100%);
            max-height: calc(100vh - 48px);
            overflow-y: auto;
        }
@media (max-width: 992px) {
            .admin-layout {
                display: block;
            }

            .admin-main.with-admin-sidebar {
                margin-left: 0;
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="admin-layout">
    <c:choose>
        <c:when test="${blogManagementRole == 'admin'}">
            <jsp:include page="/views/common/admin-sidebar.jsp">
                <jsp:param name="activeAdminMenu" value="blog"/>
            </jsp:include>
        </c:when>
        <c:otherwise>
            <jsp:include page="/views/common/staff-sidebar.jsp"/>
        </c:otherwise>
    </c:choose>

    <main class="admin-main${blogManagementRole == 'admin' ? ' with-admin-sidebar' : ''}">
        <jsp:include page="/views/common/admin-header.jsp"/>

        <div class="p-4">
            <div class="page-banner mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div class="d-flex align-items-center gap-3">
                    <i class="fa-solid fa-newspaper" style="font-size: 2.4rem;"></i>
                    <div>
                        <h1 class="h3 fw-bold m-0">Quản lý Blog</h1>
                        <p class="m-0 mt-1 text-white-50">Duyệt bài viết khách hàng và xuất bản nội dung WonderVN.</p>
                    </div>
                </div>
                <c:if test="${not blogManagementReadOnly}">
                    <a class="btn btn-light fw-bold" href="${blogManagementPath}?action=new">
                        <i class="fa-solid fa-plus me-1"></i>Thêm blog
                    </a>
                </c:if>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger fw-semibold"><c:out value="${error}"/></div>
            </c:if>

            <c:if test="${not empty param.message}">
                <div class="alert alert-info fw-semibold">
                    <c:choose>
                        <c:when test="${param.message == 'saved'}">Đã lưu bài viết thành công.</c:when>
                        <c:when test="${param.message == 'deleted'}">Đã xóa bài viết.</c:when>
                        <c:when test="${param.message == 'status_updated'}">Đã cập nhật trạng thái bài viết.</c:when>
                        <c:when test="${param.message == 'not_found'}">Không tìm thấy bài viết cần sửa.</c:when>
                        <c:otherwise>Không thể xử lý yêu cầu. Vui lòng thử lại.</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:set var="total" value="0"/>
            <c:set var="publishedCount" value="0"/>
            <c:set var="pendingCount" value="0"/>
            <c:set var="draftCount" value="0"/>
            <c:set var="rejectedCount" value="0"/>

            <c:forEach items="${BLOG_LIST}" var="post">
                <c:set var="total" value="${total + 1}"/>
                <c:if test="${post.status == 'Published'}"><c:set var="publishedCount" value="${publishedCount + 1}"/></c:if>
                <c:if test="${post.status == 'Pending'}"><c:set var="pendingCount" value="${pendingCount + 1}"/></c:if>
                <c:if test="${post.status == 'Draft'}"><c:set var="draftCount" value="${draftCount + 1}"/></c:if>
                <c:if test="${post.status == 'Rejected'}"><c:set var="rejectedCount" value="${rejectedCount + 1}"/></c:if>
            </c:forEach>

            <div class="row row-cols-1 row-cols-md-2 row-cols-xl-5 g-3 mb-4">
                <div class="col">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#e0f2fe;color:#0369a1;"><i class="fa-solid fa-layer-group"></i></div>
                        <div><h3>${total}</h3><p>Tổng bài viết</p></div>
                    </div>
                </div>
                <div class="col">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#dcfce7;color:#166534;"><i class="fa-solid fa-circle-check"></i></div>
                        <div><h3>${publishedCount}</h3><p>Đã đăng</p></div>
                    </div>
                </div>
                <div class="col">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#fef3c7;color:#92400e;"><i class="fa-solid fa-clock"></i></div>
                        <div><h3>${pendingCount}</h3><p>Chờ duyệt</p></div>
                    </div>
                </div>
                <div class="col">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#f1f5f9;color:#475569;"><i class="fa-solid fa-pen"></i></div>
                        <div><h3>${draftCount}</h3><p>Bản nháp</p></div>
                    </div>
                </div>
                <div class="col">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#fee2e2;color:#b91c1c;"><i class="fa-solid fa-ban"></i></div>
                        <div><h3>${rejectedCount}</h3><p>Từ chối</p></div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <c:if test="${not blogManagementReadOnly && showBlogForm}">
                <div class="blog-modal" role="dialog" aria-modal="true" aria-label="Biểu mẫu blog">
                    <div class="blog-dialog content-card">
                                <h2 class="h5 fw-bold mb-3">
                                    <c:choose>
                                        <c:when test="${not empty editingPost && editingPost.blogID > 0}">
                                            <i class="fa-solid fa-pen-to-square text-primary me-2"></i>Sửa bài viết
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-plus text-primary me-2"></i>Thêm bài viết
                                        </c:otherwise>
                                    </c:choose>
                                </h2>

                                <form action="${blogManagementPath}" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="save">
                                    <input type="hidden" name="blogID" value="${editingPost.blogID}">
                                    <input type="hidden" name="existingImage" value="${editingPost.image}">

                                    <div class="mb-3">
                                        <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                                        <input class="form-control" type="text" name="title" maxlength="255"
                                               value="${editingPost.title}" required>
                                    </div>

                                    <div class="mb-3 mt-3">
                                        <label class="form-label">Slug tùy chỉnh</label>
                                        <input class="form-control" type="text" name="slug" maxlength="255"
                                               value="${editingPost.slug}" placeholder="Tự tạo từ tiêu đề nếu bỏ trống">
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Ảnh</label>
                                        <input class="form-control" type="file" name="image" id="image"
                                               accept="image/jpeg,image/png,image/webp"
                                               value="${editingPost.image}" placeholder="">
                                    </div>

                                    <div class="mb-3">
                                        <c:set var="previewUrl" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png"/>
                                        <c:if test="${not empty editingPost.image}">
                                            <c:set var="previewUrl" value="${editingPost.image}"/>
                                            <c:if test="${not fn:startsWith(editingPost.image, 'http')}">
                                                <c:set var="previewUrl" value="${pageContext.request.contextPath}/${editingPost.image}"/>
                                            </c:if>
                                        </c:if>
                                        <img id="imagePreview"
                                             class="image-preview"
                                             src="${previewUrl}"
                                             alt="image preview">
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Tóm tắt</label>
                                        <textarea class="form-control" name="summary" rows="3" maxlength="500"><c:out value="${editingPost.summary}"/></textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Nội dung <span class="text-danger">*</span></label>
                                        <textarea class="form-control" name="content" rows="10" required><c:out value="${editingPost.content}"/></textarea>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button class="btn btn-outline-primary fw-bold flex-grow-1" type="submit" name="status" value="Draft">
                                            <i class="fa-solid fa-floppy-disk me-1"></i>Lưu
                                        </button>
                                        <button class="btn btn-primary fw-bold flex-grow-1" type="submit" name="status" value="Published">
                                            <i class="fa-solid fa-upload me-1"></i>Đăng
                                        </button>
                                        <c:if test="${not empty editingPost && editingPost.blogID > 0}">
                                            <a class="btn btn-outline-secondary fw-bold" href="${blogManagementPath}">
                                                Hủy
                                            </a>
                                        </c:if>
                                    </div>
                                </form>
                    </div>
                </div>
                </c:if>

                <div class="col-12">
                    <div class="content-card mb-3">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-3">
                            <div>
                                <h2 class="h5 fw-bold mb-1">Danh sách bài viết</h2>
                                <p class="text-muted mb-0">Chỉ bài viết Đã đăng mới xuất hiện trên trang khách hàng.</p>
                            </div>
                        </div>
                        <form action="${blogManagementPath}" method="get" class="row g-2 align-items-center">
                            <div class="col-lg-8">
                                <div class="input-group">
                                    <span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass text-primary"></i></span>
                                    <input class="form-control" type="text" name="keyword" value="${keyword}" placeholder="Tìm bài theo tên...">
                                </div>
                            </div>
                            <div class="col-lg-2">
                                <select class="form-select" name="status">
                                    <option value="" ${empty selectedStatus ? 'selected' : ''}>Tất cả trạng thái</option>
                                    <option value="Published" ${selectedStatus == 'Published' ? 'selected' : ''}>Đã đăng</option>
                                    <option value="Pending" ${selectedStatus == 'Pending' ? 'selected' : ''}>Chờ duyệt</option>
                                    <option value="Draft" ${selectedStatus == 'Draft' ? 'selected' : ''}>Bản nháp</option>
                                    <option value="Rejected" ${selectedStatus == 'Rejected' ? 'selected' : ''}>Từ chối</option>
                                </select>
                            </div>
                            <div class="col-lg-2 d-grid">
                                <button class="btn btn-primary fw-bold" type="submit">Lọc</button>
                            </div>
                        </form>
                    </div>
                    <div class="content-card p-0 overflow-hidden">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Bài viết</th>
                                        <th>Tác giả</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo / đăng</th>
                                        <th class="text-end">Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${empty BLOG_LIST}">
                                            <tr>
                                                <td colspan="5" class="text-center text-muted py-5">
                                                    <i class="fa-regular fa-folder-open fs-2 d-block mb-2"></i>
                                                    Không tìm thấy bài viết phù hợp.
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${BLOG_LIST}" var="post">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-3">
                                                            <c:choose>
                                                                <c:when test="${empty post.image}">
                                                                    <img src="${pageContext.request.contextPath}/assets/images/home/hero-bana.png"
                                                                         alt="Blog"
                                                                         style="width:58px;height:58px;border-radius:10px;object-fit:cover;">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:set var="postImageUrl" value="${post.image}"/>
                                                                    <c:if test="${not fn:startsWith(post.image, 'http')}">
                                                                        <c:set var="postImageUrl" value="${pageContext.request.contextPath}/${post.image}"/>
                                                                    </c:if>
                                                                    <img src="${postImageUrl}"
                                                                         alt="${post.title}"
                                                                         style="width:58px;height:58px;border-radius:10px;object-fit:cover;">
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <div>
                                                                <div class="post-title"><c:out value="${post.title}"/></div>
                                                                <small class="text-muted">/<c:out value="${post.slug}"/></small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <strong><c:out value="${post.authorName}"/></strong>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${post.status == 'Published'}">
                                                                <span class="badge-status status-published">
                                                                    <i class="fa-solid"></i> Đã đăng
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${post.status == 'Pending'}">
                                                                <span class="badge-status status-pending">
                                                                    <i class="fa-solid fa-clock"></i> Chờ duyệt
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${post.status == 'Rejected'}">
                                                                <span class="badge-status status-rejected">
                                                                    <i class="fa-solid fa-ban"></i> Từ chối
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-status status-draft">
                                                                    <i class="fa-solid"></i> Bản nháp
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-muted">
                                                        <c:choose>
                                                            <c:when test="${not empty post.publishedAt}">
                                                                <fmt:formatDate value="${post.publishedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:formatDate value="${post.createAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="action-group">
                                                        <a class="action-btn btn-view"
                                                           href="${blogManagementPath}?action=view&id=${post.blogID}"
                                                           title="Xem chi tiết">
                                                            <i class="fa-solid fa-eye"></i>
                                                        </a>
                                                        <c:if test="${not blogManagementReadOnly}">
                                                        <a class="action-btn btn-edit"
                                                           href="${blogManagementPath}?action=edit&id=${post.blogID}"
                                                           title="Sửa">
                                                            <i class="fa-solid fa-pen-to-square"></i>
                                                        </a>
                                                        </c:if>
                                                        <c:if test="${post.status == 'Pending' || post.status == 'Rejected'}">
                                                            <form class="action-form" action="${blogManagementPath}" method="post">
                                                                <input type="hidden" name="action" value="status">
                                                                <input type="hidden" name="id" value="${post.blogID}">
                                                                <input type="hidden" name="status" value="Published">
                                                                <button class="action-btn btn-approve" type="submit"
                                                                        title="Duyệt bài" aria-label="Duyệt bài viết">
                                                                    <i class="fa-solid fa-check"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${post.status == 'Pending' || post.status == 'Published'}">
                                                            <form class="action-form" action="${blogManagementPath}" method="post"
                                                                  onsubmit="return confirm('Bạn có chắc muốn từ chối bài viết này?');">
                                                                <input type="hidden" name="action" value="status">
                                                                <input type="hidden" name="id" value="${post.blogID}">
                                                                <input type="hidden" name="status" value="Rejected">
                                                                <button class="action-btn btn-reject" type="submit"
                                                                        title="Từ chối bài" aria-label="Từ chối bài viết">
                                                                    <i class="fa-solid fa-xmark"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${not blogManagementReadOnly}">
                                                            <a class="action-btn btn-delete"
                                                               href="${blogManagementPath}?action=delete&id=${post.blogID}"
                                                               onclick="return confirm('Bạn có chắc muốn xóa bài viết này không?');"
                                                               title="Xóa">
                                                                <i class="fa-solid fa-trash-can"></i>
                                                            </a>
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
                        </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    const imageInput = document.getElementById("image");
    const imagePreview = document.getElementById("imagePreview");
    const fallbackimage = "${pageContext.request.contextPath}/assets/images/home/hero-bana.png";

    imageInput?.addEventListener("change", function () {
        if (this.files && this.files[0]) {
            imagePreview.src = URL.createObjectURL(this.files[0]);
        }
    });

    imagePreview?.addEventListener("error", function () {
        this.src = fallbackimage;
    });

</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
