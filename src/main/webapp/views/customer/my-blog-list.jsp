<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Blog của tôi | WonderVN</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; background: #f5f7fb; color: #0f172a; }

        .blog-body { padding: 24px; display: grid; gap: 18px; }
        .blog-toolbar { display: flex; justify-content: space-between; gap: 14px; flex-wrap: wrap; align-items: center; }
        .primary-btn,
        .outline-btn {
            min-height: 40px;
            border-radius: 999px;
            padding: 0 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 12px;
            font-weight: 900;
            text-decoration: none;
            border: 1px solid #2563eb;
        }
        .primary-btn { background: #2563eb; color: #fff; }
        .outline-btn { background: #fff; color: #2563eb; }

        .blog-form {
            border: 1px solid #e5eaf3;
            border-radius: 16px;
            background: #fff;
            padding: 20px;
            display: grid;
            gap: 14px;
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
            width: min(820px, 100%);
            max-height: calc(100vh - 48px);
            overflow-y: auto;
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 24px 70px rgba(15, 23, 42, 0.24);
        }
        .form-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
        .form-field.full { grid-column: 1 / -1; }
        .form-label { display: block; margin-bottom: 7px; color: #334155; font-size: 12px; font-weight: 900; }
        .form-control {
            width: 100%;
            border: 1px solid #dbe5f2;
            border-radius: 12px;
            min-height: 42px;
            padding: 10px 12px;
            color: #0f172a;
            font-weight: 700;
            outline: none;
        }
        textarea.form-control { resize: vertical; min-height: 110px; }
        .help-text { margin-top: 6px; color: #64748b; font-size: 12px; font-weight: 600; }
        .image-preview {
            width: 100%;
            max-height: 180px;
            border-radius: 12px;
            object-fit: cover;
            border: 1px solid #dbe5f2;
            background: #f8fafc;
        }
        .blog-list { display: grid; gap: 12px; }
        .blog-row {
            border: 1px solid #e5eaf3;
            border-radius: 16px;
            background: #fff;
            padding: 14px;
            display: grid;
            grid-template-columns: 78px minmax(0, 1fr) auto;
            gap: 14px;
            align-items: center;
        }
        .blog-thumb {
            width: 78px;
            height: 58px;
            border-radius: 12px;
            object-fit: cover;
            background: #e2e8f0;
        }
        .blog-title { margin: 0; color: #0f172a; font-size: 15px; font-weight: 900; line-height: 1.35; }
        .blog-meta { margin-top: 6px; display: flex; gap: 10px; flex-wrap: wrap; color: #64748b; font-size: 12px; font-weight: 700; }
        .status-badge {
            min-height: 28px;
            padding: 0 10px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            background: #fef3c7;
            color: #92400e;
            font-size: 11px;
            font-weight: 900;
            text-transform: uppercase;
        }
        .status-badge.published { background: #dcfce7; color: #166534; }
        .status-badge.draft { background: #f1f5f9; color: #475569; }
        .row-actions { display: flex; gap: 8px; flex-wrap: wrap; justify-content: flex-end; }
        .icon-btn {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            border: 1px solid #dbe5f2;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #2563eb;
            text-decoration: none;
            background: #fff;
        }
        .empty-box { padding: 50px 24px; text-align: center; color: #64748b; }
        .empty-box i { font-size: 34px; color: #94a3b8; margin-bottom: 12px; }
        .alert {
            border-radius: 12px;
            padding: 13px 15px;
            font-size: 13px;
            font-weight: 800;
            border: 1px solid transparent;
        }
        .alert.info { background: #eff6ff; color: #1d4ed8; border-color: #bfdbfe; }
        .alert.error { background: #fef2f2; color: #b91c1c; border-color: #fecaca; }

        @media (max-width: 760px) {
            .form-grid, .blog-row { grid-template-columns: 1fr; }
            .row-actions { justify-content: flex-start; }
        }
    </style>
</head>
<body>
<jsp:include page="/views/common/client-header.jsp"/>

<main class="account-page">
    <div class="account-shell">
        <jsp:include page="/views/common/account-sidebar.jsp"/>

        <section class="account-content">
            <article class="account-panel">
                <div class="account-panel-head">
                    <p class="account-kicker">Tài khoản</p>
                    <h1 class="account-title">Blog của tôi</h1>
                    <p class="account-subtitle">Viết chia sẻ du lịch và gửi staff/admin duyệt trước khi hiển thị công khai.</p>
                </div>

                <div class="blog-body">
                    <c:if test="${not empty error}">
                        <div class="alert error"><c:out value="${error}"/></div>
                    </c:if>
                    <c:if test="${not empty param.message}">
                        <div class="alert info">
                            <c:choose>
                                <c:when test="${param.message == 'submitted'}">Bài viết đã được lưu và đang chờ duyệt.</c:when>
                                <c:when test="${param.message == 'not_found'}">Không tìm thấy bài viết.</c:when>
                                <c:otherwise>Không thể xử lý yêu cầu. Vui lòng thử lại.</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <div class="blog-toolbar">
                        <strong>${fn:length(BLOG_LIST)} bài viết</strong>
                        <c:choose>
                            <c:when test="${showBlogForm}">
                                <a class="outline-btn" href="${pageContext.request.contextPath}/my-blogs">
                                    <i class="fa-solid fa-xmark"></i> Đóng form
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a class="primary-btn" href="${pageContext.request.contextPath}/my-blogs?action=new">
                                    <i class="fa-solid fa-plus"></i> Thêm blog
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${showBlogForm}">
                        <div class="blog-modal" role="dialog" aria-modal="true" aria-label="Biểu mẫu blog">
                            <div class="blog-dialog">
                        <form class="blog-form" action="${pageContext.request.contextPath}/my-blogs" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="blogID" value="${editingPost.blogID}">
                            <input type="hidden" name="existingImage" value="${editingPost.image}">

                            <div class="form-grid">
                                <div class="form-field">
                                    <label class="form-label">Tiêu đề <span style="color:#dc2626">*</span></label>
                                    <input class="form-control" type="text" name="title" maxlength="255" required
                                           value="${editingPost.title}">
                                </div>
                                <div class="form-field">
                                    <label class="form-label">Slug tùy chỉnh</label>
                                    <input class="form-control" type="text" name="slug" maxlength="255"
                                           value="${editingPost.slug}" placeholder="Tự tạo từ tiêu đề nếu bỏ trống">
                                </div>
                                <div class="form-field">
                                    <label class="form-label">Ảnh bìa</label>
                                    <input class="form-control" type="file" name="image" id="image" accept="image/jpeg,image/png,image/webp">
                                    <div class="help-text">JPG, PNG hoặc WebP; tối đa 10MB.</div>
                                </div>
                                <div class="form-field full">
                                    <c:choose>
                                        <c:when test="${empty editingPost.image}">
                                            <img id="imagePreview" class="image-preview"
                                                 src="${pageContext.request.contextPath}/assets/images/home/hero-bana.png"
                                                 alt="Blog preview">
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="previewUrl" value="${editingPost.image}"/>
                                            <c:if test="${not fn:startsWith(editingPost.image, 'http')}">
                                                <c:set var="previewUrl" value="${pageContext.request.contextPath}/${editingPost.image}"/>
                                            </c:if>
                                            <img id="imagePreview" class="image-preview"
                                                 src="${previewUrl}"
                                                 alt="Blog preview">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="form-field full">
                                    <label class="form-label">Tóm tắt</label>
                                    <textarea class="form-control" name="summary" maxlength="500"><c:out value="${editingPost.summary}"/></textarea>
                                </div>
                                <div class="form-field full">
                                    <label class="form-label">Nội dung <span style="color:#dc2626">*</span></label>
                                    <textarea class="form-control" name="content" rows="9" required><c:out value="${editingPost.content}"/></textarea>
                                </div>
                            </div>

                            <div class="blog-toolbar">
                                <a class="outline-btn" href="${pageContext.request.contextPath}/my-blogs">Hủy</a>
                                <button class="primary-btn" type="submit">
                                    <i class="fa-solid fa-paper-plane"></i> Gửi duyệt
                                </button>
                            </div>
                        </form>
                            </div>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${empty BLOG_LIST}">
                            <div class="empty-box">
                                <i class="fa-regular fa-newspaper"></i>
                                <h3>Chưa có blog</h3>
                                <p>Bài viết bạn tạo sẽ xuất hiện tại đây.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="blog-list">
                                <c:forEach items="${BLOG_LIST}" var="post">
                                    <article class="blog-row">
                                        <c:choose>
                                            <c:when test="${empty post.image}">
                                                <img class="blog-thumb" src="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" alt="Blog">
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="postImageUrl" value="${post.image}"/>
                                                <c:if test="${not fn:startsWith(post.image, 'http')}">
                                                    <c:set var="postImageUrl" value="${pageContext.request.contextPath}/${post.image}"/>
                                                </c:if>
                                                <img class="blog-thumb" src="${postImageUrl}" alt="${post.title}">
                                            </c:otherwise>
                                        </c:choose>
                                        <div>
                                            <h2 class="blog-title"><c:out value="${post.title}"/></h2>
                                            <div class="blog-meta">
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${post.status == 'Published'}">
                                                            <span class="status-badge published">Đã đăng</span>
                                                        </c:when>
                                                        <c:when test="${post.status == 'Pending'}">
                                                            <span class="status-badge">Chờ duyệt</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge draft">Bản nháp</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <span><fmt:formatDate value="${post.createAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                            </div>
                                        </div>
                                        <div class="row-actions">
                                            <a class="icon-btn" href="${pageContext.request.contextPath}/my-blogs?action=view&id=${post.blogID}" title="Xem">
                                                <i class="fa-solid fa-eye"></i>
                                            </a>
                                            <a class="icon-btn" href="${pageContext.request.contextPath}/my-blogs?action=edit&id=${post.blogID}" title="Sửa">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </article>
        </section>
    </div>
</main>

<script>
    const imageInput = document.getElementById("image");
    const imagePreview = document.getElementById("imagePreview");
    imageInput?.addEventListener("change", function () {
        if (this.files && this.files[0] && imagePreview) {
            imagePreview.src = URL.createObjectURL(this.files[0]);
        }
    });
</script>
</body>
</html>
