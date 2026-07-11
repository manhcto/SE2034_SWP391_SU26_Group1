package vn.edu.fpt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = getCurrentUser(request);

        if (user != null) {
            if (user.getRoleID() == 1) {
                response.sendRedirect(request.getContextPath() + "/admin/home");
                return;
            }

            if (user.getRoleID() == 2) {
                response.sendRedirect(request.getContextPath() + "/staff/home");
                return;
            }

            if (user.getRoleID() == 3) {
                response.sendRedirect(request.getContextPath() + "/guide/home");
                return;
            }
        }

        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object user = session == null ? null : session.getAttribute("user");
        return user instanceof User ? (User) user : null;
    }
}
