package vn.edu.fpt.controller.staff;

import vn.edu.fpt.DAO.BlogDAO;
import vn.edu.fpt.model.BlogPost;
import vn.edu.fpt.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.Normalizer;
import java.util.Locale;

@WebServlet("/staff/blog")
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
                case "edit":
                    BlogPost editingPost = blogDAO.getPostById(parseId(request.getParameter("id")));
                    if (editingPost == null) {
                        response.sendRedirect(request.getContextPath() + "/staff/blog?message=not_found");
                        return;
                    }
                    request.setAttribute("editingPost", editingPost);
                    forwardManagement(request, response);
                    break;
                case "delete":
                    blogDAO.deletePost(parseId(request.getParameter("id")));
                    response.sendRedirect(request.getContextPath() + "/staff/blog?message=deleted");
                    break;
                case "status":
                    int blogID = parseId(request.getParameter("id"));
                    String status = normalizeStatus(request.getParameter("status"));
                    blogDAO.updatePostStatus(blogID, status);
                    response.sendRedirect(request.getContextPath() + "/staff/blog?message=status_updated");
                    break;
                case "list":
                default:
                    forwardManagement(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/blog?message=error");
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

            response.sendRedirect(request.getContextPath() + "/staff/blog?message=" + (success ? "saved" : "error"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/blog?message=error");
        }
    }

    private void forwardManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = normalize(request.getParameter("keyword"));
        String category = normalize(request.getParameter("category"));

        request.setAttribute("BLOG_LIST", blogDAO.getPostsForStaff(keyword, category));
        request.setAttribute("CATEGORY_LIST", blogDAO.getStaffCategories());
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", category);
        request.getRequestDispatcher("/views/staff/blog-management.jsp").forward(request, response);
    }

    private BlogPost buildPostFromRequest(HttpServletRequest request) {
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
        post.setThumbnailUrl(normalize(request.getParameter("thumbnailUrl")));
        post.setCategory(normalize(request.getParameter("category")));
        post.setStatus(normalizeStatus(request.getParameter("status")));
        post.setAuthorID(getCurrentUserID(request));
        return post;
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
