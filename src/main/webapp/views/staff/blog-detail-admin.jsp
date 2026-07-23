<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${post.title}"/> | Quản trị Blog</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f8fafc; color: #0f172a; }
        .shell { max-width: 1180px; margin: 0 auto; }
        .hero, .content-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            box-shadow: 0 14px 36px rgba(15, 23, 42, 0.06);
        }
        .hero-image {
            width: 100%;
            height: 380px;
            object-fit: cover;
            border-radius: 18px 18px 0 0;
            background: #e2e8f0;
        }
        .content-card { padding: 30px; white-space: pre-line; line-height: 1.9; }
    </style>
</head>
<body>
<main class="container py-5">
    <div class="shell">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
            <div>
                <h1 class="h3 fw-bold mb-1">Chi tiết bài viết</h1>
                <p class="text-muted mb-0">Màn nội bộ dùng để kiểm tra nhanh nội dung bài viết.</p>
            </div>
            <a href="${backToBlogManagementPath}" class="btn btn-outline-primary fw-bold">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại quản lý blog
            </a>
        </div>

        <article class="hero mb-4 overflow-hidden">
            <c:choose>
                <c:when test="${empty post.image}">
                    <img class="hero-image" src="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" alt="WonderVN Blog">
                </c:when>
                <c:otherwise>
                    <img class="hero-image" src="${pageContext.request.contextPath}/${post.image}" alt="${post.title}">
                </c:otherwise>
            </c:choose>

            <div class="p-4 p-lg-5">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                    <div>
                        <span class="badge rounded-pill text-bg-light border mb-3">
                            <c:out value="${empty post.category ? 'Chưa phân loại' : post.category}"/>
                        </span>
                        <h2 class="display-6 fw-bold mb-3"><c:out value="${post.title}"/></h2>
                        <p class="lead text-muted mb-0"><c:out value="${post.summary}"/></p>
                    </div>
                    <span class="badge rounded-pill ${post.status == 'Published' ? 'text-bg-success' : 'text-bg-secondary'}">
                        <c:out value="${post.status}"/>
                    </span>
                </div>
            </div>
        </article>

        <div class="content-card">
            <c:out value="${post.content}"/>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
