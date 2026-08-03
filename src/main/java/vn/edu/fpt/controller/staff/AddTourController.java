package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourItinerary;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddTourController", urlPatterns = {"/staff/tour/add"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 25 * 1024 * 1024)
public class AddTourController extends HttpServlet {
    private static final String MODE = "add";
    private static final String PAGE_TITLE = "Thêm tour mới";
    private static final String SUBMIT_LABEL = "Lưu tour";

    private final TourDAO tourDAO = new TourDAO();
    private final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();
    private final StaffTourFormService formService =
            new StaffTourFormService(tourDAO, administrativeUnitDAO);

    /*
     * FRONT-END /staff/tour/add bang method GET di vao day.
     * Staff vua bam "Them tour" thi ham tao du lieu mac dinh va hien form add.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // GET /staff/tour/add: mo form rong hoac render lai form khi Staff doi so ngay.
        int dayCount = formService.resolveDayCountForTourForm(request, null);
        Tour tour;
        if (request.getParameter("numberOfDay") != null) {
            // Khi doi numberOfDay, doc lai data dang nhap de khong mat noi dung form.
            StaffTourFormService.FormData data = formService.collectTourFormInput(request);
            data.status = "Draft";
            tour = formService.convertFormInputToTour(data, formService.getLoggedInStaffId(request));
        } else {
            // Lan dau vao form: tao Tour Draft mac dinh de JSP co du gia tri hien thi.
            tour = formService.createDefaultDraftTour(dayCount);
        }

        showAddTourForm(request, response, tour,
                formService.buildCompleteItineraryList(tour.getItineraryList(), dayCount),
                dayCount, null);
    }

    /*
     * FRONT-END submit form AddTour bang method POST di vao day.
     * Ham doc form, validate, insert Tour; thanh cong thi redirect sang AddTourSchedule de nhap lich dau tien.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // POST /staff/tour/add: doc form multipart, validate server-side, roi moi insert DB.
        StaffTourFormService.FormData data = formService.collectTourFormInput(request);
        data.status = "Draft";
        List<String> errors = formService.validateTourFormInput(data, false);
        Tour tour = formService.convertFormInputToTour(data, formService.getLoggedInStaffId(request));

        if (!errors.isEmpty()) {
            showAddTourForm(request, response, tour, tour.getItineraryList(),
                    resolveSubmittedDayCount(tour), errors);
            return;
        }

        int newTourID = tourDAO.insertTourWithItineraries(tour);
        if (newTourID > 0) {
            // Tao tour xong phai tao lich dau tien; tour chua co lich thi chua du dieu kien gui duyet.
            response.sendRedirect(request.getContextPath()
                    + "/staff/tour/schedule/add?tourID=" + newTourID
                    + "&message=tourCreated");
            return;
        }

        errors.add("Không thể thêm tour. Hãy kiểm tra lại dữ liệu");
        showAddTourForm(request, response, tour, tour.getItineraryList(),
                resolveSubmittedDayCount(tour), errors);
    }

    /*
     * Dung khi AddTourController can hien form add tour.
     * Neu GET: hien form rong. Neu POST loi validate: quay lai form va hien loi duoi input.
     * Ham nay chuyen tiep sang StaffTourFormService.showTourFormPage().
     */
    private void showAddTourForm(HttpServletRequest request,
                                 HttpServletResponse response,
                                 Tour tour,
                                 List<TourItinerary> itineraries,
                                 int dayCount,
                                 List<String> errors)
            throws ServletException, IOException {
        formService.showTourFormPage(
                request,
                response,
                tour,
                itineraries,
                dayCount,
                MODE,
                request.getContextPath() + "/staff/tour/add",
                PAGE_TITLE,
                SUBMIT_LABEL,
                errors
        );
    }

    /*
     * Lay so ngay da submit de render lai dung so dong lich trinh khi form bi loi.
     */
    private int resolveSubmittedDayCount(Tour tour) {
        return tour.getNumberOfDay() > 0 ? tour.getNumberOfDay() : 1;
    }
}
