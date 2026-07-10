<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${post.title}"/> | WonderVN Blog</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8fafc;
            color: #0f172a;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }

        .article-shell {
            max-width: 1120px;
            margin: 0 auto;
        }

        .breadcrumb a {
            color: #64748b;
            text-decoration: none;
            font-weight: 600;
        }

        .article-hero {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 14px 36px rgba(15, 23, 42, 0.08);
        }

        .hero-image {
            width: 100%;
            height: 430px;
            object-fit: cover;
            background: #e2e8f0;
        }

        .article-meta {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
            color: #64748b;
            font-size: 14px;
            font-weight: 600;
        }

        .category-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border-radius: 999px;
            background: #e0f2fe;
            color: #0369a1;
            font-size: 12px;
            font-weight: 800;
            padding: 7px 12px;
        }

        .article-title {
            font-size: 40px;
            font-weight: 900;
            line-height: 1.2;
            color: #0f172a;
            margin: 18px 0 14px;
        }

        .article-summary {
            font-size: 18px;
            color: #475569;
            line-height: 1.8;
            margin: 0;
        }

        .article-content {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 34px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.05);
            color: #334155;
            font-size: 17px;
            line-height: 1.95;
            white-space: pre-line;
        }

        .side-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.05);
        }

        .related-link {
            display: block;
            padding: 14px 0;
            border-bottom: 1px solid #e2e8f0;
            color: #0f172a;
            text-decoration: none;
            font-weight: 800;
            line-height: 1.45;
        }

        .related-link:last-child {
            border-bottom: none;
        }

        .related-link:hover {
            color: #2563eb;
        }

        @media (max-width: 768px) {
            .article-title {
                font-size: 30px;
            }

            .hero-image {
                height: 280px;
            }

            .article-content {
                padding: 24px;
                font-size: 16px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/views/common/client-header.jsp" />

<main class="container py-5">
    <div class="article-shell">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/blog">Blog</a></li>
                <li class="breadcrumb-item active" aria-current="page">
                    <c:out value="${post.title}"/>
                </li>
            </ol>
        </nav>

        <article class="article-hero mb-4">
            <c:choose>
                <c:when test="${empty post.thumbnailUrl}">
                    <img class="hero-image"
                         src="${pageContext.request.contextPath}/assets/images/home/hero-bana.png"
                         alt="WonderVN Blog">
                </c:when>
                <c:otherwise>
                    <img class="hero-image" src="${post.thumbnailUrl}" alt="${post.title}">
                </c:otherwise>
            </c:choose>

            <div class="p-4 p-lg-5">
                <span class="category-pill">
                    <i class="fa-solid fa-tag"></i>
                    <c:out value="${empty post.category ? 'Du lịch' : post.category}"/>
                </span>

                <h1 class="article-title">
                    <c:out value="${post.title}"/>
                </h1>

                <p class="article-summary">
                    <c:out value="${post.summary}"/>
                </p>

                <div class="article-meta mt-4">
                    <span><i class="fa-regular fa-user me-1"></i><c:out value="${post.authorName}"/></span>
                    <c:if test="${not empty post.publishedAt}">
                        <span>
                            <i class="fa-regular fa-calendar me-1"></i>
                            <fmt:formatDate value="${post.publishedAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </c:if>
                </div>
            </div>
        </article>

        <div class="row g-4">
            <div class="col-lg-8">
                <article class="article-content">
                    <c:out value="${post.content}"/>
                </article>
            </div>

            <aside class="col-lg-4">
                <div class="side-card position-sticky" style="top: 110px;">
                    <h2 class="h5 fw-bold mb-3">
                        <i class="fa-solid fa-compass text-primary me-2"></i>Bài viết liên quan
                    </h2>

                    <c:choose>
                        <c:when test="${empty RELATED_POSTS}">
                            <p class="text-muted mb-0">Chưa có bài viết liên quan.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${RELATED_POSTS}" var="related">
                                <c:url var="relatedUrl" value="/blog-detail">
                                    <c:param name="slug" value="${related.slug}"/>
                                </c:url>
                                <a class="related-link" href="${relatedUrl}">
                                    <c:out value="${related.title}"/>
                                    <div class="text-muted fw-normal mt-1" style="font-size: 13px;">
                                        <fmt:formatDate value="${related.publishedAt}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

                    <a href="${pageContext.request.contextPath}/blog" class="btn btn-outline-primary w-100 fw-bold mt-3">
                        <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Blog
                    </a>
                </div>
            </aside>
        </div>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
