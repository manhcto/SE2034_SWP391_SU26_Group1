package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Room;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CustomerAccommodationController", urlPatterns = {
        "/accommodation",
        "/accommodation/detail"
})
public class AccommodationController extends HttpServlet {

    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String servletPath = request.getServletPath();

        if ("/accommodation/detail".equals(servletPath)) {
            showDetail(request, response);
        } else {
            showList(request, response);
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");

        List<Accommodation> allList = accommodationDAO.getAvailableAccommodationsForCustomer();
        List<Accommodation> filteredList = new ArrayList<>();

        for (Accommodation acc : allList) {
            boolean matchKeyword = true;
            boolean matchType = true;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String key = keyword.trim().toLowerCase();

                String name = acc.getName() == null ? "" : acc.getName().toLowerCase();
                String address = acc.getAddress() == null ? "" : acc.getAddress().toLowerCase();
                String description = acc.getDescription() == null ? "" : acc.getDescription().toLowerCase();

                matchKeyword = name.contains(key)
                        || address.contains(key)
                        || description.contains(key);
            }

            if (type != null && !type.trim().isEmpty() && !"all".equalsIgnoreCase(type)) {
                matchType = type.equalsIgnoreCase(acc.getType());
            }

            if (matchKeyword && matchType) {
                filteredList.add(acc);
            }
        }

        request.setAttribute("accommodationList", filteredList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedType", type);

        request.getRequestDispatcher("/views/customer/accommodation-list.jsp")
                .forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        if (idRaw == null || idRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/accommodation");
            return;
        }

        try {
            int serviceID = Integer.parseInt(idRaw);

            Accommodation accommodation = accommodationDAO.getAvailableAccommodationByIdForCustomer(serviceID);

            if (accommodation == null) {
                response.sendRedirect(request.getContextPath() + "/accommodation?status=notFound");
                return;
            }

            List<Room> roomList = roomDAO.getRoomsByAccommodation(serviceID);

            request.setAttribute("accommodation", accommodation);
            request.setAttribute("roomList", roomList);

            request.getRequestDispatcher("/views/customer/accommodation-detail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/accommodation");
        }
    }
}