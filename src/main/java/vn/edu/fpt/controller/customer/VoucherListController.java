package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.VoucherDAO;
import vn.edu.fpt.model.User;
import vn.edu.fpt.model.Voucher;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "VoucherListController", urlPatterns = {"/my-vouchers"})
public class VoucherListController extends HttpServlet {
    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", "/my-vouchers");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Voucher> voucherList = voucherDAO.getAvailableVouchersForCustomer();

        request.setAttribute("voucherList", voucherList);
        request.setAttribute("activeAccountTab", "vouchers");
        request.getRequestDispatcher("/views/customer/voucher-list.jsp").forward(request, response);
    }
}
