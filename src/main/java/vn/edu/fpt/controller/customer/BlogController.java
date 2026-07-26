package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.BlogDAO;
import vn.edu.fpt.model.BlogPost;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/blog", "/blog-detail"})
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

        showList(request, response);
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

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
