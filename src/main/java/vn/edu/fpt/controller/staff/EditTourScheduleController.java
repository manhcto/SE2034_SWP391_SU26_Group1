package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourSchedule;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EditTourScheduleController", urlPatterns = {"/staff/tour/schedule/edit"})
public class EditTourScheduleController extends StaffTourScheduleSupport {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Integer scheduleID = parsePositiveInt(request.getParameter("id"));
        TourSchedule schedule = scheduleID == null ? null : tourDAO.getScheduleById(scheduleID);

        if (schedule == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        Tour tour = getTourForSchedule(schedule.getTourID());
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        alignScheduleStatusForTour(tour, schedule);

        if (!canEditScheduleForTour(tour) || isFinalScheduleStatus(schedule.getScheduleStatus())) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/tour/schedule/detail?id=" + scheduleID
                    + "&message=noScheduleEditPermission");
            return;
        }

        forwardScheduleForm(
                request,
                response,
                tour,
                schedule,
                "edit",
                request.getContextPath() + "/staff/tour/schedule/edit",
                "Cập nhật lịch khởi hành",
                "Cập nhật lịch",
                null
        );
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        ScheduleFormData data = readScheduleFormData(request);
        Integer scheduleID = parsePositiveInt(data.tourScheduleIDRaw);
        TourSchedule existingSchedule = scheduleID == null ? null : tourDAO.getScheduleById(scheduleID);
        Tour tour = existingSchedule == null ? null : getTourForSchedule(existingSchedule.getTourID());
        if (existingSchedule == null || tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }
        alignScheduleStatusForTour(tour, existingSchedule);
        boolean lockedCore = Math.max(existingSchedule.getQuantity(), existingSchedule.getBookedSeats()) > 0;

        if (!canEditScheduleForTour(tour) || isFinalScheduleStatus(existingSchedule.getScheduleStatus())) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/tour/schedule/detail?id=" + scheduleID
                    + "&message=noScheduleEditPermission");
            return;
        }

        if (existingSchedule != null) {
            data.tourIDRaw = String.valueOf(existingSchedule.getTourID());
            if (lockedCore) {
                data.startDateRaw = existingSchedule.getStartDate() == null ? null : existingSchedule.getStartDate().toLocalDateTime().toLocalDate().toString();
                data.endDateRaw = existingSchedule.getEndDate() == null ? null : existingSchedule.getEndDate().toLocalDateTime().toLocalDate().toString();
                data.scheduleTransportType = resolveScheduleTransportType(tour, existingSchedule.getScheduleTransportType());
                data.adultPriceRaw = existingSchedule.getAdultPrice() == null ? "0" : existingSchedule.getAdultPrice().toPlainString();
                data.singleRoomSurchargeRaw = existingSchedule.getSingleRoomSurcharge() == null ? "0" : existingSchedule.getSingleRoomSurcharge().toPlainString();
            }
        }

        List<String> errors = validateScheduleData(data, tour, existingSchedule, true, lockedCore);
        TourSchedule schedule = buildScheduleFromData(data, tour, existingSchedule, lockedCore);

        if (!errors.isEmpty()) {
            forwardScheduleForm(
                    request,
                    response,
                    tour,
                    schedule,
                    "edit",
                    request.getContextPath() + "/staff/tour/schedule/edit",
                    "Cập nhật lịch khởi hành",
                    "Cập nhật lịch",
                    errors
            );
            return;
        }

        boolean success = lockedCore
                ? tourDAO.updateTourScheduleLimited(schedule)
                : tourDAO.updateTourSchedule(schedule);

        response.sendRedirect(request.getContextPath()
                + "/staff/tour/schedule/detail?id=" + schedule.getTourScheduleID()
                + "&message=" + (success ? "scheduleUpdateSuccess" : "scheduleUpdateFail"));
    }
}
