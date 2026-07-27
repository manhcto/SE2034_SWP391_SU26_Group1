package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourSchedule;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "AddTourScheduleController", urlPatterns = {"/staff/tour/schedule/add"})
public class AddTourScheduleController extends StaffTourScheduleSupport {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Integer tourID = parsePositiveInt(request.getParameter("tourID"));
        Tour tour = tourID == null ? null : getTourForSchedule(tourID);

        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }
        if (!canManageScheduleForTour(tour)) {
            response.sendRedirect(request.getContextPath() + "/staff/tour/schedule?tourID=" + tourID + "&message=noSchedulePermission");
            return;
        }

        TourSchedule schedule = buildDefaultSchedule(tour);
        request.setAttribute("messageCode", safeTrim(request.getParameter("message")));
        forwardScheduleForm(
                request,
                response,
                tour,
                schedule,
                "add",
                request.getContextPath() + "/staff/tour/schedule/add",
                "Thêm lịch khởi hành",
                "Lưu lịch",
                null
        );
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        ScheduleFormData data = readScheduleFormData(request);
        Integer tourID = parsePositiveInt(data.tourIDRaw);
        Tour tour = tourID == null ? null : getTourForSchedule(tourID);
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        List<String> errors = validateScheduleData(data, tour, null, false, false);
        TourSchedule schedule = buildScheduleFromData(data, tour, null, false);

        if (!errors.isEmpty()) {
            forwardScheduleForm(
                    request,
                    response,
                    tour,
                    schedule,
                    "add",
                    request.getContextPath() + "/staff/tour/schedule/add",
                    "Thêm lịch khởi hành",
                    "Lưu lịch",
                    errors
            );
            return;
        }

        boolean firstSchedule = tour.getScheduleList() == null || tour.getScheduleList().isEmpty();
        boolean success = tourDAO.insertTourSchedule(schedule);
        if (firstSchedule) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/tour?message=" + (success ? "scheduleAddSuccess" : "scheduleAddFail"));
            return;
        }
        response.sendRedirect(request.getContextPath()
                + "/staff/tour/detail?id=" + tour.getTourID()
                + "&message=" + (success ? "scheduleAddSuccess" : "scheduleAddFail"));
    }

    private TourSchedule buildDefaultSchedule(Tour tour) {
        TourSchedule schedule = new TourSchedule();
        schedule.setTourID(tour.getTourID());
        if (tour.getAdultPrice() != null && tour.getAdultPrice().compareTo(java.math.BigDecimal.ZERO) > 0) {
            schedule.setAdultPrice(tour.getAdultPrice());
            schedule.setChildPrice(tour.getAdultPrice().multiply(new java.math.BigDecimal("0.50")).setScale(0, java.math.RoundingMode.HALF_UP));
            schedule.setInfantPrice(java.math.BigDecimal.ZERO);
        }
        if (tour.getSingleRoomSurcharge() != null && tour.getSingleRoomSurcharge().compareTo(java.math.BigDecimal.ZERO) > 0) {
            schedule.setSingleRoomSurcharge(tour.getSingleRoomSurcharge());
        } else {
            schedule.setSingleRoomSurcharge(java.math.BigDecimal.ZERO);
        }
        schedule.setDepositPercent(0);
        schedule.setVatPercent(NO_VAT_PERCENT);
        schedule.setCancellationPolicy(DEFAULT_CANCELLATION_POLICY);
        schedule.setScheduleStatus(canOpenScheduleForTour(tour) ? "Open" : "Planned");
        schedule.setScheduleTransportType(resolveScheduleTransportType(tour, null));
        LocalDate nextStartDate = resolveNextStartDate(tour);
        schedule.setStartDate(Timestamp.valueOf(nextStartDate.atStartOfDay()));
        schedule.setEndDate(Timestamp.valueOf(nextStartDate.plusDays(Math.max(1, tour.getNumberOfDay()) - 1L).atStartOfDay()));
        int defaultSeat = getSeatOptions(schedule.getScheduleTransportType()).isEmpty() ? 0 : getSeatOptions(schedule.getScheduleTransportType()).get(0);
        schedule.setMaxParticipants(defaultSeat);
        schedule.setMinParticipants((int) Math.ceil(defaultSeat * 0.5));
        schedule.setMaxParticipantsPerBooking(Math.min(10, Math.max(1, defaultSeat)));
        return schedule;
    }

    private LocalDate resolveNextStartDate(Tour tour) {
        LocalDate today = LocalDate.now();
        LocalDate latestStartDate = null;
        if (tour != null && tour.getScheduleList() != null) {
            for (TourSchedule schedule : tour.getScheduleList()) {
                if (schedule == null || schedule.getStartDate() == null || isFinalScheduleStatus(schedule.getScheduleStatus())) {
                    continue;
                }
                LocalDate startDate = schedule.getStartDate().toLocalDateTime().toLocalDate();
                if (latestStartDate == null || startDate.isAfter(latestStartDate)) {
                    latestStartDate = startDate;
                }
            }
        }

        if (latestStartDate == null) {
            return today;
        }

        LocalDate candidate = latestStartDate.plusDays(4);
        return candidate.isBefore(today) ? today : candidate;
    }
}
