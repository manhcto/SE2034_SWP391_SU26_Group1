<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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

        .thumbnail-preview {
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
            border: none;
            background: transparent;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 34px;
            height: 34px;
            border-radius: 9px;
            color: #475569;
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
                    <i class="fa-solid fa-newspaper" style="font-size: 2.4rem;"></i>
                    <div>
                        <h1 class="h3 fw-bold m-0">Quản lý Blog</h1>
                        <p class="m-0 mt-1 text-white-50">Tạo bài viết, lưu bản nháp và xuất bản nội dung cho khách hàng.</p>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/blog" class="btn btn-light text-primary fw-bold">
                    <i class="fa-solid fa-arrow-up-right-from-square me-1"></i> Xem Blog
                </a>
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
            <c:set var="draftCount" value="0"/>

            <c:forEach items="${BLOG_LIST}" var="post">
                <c:set var="total" value="${total + 1}"/>
                <c:if test="${post.status == 'Published'}"><c:set var="publishedCount" value="${publishedCount + 1}"/></c:if>
                <c:if test="${post.status != 'Published'}"><c:set var="draftCount" value="${draftCount + 1}"/></c:if>
            </c:forEach>

            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#e0f2fe;color:#0369a1;"><i class="fa-solid fa-layer-group"></i></div>
                        <div><h3>${total}</h3><p>Tổng bài viết</p></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#dcfce7;color:#166534;"><i class="fa-solid fa-circle-check"></i></div>
                        <div><h3>${publishedCount}</h3><p>Đã đăng</p></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#f1f5f9;color:#475569;"><i class="fa-solid fa-pen"></i></div>
                        <div><h3>${draftCount}</h3><p>Bản nháp</p></div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-xl-4">
                    <div class="content-card position-sticky" style="top: 24px;">
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

                        <form action="${pageContext.request.contextPath}/staff/blog" method="post">
                            <input type="hidden" name="action" value="save">
                            <input type="hidden" name="blogID" value="${editingPost.blogID}">

                            <div class="mb-3">
                                <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                                <input class="form-control" type="text" name="title" maxlength="255"
                                       value="${editingPost.title}" required>
                            </div>

                            <div class="row g-3">
                                <div class="col-md-7">
                                    <label class="form-label">Danh mục</label>
                                    <input class="form-control" type="text" name="category" maxlength="100"
                                           value="${editingPost.category}" placeholder="VD: Kinh nghiệm">
                                </div>
                                <div class="col-md-5">
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" name="status">
                                        <option value="Published" ${editingPost.status == 'Published' ? 'selected' : ''}>Đã đăng</option>
                                        <option value="Draft" ${editingPost.status != 'Published' ? 'selected' : ''}>Bản nháp</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3 mt-3">
                                <label class="form-label">Slug tùy chỉnh</label>
                                <input class="form-control" type="text" name="slug" maxlength="255"
                                       value="${editingPost.slug}" placeholder="Tự tạo từ tiêu đề nếu bỏ trống">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Link ảnh thumbnail</label>
                                <input class="form-control" type="url" name="thumbnailUrl" id="thumbnailUrl"
                                       value="${editingPost.thumbnailUrl}" placeholder="https://...">
                            </div>

                            <div class="mb-3">
                                <c:set var="previewUrl" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png"/>
                                <c:if test="${not empty editingPost.thumbnailUrl}">
                                    <c:set var="previewUrl" value="${editingPost.thumbnailUrl}"/>
                                </c:if>
                                <img id="thumbnailPreview"
                                     class="thumbnail-preview"
                                     src="${previewUrl}"
                                     alt="Thumbnail preview">
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
                                <button class="btn btn-primary fw-bold flex-grow-1" type="submit">
                                    <i class="fa-solid fa-floppy-disk me-1"></i>Lưu bài viết
                                </button>
                                <c:if test="${not empty editingPost && editingPost.blogID > 0}">
                                    <a class="btn btn-outline-secondary fw-bold" href="${pageContext.request.contextPath}/staff/blog">
                                        Hủy
                                    </a>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="col-xl-8">
                    <div class="content-card mb-3">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-3">
                            <div>
                                <h2 class="h5 fw-bold mb-1">Danh sách bài viết</h2>
                                <p class="text-muted mb-0">Chỉ bài viết Đã đăng mới xuất hiện trên trang khách hàng.</p>
                            </div>
                        </div>
                        <form action="${pageContext.request.contextPath}/staff/blog" method="get" class="row g-2 align-items-center">
                            <div class="col-lg-7">
                                <div class="input-group">
                                    <span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass text-primary"></i></span>
                                    <input class="form-control" type="text" name="keyword" value="${keyword}" placeholder="Tìm bài theo tên...">
                                </div>
                            </div>
                            <div class="col-lg-3">
                                <select class="form-select" name="category">
                                    <option value="" ${empty selectedCategory ? 'selected' : ''}>Tất cả danh mục</option>
                                    <c:forEach items="${CATEGORY_LIST}" var="cat">
                                        <option value="${cat}" ${cat == selectedCategory ? 'selected' : ''}><c:out value="${cat}"/></option>
                                    </c:forEach>
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
                                        <th>Danh mục</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày đăng</th>
                                        <th class="text-center">Hành động</th>
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
                                                                <c:when test="${empty post.thumbnailUrl}">
                                                                    <img src="${pageContext.request.contextPath}/assets/images/home/hero-bana.png"
                                                                         alt="Blog"
                                                                         style="width:58px;height:58px;border-radius:10px;object-fit:cover;">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${post.thumbnailUrl}"
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
                                                        <span class="badge rounded-pill text-bg-light border">
                                                            <c:out value="${empty post.category ? 'Chưa phân loại' : post.category}"/>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${post.status == 'Published'}">
                                                                <span class="badge-status status-published">
                                                                    <i class="fa-solid fa-circle-check"></i> Đã đăng
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-status status-draft">
                                                                    <i class="fa-solid fa-pen"></i> Bản nháp
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
                                                                Chưa đăng
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <c:if test="${post.status == 'Published'}">
                                                            <a class="action-btn btn-view"
                                                               href="${pageContext.request.contextPath}/blog-detail?slug=${post.slug}"
                                                               title="Xem bài viết">
                                                                <i class="fa-solid fa-eye"></i>
                                                            </a>
                                                        </c:if>
                                                        <a class="action-btn btn-edit"
                                                           href="${pageContext.request.contextPath}/staff/blog?action=edit&id=${post.blogID}"
                                                           title="Sửa">
                                                            <i class="fa-solid fa-pen-to-square"></i>
                                                        </a>
                                                        <a class="action-btn"
                                                           href="${pageContext.request.contextPath}/staff/blog?action=status&id=${post.blogID}&status=Published"
                                                           title="Đăng bài">
                                                            <i class="fa-solid fa-upload"></i>
                                                        </a>
                                                        <a class="action-btn"
                                                           href="${pageContext.request.contextPath}/staff/blog?action=status&id=${post.blogID}&status=Draft"
                                                           title="Đưa về bản nháp">
                                                            <i class="fa-solid fa-file-pen"></i>
                                                        </a>
                                                        <a class="action-btn btn-delete"
                                                           href="${pageContext.request.contextPath}/staff/blog?action=delete&id=${post.blogID}"
                                                           onclick="return confirm('Bạn có chắc muốn xóa bài viết này không?');"
                                                           title="Xóa">
                                                            <i class="fa-solid fa-trash-can"></i>
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
            </div>
        </div>
    </main>
</div>

<script>
    const thumbnailInput = document.getElementById("thumbnailUrl");
    const thumbnailPreview = document.getElementById("thumbnailPreview");
    const fallbackThumbnail = "${pageContext.request.contextPath}/assets/images/home/hero-bana.png";

    thumbnailInput?.addEventListener("input", function () {
        thumbnailPreview.src = this.value.trim() || fallbackThumbnail;
    });

    thumbnailPreview?.addEventListener("error", function () {
        this.src = fallbackThumbnail;
    });

</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
