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

            if (roleID == 4) {
                String redirectAfterLogin = (String) session.getAttribute("redirectAfterLogin");
                if (isSafeRedirect(request, redirectAfterLogin)) {
                    session.removeAttribute("redirectAfterLogin");
                    response.sendRedirect(redirectAfterLogin);
                    return;
                }
            }

            if (roleID == 1) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/views/admin/admin-home.jsp");
            }
            else if (roleID == 2) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/staff/home");
            }
            else if (roleID == 3) {
                response.sendRedirect(
                        request.getContextPath()
                                + "/views/guide/tour-guide-home.jsp");
            }
            else {
                response.sendRedirect(
                        request.getContextPath()
                                + "/home");
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
        HttpSession session = request.getSession(false);

        if (session != null) {

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

        request.getRequestDispatcher("/views/login.jsp")
                .forward(request, response);
    }

    private boolean isSafeRedirect(HttpServletRequest request, String redirectAfterLogin) {
        if (redirectAfterLogin == null || redirectAfterLogin.isBlank()) {
            return false;
        }

        String contextPath = request.getContextPath();
        return redirectAfterLogin.startsWith(contextPath + "/")
                && !redirectAfterLogin.startsWith(contextPath + "//");
    }
}
