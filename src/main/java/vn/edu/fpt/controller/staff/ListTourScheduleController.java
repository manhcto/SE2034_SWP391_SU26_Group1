package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.model.Tour;

import java.io.IOException;

@WebServlet(name = "ListTourScheduleController", urlPatterns = {"/staff/tour/schedule"})
public class ListTourScheduleController extends StaffTourScheduleSupport {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Integer tourID = parsePositiveInt(request.getParameter("tourID"));

        if (tourID == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        Tour tour = getTourForSchedule(tourID);
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        request.setAttribute("tour", tour);
        request.setAttribute("scheduleList", tour.getScheduleList());
        request.setAttribute("messageCode", safeTrim(request.getParameter("message")));
        request.setAttribute("canManageSchedule", canManageScheduleForTour(tour));
        request.setAttribute("canOpenSchedule", canOpenScheduleForTour(tour));
        request.getRequestDispatcher("/views/staff/tour-schedule-list.jsp")
                .forward(request, response);
    }
}
