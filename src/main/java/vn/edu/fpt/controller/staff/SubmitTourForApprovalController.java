package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SubmitTourForApprovalController", urlPatterns = "/staff/tour/submit")
public class SubmitTourForApprovalController extends HttpServlet {

    /*
     * STAFF FLOW - SUBMIT TOUR FOR APPROVAL
     * Nut "Gui duyet" o tour-detail.jsp submit POST /staff/tour/submit.
     * Controller chi nhan tourID, sau do kiem tra:
     * - Tour co ton tai khong.
     * - Tour co o trang thai Draft/Rejected khong.
     * - Tour da du thong tin, anh, itinerary, schedule, gia, so ghe chua.
     * Neu dat dieu kien thi doi status thanh Pending de Admin duyet.
     */
    private TourDAO tourDAO;

    @Override
    public void init() {
        tourDAO = new TourDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // tourID den tu hidden input trong form Gui duyet o trang chi tiet tour.
        int tourID = parseInt(request.getParameter("tourID"));
        Tour tour = tourDAO.getTourById(tourID);

        if (tour == null) {
            // ID sai hoac tour da bi xoa: dua Staff ve danh sach tour.
            response.sendRedirect(request.getContextPath() + "/staff/tour?message=notFound");
            return;
        }

        if (!("Draft".equals(tour.getStatus()) || "Rejected".equals(tour.getStatus()))) {
            // Chi tour Nhap hoac Bi tu choi moi duoc gui duyet.
            response.sendRedirect(request.getContextPath() + "/staff/tour/detail?id=" + tourID + "&message=submitInvalidStatus");
            return;
        }

        // Kiem tra cac dieu kien truoc khi gui Admin: thong tin tour, lich, gia, trung ngay...
        List<String> errors = tourDAO.checkTourBeforeSubmitForApproval(tourID);
        if (!errors.isEmpty()) {
            // Chua du dieu kien thi quay ve detail de hien danh sach can sua.
            response.sendRedirect(request.getContextPath() + "/staff/tour/detail?id=" + tourID + "&message=submitNotReady");
            return;
        }

        // Du dieu kien thi cap nhat status sang Pending/Cho duyet.
        boolean success = tourDAO.markTourAsPendingApproval(tourID);
        response.sendRedirect(request.getContextPath() + "/staff/tour/detail?id=" + tourID
                + "&message=" + (success ? "submitted" : "submitFail"));
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            // Tra -1 de getTourById(-1) khong tim thay va chay vao nhanh notFound.
            return -1;
        }
    }
}
