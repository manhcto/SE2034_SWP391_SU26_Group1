package vn.edu.fpt.controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.UserDAO;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String firstName = trimToEmpty(request.getParameter("firstName"));
        String lastName  = trimToEmpty(request.getParameter("lastName"));
        String email     = trimToEmpty(request.getParameter("email"));
        String password  = valueOrEmpty(request.getParameter("password"));
        String confirmPassword = valueOrEmpty(request.getParameter("confirmPassword"));
        String phone     = trimToEmpty(request.getParameter("phone"));
        String gender    = trimToEmpty(request.getParameter("gender"));
        String dob       = trimToEmpty(request.getParameter("dob"));
        String address   = trimToEmpty(request.getParameter("address"));

        int roleID = 4; // Customer

        String validationError = validateRegisterInput(
                firstName,
                lastName,
                email,
                password,
                confirmPassword,
                phone,
                dob,
                address
        );

        if (validationError != null) {
            applyAddressOptions(request);
            request.setAttribute("error", validationError);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        // Email da ton tai trong he thong.
        if (userDAO.isEmailExist(email)) {
            applyAddressOptions(request);

            request.setAttribute(
                    "error",
                    "Email đã tồn tại!"
            );

            request.getRequestDispatcher(
                    "/views/register.jsp"
            ).forward(request, response);

            return;
        }

        boolean success = userDAO.registerUser(
                firstName,
                lastName,
                email,
                password,
                phone,
                gender,
                dob,
                address,
                roleID
        );

        if (success) {

            HttpSession session =
                    request.getSession();

            session.setAttribute(
                    "successMsg",
                    "Đăng ký thành công! Hãy đăng nhập."
            );

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

        } else {
            applyAddressOptions(request);

            request.setAttribute(
                    "error",
                    "Đăng ký thất bại!"
            );

            request.getRequestDispatcher(
                    "/views/register.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        applyAddressOptions(request);
        request.getRequestDispatcher(
                "/views/register.jsp"
        ).forward(request, response);
    }

    private String validateRegisterInput(String firstName,
                                         String lastName,
                                         String email,
                                         String password,
                                         String confirmPassword,
                                         String phone,
                                         String dob,
                                         String address) {

        if (firstName.isEmpty()
                || lastName.isEmpty()
                || email.isEmpty()
                || password.isEmpty()
                || phone.isEmpty()
                || dob.isEmpty()
                || address.isEmpty()) {
            return "Vui lòng nhập đầy đủ thông tin đăng ký.";
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            return "Email không đúng định dạng.";
        }

        if (!phone.matches("^0\\d{9}$")) {
            return "Số điện thoại phải gồm 10 chữ số và bắt đầu bằng 0.";
        }

        if (!password.equals(confirmPassword)) {
            return "Mật khẩu nhập lại không khớp.";
        }

        try {
            LocalDate birthDate = LocalDate.parse(dob);
            if (birthDate.isAfter(LocalDate.now().minusYears(18))) {
                return "Bạn phải đủ 18 tuổi để đăng ký.";
            }
        } catch (DateTimeParseException e) {
            return "Ngày sinh không hợp lệ.";
        }

        return null;
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private String valueOrEmpty(String value) {
        return value == null ? "" : value;
    }

    private void applyAddressOptions(HttpServletRequest request) {
        request.setAttribute("administrativeUnitList", administrativeUnitDAO.getActiveUnits());
    }
}
