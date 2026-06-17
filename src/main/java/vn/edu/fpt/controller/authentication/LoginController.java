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

            // Lưu thông tin user đăng nhập
            session.setAttribute("user", user);

            // Nếu muốn hiện thông báo ở Home sau khi login
            // session.setAttribute("successMsg", "Đăng nhập thành công!");

            response.sendRedirect(
                    request.getContextPath() + "/home"
            );

        } else {

            request.setAttribute(
                    "error",
                    "Sai email hoặc password!"
            );

            request.getRequestDispatcher("/views/login.jsp")
                    .forward(request, response);
        }
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
}