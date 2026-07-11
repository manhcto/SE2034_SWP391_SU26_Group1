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
        request.setAttribute("profileRoleLabel", "Khach hang");
        request.setAttribute("profileKicker", "Tai khoan");
        request.setAttribute("profileTitle", "Thong tin ca nhan");
        request.setAttribute("profileSubtitle", "Thong tin nay duoc dung de tu dien nhanh khi ban dat tour hoac dat phong.");
        request.setAttribute("profileTheme", "customer");

        if ("/staff/profile".equals(servletPath)) {
            request.setAttribute("profileHomePath", request.getContextPath() + "/staff/home");
            request.setAttribute("profileEditPath", request.getContextPath() + "/staff/edit-profile");
            request.setAttribute("profileRoleLabel", "Nhan vien");
            request.setAttribute("profileKicker", "Staff Workspace");
            request.setAttribute("profileTitle", "Ho so nhan vien");
            request.setAttribute("profileSubtitle", "Theo doi thong tin tai khoan nhan vien va quay lai khu vuc van hanh WonderVN.");
            request.setAttribute("profileTheme", "staff");
            return;
        }

        if ("/guide/profile".equals(servletPath)) {
            request.setAttribute("profileHomePath", request.getContextPath() + "/guide/home");
            request.setAttribute("profileEditPath", request.getContextPath() + "/guide/edit-profile");
            request.setAttribute("profileRoleLabel", "Huong dan vien");
            request.setAttribute("profileKicker", "Guide Workspace");
            request.setAttribute("profileTitle", "Ho so huong dan vien");
            request.setAttribute("profileSubtitle", "Xem nhanh thong tin tai khoan va quay lai cac tour dang duoc phan cong.");
            request.setAttribute("profileTheme", "guide");
            return;
        }

        if ("/admin/profile".equals(servletPath)) {
            request.setAttribute("profileHomePath", request.getContextPath() + "/admin/home");
            request.setAttribute("profileEditPath", request.getContextPath() + "/admin/edit-profile");
            request.setAttribute("profileRoleLabel", "Quan tri vien");
            request.setAttribute("profileKicker", "Admin Control Center");
            request.setAttribute("profileTitle", "Ho so quan tri");
            request.setAttribute("profileSubtitle", "Thong tin tai khoan dung de quan tri he thong va theo doi van hanh WonderVN.");
            request.setAttribute("profileTheme", "admin");
        }
    }
}
