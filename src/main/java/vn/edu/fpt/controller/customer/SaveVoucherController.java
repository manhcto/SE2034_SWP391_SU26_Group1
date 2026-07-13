package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.UserVoucherDAO;
import vn.edu.fpt.DAO.VoucherDAO;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet(name = "SaveVoucherController", urlPatterns = {"/vouchers/save"})
public class SaveVoucherController extends HttpServlet {
    private static final String TYPE_ALL = "All";
    private static final String TYPE_TOUR = "Tour";
    private static final String TYPE_ACCOMMODATION = "Accommodation";

    private final VoucherDAO voucherDAO = new VoucherDAO();
    private final UserVoucherDAO userVoucherDAO = new UserVoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/vouchers");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String selectedType = resolveType(request.getParameter("type"));
        String voucherPageUrl = buildVoucherPageUrl(request, selectedType);

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", voucherPageUrl);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (user.getRoleID() != 4) {
            response.sendRedirect(buildSaveRedirect(request, selectedType, "forbidden"));
            return;
        }

        Integer voucherID = parsePositiveInt(request.getParameter("voucherID"));
        if (voucherID == null || !voucherDAO.isVoucherSaveableForCustomer(voucherID)) {
            response.sendRedirect(buildSaveRedirect(request, selectedType, "unavailable"));
            return;
        }

        int userID = user.getUserID();
        if (userVoucherDAO.isVoucherSavedByUser(userID, voucherID)) {
            response.sendRedirect(buildSaveRedirect(request, selectedType, "exists"));
            return;
        }

        boolean saved = userVoucherDAO.saveVoucher(userID, voucherID);
        if (saved) {
            response.sendRedirect(buildSaveRedirect(request, selectedType, "success"));
            return;
        }

        if (userVoucherDAO.isVoucherSavedByUser(userID, voucherID)) {
            response.sendRedirect(buildSaveRedirect(request, selectedType, "exists"));
            return;
        }

        response.sendRedirect(buildSaveRedirect(request, selectedType, "error"));
    }

    private String buildVoucherPageUrl(HttpServletRequest request, String selectedType) {
        return request.getContextPath() + "/vouchers?type=" + selectedType;
    }

    private String buildSaveRedirect(HttpServletRequest request, String selectedType, String saveStatus) {
        return buildVoucherPageUrl(request, selectedType) + "&save=" + saveStatus;
    }

    private Integer parsePositiveInt(String rawValue) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            return null;
        }

        try {
            int value = Integer.parseInt(rawValue.trim());
            return value > 0 ? value : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String resolveType(String type) {
        String value = type == null ? "" : type.trim();

        if (TYPE_TOUR.equals(value) || TYPE_ACCOMMODATION.equals(value)) {
            return value;
        }

        return TYPE_ALL;
    }
}
