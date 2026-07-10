package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddTourController", urlPatterns = {"/staff/tour/add"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 25 * 1024 * 1024)
public class AddTourController extends StaffTourFormSupport {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int dayCount = resolveDayCount(request, null);
        Tour tour;

        if (request.getParameter("numberOfDay") != null) {
            TourFormData data = readTourFormData(request);
            data.status = "Draft";
            tour = buildTourFromData(data, getCurrentUserID(request), true);
        } else {
            tour = buildDefaultTour(dayCount);
        }

        forwardTourForm(
                request,
                response,
                tour,
                fillSubmittedOrBlankItineraries(tour.getItineraryList(), dayCount),
                dayCount,
                "add",
                request.getContextPath() + "/staff/tour/add",
                "Thêm tour mới",
                "Lưu tour",
                null
        );
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        TourFormData data = readTourFormData(request);
        data.status = "Draft";
        List<String> errors = validateTourData(data, false);
        Tour tour = buildTourFromData(data, getCurrentUserID(request), true);

        if (!errors.isEmpty()) {
            forwardTourForm(
                    request,
                    response,
                    tour,
                    tour.getItineraryList(),
                    tour.getNumberOfDay() > 0 ? tour.getNumberOfDay() : 1,
                    "add",
                    request.getContextPath() + "/staff/tour/add",
                    "Thêm tour mới",
                    "Lưu tour",
                    errors
            );
            return;
        }

        int newTourID = tourDAO.insertTourWithItineraries(tour);

        if (newTourID > 0) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/tour/detail?id=" + newTourID
                    + "&message=addSuccess");
            return;
        }

        errors.add("Không thể thêm tour. Hãy kiểm tra lại dữ liệu hoặc kết nối database.");
        forwardTourForm(
                request,
                response,
                tour,
                tour.getItineraryList(),
                tour.getNumberOfDay() > 0 ? tour.getNumberOfDay() : 1,
                "add",
                request.getContextPath() + "/staff/tour/add",
                "Thêm tour mới",
                "Lưu tour",
                errors
        );
    }

    private List<vn.edu.fpt.model.TourItinerary> fillSubmittedOrBlankItineraries(List<vn.edu.fpt.model.TourItinerary> itineraries, int dayCount) {
        java.util.Map<Integer, vn.edu.fpt.model.TourItinerary> map = buildItineraryMap(itineraries);
        java.util.List<vn.edu.fpt.model.TourItinerary> result = new java.util.ArrayList<>();

        for (int day = 1; day <= dayCount; day++) {
            vn.edu.fpt.model.TourItinerary itinerary = map.get(day);
            if (itinerary == null) {
                itinerary = new vn.edu.fpt.model.TourItinerary();
                itinerary.setDayNumber(day);
                itinerary.setStatus("Active");
            }
            result.add(itinerary);
        }
        return result;
    }
}
