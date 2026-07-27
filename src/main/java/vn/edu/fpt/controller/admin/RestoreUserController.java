package vn.edu.fpt.controller.admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.UserDAO;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet("/admin/user/restore")
public class RestoreUserController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        User loginUser = (User) request.getSession().getAttribute("user");

        // Kiểm tra đăng nhập và quyền Admin
        if (loginUser == null || loginUser.getRoleID() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int userID = Integer.parseInt(request.getParameter("id"));
        User targetUser = userDAO.getUserById(userID);

        // Chỉ khôi phục nếu tài khoản tồn tại và đang bị Inactive
        if (targetUser != null && "Inactive".equals(targetUser.getStatus())) {
            userDAO.restoreAccount(userID);
        }

        response.sendRedirect(request.getContextPath() + "/admin/user");
    }
}