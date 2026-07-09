package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class AccommodationBookingFormController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String accommodationID = getFirstNotBlank(
                request.getParameter("accommodationID"),
                request.getParameter("accommodationId")
        );

        String roomID = getFirstNotBlank(
                request.getParameter("roomID"),
                request.getParameter("roomId")
        );

        String checkIn = getTrimValue(request, "checkIn");
        String checkOut = getTrimValue(request, "checkOut");
        String adults = getTrimValue(request, "adults");
        String children = getTrimValue(request, "children");
        String rooms = getTrimValue(request, "rooms");
        String guests = getTrimValue(request, "guests");

        if (accommodationID.isEmpty() || roomID.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/accommodation");
            return;
        }

        String redirectUrl = request.getContextPath()
                + "/booking?type=accommodation"
                + "&accommodationID=" + urlValue(accommodationID)
                + "&roomID=" + urlValue(roomID)
                + "&checkIn=" + urlValue(checkIn)
                + "&checkOut=" + urlValue(checkOut)
                + "&adults=" + urlValue(adults)
                + "&children=" + urlValue(children)
                + "&rooms=" + urlValue(rooms)
                + "&guests=" + urlValue(guests);

        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private String getFirstNotBlank(String firstValue, String secondValue) {
        if (firstValue != null && !firstValue.trim().isEmpty()) {
            return firstValue.trim();
        }

        if (secondValue != null && !secondValue.trim().isEmpty()) {
            return secondValue.trim();
        }

        return "";
    }

    private String urlValue(String value) {
        return value == null ? "" : value.trim();
    }
}
