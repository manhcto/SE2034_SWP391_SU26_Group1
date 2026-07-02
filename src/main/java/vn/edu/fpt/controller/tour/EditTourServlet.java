package vn.edu.fpt.controller.tour;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.exception.BusinessException;
import vn.edu.fpt.exception.FieldValidationException;
import vn.edu.fpt.model.TourCreateRequest;
import vn.edu.fpt.model.TourDetailDTO;

import java.io.IOException;

/**
 * Staff - sửa tour.
 * Draft/Rejected sửa toàn bộ; Selling/Approved chỉ sửa lịch khởi hành & giá.
 */
@WebServlet(urlPatterns = "/staff/tours/edit")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5L * 1024 * 1024,
        maxRequestSize = 40L * 1024 * 1024
)
public class EditTourServlet extends BaseTourServlet {
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
            request.setAttribute("old", toRequest(tour));
            loadTourLookupsSafe(request);
            request.getRequestDispatcher(TOUR_EDIT_JSP).forward(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            redirectToTourView(request, response, tourID, "errorMessage", "Không thể mở màn sửa tour.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);

        int tourID = parseInt(request.getParameter("tourID"), 0);
        if (tourID <= 0) {
            response.sendRedirect(request.getContextPath() + "/staff/tours");
            return;
        }

        TourCreateRequest updateRequest = buildTourRequest(request);
        try {
            applyUploadedImages(request, getServletContext(), updateRequest);
            tourService.updateTour(tourID, updateRequest, null);
            redirectToTourView(request, response, tourID, "success", "Cập nhật tour thành công.");
        } catch (FieldValidationException ex) {
            System.out.println("EDIT TOUR FIELD ERRORS = " + ex.getFieldErrors());
            request.setAttribute("fieldErrors", ex.getFieldErrors());
            request.setAttribute("old", updateRequest);
            forwardEdit(request, response, tourID);
        } catch (BusinessException ex) {
            request.setAttribute("systemError", ex.getMessage());
            request.setAttribute("old", updateRequest);
            forwardEdit(request, response, tourID);
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("systemError", "Không thể cập nhật tour. Lỗi này chỉ ảnh hưởng thao tác sửa tour.");
            request.setAttribute("old", updateRequest);
            forwardEdit(request, response, tourID);
        }
    }
}
