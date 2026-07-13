package vn.edu.fpt.controller.admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.UserDAO;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet("/admin/user/delete")
public class DeleteUserController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        User loginUser =
                (User) request.getSession()
                        .getAttribute("user");

        if (loginUser == null
                || loginUser.getRoleID() != 1) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN);

            return;
        }

        int userID =
                Integer.parseInt(
                        request.getParameter("id"));

        User targetUser =
                userDAO.getUserById(userID);

        if (targetUser != null
                && targetUser.getUserID() != loginUser.getUserID()
                && targetUser.getRoleID() != 1) {

            userDAO.deleteAccount(userID);
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/user");
    }
}
