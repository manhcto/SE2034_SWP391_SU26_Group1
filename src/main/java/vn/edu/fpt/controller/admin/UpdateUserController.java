package vn.edu.fpt.controller.admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.UserDAO;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet("/admin/user/update")
public class UpdateUserController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
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
                        request.getParameter("userID"));

        int roleID =
                Integer.parseInt(
                        request.getParameter("roleID"));

        User u =
                userDAO.getUserById(userID);

        if (u != null && u.getRoleID() != 1) {

            userDAO.updateRole(
                    userID,
                    roleID);
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/user");
    }
}