package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourSchedule;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public abstract class StaffTourScheduleSupport extends HttpServlet {

    protected final TourDAO tourDAO = new TourDAO();

    private static final BigDecimal MIN_ADULT_PRICE = new BigDecimal("500000");
    private static final BigDecimal MAX_MONEY = new BigDecimal("1000000000");
    private static final BigDecimal CHILD_RATE = new BigDecimal("0.75");
    private static final BigDecimal INFANT_SECOND_RATE = new BigDecimal("0.50");
    protected static final int DEFAULT_VAT = 8;
    protected static final String DEFAULT_CANCELLATION_POLICY = "Thanh toán đủ 100% khi đặt tour. Chính sách hủy/hoàn tiền áp dụng theo trang quy định chung của công ty.";

    protected static final Map<String, List<Integer>> TRANSPORT_SEATS = new LinkedHashMap<>();

    static {
        TRANSPORT_SEATS.put("Xe Du Lịch", List.of(4, 7, 16, 29, 45));
        TRANSPORT_SEATS.put("Xe Khách", List.of(29, 35, 45, 50));
        TRANSPORT_SEATS.put("Xe Giường nằm", List.of(34, 40, 44));
        TRANSPORT_SEATS.put("Toa tàu hỏa", List.of(56, 64, 80));
    }

    protected void forwardScheduleForm(HttpServletRequest request,
                                       HttpServletResponse response,
                                       Tour tour,
                                       TourSchedule schedule,
                                       String mode,
                                       String formAction,
                                       String pageTitle,
                                       String submitLabel,
                                       List<String> errors)
            throws ServletException, IOException {

        boolean bookedSchedule = schedule != null && Math.max(schedule.getQuantity(), schedule.getBookedSeats()) > 0;
        boolean lockedCore = bookedSchedule || isFinalScheduleStatus(schedule == null ? null : schedule.getScheduleStatus());
        String selectedTransport = resolveScheduleTransportType(tour, schedule == null ? null : schedule.getScheduleTransportType());

        request.setAttribute("tour", tour);
        request.setAttribute("schedule", schedule);
        request.setAttribute("mode", mode);
        request.setAttribute("formAction", formAction);
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("submitLabel", submitLabel);
        request.setAttribute("transportOptions", new ArrayList<>(TRANSPORT_SEATS.keySet()));
        request.setAttribute("selectedTransportType", selectedTransport);
        request.setAttribute("seatOptions", getSeatOptions(selectedTransport));
        request.setAttribute("todayIso", LocalDate.now().toString());
        request.setAttribute("defaultVat", DEFAULT_VAT);
        request.setAttribute("bookedSchedule", bookedSchedule);
        request.setAttribute("lockedCore", lockedCore);
        request.setAttribute("canOpenSchedule", canOpenScheduleForTour(tour));
        prepareScheduleValidationAttributes(request, errors);

        request.getRequestDispatcher("/views/staff/tour-schedule-form.jsp")
                .forward(request, response);
    }


    protected void prepareScheduleValidationAttributes(HttpServletRequest request, List<String> errors) {
        if (errors == null || errors.isEmpty()) {
            request.setAttribute("errors", new ArrayList<String>());
            request.setAttribute("fieldErrors", new LinkedHashMap<String, String>());
            return;
        }

        Map<String, String> fieldErrors = new LinkedHashMap<>();
        List<String> commonErrors = new ArrayList<>();

        for (String error : errors) {
            String key = resolveScheduleFieldErrorKey(error);
            if (key == null) {
                commonErrors.add(error);
            } else {
                fieldErrors.putIfAbsent(key, error);
            }
        }

        request.setAttribute("errors", commonErrors);
        request.setAttribute("fieldErrors", fieldErrors);
    }

    private String resolveScheduleFieldErrorKey(String error) {
        if (error == null) return null;
        String message = error.trim();

        if (message.startsWith("Mã tour")) return "tourID";
        if (message.startsWith("Lịch khởi hành cần sửa")) return "tourScheduleID";
        if (message.startsWith("Phương tiện")) return "scheduleTransportType";
        if (message.startsWith("Ngày xuất phát")) return "startDate";
        if (message.startsWith("Ngày kết thúc")) return "endDate";
        if (message.startsWith("Tour này đã có lịch")) return "startDate";
        if (message.startsWith("Giờ xuất phát")) return "departureTime";
        if (message.startsWith("Giờ về")) return "expectedReturnTime";
        if (message.startsWith("Ngày chốt bán")) return "bookingDeadline";
        if (message.startsWith("Số ghế")) return "maxParticipants";
        if (message.startsWith("Giá người lớn")) return "adultPrice";
        if (message.startsWith("Phụ thu phòng đơn")) return "singleRoomSurcharge";
        if (message.startsWith("Trạng thái lịch")) return "scheduleStatus";
        if (message.startsWith("Tour chưa ở trạng thái")) return "scheduleStatus";
        if (message.startsWith("Lịch đã có booking")) return "scheduleStatus";
        if (message.startsWith("Chỉ chuyển Hoàn tất")) return "scheduleStatus";
        if (message.startsWith("Chính sách hủy")) return "cancellationPolicy";

        return null;
    }

    protected ScheduleFormData readScheduleFormData(HttpServletRequest request) {
        ScheduleFormData data = new ScheduleFormData();
        data.tourIDRaw = request.getParameter("tourID");
        data.tourScheduleIDRaw = request.getParameter("tourScheduleID");
        data.scheduleTransportType = safeTrim(request.getParameter("scheduleTransportType"));
        data.startDateRaw = request.getParameter("startDate");
        data.endDateRaw = request.getParameter("endDate");
        data.departureTimeRaw = request.getParameter("departureTime");
        data.expectedReturnTimeRaw = request.getParameter("expectedReturnTime");
        data.bookingDeadlineRaw = request.getParameter("bookingDeadline");
        data.maxParticipantsRaw = request.getParameter("maxParticipants");
        data.maxParticipantsPerBookingRaw = request.getParameter("maxParticipantsPerBooking");
        data.adultPriceRaw = request.getParameter("adultPrice");
        data.singleRoomSurchargeRaw = request.getParameter("singleRoomSurcharge");
        data.cancellationPolicy = safeTrim(request.getParameter("cancellationPolicy"));
        data.scheduleStatus = safeTrim(request.getParameter("scheduleStatus"));
        return data;
    }

    protected List<String> validateScheduleData(ScheduleFormData data,
                                                Tour tour,
                                                TourSchedule existingSchedule,
                                                boolean editMode,
                                                boolean lockedCore) {
        List<String> errors = new ArrayList<>();

        if (tour == null) {
            errors.add("Tour không tồn tại.");
            return errors;
        }

        if (!canManageScheduleForTour(tour)) {
            errors.add("Tour đang ngừng bán nên không được thêm/sửa lịch khởi hành.");
        }

        Integer tourID = parsePositiveInt(data.tourIDRaw);
        if (tourID == null || tourID != tour.getTourID()) {
            errors.add("Mã tour của lịch khởi hành không hợp lệ.");
        }

        if (editMode && (existingSchedule == null || parsePositiveInt(data.tourScheduleIDRaw) == null)) {
            errors.add("Lịch khởi hành cần sửa không tồn tại.");
        }

        if (isFinalScheduleStatus(existingSchedule == null ? null : existingSchedule.getScheduleStatus())) {
            errors.add("Lịch đã hủy hoặc hoàn tất không được sửa. Chỉ nên xem chi tiết để đối soát.");
        }

        String transportType = lockedCore && existingSchedule != null
                ? resolveScheduleTransportType(tour, existingSchedule.getScheduleTransportType())
                : resolveScheduleTransportType(tour, data.scheduleTransportType);

        if (!TRANSPORT_SEATS.containsKey(transportType)) {
            errors.add("Phương tiện của lịch khởi hành không hợp lệ.");
        }

        LocalDate startDate = lockedCore && existingSchedule != null
                ? toLocalDate(existingSchedule.getStartDate())
                : parseLocalDate(data.startDateRaw);
        LocalDate endDate = lockedCore && existingSchedule != null
                ? toLocalDate(existingSchedule.getEndDate())
                : parseLocalDate(data.endDateRaw);

        if (startDate == null) {
            errors.add("Ngày xuất phát là bắt buộc và phải đúng định dạng.");
        }
        if (endDate == null) {
            errors.add("Ngày kết thúc là bắt buộc và phải đúng định dạng.");
        }

        LocalDate today = LocalDate.now();
        if (!lockedCore && startDate != null && startDate.isBefore(today)) {
            errors.add("Ngày xuất phát không được nhỏ hơn ngày hiện tại.");
        }
        if (!lockedCore && endDate != null && endDate.isBefore(today)) {
            errors.add("Ngày kết thúc không được nhỏ hơn ngày hiện tại.");
        }

        if (startDate != null && endDate != null) {
            if (endDate.isBefore(startDate)) {
                errors.add("Ngày kết thúc không được trước ngày xuất phát.");
            }

            long actualDays = ChronoUnit.DAYS.between(startDate, endDate) + 1;
            if (actualDays != tour.getNumberOfDay()) {
                errors.add("Ngày xuất phát và ngày kết thúc phải khớp đúng số ngày của tour. Tour "
                        + tour.getNumberOfDay() + " ngày thì lịch phải kéo dài đúng " + tour.getNumberOfDay() + " ngày.");
            }

            int currentScheduleID = existingSchedule == null ? 0 : existingSchedule.getTourScheduleID();
            if (!lockedCore && tourDAO.isDuplicateScheduleStartDate(tour.getTourID(), currentScheduleID, Timestamp.valueOf(startDate.atStartOfDay()))) {
                errors.add("Tour này đã có lịch khởi hành cùng ngày xuất phát. Không nên tạo trùng ngày.");
            }
        }

        if (!isBlank(data.departureTimeRaw) && parseLocalTime(data.departureTimeRaw) == null) {
            errors.add("Giờ xuất phát không hợp lệ.");
        }
        if (!isBlank(data.expectedReturnTimeRaw) && parseLocalTime(data.expectedReturnTimeRaw) == null) {
            errors.add("Giờ về dự kiến không hợp lệ.");
        }

        LocalDate deadline = parseLocalDate(data.bookingDeadlineRaw);
        if (!isBlank(data.bookingDeadlineRaw) && deadline == null) {
            errors.add("Ngày chốt bán không hợp lệ.");
        }
        boolean deadlineChanged = existingSchedule == null
                || !sameLocalDate(deadline, toLocalDate(existingSchedule.getBookingDeadline()));
        if (deadline != null && deadline.isBefore(today) && deadlineChanged) {
            errors.add("Ngày chốt bán không được nhỏ hơn ngày hiện tại.");
        }
        if (deadline != null && startDate != null && !deadline.isBefore(startDate)) {
            errors.add("Ngày chốt bán phải trước ngày xuất phát.");
        }

        Integer maxParticipants = parsePositiveInt(data.maxParticipantsRaw);
        if (maxParticipants == null) {
            errors.add("Số ghế/tổng số khách tối đa là bắt buộc.");
        } else if (!getSeatOptions(transportType).contains(maxParticipants)) {
            errors.add("Số ghế không phù hợp với phương tiện của lịch khởi hành.");
        }

        int bookedQuantity = existingSchedule == null ? 0 : Math.max(existingSchedule.getQuantity(), existingSchedule.getBookedSeats());
        if (maxParticipants != null && maxParticipants < bookedQuantity) {
            errors.add("Số ghế tối đa không được nhỏ hơn số khách đã đặt hiện tại: " + bookedQuantity + ".");
        }

        Integer maxPerBooking = parsePositiveInt(data.maxParticipantsPerBookingRaw);
        if (maxPerBooking == null) {
            errors.add("Số khách tối đa mỗi booking là bắt buộc.");
        } else if (maxParticipants != null && maxPerBooking > maxParticipants) {
            errors.add("Số khách tối đa mỗi booking không được lớn hơn tổng số ghế.");
        } else if (maxPerBooking > 20) {
            errors.add("Số khách tối đa mỗi booking không nên vượt quá 20 để tránh booking quá lớn.");
        }

        if (!lockedCore) {
            validateAdultPrice(data.adultPriceRaw, errors);
            validateMoney(data.singleRoomSurchargeRaw, "Phụ thu phòng đơn", true, errors);
        }

        String normalizedStatus = normalizeScheduleStatusForTour(tour, data.scheduleStatus);
        if (!isValidScheduleStatus(normalizedStatus)) {
            errors.add("Trạng thái lịch khởi hành không hợp lệ.");
        }

        if (!canOpenScheduleForTour(tour) && !"Inactive".equals(tour.getStatus()) && !"Planned".equals(normalizedStatus)) {
            errors.add("Tour chưa ở trạng thái Đang bán nên lịch khởi hành chỉ được để Chưa mở bán.");
        }

        if (bookedQuantity > 0 && "Cancelled".equals(normalizedStatus)) {
            errors.add("Lịch đã có booking không được hủy trực tiếp. Cần xử lý booking/hoàn tiền trước.");
        }

        if ("Completed".equals(normalizedStatus) && endDate != null && endDate.isAfter(today)) {
            errors.add("Chỉ chuyển Hoàn tất khi ngày kết thúc không còn ở tương lai.");
        }

        validateLength(data.cancellationPolicy, "Chính sách hủy", 0, 2000, errors);

        return errors;
    }

    protected TourSchedule buildScheduleFromData(ScheduleFormData data, Tour tour, TourSchedule existingSchedule, boolean lockedCore) {
        TourSchedule schedule = new TourSchedule();

        int tourScheduleID = defaultInt(parsePositiveInt(data.tourScheduleIDRaw), 0);
        schedule.setTourScheduleID(tourScheduleID);
        schedule.setTourID(tour == null ? defaultInt(parsePositiveInt(data.tourIDRaw), 0) : tour.getTourID());
        schedule.setScheduleTransportType(lockedCore && existingSchedule != null
                ? resolveScheduleTransportType(tour, existingSchedule.getScheduleTransportType())
                : resolveScheduleTransportType(tour, data.scheduleTransportType));

        LocalDate startDate = lockedCore && existingSchedule != null
                ? toLocalDate(existingSchedule.getStartDate())
                : parseLocalDate(data.startDateRaw);
        LocalDate endDate = lockedCore && existingSchedule != null
                ? toLocalDate(existingSchedule.getEndDate())
                : parseLocalDate(data.endDateRaw);

        if (startDate != null) {
            schedule.setStartDate(Timestamp.valueOf(startDate.atStartOfDay()));
        }
        if (endDate != null) {
            schedule.setEndDate(Timestamp.valueOf(endDate.atStartOfDay()));
        }

        schedule.setDepartureTime(toSqlTime(data.departureTimeRaw));
        schedule.setExpectedReturnTime(toSqlTime(data.expectedReturnTimeRaw));
        schedule.setBookingDeadline(resolveBookingDeadline(data.bookingDeadlineRaw, startDate));

        int maxParticipants = defaultInt(parsePositiveInt(data.maxParticipantsRaw), existingSchedule == null ? 0 : existingSchedule.getMaxParticipants());
        schedule.setMaxParticipants(maxParticipants);
        schedule.setMinParticipants((int) Math.ceil(maxParticipants * 0.5));
        schedule.setMaxParticipantsPerBooking(defaultInt(parsePositiveInt(data.maxParticipantsPerBookingRaw), Math.min(10, Math.max(1, maxParticipants))));

        BigDecimal adultPrice = lockedCore && existingSchedule != null
                ? existingSchedule.getAdultPrice()
                : parseBigDecimal(data.adultPriceRaw);
        if (adultPrice == null && tour != null) {
            adultPrice = tour.getAdultPrice();
        }
        if (adultPrice == null) {
            adultPrice = BigDecimal.ZERO;
        }

        BigDecimal singleRoom = lockedCore && existingSchedule != null
                ? existingSchedule.getSingleRoomSurcharge()
                : parseMoneyOrZero(data.singleRoomSurchargeRaw);

        schedule.setAdultPrice(adultPrice);
        schedule.setChildPrice(calculatePercentWithVat(adultPrice, CHILD_RATE));
        schedule.setInfantPrice(calculatePercentWithVat(adultPrice, INFANT_SECOND_RATE));
        schedule.setSingleRoomSurcharge(singleRoom == null ? BigDecimal.ZERO : singleRoom);
        schedule.setDepositPercent(0);
        schedule.setVatPercent(DEFAULT_VAT);
        schedule.setCancellationPolicy(isBlank(data.cancellationPolicy) ? DEFAULT_CANCELLATION_POLICY : data.cancellationPolicy);
        schedule.setScheduleStatus(normalizeScheduleStatusForTour(tour, data.scheduleStatus));

        if (existingSchedule != null) {
            schedule.setQuantity(existingSchedule.getQuantity());
            schedule.setBookedSeats(existingSchedule.getBookedSeats());
            schedule.setCreatedAt(existingSchedule.getCreatedAt());
        } else {
            schedule.setQuantity(0);
            schedule.setBookedSeats(0);
        }

        return schedule;
    }

    protected Tour getTourForSchedule(int tourID) {
        Tour tour = tourDAO.getTourById(tourID);
        if (tour != null) {
            tourDAO.syncOpenSchedulesWithTourStatus(tour);
            tour.setScheduleList(tourDAO.getSchedulesByTourId(tourID));
            alignSchedulesForTourStatus(tour);
        }
        return tour;
    }

    protected boolean canManageScheduleForTour(Tour tour) {
        return tour != null && !"Inactive".equals(tour.getStatus());
    }

    protected boolean canOpenScheduleForTour(Tour tour) {
        return tour != null && "Active".equals(tour.getStatus());
    }

    protected String normalizeScheduleStatusForTour(Tour tour, String status) {
        String safeStatus = isBlank(status) ? "Planned" : status.trim();
        if (!canOpenScheduleForTour(tour) && !isFinalScheduleStatus(safeStatus)) {
            return "Inactive".equals(tour == null ? null : tour.getStatus()) ? "Closed" : "Planned";
        }
        if (canOpenScheduleForTour(tour) && isBlank(status)) {
            return "Open";
        }
        return safeStatus;
    }

    protected void alignScheduleStatusForTour(Tour tour, TourSchedule schedule) {
        if (schedule == null || tour == null) {
            return;
        }
        schedule.setScheduleStatus(normalizeScheduleStatusForTour(tour, schedule.getScheduleStatus()));
        if (isBlank(schedule.getScheduleTransportType())) {
            schedule.setScheduleTransportType(resolveScheduleTransportType(tour, null));
        }
    }

    protected void alignSchedulesForTourStatus(Tour tour) {
        if (tour == null || tour.getScheduleList() == null) {
            return;
        }
        for (TourSchedule schedule : tour.getScheduleList()) {
            alignScheduleStatusForTour(tour, schedule);
        }
    }

    protected boolean isFinalScheduleStatus(String status) {
        return "Cancelled".equals(status) || "Completed".equals(status);
    }

    protected List<Integer> getSeatOptions(Tour tour) {
        return getSeatOptions(resolveScheduleTransportType(tour, null));
    }

    protected List<Integer> getSeatOptions(String transportType) {
        return TRANSPORT_SEATS.getOrDefault(transportType, List.of(4, 7, 16, 29, 45));
    }

    protected String resolveScheduleTransportType(Tour tour, String scheduleTransportType) {
        String value = safeTrim(scheduleTransportType);
        if (!isBlank(value) && TRANSPORT_SEATS.containsKey(value)) {
            return value;
        }
        value = tour == null ? "" : safeTrim(tour.getMainTransportType());
        if (!isBlank(value) && TRANSPORT_SEATS.containsKey(value)) {
            return value;
        }
        return "Xe Du Lịch";
    }

    protected Integer parsePositiveInt(String value) {
        try {
            if (isBlank(value)) {
                return null;
            }
            int number = Integer.parseInt(value.trim());
            return number > 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    protected String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    protected boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private int defaultInt(Integer value, int defaultValue) {
        return value == null ? defaultValue : value;
    }

    private LocalDate parseLocalDate(String value) {
        try {
            if (isBlank(value)) {
                return null;
            }
            return LocalDate.parse(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private LocalTime parseLocalTime(String value) {
        try {
            if (isBlank(value)) {
                return null;
            }
            return LocalTime.parse(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Time toSqlTime(String value) {
        LocalTime time = parseLocalTime(value);
        return time == null ? null : Time.valueOf(time);
    }

    private Timestamp resolveBookingDeadline(String rawDeadline, LocalDate startDate) {
        LocalDate deadline = parseLocalDate(rawDeadline);
        if (deadline != null) {
            return Timestamp.valueOf(deadline.atTime(23, 59));
        }
        if (startDate != null) {
            return Timestamp.valueOf(startDate.minusDays(1).atTime(23, 59));
        }
        return null;
    }

    private LocalDate toLocalDate(Timestamp timestamp) {
        return timestamp == null ? null : timestamp.toLocalDateTime().toLocalDate();
    }

    private boolean sameLocalDate(LocalDate a, LocalDate b) {
        if (a == null && b == null) {
            return true;
        }
        if (a == null || b == null) {
            return false;
        }
        return a.equals(b);
    }

    private void validateAdultPrice(String rawValue, List<String> errors) {
        BigDecimal value = parseBigDecimal(rawValue);
        if (value == null) {
            errors.add("Giá người lớn là bắt buộc và phải là số hợp lệ.");
            return;
        }
        if (!isWholeMoney(value)) {
            errors.add("Giá người lớn phải là số tiền nguyên, không nhập số thập phân.");
            return;
        }
        if (value.compareTo(MIN_ADULT_PRICE) <= 0 || value.compareTo(MAX_MONEY) > 0) {
            errors.add("Giá người lớn phải lớn hơn 500.000 và không vượt quá 1.000.000.000.");
        }
    }

    private void validateMoney(String rawValue, String label, boolean allowZero, List<String> errors) {
        BigDecimal value = parseBigDecimal(rawValue);
        if (value == null) {
            errors.add(label + " là bắt buộc và phải là số hợp lệ.");
            return;
        }
        if (!isWholeMoney(value)) {
            errors.add(label + " phải là số tiền nguyên, không nhập số thập phân.");
            return;
        }
        int minCompare = allowZero ? value.compareTo(BigDecimal.ZERO) : value.compareTo(BigDecimal.ZERO.add(BigDecimal.ONE));
        if (minCompare < 0 || value.compareTo(MAX_MONEY) > 0) {
            errors.add(label + " phải từ 0 đến 1.000.000.000.");
        }
    }

    private boolean isWholeMoney(BigDecimal value) {
        return value != null && value.stripTrailingZeros().scale() <= 0;
    }

    private void validateLength(String value, String label, int min, int max, List<String> errors) {
        String safeValue = safeTrim(value);
        if (safeValue.length() < min || safeValue.length() > max) {
            errors.add(label + " phải từ " + min + " đến " + max + " ký tự.");
        }
    }

    private boolean isValidScheduleStatus(String value) {
        return "Planned".equals(value)
                || "Open".equals(value)
                || "Closed".equals(value)
                || "Cancelled".equals(value)
                || "Completed".equals(value);
    }

    private BigDecimal parseBigDecimal(String value) {
        try {
            if (isBlank(value)) {
                return null;
            }
            return new BigDecimal(value.trim().replace(",", "."));
        } catch (Exception e) {
            return null;
        }
    }

    private BigDecimal parseMoneyOrZero(String value) {
        BigDecimal money = parseBigDecimal(value);
        return money == null ? BigDecimal.ZERO : money;
    }

    private BigDecimal calculatePercentWithVat(BigDecimal base, BigDecimal rate) {
        if (base == null) {
            return BigDecimal.ZERO;
        }
        return base.multiply(rate)
                .multiply(BigDecimal.valueOf(100 + DEFAULT_VAT))
                .divide(BigDecimal.valueOf(100), 0, RoundingMode.HALF_UP);
    }

    protected static class ScheduleFormData {
        String tourIDRaw;
        String tourScheduleIDRaw;
        String scheduleTransportType;
        String startDateRaw;
        String endDateRaw;
        String departureTimeRaw;
        String expectedReturnTimeRaw;
        String bookingDeadlineRaw;
        String maxParticipantsRaw;
        String maxParticipantsPerBookingRaw;
        String adultPriceRaw;
        String singleRoomSurchargeRaw;
        String cancellationPolicy;
        String scheduleStatus;
    }
}
