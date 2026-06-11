package vn.edu.fpt.controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vn.edu.fpt.DAO.UserDAO;

import java.io.IOException;
import java.util.Random;
import vn.edu.fpt.util.EmailUtil;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/forgot-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        boolean valid =
                userDAO.checkEmailAndPhone(email, phone);

        if (!valid) {

            request.setAttribute(
                    "error",
                    "Email hoặc số điện thoại không đúng!"
            );

            request.getRequestDispatcher(
                            "/views/forgot-password.jsp")
                    .forward(request, response);

            return;
        }

        // tạo OTP 6 số
        String otp =
                String.valueOf(
                        100000 +
                                new Random().nextInt(900000)
                );

        HttpSession session =
                request.getSession();

        session.setAttribute(
                "resetEmail",
                email
        );

        session.setAttribute(
                "otp",
                otp
        );

        EmailUtil.sendOTP(email, otp);

        response.sendRedirect(
                request.getContextPath()
                        + "/verify-otp"
        );
    }
}