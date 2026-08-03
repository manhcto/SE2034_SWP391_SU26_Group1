package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourItinerary;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EditTourController", urlPatterns = {"/staff/tour/edit"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 25 * 1024 * 1024)
public class EditTourController extends HttpServlet {
    private static final String MODE = "edit";
    private static final String PAGE_TITLE = "C\u1EADp nh\u1EADt tour";
    private static final String SUBMIT_LABEL = "C\u1EADp nh\u1EADt tour";

    private final TourDAO tourDAO = new TourDAO();
    private final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();
    private final StaffTourFormService formService =
            new StaffTourFormService(tourDAO, administrativeUnitDAO);

    /*
     * FRONT-END /staff/tour/edit?id=... bang GET di vao day.
     * Ham load tour cu tu DB, kiem tra trang thai co duoc sua khong, roi hien form edit.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // id/tourID deu tro ve cung tour can sua, tuy link tu man hinh nao gui sang.
        Integer tourID = formService.parsePositiveInt(
                firstNonBlank(request.getParameter("id"), request.getParameter("tourID")));
        Tour tour = tourID == null ? null : tourDAO.getTourById(tourID);
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        // Kiem tra trang thai truoc khi mo form edit.
        // Draft/Rejected sua du; Pending/Active bi khoa mot phan theo rule nghiep vu.
        if (!formService.canStaffEditTour(tour.getStatus())) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/tour/detail?id=" + tourID
                    + "&message=noEditPermission");
            return;
        }

        // Load du lieu phu de form edit hien lich trinh ngay va anh da upload.
        List<TourItinerary> itineraries = tourDAO.getItinerariesByTourId(tourID);
        tour.setItineraryList(itineraries);
        tourDAO.loadManagedImages(tour);

        // Tour da khoa gia/lich thi khong cho doi so ngay, vi doi so ngay se lam lech lich trinh.
        int dayCount = formService.isCoreTourInfoLocked(tour.getStatus())
                ? formService.limitDayCountToAllowedRange(tour.getNumberOfDay())
                : formService.resolveDayCountForTourForm(request, tour);
        List<TourItinerary> formItineraries = itineraries;

        if (request.getParameter("numberOfDay") != null) {
            // Staff doi so ngay tren form: giu du lieu vua nhap nhung van ton trong cac truong dang bi khoa.
            StaffTourFormService.FormData data = formService.collectTourFormInput(request);
            data.status = tour.getStatus();
            if (formService.isTourAlreadySelling(tour.getStatus())) {
                formService.keepOnlyFieldsAllowedForActiveTour(data, tour);
            } else if (formService.isCoreTourInfoLocked(tour.getStatus())) {
                formService.keepLockedCoreFieldsFromDatabase(data, tour);
            }
            Tour submittedTour = formService.convertFormInputToTour(data, formService.getLoggedInStaffId(request));
            submittedTour.setTourCode(tour.getTourCode());
            tour = submittedTour;
            formItineraries = submittedTour.getItineraryList();
        }

        showEditTourForm(request, response, tour,
                formService.buildCompleteItineraryList(formItineraries, dayCount),
                dayCount, null);
    }

    /*
     * FRONT-END submit form EditTour bang POST di vao day.
     * Ham load tour cu, khoa cac truong khong duoc sua theo status, validate roi update DB.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // POST edit luon load lai tour cu truoc, vi status cu quyet dinh truong nao duoc phep sua.
        StaffTourFormService.FormData data = formService.collectTourFormInput(request);
        Integer tourID = formService.parsePositiveInt(data.tourIDRaw);
        Tour existingTour = tourID == null ? null : tourDAO.getTourById(tourID);

        if (existingTour != null) {
            existingTour.setItineraryList(tourDAO.getItinerariesByTourId(existingTour.getTourID()));
            tourDAO.loadManagedImages(existingTour);
            data.status = existingTour.getStatus();

            // Active: chi giu phan duoc sua nhe; cac truong loi nhu gia, tuyen, so ngay lay lai tu DB.
            if (formService.isTourAlreadySelling(existingTour.getStatus())) {
                formService.keepOnlyFieldsAllowedForActiveTour(data, existingTour);
            }
            if (!formService.isTourAlreadySelling(existingTour.getStatus())
                    && formService.isCoreTourInfoLocked(existingTour.getStatus())) {
                formService.keepLockedCoreFieldsFromDatabase(data, existingTour);
            }
        }

        List<String> errors = formService.validateTourFormInput(data, true);
        if (tourID == null || existingTour == null) {
            errors.add("Tour c\u1EA7n c\u1EADp nh\u1EADt kh\u00F4ng t\u1ED3n t\u1EA1i.");
        } else if (!formService.canStaffEditTour(existingTour.getStatus())) {
            errors.add("Tour \u1EDF tr\u1EA1ng th\u00E1i hi\u1EC7n t\u1EA1i kh\u00F4ng \u0111\u01B0\u1EE3c s\u1EEDa.");
        }

        Tour tour = formService.convertFormInputToTour(data, formService.getLoggedInStaffId(request));
        if (existingTour != null) {
            // tourCode khong lay tu form de tranh Staff sua ma tour.
            tour.setTourCode(existingTour.getTourCode());
        }

        if (!errors.isEmpty()) {
            showEditTourForm(request, response, tour, tour.getItineraryList(),
                    tour.getNumberOfDay() > 0 ? tour.getNumberOfDay() : 1, errors);
            return;
        }

        // Active chi update noi dung nhe/anh; cac trang thai con lai update tour + itinerary.
        boolean success = formService.isTourAlreadySelling(existingTour.getStatus())
                ? tourDAO.updateActiveTourContentOnly(tour)
                : tourDAO.updateTourWithItineraries(tour);

        response.sendRedirect(request.getContextPath()
                + "/staff/tour/detail?id=" + tour.getTourID()
                + "&message=" + (success ? "updateSuccess" : "updateFail"));
    }

    /*
     * Dung khi EditTourController can hien form edit.
     * GET se load tour tu DB roi forward vao JSP.
     * POST neu validate loi se forward lai JSP voi danh sach errors/fieldErrors.
     */
    private void showEditTourForm(HttpServletRequest request,
                                  HttpServletResponse response,
                                  Tour tour,
                                  List<TourItinerary> itineraries,
                                  int dayCount,
                                  List<String> errors)
            throws ServletException, IOException {
        formService.showTourFormPage(
                request,
                response,
                tour,
                itineraries,
                dayCount,
                MODE,
                request.getContextPath() + "/staff/tour/edit",
                PAGE_TITLE,
                SUBMIT_LABEL,
                errors
        );
    }

    private String firstNonBlank(String first, String second) {
        return first != null && !first.trim().isEmpty() ? first : second;
    }
}
