package vn.edu.fpt.controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.UserDAO;

import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String firstName = request.getParameter("firstName");
        String lastName  = request.getParameter("lastName");
        String email     = request.getParameter("email");
        String password  = request.getParameter("password");
        String phone     = request.getParameter("phone");
        String gender    = request.getParameter("gender");
        String dob       = request.getParameter("dob");
        String address   = request.getParameter("address");

        int roleID = 4; // Customer

        // Email đang được tài khoản Active hoặc Blocked sử dụng
        if (userDAO.isEmailExist(email)) {

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

        request.getRequestDispatcher(
                "/views/register.jsp"
        ).forward(request, response);
    }
}