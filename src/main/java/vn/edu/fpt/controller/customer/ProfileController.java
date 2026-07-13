package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet(urlPatterns = {"/profile", "/staff/profile", "/guide/profile", "/admin/profile"})
public class ProfileController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", request.getServletPath());
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeAccountTab", "profile");
        applyProfileTheme(request);
        request.getRequestDispatcher(
                        "/views/customer/profile.jsp")
                .forward(request, response);
    }

    private void applyProfileTheme(HttpServletRequest request) {
        String servletPath = request.getServletPath();

        request.setAttribute("profileHomePath", request.getContextPath() + "/home");
        request.setAttribute("profileLogoutPath", request.getContextPath() + "/logout");
        request.setAttribute("profileEditPath", request.getContextPath() + "/edit-profile");
        request.setAttribute("profileRoleLabel", "Khách hàng");
        request.setAttribute("profileKicker", "Tài khoản");
        request.setAttribute("profileTitle", "Thông tin cá nhân");
        request.setAttribute("profileSubtitle", "Thông tin này được dùng để tự điền nhanh khi bạn đặt tour hoặc đặt phòng.");
        request.setAttribute("profileTheme", "customer");

        if ("/staff/profile".equals(servletPath)) {
            request.setAttribute("profileHomePath", request.getContextPath() + "/staff/home");
            request.setAttribute("profileEditPath", request.getContextPath() + "/staff/edit-profile");
            request.setAttribute("profileRoleLabel", "Nhân viên");
            request.setAttribute("profileKicker", "Khu vực nhân viên");
            request.setAttribute("profileTitle", "Hồ sơ nhân viên");
            request.setAttribute("profileSubtitle", "Theo dõi và cập nhật thông tin tài khoản nhân viên WonderVN.");
            request.setAttribute("profileTheme", "staff");
            return;
        }

        if ("/guide/profile".equals(servletPath)) {
            request.setAttribute("profileHomePath", request.getContextPath() + "/guide/home");
            request.setAttribute("profileEditPath", request.getContextPath() + "/guide/edit-profile");
            request.setAttribute("profileRoleLabel", "Hướng dẫn viên");
            request.setAttribute("profileKicker", "Khu vực hướng dẫn viên");
            request.setAttribute("profileTitle", "Hồ sơ hướng dẫn viên");
            request.setAttribute("profileSubtitle", "Xem thông tin tài khoản và các tour đang được phân công.");
            request.setAttribute("profileTheme", "guide");
            return;
        }

        if ("/admin/profile".equals(servletPath)) {
            request.setAttribute("profileHomePath", request.getContextPath() + "/admin/home");
            request.setAttribute("profileEditPath", request.getContextPath() + "/admin/edit-profile");
            request.setAttribute("profileRoleLabel", "Quản trị viên");
            request.setAttribute("profileKicker", "Khu vực quản trị");
            request.setAttribute("profileTitle", "Hồ sơ quản trị viên");
            request.setAttribute("profileSubtitle", "Thông tin tài khoản dùng để quản trị và theo dõi hoạt động của WonderVN.");
            request.setAttribute("profileTheme", "admin");
        }
    }
}
