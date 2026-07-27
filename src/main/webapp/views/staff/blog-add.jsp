<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm blog | WonderVN Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        body { margin: 0; background: #f8fafc; color: #0f172a; font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; }
        .admin-layout { display: flex; min-height: 100vh; }
        .admin-main { flex: 1; min-width: 0; padding: 28px; }
        .page-banner { background: #0f766e; border-radius: 14px; color: #fff; padding: 26px; box-shadow: 0 12px 30px rgba(15,118,110,.18); }
        .content-card { background: #fff; border: 1px solid #e2e8f0; border-radius: 14px; box-shadow: 0 8px 24px rgba(15,23,42,.05); padding: 24px; }
        .form-label { font-weight: 800; color: #1e293b; font-size: 14px; }
        .form-control, .form-select { min-height: 46px; border-radius: 12px; border-color: #dbe3ef; }
        .image-preview { width: 100%; height: 220px; border-radius: 12px; object-fit: cover; background: #e2e8f0; border: 1px solid #e2e8f0; }
        @media (max-width: 992px) { .admin-layout { display: block; } .admin-main { padding: 18px; } }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp"/>

    <main class="admin-main">
        <div class="page-banner mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h1 class="h3 fw-bold m-0">Thêm blog</h1>
                <p class="m-0 mt-1 text-white-50">Tạo bài viết mới và chọn lưu nháp hoặc đăng ngay.</p>
            </div>
            <a class="btn btn-light fw-bold" href="${blogManagementPath}">
                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger fw-semibold"><c:out value="${error}"/></div>
        </c:if>

        <section class="content-card">
            <form action="${blogAddPath}" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="blogID" value="0">
                <input type="hidden" name="existingImage" value="">

                <div class="row g-4">
                    <div class="col-lg-8">
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                            <input class="form-control" type="text" name="title" maxlength="255" value="${fn:escapeXml(editingPost.title)}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                            <select class="form-select" name="category" required>
                                <option value="">Chọn danh mục</option>
                                <c:forEach var="category" items="${categoryList}">
                                    <option value="${fn:escapeXml(category)}" ${editingPost.category == category ? 'selected' : ''}>
                                        <c:out value="${category}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Slug tùy chỉnh</label>
                            <input class="form-control" type="text" name="slug" maxlength="255" value="${fn:escapeXml(editingPost.slug)}" placeholder="Tự tạo từ tiêu đề nếu bỏ trống">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Tóm tắt</label>
                            <textarea class="form-control" name="summary" rows="3" maxlength="500"><c:out value="${editingPost.summary}"/></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Nội dung <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="content" rows="12" required><c:out value="${editingPost.content}"/></textarea>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">Ảnh</label>
                            <input class="form-control" type="file" name="image" id="image" accept="image/jpeg,image/png,image/webp">
                        </div>
                        <img id="imagePreview" class="image-preview" src="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" alt="image preview">
                    </div>
                </div>

                <div class="d-flex gap-2 justify-content-end mt-4">
                    <button class="btn btn-outline-primary fw-bold px-4" type="submit" name="status" value="Draft">
                        <i class="fa-solid fa-floppy-disk me-1"></i>Lưu nháp
                    </button>
                    <button class="btn btn-primary fw-bold px-4" type="submit" name="status" value="Published">
                        <i class="fa-solid fa-upload me-1"></i>Đăng bài
                    </button>
                </div>
            </form>
        </section>
    </main>
</div>

<script>
    const imageInput = document.getElementById("image");
    const imagePreview = document.getElementById("imagePreview");

    imageInput?.addEventListener("change", function () {
        if (this.files && this.files[0]) {
            imagePreview.src = URL.createObjectURL(this.files[0]);
        }
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
