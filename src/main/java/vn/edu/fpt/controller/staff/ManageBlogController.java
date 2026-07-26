package vn.edu.fpt.controller.staff;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import vn.edu.fpt.DAO.BlogDAO;
import vn.edu.fpt.model.BlogPost;
import vn.edu.fpt.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.text.Normalizer;
import java.util.Locale;

@WebServlet("/staff/blog")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 50 * 1024 * 1024
)
public class ManageBlogController extends HttpServlet {
    private BlogDAO blogDAO;

    @Override
    public void init() {
        blogDAO = new BlogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = normalize(request.getParameter("action"));
        try {
            switch (action) {
                case "view":
                    BlogPost viewingPost = blogDAO.getPostById(parseId(request.getParameter("id")));
                    if (viewingPost == null) {
                        response.sendRedirect(resolveManagementPath(request) + "?message=not_found");
                        return;
                    }
                    forwardDetailView(request, response, viewingPost);
                    break;
                case "edit":
                    BlogPost editingPost = blogDAO.getPostById(parseId(request.getParameter("id")));
                    if (editingPost == null) {
                        response.sendRedirect(resolveManagementPath(request) + "?message=not_found");
                        return;
                    }
                    request.setAttribute("editingPost", editingPost);
                    request.setAttribute("showBlogForm", true);
                    forwardManagement(request, response);
                    break;
                case "new":
                    request.setAttribute("showBlogForm", true);
                    forwardManagement(request, response);
                    break;
                case "delete":
                    blogDAO.deletePost(parseId(request.getParameter("id")));
                    response.sendRedirect(resolveManagementPath(request) + "?message=deleted");
                    break;
                case "list":
                default:
                    forwardManagement(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(resolveManagementPath(request) + "?message=error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            BlogPost post = buildPostFromRequest(request);
            if (post.getTitle().isEmpty() || post.getContent().isEmpty()) {
                request.setAttribute("editingPost", post);
                request.setAttribute("showBlogForm", true);
                request.setAttribute("error", "Vui lòng nhập tiêu đề và nội dung bài viết.");
                forwardManagement(request, response);
                return;
            }

            boolean success;
            if (post.getBlogID() > 0) {
                success = blogDAO.updatePost(post);
            } else {
                success = blogDAO.insertPost(post);
            }

            response.sendRedirect(resolveManagementPath(request) + "?message=" + (success ? "saved" : "error"));
        } catch (IllegalArgumentException e) {
            request.setAttribute("showBlogForm", true);
            request.setAttribute("error", e.getMessage());
            forwardManagement(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(resolveManagementPath(request) + "?message=error");
        }
    }

    private void forwardManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = normalize(request.getParameter("keyword"));
        String status = normalizeStatusFilter(request.getParameter("status"));

        request.setAttribute("BLOG_LIST", blogDAO.getPostsForStaff(keyword, status));
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("blogManagementPath", resolveManagementPath(request));
        request.setAttribute("showBlogForm",
                Boolean.TRUE.equals(request.getAttribute("showBlogForm"))
                        || request.getAttribute("editingPost") != null);
        request.getRequestDispatcher("/views/staff/blog-management.jsp").forward(request, response);
    }

    private void forwardDetailView(HttpServletRequest request, HttpServletResponse response, BlogPost post)
            throws ServletException, IOException {
        request.setAttribute("post", post);
        request.setAttribute("RELATED_POSTS",
                blogDAO.getRelatedPublishedPosts(post.getCategory(), post.getBlogID(), 3));
        request.setAttribute("backToBlogManagementPath", resolveManagementPath(request));
        request.getRequestDispatcher("/views/customer/blog-detail.jsp").forward(request, response);
    }

    private String resolveManagementPath(HttpServletRequest request) {
        return request.getContextPath() + "/staff/blog";
    }

    private BlogPost buildPostFromRequest(HttpServletRequest request)
            throws ServletException, IOException {
        int blogID = parseId(request.getParameter("blogID"));
        String title = normalize(request.getParameter("title"));
        String customSlug = normalize(request.getParameter("slug"));
        String baseSlug = customSlug.isEmpty() ? createSlug(title) : createSlug(customSlug);

        BlogPost post = new BlogPost();
        post.setBlogID(blogID);
        post.setTitle(title);
        post.setSlug(blogDAO.createUniqueSlug(baseSlug, blogID));
        post.setSummary(normalize(request.getParameter("summary")));
        post.setContent(normalize(request.getParameter("content")));
        post.setImage(normalize(request.getParameter("existingImage")));
        Part imagePart = request.getPart("image");

        if (imagePart != null && imagePart.getSize() > 0) {
            if (!isAllowedImage(imagePart)) {
                throw new IllegalArgumentException("Chỉ được upload file ảnh JPG, PNG hoặc WebP.");
            }

            String fileName = System.currentTimeMillis() + "-" + Paths.get(imagePart.getSubmittedFileName())
                    .getFileName()
                    .toString();

            String uploadPath = getServletContext().getRealPath("/uploads/blog");

            File folder = new File(uploadPath);
            if (!folder.exists()) {
                folder.mkdirs();
            }

            imagePart.write(uploadPath + File.separator + fileName);

            post.setImage("uploads/blog/" + fileName);
        }
        post.setStatus(normalizeStatus(request.getParameter("status")));
        post.setAuthorID(resolveAuthorIDForSave(request, blogID));
        return post;
    }

    private Integer resolveAuthorIDForSave(HttpServletRequest request, int blogID) {
        if (blogID <= 0) {
            return getCurrentUserID(request);
        }

        BlogPost existingPost = blogDAO.getPostById(blogID);
        return existingPost != null ? existingPost.getAuthorID() : getCurrentUserID(request);
    }

    private boolean isAllowedImage(Part part) {
        String contentType = part.getContentType();
        if (contentType == null) {
            return false;
        }

        String normalizedType = contentType.toLowerCase(Locale.ROOT);
        if (!("image/jpeg".equals(normalizedType)
                || "image/png".equals(normalizedType)
                || "image/webp".equals(normalizedType))) {
            return false;
        }

        String submittedName = part.getSubmittedFileName();
        if (submittedName == null) {
            return false;
        }

        String fileName = submittedName.toLowerCase(Locale.ROOT);
        return fileName.endsWith(".jpg")
                || fileName.endsWith(".jpeg")
                || fileName.endsWith(".png")
                || fileName.endsWith(".webp");
    }

    private Integer getCurrentUserID(HttpServletRequest request) {
        Object userObject = request.getSession().getAttribute("user");
        if (userObject instanceof User) {
            return ((User) userObject).getUserID();
        }
        return null;
    }

    private String createSlug(String value) {
        String source = normalize(value);
        if (source.isEmpty()) {
            return "blog-post";
        }

        source = source.replace('đ', 'd').replace('Đ', 'D');
        String normalized = Normalizer.normalize(source, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        String slug = normalized.toLowerCase(Locale.ROOT)
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("^-+|-+$", "");
        return slug.isEmpty() ? "blog-post" : slug;
    }

    private String normalizeStatus(String status) {
        String value = normalize(status);
        if ("Published".equalsIgnoreCase(value)) {
            return "Published";
        }
        return "Draft";
    }

    private String normalizeStatusFilter(String status) {
        String value = normalize(status);
        if ("Published".equalsIgnoreCase(value)) {
            return "Published";
        }
        if ("Draft".equalsIgnoreCase(value)) {
            return "Draft";
        }
        return "";
    }

    private int parseId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
