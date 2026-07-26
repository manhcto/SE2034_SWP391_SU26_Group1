package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.DashboardDAO;
import vn.edu.fpt.model.BookingStatusStat;
import vn.edu.fpt.model.BookingTypeStat;
import vn.edu.fpt.model.BookingValueDataPoint;
import vn.edu.fpt.model.ServicePerformanceItem;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "DashboardController", urlPatterns = {"/admin/dashboard"})
public class DashboardController extends HttpServlet {
    private static final int ADMIN_ROLE_ID = 1;
    private static final int STAFF_ROLE_ID = 2;
    private static final int GUIDE_ROLE_ID = 3;
    private static final int DEFAULT_RANGE_DAYS = 30;
    private static final String DASHBOARD_PAGE = "/views/admin/dashboard.jsp";

    private final DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = getCurrentUser(request);
        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", currentPathWithQuery(request));
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (user.getRoleID() != ADMIN_ROLE_ID) {
            response.sendRedirect(resolveHomeByRole(request, user.getRoleID()));
            return;
        }

        DateRange dateRange = resolveDateRange(request);

        List<BookingValueDataPoint> bookingValueTrend =
                dashboardDAO.getBookingValueTrend(dateRange.fromDate, dateRange.toDate);
        List<BookingStatusStat> bookingStatusStats =
                dashboardDAO.getBookingStatusStats(dateRange.fromDate, dateRange.toDate);
        List<BookingTypeStat> bookingTypeStats =
                dashboardDAO.getBookingTypeStats(dateRange.fromDate, dateRange.toDate);
        List<ServicePerformanceItem> topTours =
                dashboardDAO.getTopTours(dateRange.fromDate, dateRange.toDate, 5);
        List<ServicePerformanceItem> topAccommodations =
                dashboardDAO.getTopAccommodations(dateRange.fromDate, dateRange.toDate, 5);

        BigDecimal trendMaxValue = getMaxTrendValue(bookingValueTrend);
        int statusMaxCount = getMaxStatusCount(bookingStatusStats);
        int typeMaxCount = getMaxTypeCount(bookingTypeStats);
        int topTourMaxCount = getMaxServiceCount(topTours);
        int topAccommodationMaxCount = getMaxServiceCount(topAccommodations);

        applyTrendPercentages(bookingValueTrend, trendMaxValue);
        applyStatusPercentages(bookingStatusStats, statusMaxCount);
        applyTypePercentages(bookingTypeStats, typeMaxCount);
        applyServicePercentages(topTours, topTourMaxCount);
        applyServicePercentages(topAccommodations, topAccommodationMaxCount);

        request.setAttribute("summary", dashboardDAO.getDashboardSummary(dateRange.fromDate, dateRange.toDate));
        request.setAttribute("bookingValueTrend", bookingValueTrend);
        request.setAttribute("bookingStatusStats", bookingStatusStats);
        request.setAttribute("bookingTypeStats", bookingTypeStats);
        request.setAttribute("topTours", topTours);
        request.setAttribute("topAccommodations", topAccommodations);

        request.setAttribute("fromDate", dateRange.fromDate.toString());
        request.setAttribute("toDate", dateRange.toDate.toString());
        request.setAttribute("isDefaultRange", dateRange.defaultRange);

        request.setAttribute("trendMaxValue", trendMaxValue);
        request.setAttribute("hasTrendValue", trendMaxValue.compareTo(BigDecimal.ZERO) > 0);
        request.setAttribute("statusMaxCount", statusMaxCount);
        request.setAttribute("typeMaxCount", typeMaxCount);
        request.setAttribute("topTourMaxCount", topTourMaxCount);
        request.setAttribute("topAccommodationMaxCount", topAccommodationMaxCount);

