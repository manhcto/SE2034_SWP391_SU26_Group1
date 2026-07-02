package vn.edu.fpt.controller.tour;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.exception.BusinessException;
import vn.edu.fpt.exception.FieldValidationException;
import vn.edu.fpt.model.TourCreateRequest;

import java.io.IOException;

/**
 * Staff - tạo tour mới.
 * GET mở form, POST xử lý form tạo tour.
 */
@WebServlet(urlPatterns = "/staff/tours/create")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5L * 1024 * 1024,
        maxRequestSize = 40L * 1024 * 1024
)
public class CreateTourServlet extends BaseTourServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);
        forwardCreate(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);

        TourCreateRequest createRequest = buildTourRequest(request);
        try {
            applyUploadedImages(request, getServletContext(), createRequest);
            int tourID = tourService.createTour(createRequest, null);
            redirectToTourView(request, response, tourID, "success", "Tạo tour thành công.");
        } catch (FieldValidationException ex) {
            request.setAttribute("fieldErrors", ex.getFieldErrors());
            request.setAttribute("old", createRequest);
            request.setAttribute("systemError", "Dữ liệu chưa hợp lệ. Vui lòng kiểm tra các trường được đánh dấu bên dưới.");
            forwardCreate(request, response);
        } catch (BusinessException ex) {
            request.setAttribute("systemError", ex.getMessage());
            request.setAttribute("old", createRequest);
            forwardCreate(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("systemError", "Không thể tạo tour. Vui lòng kiểm tra dữ liệu nhập hoặc database.");
            request.setAttribute("old", createRequest);
            forwardCreate(request, response);
        }
    }
}
