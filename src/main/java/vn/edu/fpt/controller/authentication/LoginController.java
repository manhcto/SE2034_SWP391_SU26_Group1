package vn.edu.fpt.controller.authentication;

import vn.edu.fpt.DAO.UserDAO;
import vn.edu.fpt.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.login(email, password);

        if (user != null) {

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            int roleID = user.getRoleID();

            if (roleID == 1) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/views/admin/admin-home.jsp");
            }
            else if (roleID == 2) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/views/staff/staff-home.jsp");
            }
            else if (roleID == 3) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/views/guide/tour-guide-home.jsp");
            }
            else {
                String redirectAfterLogin = getRedirectAfterLogin(request, session);
                session.removeAttribute("redirectAfterLogin");

                response.sendRedirect(request.getContextPath() + redirectAfterLogin);
            }

            return;
        }

        User existingUser = userDAO.getUserByEmail(email);

        if (existingUser == null) {

            request.setAttribute(
                    "error",
                    "Email không tồn tại!"
            );

        } else {

            String status = existingUser.getStatus();

            if ("Inactive".equalsIgnoreCase(status)) {

                request.setAttribute(
                        "error",
                        "Tài khoản chưa được kích hoạt!"
                );

            } else if ("Blocked".equalsIgnoreCase(status)) {

                request.setAttribute(
                        "error",
                        "Tài khoản đã bị khóa!"
                );

            } else {

                request.setAttribute(
                        "error",
                        "Sai mật khẩu!"
                );
            }
        }

        request.getRequestDispatcher("/views/login.jsp")
                .forward(request, response);

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Không tạo session mới nếu chưa tồn tại
        String redirect = request.getParameter("redirect");
        HttpSession session = isSafeRedirect(redirect)
                ? request.getSession()
                : request.getSession(false);

        if (session != null) {
            if (isSafeRedirect(redirect)) {
                session.setAttribute("redirectAfterLogin", redirect);
                request.setAttribute("redirectAfterLogin", redirect);
            } else {
                String redirectAfterLogin =
                        (String) session.getAttribute("redirectAfterLogin");

                if (isSafeRedirect(redirectAfterLogin)) {
                    request.setAttribute("redirectAfterLogin", redirectAfterLogin);
                }
            }

            String successMsg =
                    (String) session.getAttribute("successMsg");

            if (successMsg != null) {

                request.setAttribute(
                        "successMsg",
                        successMsg
                );

                // Hiển thị 1 lần rồi xóa
                session.removeAttribute("successMsg");
            }
        }

        String redirectAfterLogin = getRedirectAfterLogin(request, request.getSession());

        if (isSafeRedirect(redirectAfterLogin)) {
            request.setAttribute("redirectAfterLogin", redirectAfterLogin);
        }

        request.getRequestDispatcher("/views/login.jsp")
                .forward(request, response);
    }

    private String getRedirectAfterLogin(HttpServletRequest request, HttpSession session) {
        String redirect = request.getParameter("redirect");

        if (!isSafeRedirect(redirect) && session != null) {
            redirect = (String) session.getAttribute("redirectAfterLogin");
        }

        return isSafeRedirect(redirect) ? redirect : "/home";
    }

    private boolean isSafeRedirect(String redirect) {
        if (redirect == null || redirect.trim().isEmpty()) {
            return false;
        }

        String value = redirect.trim();
        return value.startsWith("/")
                && !value.startsWith("//")
                && !value.contains("\\")
                && !value.toLowerCase().contains("%5c");
    }
}
