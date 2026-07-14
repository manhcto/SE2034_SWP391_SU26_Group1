package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.VoucherDAO;
import vn.edu.fpt.model.Voucher;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/staff/voucher", "/admin/voucher"})
public class ManageVoucherController extends HttpServlet {
    private static final String VOUCHER_MANAGEMENT_PAGE = "/views/staff/voucher-management.jsp";
    private static final BigDecimal ONE_HUNDRED = new BigDecimal("100");

    private VoucherDAO voucherDAO;

    @Override
    public void init() {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = normalize(request.getParameter("action"));

        if ("edit".equals(action) && !isAdminRequest(request)) {
            showEditVoucherForm(request, response);
            return;
        }

        showVoucherList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = normalize(request.getParameter("action"));

        if (isAdminRequest(request)) {
            if ("approve".equals(action)) {
                approveVoucher(request, response);
                return;
            }

            response.sendRedirect(resolveManagementPath(request));
            return;
        }

        if ("insert".equals(action)) {
            insertVoucher(request, response);
            return;
        }

        if ("update".equals(action)) {
            updateVoucher(request, response);
            return;
        }

        response.sendRedirect(resolveManagementPath(request));
    }

    private void showVoucherList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("voucherList", voucherDAO.getAllVouchers());
        request.setAttribute("voucherManagementPath", resolveManagementPath(request));
        request.setAttribute("voucherManagementRole", isAdminRequest(request) ? "admin" : "staff");
        request.setAttribute("voucherManagementReadOnly", isAdminRequest(request));
        request.getRequestDispatcher(VOUCHER_MANAGEMENT_PAGE).forward(request, response);
    }

    private void showEditVoucherForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();
        Integer voucherID = parseVoucherID(request.getParameter("voucherID"), errors);

        if (voucherID == null) {
            request.setAttribute("errors", errors);
            showVoucherList(request, response);
            return;
        }

        Voucher editVoucher = voucherDAO.getVoucherById(voucherID);

        if (editVoucher == null) {
            errors.add("Voucher không tồn tại.");
            request.setAttribute("errors", errors);
            showVoucherList(request, response);
            return;
        }

        request.setAttribute("editMode", true);
        request.setAttribute("editVoucher", editVoucher);
        showVoucherList(request, response);
    }

    private void insertVoucher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();
        Voucher voucher = buildVoucherFromRequest(request, errors, null, null);

        if (voucher != null) {
            voucher.setStatus("Inactive");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("submittedForm", true);
            showVoucherList(request, response);
            return;
        }

        boolean inserted = voucherDAO.insertVoucher(voucher);

        if (!inserted) {
            errors.add("Không thể thêm Voucher. Vui lòng kiểm tra thông tin và thử lại.");
            request.setAttribute("errors", errors);
            request.setAttribute("submittedForm", true);
            showVoucherList(request, response);
            return;
        }

        response.sendRedirect(resolveManagementPath(request) + "?success=insert");
    }

    private void updateVoucher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();
        Integer voucherID = parseVoucherID(request.getParameter("voucherID"), errors);
        Voucher existingVoucher = null;

        if (voucherID != null) {
            existingVoucher = voucherDAO.getVoucherById(voucherID);
            if (existingVoucher == null) {
                errors.add("Voucher không tồn tại.");
            }
        }

        Voucher voucher = null;
        if (voucherID != null && existingVoucher != null) {
            voucher = buildVoucherFromRequest(request, errors, voucherID, existingVoucher.getUsedCount());
            if (voucher != null) {
                voucher.setStatus("Inactive");
            }
        }

        if (!errors.isEmpty() || voucher == null) {
            request.setAttribute("errors", errors);
            prepareEditErrorView(request, existingVoucher);
            showVoucherList(request, response);
            return;
        }

        boolean updated = voucherDAO.updateVoucher(voucher);

        if (!updated) {
            errors.add("Không thể cập nhật Voucher. Vui lòng kiểm tra thông tin và thử lại.");
            request.setAttribute("errors", errors);
            prepareEditErrorView(request, existingVoucher);
            showVoucherList(request, response);
            return;
        }

        response.sendRedirect(resolveManagementPath(request) + "?success=update");
    }

    private void approveVoucher(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<String> errors = new ArrayList<>();
        Integer voucherID = parseVoucherID(request.getParameter("voucherID"), errors);
        boolean approved = voucherID != null && voucherDAO.approveVoucher(voucherID);
        response.sendRedirect(resolveManagementPath(request)
                + "?success=" + (approved ? "approve" : "approve_error"));
    }

    private void prepareEditErrorView(HttpServletRequest request, Voucher editVoucher) {
        request.setAttribute("editMode", true);
        request.setAttribute("submittedForm", true);

        if (editVoucher != null) {
            request.setAttribute("editVoucher", editVoucher);
        }
    }

    private Voucher buildVoucherFromRequest(HttpServletRequest request,
                                            List<String> errors,
                                            Integer voucherID,
                                            Integer currentUsedCount) {
        String code = normalize(request.getParameter("code"));
        String description = normalize(request.getParameter("description"));
        String status = normalize(request.getParameter("status"));
        String applicableType = normalize(request.getParameter("applicableType"));
        BigDecimal percentDiscount = parseOptionalDecimal(
                request.getParameter("percentDiscount"), "Phần trăm giảm giá", errors);
        BigDecimal amountDiscount = parseOptionalDecimal(
                request.getParameter("amountDiscount"), "Số tiền giảm giá", errors);
        BigDecimal minOrderAmount = parseOptionalDecimal(
                request.getParameter("minOrderAmount"), "Giá trị đơn hàng tối thiểu", errors);
        Integer quantity = parseQuantity(request.getParameter("quantity"), errors);
        LocalDate startDate = parseRequiredDate(request.getParameter("startDate"), "Ngày bắt đầu", errors);
        LocalDate endDate = parseRequiredDate(request.getParameter("endDate"), "Ngày kết thúc", errors);

        validateCode(code, voucherID, errors);
        validateDescription(description, errors);
        validateDiscounts(percentDiscount, amountDiscount, errors);
        validateMinOrderAmount(minOrderAmount, errors);
        validateQuantity(quantity, 1, errors);
        validateQuantityAgainstUsedCount(quantity, currentUsedCount, errors);
        validateDates(startDate, endDate, errors);
        validateStatus(status, errors);
        validateApplicableType(applicableType, errors);

        if (!errors.isEmpty()) {
            return null;
        }

        Voucher voucher = new Voucher();
        if (voucherID != null) {
            voucher.setVoucherID(voucherID);
        }
        voucher.setCode(code);
        voucher.setDescription(description);
        voucher.setPercentDiscount(percentDiscount);
        voucher.setAmountDiscount(amountDiscount);
        voucher.setMinOrderAmount(minOrderAmount);
        voucher.setQuantity(quantity);
        voucher.setApplicableType(applicableType);
        voucher.setUsedCount(currentUsedCount == null ? 0 : currentUsedCount);
        voucher.setStartDate(Timestamp.valueOf(startDate.atStartOfDay()));
        voucher.setEndDate(Timestamp.valueOf(endDate.atTime(LocalTime.of(23, 59, 59))));
        voucher.setStatus(status);

        return voucher;
    }

    private void validateCode(String code, Integer voucherID, List<String> errors) {
        if (code.isEmpty()) {
            errors.add("Mã Voucher không được để trống.");
            return;
        }

        if (code.length() > 50) {
            errors.add("Mã Voucher không được vượt quá 50 ký tự.");
            return;
        }

        if (!code.matches("^[A-Z0-9]+$")) {
            errors.add("Mã Voucher chỉ được chứa chữ cái in hoa và chữ số.");
            return;
        }

        if (voucherID == null && voucherDAO.isCodeExists(code)) {
            errors.add("Mã Voucher đã tồn tại.");
        }

        if (voucherID != null && voucherDAO.isCodeExistsExceptId(code, voucherID)) {
            errors.add("Mã Voucher không được trùng Voucher khác.");
        }
    }

    private void validateDescription(String description, List<String> errors) {
        if (description.length() > 500) {
            errors.add("Mô tả không được vượt quá 500 ký tự.");
        }
    }

    private void validateDiscounts(BigDecimal percentDiscount,
                                   BigDecimal amountDiscount,
                                   List<String> errors) {

        boolean hasPercent = percentDiscount != null && percentDiscount.compareTo(BigDecimal.ZERO) > 0;
        boolean hasAmount = amountDiscount != null && amountDiscount.compareTo(BigDecimal.ZERO) > 0;

        if (percentDiscount != null
                && (percentDiscount.compareTo(BigDecimal.ONE) < 0
                || percentDiscount.compareTo(ONE_HUNDRED) > 0)) {
            errors.add("Phần trăm giảm giá phải từ 1 đến 100.");
        }

        if (amountDiscount != null && amountDiscount.compareTo(BigDecimal.ZERO) <= 0) {
            errors.add("Số tiền giảm giá phải lớn hơn 0.");
        }

        if (hasPercent && hasAmount) {
            errors.add("Chỉ được chọn một loại giảm giá: phần trăm hoặc số tiền cố định.");
        }

        if (!hasPercent && !hasAmount) {
            errors.add("Vui lòng nhập một loại giảm giá.");
        }
    }

    private void validateMinOrderAmount(BigDecimal minOrderAmount, List<String> errors) {
        if (minOrderAmount != null && minOrderAmount.compareTo(BigDecimal.ZERO) < 0) {
            errors.add("Giá trị đơn hàng tối thiểu không được âm.");
        }
    }

    private void validateQuantity(Integer quantity, int minimumQuantity, List<String> errors) {
        if (quantity == null) {
            return;
        }

        if (quantity < minimumQuantity) {
            if (minimumQuantity == 0) {
                errors.add("Số lượng phải lớn hơn hoặc bằng 0.");
                return;
            }

            errors.add("Số lượng phải lớn hơn hoặc bằng 1.");
        }
    }

    private void validateQuantityAgainstUsedCount(Integer quantity, Integer currentUsedCount, List<String> errors) {
        if (quantity == null || currentUsedCount == null) {
            return;
        }

        if (quantity < currentUsedCount) {
            errors.add("Tổng số lượt sử dụng không được nhỏ hơn số lượt đã được sử dụng.");
        }
    }

    private void validateDates(LocalDate startDate, LocalDate endDate, List<String> errors) {
        if (startDate == null || endDate == null) {
            return;
        }

        if (endDate.isBefore(startDate)) {
            errors.add("Ngày kết thúc không được trước ngày bắt đầu.");
        }
    }

    private void validateStatus(String status, List<String> errors) {
        if (!"Active".equals(status) && !"Inactive".equals(status)) {
            errors.add("Trạng thái không hợp lệ.");
        }
    }

    private void validateApplicableType(String applicableType, List<String> errors) {
        if (!"All".equals(applicableType)
                && !"Tour".equals(applicableType)
                && !"Accommodation".equals(applicableType)) {
            errors.add("Phạm vi áp dụng không hợp lệ.");
        }
    }

    private BigDecimal parseOptionalDecimal(String rawValue, String label, List<String> errors) {
        String value = normalize(rawValue);

        if (value.isEmpty()) {
            return null;
        }

        try {
            return new BigDecimal(value);
        } catch (NumberFormatException e) {
            errors.add(label + " phải là số hợp lệ.");
            return null;
        }
    }

    private Integer parseQuantity(String rawValue, List<String> errors) {
        String value = normalize(rawValue);

        if (value.isEmpty()) {
            errors.add("Số lượng không được để trống.");
            return null;
        }

        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            errors.add("Số lượng phải là số nguyên.");
            return null;
        }
    }

    private LocalDate parseRequiredDate(String rawValue, String label, List<String> errors) {
        String value = normalize(rawValue);

        if (value.isEmpty()) {
            errors.add(label + " không được để trống.");
            return null;
        }

        try {
            return LocalDate.parse(value);
        } catch (DateTimeParseException e) {
            errors.add(label + " không hợp lệ.");
            return null;
        }
    }

    private Integer parseVoucherID(String rawValue, List<String> errors) {
        String value = normalize(rawValue);

        if (value.isEmpty()) {
            errors.add("Voucher không tồn tại.");
            return null;
        }

        try {
            int voucherID = Integer.parseInt(value);

            if (voucherID <= 0) {
                errors.add("Voucher không tồn tại.");
                return null;
            }

            return voucherID;
        } catch (NumberFormatException e) {
            errors.add("Voucher không tồn tại.");
            return null;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isAdminRequest(HttpServletRequest request) {
        return request.getServletPath() != null && request.getServletPath().startsWith("/admin/");
    }

    private String resolveManagementPath(HttpServletRequest request) {
        return request.getContextPath() + (isAdminRequest(request) ? "/admin/voucher" : "/staff/voucher");
    }
}
