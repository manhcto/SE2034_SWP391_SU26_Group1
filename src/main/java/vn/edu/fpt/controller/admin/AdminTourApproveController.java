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
import java.util.List;

@WebServlet(name = "AdminTourApproveController", urlPatterns = "/admin/tour/approve")
public class AdminTourApproveController extends HttpServlet {

    private TourDAO tourDAO;

    @Override
    public void init() {
        tourDAO = new TourDAO();
    }

    /*
     * FRONT-END nut "Duyet tour" o admin-tour-detail.jsp submit POST /admin/tour/approve vao day.
     * Ham kiem tra tour Pending va checklist hop le, sau do goi DAO doi tour sang Active.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Form "Duyet tour" tren admin-tour-detail.jsp chi gui tourID va checkbox openSchedules.
        int tourID = parseInt(request.getParameter("tourID"));
        User admin = (User) request.getSession().getAttribute("user");

        // Luon load lai tour tu DB, khong tin vao du lieu hien tren JSP, de tranh duyet nham tour da thay doi.
        Tour tour = tourDAO.getTourById(tourID);
        if (admin == null || tour == null) {
            response.sendRedirect(request.getContextPath() + "/admin/tour?message=notFound");
            return;
        }

        // Chi tour Pending moi la tour Staff da gui duyet va dang cho Admin xu ly.
        if (!"Pending".equals(tour.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID + "&message=invalidStatus");
            return;
        }

        // Kiem tra lai dieu kien ngay tai backend truoc khi update DB.
        // Neu co loi, admin-tour-detail.jsp se hien canh bao de Staff/Admin sua.
        List<String> errors = tourDAO.checkTourBeforeSubmitForApproval(tourID);
        if (!errors.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID + "&message=notReady");
            return;
        }

        // openSchedules=true nghia la khi tour duoc Active, cac lich Planned hop le se mo ban thanh Open.
        boolean openSchedules = "on".equalsIgnoreCase(request.getParameter("openSchedules"))
                || "true".equalsIgnoreCase(request.getParameter("openSchedules"));
        boolean success = tourDAO.approvePendingTour(tourID, admin.getUserID(), openSchedules);
        response.sendRedirect(request.getContextPath() + "/admin/tour/detail?id=" + tourID
                + "&message=" + (success ? "approved" : "approveFail"));
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            return -1;
        }
    }
}
