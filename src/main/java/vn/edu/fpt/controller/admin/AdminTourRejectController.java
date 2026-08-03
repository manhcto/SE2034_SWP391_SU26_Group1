package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet(name = "AdminTourRejectController", urlPatterns = "/admin/tour/reject")
public class AdminTourRejectController extends HttpServlet {

    private TourDAO tourDAO;

    @Override
    public void init() {
        tourDAO = new TourDAO();
    }

    /*
     * FRONT-END nut "Tu choi" o admin-tour-detail.jsp submit POST /admin/tour/reject vao day.
     * Ham validate ly do, sau do goi DAO doi tour Pending sang Rejected.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Form "Tu choi tour" tren admin-tour-detail.jsp gui tourID va ly do tu choi.
        int tourID = parseInt(request.getParameter("tourID"));
        String reason = request.getParameter("rejectionReason") == null ? "" : request.getParameter("rejectionReason").trim();
        User admin = (User) request.getSession().getAttribute("user");

        // Load lai tour tu DB de dam bao tour van ton tai va dung trang thai truoc khi tu choi.
        Tour tour = tourDAO.getTourById(tourID);
        if (admin == null || tour == null) {
            response.sendRedirect(request.getContextPath() + "/admin/tour?message=notFound");
            return;
        }

        // Chi tour Pending moi duoc tu choi. Tour Active/Draft/Rejected khong di qua flow nay.
        if (!"Pending".equals(tour.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID + "&message=invalidStatus");
            return;
        }

        // Ly do phai du ro de Staff biet can sua gi khi tour quay ve Rejected.
        if (reason.length() < 10 || reason.length() > 500) {
            response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID + "&message=rejectReasonInvalid");
            return;
        }

        // DAO update status = Rejected va luu rejectionReason vao bang Tour.
        boolean success = tourDAO.rejectPendingTour(tourID, admin.getUserID(), reason);
        response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID
                + "&message=" + (success ? "rejected" : "rejectFail"));
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return -1;
        }
    }
}
