package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ListTourScheduleController", urlPatterns = {"/staff/tour/schedule"})
public class ListTourScheduleController extends StaffTourScheduleSupport {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        attachImportFlash(request);
        Integer tourID = parsePositiveInt(request.getParameter("tourID"));

        if (tourID == null) {
            // Khong co tourID: day la trang tong quan tat ca lich cua Staff.
            // Truoc khi hien, dong bo lai lich Open cua tour khong con Active.
            scheduleDAO.syncOpenSchedulesWithTourStatuses();
            request.setAttribute("tourList", tourDAO.getToursForStaff(null, null, null, null));
            request.setAttribute("scheduleList", scheduleDAO.getSchedulesForStaffOverview());
            request.setAttribute("messageCode", safeTrim(request.getParameter("message")));
            request.setAttribute("allSchedules", true);
            request.getRequestDispatcher("/views/staff/tour-schedule-list.jsp")
                    .forward(request, response);
            return;
        }

        // Co tourID: day la danh sach lich rieng cua mot tour, dung sau khi Staff bam icon lich.
        Tour tour = getTourForSchedule(tourID);
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        // Day them readinessErrors/duplicateStartDateMap de JSP canh bao truoc khi gui duyet.
        request.setAttribute("tour", tour);
        request.setAttribute("scheduleList", tour.getScheduleList());
        request.setAttribute("readinessErrors", tourDAO.checkTourBeforeSubmitForApproval(tourID));
        request.setAttribute("duplicateStartDateMap", scheduleDAO.getDuplicateScheduleStartDateMap(tourID));
        request.setAttribute("messageCode", safeTrim(request.getParameter("message")));
        request.setAttribute("canManageSchedule", canManageScheduleForTour(tour));
        request.setAttribute("canEditSchedule", canEditScheduleForTour(tour));
        request.setAttribute("canOpenSchedule", canOpenScheduleForTour(tour));
        request.setAttribute("allSchedules", false);
        request.getRequestDispatcher("/views/staff/tour-schedule-list.jsp")
                .forward(request, response);
    }

    private void attachImportFlash(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }

        Object insertedCount = session.getAttribute("scheduleImportInsertedCount");
        Object updatedCount = session.getAttribute("scheduleImportUpdatedCount");
        Object errorList = session.getAttribute("scheduleImportErrors");

        if (insertedCount != null || updatedCount != null || errorList != null) {
            request.setAttribute("scheduleImportInsertedCount", insertedCount == null ? 0 : insertedCount);
            request.setAttribute("scheduleImportUpdatedCount", updatedCount == null ? 0 : updatedCount);
            request.setAttribute("scheduleImportErrors", errorList);
        }

        session.removeAttribute("scheduleImportInsertedCount");
        session.removeAttribute("scheduleImportUpdatedCount");
        session.removeAttribute("scheduleImportErrors");
    }
}
