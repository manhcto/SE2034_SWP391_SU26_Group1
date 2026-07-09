package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.VoucherDAO;
import vn.edu.fpt.model.Voucher;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "VoucherPromotionController", urlPatterns = {"/vouchers"})
public class VoucherPromotionController extends HttpServlet {
    private static final String PROMOTION_PAGE = "/views/customer/voucher-promotions.jsp";
    private static final String TYPE_ALL = "All";
    private static final String TYPE_TOUR = "Tour";
    private static final String TYPE_ACCOMMODATION = "Accommodation";

    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String selectedType = resolveType(request.getParameter("type"));
        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForCustomer();
        List<Voucher> filteredVouchers = filterByType(availableVouchers, selectedType);

        request.setAttribute("selectedType", selectedType);
        request.setAttribute("voucherList", filteredVouchers);
        request.getRequestDispatcher(PROMOTION_PAGE).forward(request, response);
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
