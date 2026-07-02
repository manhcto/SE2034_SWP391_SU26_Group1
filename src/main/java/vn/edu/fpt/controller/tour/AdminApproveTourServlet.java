package vn.edu.fpt.controller.tour;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.exception.BusinessException;

import java.io.IOException;

/**
 * Admin - duyệt tour và mở bán.
 * Khi có login/phân quyền thật, thêm kiểm tra quyền Admin ở đây hoặc filter riêng.
 */
@WebServlet(urlPatterns = "/admin/tours/approve")
public class AdminApproveTourServlet extends BaseTourServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);

        int tourID = parseInt(request.getParameter("tourID"), 0);
        if (tourID <= 0) {
            response.sendRedirect(request.getContextPath() + "/staff/tours");
            return;
        }

        try {
            tourService.approveTour(tourID, null);
            redirectToTourView(request, response, tourID, "success", "Admin đã duyệt tour. Tour chuyển sang Đang bán và lịch khởi hành đã mở bán.");
        } catch (BusinessException ex) {
            redirectToTourView(request, response, tourID, "notice", ex.getMessage());
        } catch (Exception ex) {
            ex.printStackTrace();
            redirectToTourView(request, response, tourID, "errorMessage", "Admin chưa duyệt được tour do lỗi dữ liệu hoặc database.");
        }
    }
}
