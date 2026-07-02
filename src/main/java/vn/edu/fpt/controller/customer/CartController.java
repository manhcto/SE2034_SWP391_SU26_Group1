package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.CartDAO;
import vn.edu.fpt.model.CartItems;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet(name = "CartController", urlPatterns = {
        "/cart",
        "/cart/add",
        "/cart/remove",
        "/cart/update"
})
public class CartController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User currentUser = getCurrentUser(request);

        if (currentUser == null) {
            redirectToLogin(request, response);
            return;
        }

        showCart(request, response, currentUser);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User currentUser = getCurrentUser(request);

        if (currentUser == null) {
            redirectToLogin(request, response);
            return;
        }

        String path = request.getServletPath();

        if ("/cart/add".equals(path)) {
            addToCart(request, response, currentUser);
            return;
        }

        if ("/cart/remove".equals(path)) {
            removeFromCart(request, response, currentUser);
            return;
        }

        if ("/cart/update".equals(path)) {
            updateCartItem(request, response, currentUser);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void showCart(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        List<CartItems> cartItems = cartDAO.getCartItems(currentUser.getUserID());

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartDAO.calculateTotal(cartItems));

        request.getRequestDispatcher("/views/customer/cart.jsp").forward(request, response);
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        String type = safe(request.getParameter("type")).toLowerCase();
        int newCartItemID = 0;

        if ("vehicle".equals(type)) {
            int vehicleID = firstPositive(
                    parsePositiveInt(request.getParameter("vehicleID")),
                    parsePositiveInt(request.getParameter("serviceID"))
            );

            newCartItemID = cartDAO.addServiceItem(
                    currentUser.getUserID(),
                    vehicleID,
                    0,
                    0,
                    1
            );

        } else if ("room".equals(type)) {
            int roomID = parsePositiveInt(request.getParameter("roomID"));
            int adults = firstPositive(parsePositiveInt(request.getParameter("adults")), 1);
            int children = Math.max(0, parsePositiveInt(request.getParameter("children")));
            int rooms = firstPositive(parsePositiveInt(request.getParameter("rooms")), 1);
            String checkIn = safe(request.getParameter("checkIn"));
            String checkOut = safe(request.getParameter("checkOut"));

            newCartItemID = cartDAO.addRoomItem(
                    currentUser.getUserID(),
                    roomID,
                    adults,
                    children,
                    rooms,
                    checkIn,
                    checkOut
            );
        }

        refreshCartCount(request, currentUser);

        String submitAction = safe(request.getParameter("submitAction"));

        if ("buy_now".equalsIgnoreCase(submitAction) && newCartItemID > 0) {
            response.sendRedirect(request.getContextPath()
                    + "/booking?source=cart&cartItemID=" + newCartItemID);
            return;
        }

        String redirect = normalizeRedirect(request.getParameter("redirect"));

        if (redirect.isEmpty()) {
            redirect = "/cart";
        }

        response.sendRedirect(request.getContextPath()
                + appendStatus(redirect, newCartItemID > 0 ? "cartAdded" : "cartError"));
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        int cartItemID = parsePositiveInt(request.getParameter("cartItemID"));

        if (cartItemID > 0) {
            cartDAO.removeItem(currentUser.getUserID(), cartItemID);
            refreshCartCount(request, currentUser);
        }

        response.sendRedirect(request.getContextPath() + "/cart?status=removed");
    }

    private void updateCartItem(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        int cartItemID = parsePositiveInt(request.getParameter("cartItemID"));
        int quantity = firstPositive(parsePositiveInt(request.getParameter("quantity")), 1);

        if (cartItemID > 0) {
            cartDAO.updateQuantity(currentUser.getUserID(), cartItemID, quantity);
            refreshCartCount(request, currentUser);
        }

        response.sendRedirect(request.getContextPath() + "/cart?status=updated");
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object user = session == null ? null : session.getAttribute("user");

        if (user instanceof User) {
            return (User) user;
        }

        return null;
    }

    private void refreshCartCount(HttpServletRequest request, User currentUser) {
        request.getSession().setAttribute("cartCount", cartDAO.countCartItems(currentUser.getUserID()));
    }

    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String target = normalizeRedirect(request.getParameter("redirect"));

        if (target.isEmpty()) {
            target = request.getRequestURI();

            String contextPath = request.getContextPath();

            if (target.startsWith(contextPath)) {
                target = target.substring(contextPath.length());
            }

            if (request.getQueryString() != null) {
                target += "?" + request.getQueryString();
            }
        }

        request.getSession().setAttribute("redirectAfterLogin", target);

        response.sendRedirect(request.getContextPath()
                + "/login?redirect="
                + URLEncoder.encode(target, StandardCharsets.UTF_8));
    }

    private int parsePositiveInt(String value) {
        try {
            int parsed = Integer.parseInt(safe(value));
            return parsed > 0 ? parsed : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private int firstPositive(int value, int fallback) {
        return value > 0 ? value : fallback;
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private String normalizeRedirect(String redirect) {
        String safeRedirect = safe(redirect);

        if (safeRedirect.startsWith("/") && !safeRedirect.startsWith("//")) {
            return safeRedirect;
        }

        return "";
    }

    private String appendStatus(String redirect, String status) {
        String separator = redirect.contains("?") ? "&" : "?";
        return redirect + separator + "status=" + URLEncoder.encode(status, StandardCharsets.UTF_8);
    }
}
