package vn.edu.fpt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.UserDAO;
import vn.edu.fpt.model.AdministrativeUnit;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet(urlPatterns = {
        "/edit-profile",
        "/staff/edit-profile",
        "/guide/edit-profile",
        "/admin/edit-profile"
})
public class EditProfileController
        extends HttpServlet {

    private final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();
    private UserDAO userDAO =
            new UserDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        applyEditProfileContext(request);

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
        String streetAddress = trimToEmpty(request.getParameter("streetAddress"));
        int administrativeUnitID = parsePositiveInt(request.getParameter("administrativeUnitID"));
        AdministrativeUnit administrativeUnit = administrativeUnitID > 0
                ? administrativeUnitDAO.getActiveUnitByID(administrativeUnitID)
                : null;

        if (administrativeUnit == null) {
            applyEditProfileContext(request);
            request.setAttribute("error", "Vui lòng chọn tỉnh/thành phố và phường/xã hợp lệ.");
            request.getRequestDispatcher("/views/edit-profile.jsp").forward(request, response);
            return;
        }

        String address = streetAddress.isEmpty()
                ? administrativeUnit.getWardName() + ", " + administrativeUnit.getProvinceName()
                : streetAddress + ", " + administrativeUnit.getWardName()
                + ", " + administrativeUnit.getProvinceName();

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
                    request.getContextPath() + resolveProfilePath(request)
            );

        } else {
            applyEditProfileContext(request);

            request.setAttribute(
                    "error",
                    "Cập nhật hồ sơ thất bại!"
            );

            request.getRequestDispatcher(
                    "/views/edit-profile.jsp"
            ).forward(request, response);
        }
    }

    private void applyEditProfileContext(HttpServletRequest request) {
        request.setAttribute("editProfileActionPath", request.getContextPath() + request.getServletPath());
        request.setAttribute("editProfileBackPath", resolveProfilePath(request));
        request.setAttribute("editProfileTheme", resolveTheme(request));
        request.setAttribute("administrativeUnitList", administrativeUnitDAO.getActiveUnits());
    }

    private String resolveProfilePath(HttpServletRequest request) {
        String servletPath = request.getServletPath();

        if ("/staff/edit-profile".equals(servletPath)) {
            return "/staff/profile";
        }

        if ("/guide/edit-profile".equals(servletPath)) {
            return "/guide/profile";
        }

        if ("/admin/edit-profile".equals(servletPath)) {
            return "/admin/profile";
        }

        return "/profile";
    }

    private String resolveTheme(HttpServletRequest request) {
        String servletPath = request.getServletPath();

        if ("/staff/edit-profile".equals(servletPath)) {
            return "staff";
        }

        if ("/guide/edit-profile".equals(servletPath)) {
            return "guide";
        }

        if ("/admin/edit-profile".equals(servletPath)) {
            return "admin";
        }

        return "customer";
    }

    private int parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(trimToEmpty(value));
            return number > 0 ? number : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
