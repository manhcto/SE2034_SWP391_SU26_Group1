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
import vn.edu.fpt.model.Voucher;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

@WebServlet(name = "VoucherPromotionController", urlPatterns = {"/vouchers"})
public class VoucherPromotionController extends HttpServlet {
    private static final String PROMOTION_PAGE = "/views/customer/voucher-promotions.jsp";
    private static final String TYPE_ALL = "All";
    private static final String TYPE_TOUR = "Tour";
    private static final String TYPE_ACCOMMODATION = "Accommodation";

    private final VoucherDAO voucherDAO = new VoucherDAO();
    private final UserVoucherDAO userVoucherDAO = new UserVoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String selectedType = resolveType(request.getParameter("type"));
        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForCustomer();
        List<Voucher> filteredVouchers = filterByType(availableVouchers, selectedType);
        Set<Integer> savedVoucherIds = getSavedVoucherIds(request);

        request.setAttribute("selectedType", selectedType);
        request.setAttribute("voucherList", filteredVouchers);
        request.setAttribute("savedVoucherIds", savedVoucherIds);
        request.getRequestDispatcher(PROMOTION_PAGE).forward(request, response);
    }

    private Set<Integer> getSavedVoucherIds(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null || user.getRoleID() != 4) {
            return Collections.emptySet();
        }

        return userVoucherDAO.getSavedVoucherIdsByUser(user.getUserID());
    }

    private List<Voucher> filterByType(List<Voucher> vouchers, String selectedType) {
        if (TYPE_ALL.equals(selectedType)) {
            return vouchers;
        }

        List<Voucher> filteredVouchers = new ArrayList<>();
        for (Voucher voucher : vouchers) {
            String applicableType = resolveType(voucher.getApplicableType());
            if (TYPE_ALL.equals(applicableType) || selectedType.equals(applicableType)) {
                filteredVouchers.add(voucher);
            }
        }

        return filteredVouchers;
    }

    private String resolveType(String type) {
        String value = type == null ? "" : type.trim();

        if (TYPE_TOUR.equals(value) || TYPE_ACCOMMODATION.equals(value)) {
            return value;
        }

        return TYPE_ALL;
    }
}
