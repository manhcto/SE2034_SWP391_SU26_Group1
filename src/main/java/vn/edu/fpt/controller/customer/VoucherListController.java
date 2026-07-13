package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.UserVoucherDAO;
import vn.edu.fpt.model.MyVoucherView;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "VoucherListController", urlPatterns = {"/my-vouchers"})
public class VoucherListController extends HttpServlet {
    private static final String STATUS_AVAILABLE = "available";
    private static final String STATUS_USED = "used";
    private static final String STATUS_UNAVAILABLE = "unavailable";

    private final UserVoucherDAO userVoucherDAO = new UserVoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", currentPathWithQuery(request));
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (user.getRoleID() != 4) {
            response.sendRedirect(request.getContextPath() + "/vouchers");
            return;
        }

        String currentStatus = resolveStatus(request.getParameter("status"));
        List<MyVoucherView> allVouchers = userVoucherDAO.getMyVouchersByUserID(user.getUserID());
        List<MyVoucherView> voucherList = new ArrayList<>();
        int availableCount = 0;
        int usedCount = 0;
        int unavailableCount = 0;

        for (MyVoucherView voucher : allVouchers) {
            String displayStatus = resolveStatus(voucher.getDisplayStatus());

            if (STATUS_USED.equals(displayStatus)) {
                usedCount++;
            } else if (STATUS_UNAVAILABLE.equals(displayStatus)) {
                unavailableCount++;
            } else {
                availableCount++;
            }

            if (currentStatus.equals(displayStatus)) {
                voucherList.add(voucher);
            }
        }

        request.setAttribute("voucherList", voucherList);
        request.setAttribute("currentStatus", currentStatus);
        request.setAttribute("availableCount", availableCount);
        request.setAttribute("usedCount", usedCount);
        request.setAttribute("unavailableCount", unavailableCount);
        request.setAttribute("activeAccountTab", "vouchers");
        request.getRequestDispatcher("/views/customer/voucher-list.jsp").forward(request, response);
    }

    private String resolveStatus(String status) {
        String value = status == null ? "" : status.trim();

        if (STATUS_USED.equals(value) || STATUS_UNAVAILABLE.equals(value)) {
            return value;
        }

        return STATUS_AVAILABLE;
    }

    private String currentPathWithQuery(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String query = request.getQueryString();
        return query == null || query.isBlank() ? uri : uri + "?" + query;
    }
}
