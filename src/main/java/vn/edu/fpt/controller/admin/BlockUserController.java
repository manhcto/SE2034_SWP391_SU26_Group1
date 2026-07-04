package vn.edu.fpt.controller.admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.UserDAO;

import java.io.IOException;

@WebServlet("/admin/user/block")
public class BlockUserController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        int userID =
                Integer.parseInt(request.getParameter("id"));

        userDAO.blockUser(userID);

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/user");
    }
}