        request.getRequestDispatcher(DASHBOARD_PAGE).forward(request, response);
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("user");
    }

    private DateRange resolveDateRange(HttpServletRequest request) {
        String fromRaw = safeTrim(request.getParameter("from"));
        String toRaw = safeTrim(request.getParameter("to"));

        if (!fromRaw.isEmpty() && !toRaw.isEmpty()) {
            try {
                LocalDate fromDate = LocalDate.parse(fromRaw);
                LocalDate toDate = LocalDate.parse(toRaw);

                if (!fromDate.isAfter(toDate)) {
                    return new DateRange(fromDate, toDate, false);
                }
            } catch (DateTimeParseException ignored) {
                // Fallback to the safe default range below.
            }
        }

        LocalDate today = LocalDate.now();
        return new DateRange(today.minusDays(DEFAULT_RANGE_DAYS - 1), today, true);
    }

    private BigDecimal getMaxTrendValue(List<BookingValueDataPoint> points) {
        BigDecimal maxValue = BigDecimal.ZERO;

        for (BookingValueDataPoint point : points) {
            if (point.getTotalValue() != null && point.getTotalValue().compareTo(maxValue) > 0) {
                maxValue = point.getTotalValue();
            }
        }

        return maxValue;
    }

    private int getMaxStatusCount(List<BookingStatusStat> stats) {
        int max = 0;
        for (BookingStatusStat stat : stats) {
            max = Math.max(max, stat.getCount());
        }
        return max;
    }

    private int getMaxTypeCount(List<BookingTypeStat> stats) {
        int max = 0;
        for (BookingTypeStat stat : stats) {
            max = Math.max(max, stat.getCount());
        }
        return max;
    }

    private int getMaxServiceCount(List<ServicePerformanceItem> items) {
        int max = 0;
        for (ServicePerformanceItem item : items) {
            max = Math.max(max, item.getBookingCount());
        }
        return max;
    }

    private void applyTrendPercentages(List<BookingValueDataPoint> points, BigDecimal maxValue) {
        if (maxValue.compareTo(BigDecimal.ZERO) <= 0) {
            return;
        }

        for (BookingValueDataPoint point : points) {
            BigDecimal percent = point.getTotalValue()
                    .multiply(BigDecimal.valueOf(100))
                    .divide(maxValue, 2, RoundingMode.HALF_UP);
            point.setBarPercent(percent.doubleValue());
        }
    }

    private void applyStatusPercentages(List<BookingStatusStat> stats, int maxCount) {
        if (maxCount <= 0) {
            return;
        }

        for (BookingStatusStat stat : stats) {
            stat.setPercentage(stat.getCount() * 100.0 / maxCount);
        }
    }

    private void applyTypePercentages(List<BookingTypeStat> stats, int maxCount) {
        if (maxCount <= 0) {
            return;
        }

        for (BookingTypeStat stat : stats) {
            stat.setPercentage(stat.getCount() * 100.0 / maxCount);
        }
    }

    private void applyServicePercentages(List<ServicePerformanceItem> items, int maxCount) {
        if (maxCount <= 0) {
            return;
        }

        for (ServicePerformanceItem item : items) {
            item.setPercentage(item.getBookingCount() * 100.0 / maxCount);
        }
    }

    private String resolveHomeByRole(HttpServletRequest request, int roleID) {
        String contextPath = request.getContextPath();

        if (roleID == STAFF_ROLE_ID) {
            return contextPath + "/staff/tour";
        }

        if (roleID == GUIDE_ROLE_ID) {
            return contextPath + "/guide/home";
        }

        return contextPath + "/home";
    }

    private String currentPathWithQuery(HttpServletRequest request) {
        String path = request.getContextPath() + request.getServletPath();
        String query = request.getQueryString();
        return query == null || query.isBlank() ? path : path + "?" + query;
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private static class DateRange {
        private final LocalDate fromDate;
        private final LocalDate toDate;
        private final boolean defaultRange;

        private DateRange(LocalDate fromDate, LocalDate toDate, boolean defaultRange) {
            this.fromDate = fromDate;
            this.toDate = toDate;
            this.defaultRange = defaultRange;
        }
    }
}
