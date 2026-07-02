package vn.edu.fpt.controller.tour;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.model.TourDetailDTO;

import java.io.IOException;

/**
 * Staff - màn xem chi tiết tour.
 * Chỉ xử lý GET /staff/tours/view.
 */
@WebServlet(urlPatterns = "/staff/tours/view")
public class TourDetailServlet extends BaseTourServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);

        int tourID = parseInt(request.getParameter("id"), 0);
        if (tourID <= 0) {
            response.sendRedirect(request.getContextPath() + "/staff/tours");
            return;
        }

        try {
            TourDetailDTO tour = tourService.getTourDetail(tourID);
            if (tour == null) {
                response.sendRedirect(request.getContextPath() + "/staff/tours?error=notfound");
                return;
            }

            request.setAttribute("tour", tour);
            request.getRequestDispatcher(TOUR_VIEW_JSP).forward(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("systemError", "Không thể tải chi tiết tour.");
            loadListFiltersSafe(request);
            request.getRequestDispatcher(TOUR_LIST_JSP).forward(request, response);
        }
    }
}
