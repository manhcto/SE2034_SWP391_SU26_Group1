package vn.edu.fpt.controller.staff;

import vn.edu.fpt.DAO.ExternalTicketDAO;
import vn.edu.fpt.model.ExternalTicket;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Time;
import java.util.List;

@WebServlet("/staff/external-ticket")
public class ManageExternalTicketController extends HttpServlet {
    private ExternalTicketDAO ticketDAO;

    @Override
    public void init() {
        ticketDAO = new ExternalTicketDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add":
                    request.getRequestDispatcher("/views/staff/add-external-ticket.jsp").forward(request, response);
                    break;

                case "view":
                    int viewId = Integer.parseInt(request.getParameter("id"));
                    ExternalTicket viewTicket = ticketDAO.getExternalTicketById(viewId);
                    request.setAttribute("ticket", viewTicket);
                    request.getRequestDispatcher("/views/staff/view-external-ticket.jsp").forward(request, response);
                    break;

                case "edit":
                    int id = Integer.parseInt(request.getParameter("id"));
                    ExternalTicket ticket = ticketDAO.getExternalTicketById(id);

                    String dayStr = ticket.getDayOfWeekOpen();
                    String openDayFrom = "Thứ 2";
                    String openDayTo = "Chủ Nhật";

                    if (dayStr != null && !dayStr.isEmpty()) {
                        if (dayStr.contains("-")) {
                            String[] parts = dayStr.split("-");
                            openDayFrom = parts[0].trim();
                            openDayTo = parts[1].trim();
                        } else {
                            openDayFrom = dayStr.trim();
                            openDayTo = dayStr.trim();
                        }
                    }
                    request.setAttribute("openDayFrom", openDayFrom);
                    request.setAttribute("openDayTo", openDayTo);
                    request.setAttribute("ticket", ticket);
                    request.getRequestDispatcher("/views/staff/edit-external-ticket.jsp").forward(request, response);
                    break;

                case "delete":
                    int delId = Integer.parseInt(request.getParameter("id"));
                    ticketDAO.deleteExternalTicket(delId);
                    response.sendRedirect(request.getContextPath() + "/staff/external-ticket?action=list");
                    break;

                case "list":
                default:
                    List<ExternalTicket> list = ticketDAO.getAllTicketsForStaff();
                    request.setAttribute("TICKET_LIST", list);
                    request.getRequestDispatcher("/views/staff/list-external-ticket.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            // 1. XỬ LÝ NHÁNH BULK ACTION (THAO TÁC HÀNG LOẠT) ĐƯỢC ƯU TIÊN ĐẶT LÊN ĐẦU
            if ("bulk".equals(action)) {
                String bulkType = request.getParameter("bulkActionType");
                String[] ticketIds = request.getParameterValues("ticketIds");

                if (ticketIds != null && bulkType != null) {
                    for (String idStr : ticketIds) {
                        int currentId = Integer.parseInt(idStr);
                        if ("active".equals(bulkType)) {
                            ticketDAO.updateTicketStatus(currentId, "Active");
                        } else if ("inactive".equals(bulkType)) {
                            ticketDAO.updateTicketStatus(currentId, "Inactive");
                        } else if ("delete".equals(bulkType)) {
                            ticketDAO.deleteExternalTicket(currentId);
                        }
                    }
                }
                response.sendRedirect(request.getContextPath() + "/staff/external-ticket?action=list");
                return; // Dừng hàm tại đây để không chạy xuống phần lấy giá vé bên dưới gây lỗi Null
            }

            // 2. XỬ LÝ NHÁNH ADD / EDIT (THÊM / SỬA)
            String name = request.getParameter("name");
            String image = request.getParameter("image");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String description = request.getParameter("description");
            String type = request.getParameter("type");
            String status = request.getParameter("status");
            double ticketPrice = Double.parseDouble(request.getParameter("ticketPrice"));

            String openDayFrom = request.getParameter("openDayFrom");
            String openDayTo = request.getParameter("openDayTo");
            String dayOfWeekOpen = openDayFrom + " - " + openDayTo;
            if(openDayFrom.equals(openDayTo)) dayOfWeekOpen = openDayFrom;

            String timeOpenStr = request.getParameter("timeOpen");
            if (timeOpenStr != null && timeOpenStr.length() == 5) timeOpenStr += ":00";
            Time timeOpen = Time.valueOf(timeOpenStr);

            String timeCloseStr = request.getParameter("timeClose");
            if (timeCloseStr != null && timeCloseStr.length() == 5) timeCloseStr += ":00";
            Time timeClose = Time.valueOf(timeCloseStr);

            if ("add".equals(action)) {
                double rate = 5.0;
                int reviewCount = 0;

                ExternalTicket newTicket = new ExternalTicket(0, name, image, address, phone, description, rate, reviewCount, type, status, timeOpen, timeClose, dayOfWeekOpen, ticketPrice);
                boolean isSuccess = ticketDAO.insertExternalTicket(newTicket);

                if (isSuccess) {
                    response.sendRedirect(request.getContextPath() + "/staff/external-ticket?action=list");
                } else {
                    response.sendRedirect(request.getContextPath() + "/staff/external-ticket?action=add&error=true");
                }

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));

                ExternalTicket updateTicket = new ExternalTicket();
                updateTicket.setServiceID(id);
                updateTicket.setName(name);
                updateTicket.setImage(image);
                updateTicket.setAddress(address);
                updateTicket.setPhone(phone);
                updateTicket.setDescription(description);
                updateTicket.setType(type);
                updateTicket.setStatus(status);
                updateTicket.setTimeOpen(timeOpen);
                updateTicket.setTimeClose(timeClose);
                updateTicket.setDayOfWeekOpen(dayOfWeekOpen);
                updateTicket.setTicketPrice(ticketPrice);

                boolean isSuccess = ticketDAO.updateExternalTicket(updateTicket);

                if (isSuccess) {
                    response.sendRedirect(request.getContextPath() + "/staff/external-ticket?action=list");
                } else {
                    response.sendRedirect(request.getContextPath() + "/staff/external-ticket?action=edit&id=" + id + "&error=true");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, quay về trang danh sách
            response.sendRedirect(request.getContextPath() + "/staff/external-ticket?action=list");
        }
    }
}