package vn.edu.fpt.controller.authentication;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        request.getSession().invalidate();

        response.sendRedirect(
                request.getContextPath() + "/home");
    }
}