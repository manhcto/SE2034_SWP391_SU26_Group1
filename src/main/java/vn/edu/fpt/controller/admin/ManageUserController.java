package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.UserDAO;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/user")
public class ManageUserController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        User loginUser =
                (User) request.getSession()
                        .getAttribute("user");

        if (loginUser == null
                || loginUser.getRoleID() != 1) {

            response.sendRedirect(
                    request.getContextPath() + "/home");

            return;
        }

        int page = 1;
        int pageSize = 10;

        String keyword =
                request.getParameter("keyword") == null
                        ? ""
                        : request.getParameter("keyword");

        String role =
                request.getParameter("role") == null
                        ? ""
                        : request.getParameter("role");

        String status =
                request.getParameter("status") == null
                        ? ""
                        : request.getParameter("status");

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(
                    request.getParameter("page"));
        }

        List<User> users =
                userDAO.getUsersPaging(
                        page,
                        pageSize,
                        keyword,
                        role,
                        status);

        int totalUsers =
                userDAO.getTotalUsers(
                        keyword,
                        role,
                        status);

        int totalPages =
                (int) Math.ceil(
                        (double) totalUsers / pageSize);

        request.setAttribute(
                "users",
                users);

        request.setAttribute(
                "totalUsers",
                totalUsers);

        request.setAttribute(
                "totalPages",
                totalPages);

        request.setAttribute(
                "currentPage",
                page);

        request.setAttribute(
                "staffCount",
                userDAO.countByRole(2));

        request.setAttribute(
                "tourGuideCount",
                userDAO.countByRole(3));

        request.setAttribute(
                "customerCount",
                userDAO.countByRole(4));

        request.setAttribute(
                "blockedCount",
                userDAO.countBlockedUsers());

        request.getRequestDispatcher(
                        "/views/admin/user-management.jsp")
                .forward(request, response);
    }
}
