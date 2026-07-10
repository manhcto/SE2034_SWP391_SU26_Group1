package vn.edu.fpt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.UserDAO;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet("/edit-profile")
public class EditProfileController
        extends HttpServlet {

    private UserDAO userDAO =
            new UserDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                        "/views/edit-profile.jsp")
                .forward(request, response);

    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");
        String address = request.getParameter("address");

        boolean success = userDAO.updateProfile(
                user.getUserID(),
                firstName,
                lastName,
                phone,
                gender,
                dob,
                address
        );

        if (success) {

            // cập nhật session
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setPhone(phone);
            user.setGender(gender);
            user.setDob(dob);
            user.setAddress(address);

            session.setAttribute("user", user);

            response.sendRedirect(
                    request.getContextPath() + "/profile"
            );

        } else {

            request.setAttribute(
                    "error",
                    "Cập nhật hồ sơ thất bại!"
            );

            request.getRequestDispatcher(
                    "/views/edit-profile.jsp"
            ).forward(request, response);
        }
    }
}