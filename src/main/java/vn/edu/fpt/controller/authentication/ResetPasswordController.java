package vn.edu.fpt.controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.fpt.DAO.UserDAO;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/reset-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String password =
                request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                    "error",
                    "Mật khẩu xác nhận không khớp!"
            );

            request.getRequestDispatcher(
                    "/views/reset-password.jsp"
            ).forward(request, response);

            return;
        }

        HttpSession session =
                request.getSession();

        String email =
                (String) session.getAttribute("resetEmail");

        UserDAO dao = new UserDAO();

        dao.updatePassword(email, password);

        session.removeAttribute("otp");
        session.removeAttribute("resetEmail");

        session.setAttribute(
                "successMsg",
                "Đổi mật khẩu thành công! Hãy đăng nhập."
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/login"
        );
    }
}