package vn.edu.fpt.controller.customer;

import jakarta.servlet.annotation.MultipartConfig;
import vn.edu.fpt.DAO.BlogDAO;
import vn.edu.fpt.model.BlogPost;
import vn.edu.fpt.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.text.Normalizer;
import java.util.Locale;
import java.util.List;

@WebServlet({"/blog", "/blog-detail", "/my-blogs"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 50 * 1024 * 1024
)
public class BlogController extends HttpServlet {
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
        String path = request.getServletPath();

        if ("/blog-detail".equals(path)) {
            showDetail(request, response);
            return;
        }

        if ("/my-blogs".equals(path)) {
            showMyBlogs(request, response);
            return;
        }

        showList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!"/my-blogs".equals(request.getServletPath())) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        User user = requireCustomer(request, response);
        if (user == null) {
            return;
        }

        try {
            BlogPost post = buildPostFromRequest(request, user.getUserID());
            if (post.getTitle().isEmpty() || post.getContent().isEmpty()) {
                request.setAttribute("editingPost", post);
                request.setAttribute("showBlogForm", true);
                request.setAttribute("error", "Vui lòng nhập tiêu đề và nội dung bài viết.");
                forwardMyBlogs(request, response, user);
                return;
            }

            boolean success = post.getBlogID() > 0
                    ? blogDAO.updatePost(post)
                    : blogDAO.insertPost(post);

            response.sendRedirect(request.getContextPath()
                    + "/my-blogs?message=" + (success ? "submitted" : "error"));
        } catch (IllegalArgumentException e) {
            request.setAttribute("showBlogForm", true);
            request.setAttribute("error", e.getMessage());
            forwardMyBlogs(request, response, user);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/my-blogs?message=error");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = normalize(request.getParameter("keyword"));
        String category = normalize(request.getParameter("category"));

        List<BlogPost> posts = blogDAO.getPublishedPosts(keyword, category);
        int totalPosts = blogDAO.countPublishedPosts(keyword, category);

        request.setAttribute("BLOG_LIST", posts);
        request.setAttribute("CATEGORY_LIST", blogDAO.getPublishedCategories());
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("totalPosts", totalPosts);
        request.getRequestDispatcher("/views/customer/blog-list.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BlogPost post = null;
        String id = normalize(request.getParameter("id"));
        String slug = normalize(request.getParameter("slug"));

        if (!id.isEmpty()) {
            try {
                post = blogDAO.getPublishedPostById(Integer.parseInt(id));
            } catch (NumberFormatException ignored) {
                post = null;
            }
        } else if (!slug.isEmpty()) {
            post = blogDAO.getPublishedPostBySlug(slug);
        }

        if (post == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }

        request.setAttribute("post", post);
        request.setAttribute("RELATED_POSTS",
                blogDAO.getRelatedPublishedPosts(post.getCategory(), post.getBlogID(), 3));
        request.getRequestDispatcher("/views/customer/blog-detail.jsp").forward(request, response);
    }

    private void showMyBlogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = requireCustomer(request, response);
        if (user == null) {
            return;
        }

        String action = normalize(request.getParameter("action"));
        int blogID = parseId(request.getParameter("id"));

        if ("view".equals(action)) {
            BlogPost post = blogDAO.getPostByIdAndAuthorID(blogID, user.getUserID());
            if (post == null) {
                response.sendRedirect(request.getContextPath() + "/my-blogs?message=not_found");
                return;
            }

            request.setAttribute("post", post);
            request.setAttribute("RELATED_POSTS", List.of());
            request.setAttribute("backToMyBlogPath", request.getContextPath() + "/my-blogs");
            request.getRequestDispatcher("/views/customer/blog-detail.jsp").forward(request, response);
            return;
        }

        if ("new".equals(action)) {
            request.setAttribute("showBlogForm", true);
        } else if ("edit".equals(action)) {
            BlogPost editingPost = blogDAO.getPostByIdAndAuthorID(blogID, user.getUserID());
            if (editingPost == null) {
                response.sendRedirect(request.getContextPath() + "/my-blogs?message=not_found");
                return;
            }
            request.setAttribute("editingPost", editingPost);
            request.setAttribute("showBlogForm", true);
        }

        forwardMyBlogs(request, response, user);
    }

    private void forwardMyBlogs(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        request.setAttribute("BLOG_LIST", blogDAO.getPostsByAuthorID(user.getUserID()));
        request.setAttribute("CATEGORY_LIST", blogDAO.getStaffCategories());
        request.setAttribute("activeAccountTab", "blogs");
        request.getRequestDispatcher("/views/customer/my-blog-list.jsp").forward(request, response);
    }

    private BlogPost buildPostFromRequest(HttpServletRequest request, int authorID)
            throws ServletException, IOException {
        int blogID = parseId(request.getParameter("blogID"));
        String title = normalize(request.getParameter("title"));
        String customSlug = normalize(request.getParameter("slug"));
        String baseSlug = customSlug.isEmpty() ? createSlug(title) : createSlug(customSlug);

        BlogPost existingPost = blogID > 0 ? blogDAO.getPostByIdAndAuthorID(blogID, authorID) : null;
        if (blogID > 0 && existingPost == null) {
            throw new IllegalArgumentException("Không tìm thấy bài viết cần sửa.");
        }

        BlogPost post = new BlogPost();
        post.setBlogID(blogID);
        post.setTitle(title);
        post.setSlug(blogDAO.createUniqueSlug(baseSlug, blogID));
        post.setSummary(normalize(request.getParameter("summary")));
        post.setContent(normalize(request.getParameter("content")));
        post.setImage(normalize(request.getParameter("existingImage")));
        post.setCategory(normalize(request.getParameter("category")));
        post.setStatus("Pending");
        post.setAuthorID(authorID);

        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            if (!isAllowedImage(imagePart)) {
                throw new IllegalArgumentException("Chỉ được upload ảnh JPG, PNG hoặc WebP.");
            }

            String fileName = System.currentTimeMillis() + "-"
                    + Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/uploads/blog");
            File folder = new File(uploadPath);
            if (!folder.exists()) {
                folder.mkdirs();
            }

            imagePart.write(uploadPath + File.separator + fileName);
            post.setImage("uploads/blog/" + fileName);
        }

        return post;
    }

    private User requireCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", "/my-blogs");
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return user;
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
