package vn.edu.fpt.controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOTPController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/verify-otp.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String userOTP = request.getParameter("otp");

        HttpSession session = request.getSession();

        String sessionOTP =
                (String) session.getAttribute("otp");

        if (userOTP != null &&
                userOTP.equals(sessionOTP)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/reset-password"
            );

        } else {

            request.setAttribute(
                    "error",
                    "OTP không chính xác!"
            );

            request.getRequestDispatcher(
                    "/views/verify-otp.jsp"
            ).forward(request, response);
        }
    }
}