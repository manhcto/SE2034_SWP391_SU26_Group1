package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.VatRateDAO;
import vn.edu.fpt.model.User;
import vn.edu.fpt.model.VatRate;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminVatController", urlPatterns = "/admin/vat")
public class AdminVatController extends HttpServlet {
    private static final String SYSTEM_LEGAL_DOCUMENT = "Luật Thuế GTGT 48/2024/QH15; Nghị quyết 204/2025/QH15; Nghị định 174/2025/NĐ-CP";
    private static final int MIN_YEAR = 2025;
    private static final int MAX_YEAR = 2035;

    private VatRateDAO vatRateDAO;

    @Override
    public void init() {
        vatRateDAO = new VatRateDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        forwardVatPage(request, response, new ArrayList<>());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = normalize(request.getParameter("action"));

        if ("deactivate".equals(action)) {
            int vatRateID = parseInt(request.getParameter("vatRateID"));
            boolean success = vatRateDAO.deactivateFutureRate(vatRateID);
            response.sendRedirect(request.getContextPath() + "/admin/vat?message=" + (success ? "deactivated" : "deactivateFail"));
            return;
        }

        if (!"create".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/admin/vat?message=invalidAction");
            return;
        }

        VatRate rate = readRate(request);
        List<String> errors = validateRate(rate);
        if (!errors.isEmpty()) {
            request.setAttribute("draftVat", rate);
            forwardVatPage(request, response, errors);
            return;
        }

        User admin = (User) request.getSession().getAttribute("user");
        if (admin != null) {
            rate.setCreatedByUserID(admin.getUserID());
        }

        boolean success = vatRateDAO.insertRate(rate);
        response.sendRedirect(request.getContextPath() + "/admin/vat?message=" + (success ? "created" : "createFail"));
    }

    private void forwardVatPage(HttpServletRequest request, HttpServletResponse response, List<String> errors)
            throws ServletException, IOException {
        request.setAttribute("vatRates", vatRateDAO.getAllRates());
        request.setAttribute("currentVat", vatRateDAO.getVatPercentForDate(LocalDate.now()));
        request.setAttribute("errors", errors);
        request.setAttribute("message", normalize(request.getParameter("message")));
        request.setAttribute("todayIso", LocalDate.now().toString());
        request.setAttribute("systemLegalDocument", SYSTEM_LEGAL_DOCUMENT);
        request.setAttribute("currentYear", LocalDate.now().getYear());
        request.getRequestDispatcher("/views/admin/admin-vat-management.jsp").forward(request, response);
    }

    private VatRate readRate(HttpServletRequest request) {
        VatRate rate = new VatRate();
        Integer percent = parseInteger(request.getParameter("vatPercent"));
        Integer year = parseInteger(request.getParameter("effectiveYear"));
        Integer quarter = parseInteger(request.getParameter("effectiveQuarter"));
        LocalDate from = resolveQuarterStart(year, quarter);
        LocalDate to = resolveQuarterEnd(year, quarter);

        rate.setVatPercent(percent == null ? -1 : percent);
        if (from != null) rate.setEffectiveFrom(Date.valueOf(from));
        if (to != null) rate.setEffectiveTo(Date.valueOf(to));
        rate.setLegalDocument(SYSTEM_LEGAL_DOCUMENT);
        rate.setDescription(normalize(request.getParameter("description")));
        rate.setStatus("Active");
        requestQuarterSnapshot(request, rate, year, quarter);
        return rate;
    }

    private List<String> validateRate(VatRate rate) {
        List<String> errors = new ArrayList<>();

        if (rate.getVatPercent() < 0 || rate.getVatPercent() > 10) {
            errors.add("Thuế VAT chỉ được chọn từ 0% đến 10% theo khung thuế suất VAT đang áp dụng.");
        }
        if (rate.getEffectiveFrom() == null) {
            errors.add("Ngày bắt đầu hiệu lực là bắt buộc.");
        }
        if (rate.getEffectiveTo() == null) {
            errors.add("Ngày kết thúc hiệu lực là bắt buộc.");
        }
        if (rate.getEffectiveFrom() != null && rate.getEffectiveTo() != null) {
            LocalDate from = rate.getEffectiveFrom().toLocalDate();
            LocalDate to = rate.getEffectiveTo().toLocalDate();
            if (to.isBefore(from)) {
                errors.add("Ngày kết thúc hiệu lực không được trước ngày bắt đầu.");
            } else if (!isFullQuarter(from, to)) {
                errors.add("Thời gian hiệu lực VAT phải trọn một quý: 3 tháng, bắt đầu ngày đầu quý và kết thúc ngày cuối quý.");
            } else if (vatRateDAO.hasOverlap(from, to)) {
                errors.add("Khoảng thời gian VAT đang bị chồng lấn với một kỳ VAT Active khác.");
            }
        }
        if (rate.getDescription().length() > 1000) {
            errors.add("Ghi chú không được vượt quá 1000 ký tự.");
        }

        return errors;
    }

    private Integer parseInteger(String raw) {
        try {
            return Integer.parseInt(normalize(raw));
        } catch (Exception e) {
            return null;
        }
    }

    private int parseInt(String raw) {
        Integer value = parseInteger(raw);
        return value == null ? -1 : value;
    }

    private LocalDate resolveQuarterStart(Integer year, Integer quarter) {
        if (!isValidQuarterYear(year, quarter)) return null;
        return LocalDate.of(year, (quarter - 1) * 3 + 1, 1);
    }

    private LocalDate resolveQuarterEnd(Integer year, Integer quarter) {
        LocalDate start = resolveQuarterStart(year, quarter);
        return start == null ? null : start.plusMonths(3).minusDays(1);
    }

    private boolean isValidQuarterYear(Integer year, Integer quarter) {
        return year != null && year >= MIN_YEAR && year <= MAX_YEAR
                && quarter != null && quarter >= 1 && quarter <= 4;
    }

    private boolean isFullQuarter(LocalDate from, LocalDate to) {
        int month = from.getMonthValue();
        boolean startOfQuarter = from.getDayOfMonth() == 1 && (month == 1 || month == 4 || month == 7 || month == 10);
        return startOfQuarter && to.equals(from.plusMonths(3).minusDays(1));
    }

    private void requestQuarterSnapshot(HttpServletRequest request, VatRate rate, Integer year, Integer quarter) {
        request.setAttribute("draftVatYear", year == null ? LocalDate.now().getYear() : year);
        request.setAttribute("draftVatQuarter", quarter == null ? 1 : quarter);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
