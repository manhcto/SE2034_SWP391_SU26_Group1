package vn.edu.fpt.controller.staff;

import vn.edu.fpt.DAO.VoucherDAO;
import vn.edu.fpt.model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/staff/voucher")
public class ManageVoucherController extends HttpServlet {
    private VoucherDAO voucherDAO;

    @Override
    public void init() throws ServletException {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            voucherDAO.deleteVoucher(id);
            response.sendRedirect("voucher");
        } else {
            List<Voucher> list = voucherDAO.getAllVouchers();
            request.setAttribute("VOUCHER_LIST", list);
            request.getRequestDispatcher("/views/staff/voucher-management.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            // 1. LẤY DỮ LIỆU TỪ FORM
            String voucherCode = request.getParameter("voucherCode");
            String voucherName = request.getParameter("voucherName");
            double percentDiscount = Double.parseDouble(request.getParameter("percentDiscount"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Date startDate = Date.valueOf(request.getParameter("startDate"));
            Date endDate = Date.valueOf(request.getParameter("endDate"));
            String applyFor = request.getParameter("applyFor");
            String image = request.getParameter("image");
            String description = request.getParameter("description");

            // 2. VALIDATION BẢO MẬT Ở BACKEND
            // Kiểm tra mã: Viết hoa, không khoảng trắng, không dấu
            if (!voucherCode.matches("^[A-Z0-9]+$")) {
                response.sendRedirect("voucher?error=invalid_code");
                return;
            }

            // Kiểm tra phần trăm (phải là số nguyên và từ 1-100)
            if (percentDiscount < 1 || percentDiscount > 100 || percentDiscount % 1 != 0) {
                response.sendRedirect("voucher?error=invalid_number");
                return;
            }

            // Kiểm tra số lượng (phải >= 1)
            if (quantity < 1) {
                response.sendRedirect("voucher?error=invalid_number");
                return;
            }

            // Kiểm tra ngày kết thúc không được nhỏ hơn ngày bắt đầu
            if (endDate.before(startDate)) {
                response.sendRedirect("voucher?error=invalid_date");
                return;
            }

            // 3. NẠP DỮ LIỆU VÀO OBJECT
            Voucher v = new Voucher();
            v.setVoucherCode(voucherCode);
            v.setVoucherName(voucherName);
            v.setPercentDiscount(percentDiscount);
            v.setStartDate(startDate);
            v.setEndDate(endDate);
            v.setQuantity(quantity);
            v.setApplyFor(applyFor);
            v.setImage(image);
            v.setDescription(description);

            // 4. THỰC THI LỆNH XUỐNG DATABASE
            if ("insert".equals(action)) {
                // Khi tạo mới, ngày kết thúc không được nằm trong quá khứ
                if (endDate.toLocalDate().isBefore(java.time.LocalDate.now())) {
                    response.sendRedirect("voucher?error=invalid_date");
                    return;
                }
                voucherDAO.insertVoucher(v);
            } else if ("update".equals(action)) {
                v.setVoucherId(Integer.parseInt(request.getParameter("voucherId")));
                v.setStatus(request.getParameter("status"));
                voucherDAO.updateVoucher(v);
            }

            // Thành công thì quay về trang danh sách
            response.sendRedirect("voucher");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("voucher?error=system_error");
        }
    }
}
