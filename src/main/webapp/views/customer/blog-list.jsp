<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Blog du lịch | WonderVN</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8fafc;
            color: #0f172a;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }

        .blog-hero {
            background: linear-gradient(135deg, #0f766e, #2563eb);
            border-radius: 18px;
            color: #ffffff;
            padding: 42px;
            overflow: hidden;
            position: relative;
        }

        .blog-hero h1 {
            font-size: 38px;
            font-weight: 800;
            margin-bottom: 10px;
        }

        .blog-hero p {
            max-width: 680px;
            color: rgba(255, 255, 255, 0.86);
            margin: 0;
            line-height: 1.7;
        }

        .search-panel {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
            padding: 18px;
        }

        .blog-card {
            height: 100%;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
            transition: 0.22s ease;
            display: flex;
            flex-direction: column;
        }

        .blog-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 16px 34px rgba(15, 23, 42, 0.11);
        }

        .blog-thumb {
            width: 100%;
            height: 210px;
            object-fit: cover;
            background: #e2e8f0;
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

        .blog-title {
            color: #0f172a;
            font-size: 20px;
            font-weight: 800;
            line-height: 1.35;
            margin: 14px 0 10px;
            min-height: 54px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .blog-summary {
            color: #64748b;
            line-height: 1.7;
            min-height: 78px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .meta-line {
            color: #64748b;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .read-link {
            border-radius: 10px;
            background: #eff6ff;
            color: #1d4ed8;
            font-weight: 800;
            padding: 10px 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .read-link:hover {
            background: #2563eb;
            color: #ffffff;
        }

        .empty-state {
            background: #ffffff;
            border: 1px dashed #cbd5e1;
            border-radius: 16px;
            padding: 48px 24px;
            text-align: center;
            color: #64748b;
        }

    </style>
</head>
<body>

<jsp:include page="/views/common/client-header.jsp" />

<main class="container py-5">
    <section class="blog-hero mb-4">
        <span class="category-pill bg-white text-primary mb-3">
            <i class="fa-solid fa-newspaper"></i> WonderVN Blog
        </span>
        <h1>Cẩm nang du lịch Việt Nam</h1>
        <p>Gợi ý lịch trình, kinh nghiệm đặt dịch vụ và cảm hứng khám phá các điểm đến nổi bật trên WonderVN.</p>
    </section>

    <section class="search-panel mb-4">
        <form action="${pageContext.request.contextPath}/blog" method="get" class="row g-3 align-items-center">
            <div class="col-lg-10">
                <div class="input-group input-group-lg">
                    <span class="input-group-text bg-white border-end-0">
                        <i class="fa-solid fa-magnifying-glass text-primary"></i>
                    </span>
                    <input class="form-control border-start-0"
                           type="text"
                           name="keyword"
                           value="${keyword}"
                           placeholder="Tìm bài viết, điểm đến, kinh nghiệm...">
                </div>
            </div>

            <div class="col-lg-2 d-grid">
                <button class="btn btn-primary btn-lg fw-bold" type="submit">
                    <i class="fa-solid fa-magnifying-glass me-1"></i> Tìm
                </button>
            </div>
        </form>
    </section>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="h5 fw-bold m-0">
            Tìm thấy <span class="text-primary">${totalPosts}</span> bài viết
        </h2>
        <a class="text-decoration-none fw-bold" href="${pageContext.request.contextPath}/blog">
            Xóa bộ lọc
        </a>
    </div>

    <c:choose>
        <c:when test="${empty BLOG_LIST}">
            <div class="empty-state">
                <i class="fa-regular fa-folder-open fs-1 mb-3 text-primary"></i>
                <h3 class="h5 fw-bold text-dark">Chưa có bài viết phù hợp</h3>
                <p class="mb-0">Hãy thử đổi từ khóa hoặc chọn danh mục khác.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach items="${BLOG_LIST}" var="post">
                    <div class="col-md-6 col-xl-4">
                        <article class="blog-card">
                            <c:choose>
                                <c:when test="${empty post.image}">
                                    <img class="blog-thumb"
                                         src="${pageContext.request.contextPath}/assets/images/home/hero-bana.png"
                                         alt="WonderVN Blog">
                                </c:when>
                                <c:otherwise>
                                    <c:set var="postImageUrl" value="${post.image}"/>
                                    <c:if test="${not fn:startsWith(post.image, 'http')}">
                                        <c:set var="postImageUrl" value="${pageContext.request.contextPath}/${post.image}"/>
                                    </c:if>
                                    <img class="blog-thumb" src="${postImageUrl}" alt="${post.title}">
                                </c:otherwise>
                            </c:choose>

                            <div class="p-4 d-flex flex-column flex-grow-1">
                                <div class="mb-2">
                                    <span class="category-pill">
                                        <i class="fa-solid fa-newspaper"></i>
                                        Blog WonderVN
                                    </span>
                                </div>

                                <h3 class="blog-title">
                                    <c:out value="${post.title}"/>
                                </h3>

                                <p class="blog-summary">
                                    <c:out value="${post.summary}"/>
                                </p>

                                <div class="meta-line mt-auto mb-3">
                                    <span><i class="fa-regular fa-user"></i> <c:out value="${post.authorName}"/></span>
                                    <c:if test="${not empty post.publishedAt}">
                                        <span>
                                            <i class="fa-regular fa-calendar"></i>
                                            <fmt:formatDate value="${post.publishedAt}" pattern="dd/MM/yyyy"/>
                                        </span>
                                    </c:if>
                                </div>

                                <c:url var="detailUrl" value="/blog-detail">
                                    <c:param name="slug" value="${post.slug}"/>
                                </c:url>
                                <a class="read-link" href="${detailUrl}">
                                    Đọc bài viết <i class="fa-solid fa-arrow-right"></i>
                                </a>
                            </div>
                        </article>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<jsp:include page="/views/common/client-footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
