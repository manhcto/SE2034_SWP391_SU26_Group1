package vn.edu.fpt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.BlogDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.BlogPost;
import vn.edu.fpt.model.Room;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private final TourDAO tourDAO = new TourDAO();
    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final BlogDAO blogDAO = new BlogDAO();
    private final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();

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

            if (isTourGuide(user, roleName)) {
                response.sendRedirect(request.getContextPath() + "/guide/home");
                return;
            }

            if (isStaff(user, roleName)) {
                response.sendRedirect(request.getContextPath() + "/staff/home");
                return;
            }
        }

        List<Tour> featuredTours = tourDAO.getFeaturedToursForHome(4);
        List<Tour> packageTours = tourDAO.getPublishedToursForCustomer(
                null, null, null, null, null, null, 10);
        List<Accommodation> availableAccommodations =
                accommodationDAO.getAvailableAccommodationsForCustomer();
        List<Accommodation> featuredAccommodations = take(availableAccommodations, 6);
        List<BlogPost> publishedBlogs = blogDAO.getPublishedPosts("", "");

        Map<Integer, List<Room>> roomsByAccommodation = new HashMap<>();
        for (Room room : roomDAO.getAllAvailableRooms()) {
            roomsByAccommodation
                    .computeIfAbsent(room.getAccommodationID(), ignored -> new ArrayList<>())
                    .add(room);
        }
        for (Accommodation accommodation : featuredAccommodations) {
            accommodation.setRoomList(roomsByAccommodation.getOrDefault(
                    accommodation.getAccommodationID(), List.of()));
        }

        request.setAttribute("featuredTours", featuredTours);
        request.setAttribute("domesticTours", take(packageTours, 8));
        request.setAttribute("packageTours", packageTours);
        request.setAttribute("featuredAccommodations", featuredAccommodations);
        request.setAttribute("latestBlogs", take(publishedBlogs, 3));
        request.setAttribute("northTours", tourDAO.getPublishedToursForHomeByRegionName("Miền Bắc", 3));
        request.setAttribute("centralTours", tourDAO.getPublishedToursForHomeByRegionName("Miền Trung", 3));
        request.setAttribute("southTours", tourDAO.getPublishedToursForHomeByRegionName("Miền Nam", 3));
        request.setAttribute("startPlaces", tourDAO.getPublishedStartPlaces());
        request.setAttribute("destinations", tourDAO.getPublishedDestinations());
        request.setAttribute("provinceList", administrativeUnitDAO.getActiveProvinceNames());
        request.setAttribute("activeTourCount", packageTours.size());
        request.setAttribute("accommodationCount", availableAccommodations.size());
        request.setAttribute("publishedBlogCount", publishedBlogs.size());

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
        if (!roleName.isEmpty()) {
            return "staff".equals(roleName);
        }

        return user.getRoleID() == 2;
    }

    private boolean isTourGuide(User user, String roleName) {
        String compactRoleName = roleName.replace(" ", "").replace("-", "").replace("_", "");

        if (!compactRoleName.isEmpty()) {
            return "tourguide".equals(compactRoleName)
                    || "guide".equals(compactRoleName);
        }

        return user.getRoleID() == 3;
    }

    private <T> List<T> take(List<T> items, int limit) {
        return items.size() <= limit ? items : items.subList(0, limit);
    }
}
