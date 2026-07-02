package vn.edu.fpt.controller.tour;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.exception.BusinessException;

import java.io.IOException;

/**
 * Staff - đổi trạng thái tour thuộc phạm vi Staff.
 * - /staff/tours/submit: gửi duyệt
 * - /staff/tours/mark-sold: chuyển đã bán
 * - /staff/tours/approve: chặn route cũ để Staff không tự duyệt/mở bán
 */
@WebServlet(urlPatterns = {
        "/staff/tours/submit",
        "/staff/tours/mark-sold",
        "/staff/tours/approve"
})
public class ChangeTourStatusServlet extends BaseTourServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);

        String path = request.getServletPath();
        switch (path) {
            case "/staff/tours/submit":
                submitForApproval(request, response);
                break;
            case "/staff/tours/mark-sold":
                markSoldOut(request, response);
                break;
            case "/staff/tours/approve":
                blockStaffApprove(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void submitForApproval(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int tourID = parseInt(request.getParameter("tourID"), 0);
        if (tourID <= 0) {
            response.sendRedirect(request.getContextPath() + "/staff/tours");
            return;
        }

        try {
            tourService.submitForApproval(tourID, null);
            redirectToTourView(request, response, tourID, "success", "Đã gửi tour lên Admin chờ duyệt. Lịch khởi hành đã chuyển sang trạng thái chờ duyệt.");
        } catch (BusinessException ex) {
            redirectToTourView(request, response, tourID, "notice", ex.getMessage());
        } catch (Exception ex) {
            ex.printStackTrace();
            redirectToTourView(request, response, tourID, "errorMessage", "Không thể gửi duyệt tour. Chức năng tạo/sửa tour không bị ảnh hưởng.");
        }
    }

    private void markSoldOut(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int tourID = parseInt(request.getParameter("tourID"), 0);
        if (tourID <= 0) {
            response.sendRedirect(request.getContextPath() + "/staff/tours");
            return;
        }

        try {
            tourService.markTourSoldOut(tourID, null);
            redirectToTourView(request, response, tourID, "success", "Đã chuyển tour sang trạng thái đã bán và cập nhật trạng thái lịch khởi hành.");
        } catch (BusinessException ex) {
            redirectToTourView(request, response, tourID, "notice", ex.getMessage());
        } catch (Exception ex) {
            ex.printStackTrace();
            redirectToTourView(request, response, tourID, "errorMessage", "Không thể chuyển tour sang đã bán. Chức năng tạo/sửa tour không bị ảnh hưởng.");
        }
    }

    private void blockStaffApprove(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int tourID = parseInt(request.getParameter("tourID"), 0);
        if (tourID <= 0) {
            response.sendRedirect(request.getContextPath() + "/staff/tours");
            return;
        }

        redirectToTourView(
                request,
                response,
                tourID,
                "notice",
                "Tour đang chưa được duyệt. Hãy liên hệ với Admin để kiểm tra trước khi mở bán."
        );
    }
}
