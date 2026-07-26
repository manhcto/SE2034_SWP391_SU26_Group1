package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourItinerary;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EditTourController", urlPatterns = {"/staff/tour/edit"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 25 * 1024 * 1024)
public class EditTourController extends StaffTourFormSupport {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer tourID = parsePositiveInt(firstNonBlank(request.getParameter("id"), request.getParameter("tourID")));

        if (tourID == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        Tour tour = tourDAO.getTourById(tourID);

        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        if (!canEditTourStatus(tour.getStatus())) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/tour/detail?id=" + tourID
                    + "&message=noEditPermission");
            return;
        }

        List<TourItinerary> itineraries = tourDAO.getItinerariesByTourId(tourID);
        tour.setItineraryList(itineraries);
        tour.setScheduleList(tourDAO.getSchedulesByTourId(tourID));
        tourDAO.loadManagedImages(tour);

        int dayCount = isPriceAndScheduleLocked(tour.getStatus())
                ? normalizeDayCount(tour.getNumberOfDay())
                : resolveDayCount(request, tour);
        List<TourItinerary> formItineraries = itineraries;

        if (request.getParameter("numberOfDay") != null) {
            TourFormData data = readTourFormData(request);
            data.status = tour.getStatus();
            if (isActiveTourStatus(tour.getStatus())) {
                preserveActiveTourEditableFields(data, tour);
            } else if (isPriceAndScheduleLocked(tour.getStatus())) {
                preservePriceRouteAndScheduleFields(data, tour);
            }
            Tour submittedTour = buildTourFromData(data, getCurrentUserID(request), false);
            submittedTour.setTourCode(tour.getTourCode());
            submittedTour.setScheduleList(tour.getScheduleList());
            tour = submittedTour;
            formItineraries = submittedTour.getItineraryList();
        }

        forwardTourForm(
                request,
                response,
                tour,
                fillMissingItineraries(formItineraries, dayCount),
                dayCount,
                "edit",
                request.getContextPath() + "/staff/tour/edit",
                "Cập nhật tour",
                "Cập nhật tour",
                null
        );
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        TourFormData data = readTourFormData(request);
        Integer tourID = parsePositiveInt(data.tourIDRaw);
        Tour existingTour = tourID == null ? null : tourDAO.getTourById(tourID);

        if (existingTour != null) {
            existingTour.setItineraryList(tourDAO.getItinerariesByTourId(existingTour.getTourID()));
            existingTour.setScheduleList(tourDAO.getSchedulesByTourId(existingTour.getTourID()));
            tourDAO.loadManagedImages(existingTour);
            data.status = existingTour.getStatus();
            if (isActiveTourStatus(existingTour.getStatus())) {
                preserveActiveTourEditableFields(data, existingTour);
            } else {
                preserveTourPricingFields(data, existingTour);
            }
            if (!isActiveTourStatus(existingTour.getStatus()) && isPriceAndScheduleLocked(existingTour.getStatus())) {
                preservePriceRouteAndScheduleFields(data, existingTour);
            }
        }

        List<String> errors = validateTourData(data, true);

        if (tourID == null || existingTour == null) {
            errors.add("Tour cần cập nhật không tồn tại.");
        } else if (!canEditTourStatus(existingTour.getStatus())) {
            errors.add("Tour ở trạng thái hiện tại không được sửa. Chỉ trạng thái Nháp/Bị từ chối được sửa đầy đủ; Đang bán chỉ được thêm ảnh và sửa điểm nổi bật.");
        }

        Tour tour = buildTourFromData(data, getCurrentUserID(request), false);
        if (existingTour != null) {
            tour.setTourCode(existingTour.getTourCode());
            tour.setScheduleList(tourDAO.getSchedulesByTourId(existingTour.getTourID()));
        }

        if (!errors.isEmpty()) {
            forwardTourForm(
                    request,
                    response,
                    tour,
                    tour.getItineraryList(),
                    tour.getNumberOfDay() > 0 ? tour.getNumberOfDay() : 1,
                    "edit",
                    request.getContextPath() + "/staff/tour/edit",
                    "Cập nhật tour",
                    "Cập nhật tour",
                    errors
            );
            return;
        }

        boolean success = isActiveTourStatus(existingTour.getStatus())
                ? tourDAO.updateActiveTourContentOnly(tour)
                : tourDAO.updateTourWithItineraries(tour);

        response.sendRedirect(request.getContextPath()
                + "/staff/tour/detail?id=" + tour.getTourID()
                + "&message=" + (success ? "updateSuccess" : "updateFail"));
    }

    private List<TourItinerary> fillMissingItineraries(List<TourItinerary> itineraries, int dayCount) {
        java.util.Map<Integer, TourItinerary> map = buildItineraryMap(itineraries);
        java.util.List<TourItinerary> result = new java.util.ArrayList<>();

        for (int day = 1; day <= dayCount; day++) {
            TourItinerary itinerary = map.get(day);

            if (itinerary == null) {
                itinerary = new TourItinerary();
                itinerary.setDayNumber(day);
                itinerary.setStatus("Active");
            }

            result.add(itinerary);
        }

        return result;
    }


    private String firstNonBlank(String first, String second) {
        if (first != null && !first.trim().isEmpty()) {
            return first;
        }
        return second;
    }
}
