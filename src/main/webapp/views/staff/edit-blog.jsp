<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>S&#7917;a b&#224;i vi&#7871;t | WonderVN</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f8fafc; }
        .admin-layout { display: flex; min-height: 100vh; }
        .admin-main { flex: 1; min-width: 0; }
        .form-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            box-shadow: 0 14px 36px rgba(15, 23, 42, 0.06);
            padding: 28px;
        }
        .form-shell { max-width: 980px; }
        .image-preview {
            width: 100%;
            height: 220px;
            object-fit: cover;
            border-radius: 14px;
            background: #e2e8f0;
            border: 1px solid #e2e8f0;
        }
        @media (max-width: 992px) {
            .admin-layout { display: block; }
        }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp"/>
    <main class="admin-main">
        <jsp:include page="/views/common/admin-header.jsp"/>
        <div class="p-4">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                <div>
                    <h1 class="h3 fw-bold mb-1">S&#7917;a b&#224;i vi&#7871;t</h1>
                    <p class="text-muted mb-0">Ch&#7881;nh n&#7897;i dung nh&#432;ng v&#7851;n t&#225;ch r&#245; ng&#224;y t&#7841;o, c&#7853;p nh&#7853;t v&#224; ng&#224;y &#273;&#259;ng.</p>
                </div>
                <a class="btn btn-outline-secondary fw-bold" href="${blogManagementPath}">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay l&#7841;i danh s&#225;ch
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger fw-semibold"><c:out value="${error}"/></div>
            </c:if>

            <div class="form-card">
                <form action="${blogManagementPath}" method="post" enctype="multipart/form-data" class="form-shell">
                    <input type="hidden" name="action" value="save">
                    <input type="hidden" name="blogID" value="${editingPost.blogID}">
                    <input type="hidden" name="existingImage" value="${editingPost.image}">

                    <div class="mb-3">
                        <label class="form-label fw-bold">Ti&#234;u &#273;&#7873; <span class="text-danger">*</span></label>
                        <input class="form-control" type="text" name="title" maxlength="255" value="${editingPost.title}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Danh m&#7909;c <span class="text-danger">*</span></label>
                        <select class="form-select" name="category" required>
                            <option value="" disabled ${empty editingPost.category ? 'selected' : ''}>Ch&#7885;n danh m&#7909;c</option>
                            <c:forEach items="${CATEGORY_LIST}" var="cat">
                                <option value="${cat}" ${cat == editingPost.category ? 'selected' : ''}>
                                    <c:choose>
                                        <c:when test="${cat == 'Kinh nghiem'}">Kinh nghiệm</c:when>
                                        <c:when test="${cat == 'Am thuc'}">Ẩm thực</c:when>
                                        <c:when test="${cat == 'Diem den'}">Điểm đến</c:when>
                                        <c:when test="${cat == 'Meo du lich'}">Mẹo du lịch</c:when>
                                        <c:otherwise><c:out value="${cat}"/></c:otherwise>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Slug t&#249;y ch&#7881;nh</label>
                        <input class="form-control" type="text" name="slug" maxlength="255" value="${editingPost.slug}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">T&#243;m t&#7855;t</label>
                        <textarea class="form-control" name="summary" rows="3" maxlength="500"><c:out value="${editingPost.summary}"/></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Ch&#7885;n &#7843;nh m&#7899;i</label>
                        <input class="form-control" type="file" name="image" id="imageUpload" accept="image/jpeg,image/png,image/webp">
                    </div>

                    <div class="mb-3">
                        <img id="imagePreview"
                             class="image-preview${empty editingPost.image ? ' d-none' : ''}"
                             src="${empty editingPost.image ? '' : pageContext.request.contextPath.concat('/').concat(editingPost.image)}"
                             alt="Blog preview">
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">N&#7897;i dung <span class="text-danger">*</span></label>
                        <textarea class="form-control" name="content" rows="12" required><c:out value="${editingPost.content}"/></textarea>
                    </div>

                    <div class="d-flex gap-2">
                        <button class="btn btn-outline-primary fw-bold flex-grow-1" type="submit" name="status" value="Draft">
                            <i class="fa-solid fa-floppy-disk me-1"></i> L&#432;u nh&#225;p
                        </button>
                        <button class="btn btn-primary fw-bold flex-grow-1" type="submit" name="status" value="Published">
                            <i class="fa-solid fa-upload me-1"></i> C&#7853;p nh&#7853;t v&#224; &#273;&#259;ng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    const editImageInput = document.getElementById("imageUpload");
    const editImagePreview = document.getElementById("imagePreview");
    const currentImageSrc = editImagePreview?.getAttribute("src") || "";

    editImageInput?.addEventListener("change", function () {
        if (this.files && this.files[0]) {
            editImagePreview.src = URL.createObjectURL(this.files[0]);
            editImagePreview.classList.remove("d-none");
            return;
        }

        editImagePreview.src = currentImageSrc;
        if (currentImageSrc) {
            editImagePreview.classList.remove("d-none");
        } else {
            editImagePreview.classList.add("d-none");
        }
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
