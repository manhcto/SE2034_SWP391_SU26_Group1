package vn.edu.fpt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private final TourDAO tourDAO = new TourDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = getCurrentUser(request);
        if (user != null) {
            String roleName = normalizeRoleName(user.getRoleName());

            if ("admin".equals(roleName) || user.getRoleID() == 1) {
                response.sendRedirect(request.getContextPath() + "/admin/home");
                return;
            }

            if (isStaff(user, roleName)) {
                response.sendRedirect(request.getContextPath() + "/staff/home");
                return;
            }

            if (isTourGuide(user, roleName)) {
                response.sendRedirect(request.getContextPath() + "/guide/home");
                return;
            }
        }

        List<Tour> featuredTours = tourDAO.getFeaturedToursForHome(4);
        List<Tour> packageTours = tourDAO.getPublishedToursForCustomer(null, null, null, null, null, null, 10);

        request.setAttribute("featuredTours", featuredTours);
        request.setAttribute("packageTours", packageTours);
        request.setAttribute("northTours", tourDAO.getPublishedToursForHomeByRegionName("Miền Bắc", 3));
        request.setAttribute("centralTours", tourDAO.getPublishedToursForHomeByRegionName("Miền Trung", 3));
        request.setAttribute("southTours", tourDAO.getPublishedToursForHomeByRegionName("Miền Nam", 3));
        request.setAttribute("startPlaces", tourDAO.getPublishedStartPlaces());
        request.setAttribute("destinations", tourDAO.getPublishedDestinations());

        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }

    private User getCurrentUser(HttpServletRequest request) {
        Object user = request.getSession(false) == null
                ? null
                : request.getSession(false).getAttribute("user");
        return user instanceof User ? (User) user : null;
    }

    private String normalizeRoleName(String roleName) {
        return roleName == null ? "" : roleName.trim().toLowerCase();
    }

    private boolean isStaff(User user, String roleName) {
        return "staff".equals(roleName) || user.getRoleID() == 2;
    }

    private boolean isTourGuide(User user, String roleName) {
        String compactRoleName = roleName.replace(" ", "").replace("-", "");
        return "tourguide".equals(compactRoleName)
                || "guide".equals(compactRoleName)
                || user.getRoleID() == 3;
    }
}
