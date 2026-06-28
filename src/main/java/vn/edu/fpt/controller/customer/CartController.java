package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CartController", urlPatterns = {"/cart/add"})
public class CartController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        List<Map<String, String>> cartItems = (List<Map<String, String>>) session.getAttribute("cartItems");

        if (cartItems == null) {
            cartItems = new ArrayList<>();
            session.setAttribute("cartItems", cartItems);
        }

        Map<String, String> item = new LinkedHashMap<>();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String[] values = entry.getValue();
            item.put(entry.getKey(), values == null || values.length == 0 ? "" : values[0]);
        }

        item.put("addedAt", String.valueOf(System.currentTimeMillis()));
        cartItems.add(item);
        session.setAttribute("cartCount", cartItems.size());

        String redirect = safeInternalRedirect(request.getParameter("redirect"));
        response.sendRedirect(request.getContextPath() + redirect + appendStatus(redirect));
    }

    private String safeInternalRedirect(String redirect) {
        if (redirect == null || redirect.isBlank() || !redirect.startsWith("/") || redirect.startsWith("//")) {
            return "/home";
        }

        return redirect;
    }

    private String appendStatus(String redirect) {
        return redirect.contains("?") ? "&status=cartAdded" : "?status=cartAdded";
    }
}
