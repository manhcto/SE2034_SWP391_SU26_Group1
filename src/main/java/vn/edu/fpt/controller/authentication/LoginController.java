package vn.edu.fpt.controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.UserDAO;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = trimToEmpty(request.getParameter("email"));
        String password = trimToEmpty(request.getParameter("password"));

        User user = userDAO.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            redirectByRole(request, response, user);
            return;
        }

        User existingUser = userDAO.getUserByEmail(email);

        if (existingUser == null) {
            request.setAttribute("error", "Email không tồn tại!");
        } else {
            String status = existingUser.getStatus();

            if ("Inactive".equalsIgnoreCase(status)) {
                request.setAttribute("error", "Tài khoản chưa được kích hoạt!");
            } else if ("Blocked".equalsIgnoreCase(status)) {
                request.setAttribute("error", "Tài khoản đã bị khóa!");
            } else {
                request.setAttribute("error", "Sai mật khẩu!");
            }
        }

        request.getRequestDispatcher("/views/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            String successMsg = (String) session.getAttribute("successMsg");

            if (successMsg != null) {
                request.setAttribute("successMsg", successMsg);
                session.removeAttribute("successMsg");
            }
        }

        request.getRequestDispatcher("/views/login.jsp")
                .forward(request, response);
    }

    private void redirectByRole(HttpServletRequest request,
                                HttpServletResponse response,
                                User user)
            throws IOException {

        String roleName = normalizeRoleName(user.getRoleName());

        if ("admin".equals(roleName) || user.getRoleID() == 1) {
            response.sendRedirect(request.getContextPath() + "/admin/home");
            return;
        }

        if ("staff".equals(roleName)) {
            response.sendRedirect(request.getContextPath() + "/staff/home");
            return;
        }

        if ("tour guide".equals(roleName) || "guide".equals(roleName)) {
            response.sendRedirect(request.getContextPath() + "/guide/home");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private String normalizeRoleName(String roleName) {
        return roleName == null ? "" : roleName.trim().toLowerCase();
    }
}
