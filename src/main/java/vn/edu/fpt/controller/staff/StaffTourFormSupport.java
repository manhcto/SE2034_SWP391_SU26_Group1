package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourItinerary;
import vn.edu.fpt.model.TourSchedule;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

public abstract class StaffTourFormSupport extends HttpServlet {

    protected final TourDAO tourDAO = new TourDAO();
    protected final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();

    private static final BigDecimal MAX_MONEY = new BigDecimal("1000000000");
    private static final BigDecimal CHILD_RATE = new BigDecimal("0.75");
    private static final BigDecimal INFANT_SECOND_RATE = new BigDecimal("0.50");
    private static final int DEFAULT_VAT = 8;
    private static final int DEFAULT_ARRIVE_BEFORE_MINUTES = 30;
    private static final String DEFAULT_CANCELLATION_POLICY = "Thanh toán đủ 100% khi đặt tour. Chính sách hủy/hoàn tiền áp dụng theo trang quy định chung của công ty.";

    private static final Map<String, List<Integer>> TRANSPORT_SEATS = Map.of(
            "Xe Du Lịch", List.of(4, 7, 16, 29, 45),
            "Xe Khách", List.of(29, 35, 45, 50),
            "Xe Giường nằm", List.of(34, 40, 44),
            "Toa tàu hỏa", List.of(56, 64, 80)
    );

    protected void forwardTourForm(HttpServletRequest request,
                                   HttpServletResponse response,
                                   Tour tour,
                                   List<TourItinerary> itineraries,
                                   int dayCount,
                                   String mode,
                                   String formAction,
                                   String pageTitle,
                                   String submitLabel,
                                   List<String> errors)
            throws ServletException, IOException {

        request.setAttribute("tour", tour);
        request.setAttribute("itineraryList", itineraries);
        request.setAttribute("itineraryMap", buildItineraryMap(itineraries));
        request.setAttribute("dayCount", normalizeDayCount(dayCount));
        request.setAttribute("mode", mode);
        request.setAttribute("formAction", formAction);
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("submitLabel", submitLabel);
        request.setAttribute("categoryList", tourDAO.getActiveCategories());
        request.setAttribute("regionList", tourDAO.getActiveRegions());
        request.setAttribute("administrativeUnitList", administrativeUnitDAO.getActiveProvinces());
        request.setAttribute("transportSeats", TRANSPORT_SEATS);
        request.setAttribute("defaultVat", DEFAULT_VAT);
        request.setAttribute("nextTourCode", tourDAO.getNextTourCodePreview());

        String currentStatus = tour == null ? "" : safeTrim(tour.getStatus());
        boolean editMode = "edit".equalsIgnoreCase(mode);
        boolean fullEditAllowed = !editMode || isFullEditableStatus(currentStatus);
        boolean limitedEditAllowed = editMode && isLimitedEditableStatus(currentStatus);
        boolean priceAndScheduleLocked = editMode && isPriceAndScheduleLocked(currentStatus);
        request.setAttribute("fullEditAllowed", fullEditAllowed);
        request.setAttribute("limitedEditAllowed", limitedEditAllowed);
        request.setAttribute("priceAndScheduleLocked", priceAndScheduleLocked);
        request.setAttribute("routeAndScheduleInfoLocked", priceAndScheduleLocked);
        if (tour != null && tour.getScheduleList() != null && !tour.getScheduleList().isEmpty()) {
            request.setAttribute("initialSchedule", tour.getScheduleList().get(0));
        }

        prepareValidationAttributes(request, errors);

        request.getRequestDispatcher("/views/staff/tour-form.jsp")
                .forward(request, response);
    }


    protected void prepareValidationAttributes(HttpServletRequest request, List<String> errors) {
        if (errors == null || errors.isEmpty()) {
            request.setAttribute("errors", new ArrayList<String>());
            request.setAttribute("fieldErrors", new LinkedHashMap<String, String>());
            return;
        }

        Map<String, String> fieldErrors = new LinkedHashMap<>();
        List<String> commonErrors = new ArrayList<>();

        for (String error : errors) {
            String key = resolveTourFieldErrorKey(error);
            if (key == null) {
                commonErrors.add(error);
            } else {
                fieldErrors.putIfAbsent(key, error);
            }
        }

        request.setAttribute("errors", commonErrors);
        request.setAttribute("fieldErrors", fieldErrors);
    }

    private String resolveTourFieldErrorKey(String error) {
        if (error == null) return null;
        String message = error.trim();

        if (message.startsWith("Mã tour")) return "tourID";
        if (message.startsWith("Danh mục")) return "tourCategoryID";
        if (message.startsWith("Tên tour")) return "tourName";
        if (message.startsWith("Loại tour")) return "tourType";
        if (message.startsWith("Số ngày")) return "numberOfDay";
        if (message.startsWith("Số đêm")) return "numberOfNights";
        if (message.startsWith("Điểm khởi hành")) return "startPlace";
        if (message.startsWith("Điểm đến")) return "endPlace";
        if (message.startsWith("Ảnh bìa")) return "coverImage";
        if (message.startsWith("Ảnh giới thiệu")) return "introImage";
        if (message.startsWith("Giá người lớn")) return "adultPrice";
        if (message.startsWith("Phụ thu phòng đơn")) return "singleRoomSurcharge";
        if (message.startsWith("Trạng thái tour")) return "status";
        if (message.startsWith("Khu vực")) return "regionID";
        if (message.startsWith("Phương tiện chính")) return "mainTransportType";
        if (message.startsWith("Điểm nổi bật")) return "tourHighlights";
        if (message.startsWith("Số dòng lịch trình")) return "itinerary";
        if (message.startsWith("Ngày xuất phát")) return "scheduleStartDate";
        if (message.startsWith("Ngày kết thúc")) return "scheduleEndDate";
        if (message.startsWith("Số ghế")) return "maxParticipants";
        if (message.startsWith("Giờ xuất phát")) return "departureTime";
        if (message.startsWith("Giờ về")) return "expectedReturnTime";

        java.util.regex.Matcher matcher = java.util.regex.Pattern
                .compile("^Ngày\\s+(\\d+):\\s+(.+)$")
                .matcher(message);
        if (matcher.matches()) {
            String day = matcher.group(1);
            String detail = matcher.group(2);
            if (detail.startsWith("tiêu đề")) return "itineraryTitle_" + day;
            if (detail.startsWith("mô tả")) return "itineraryDescription_" + day;
            if (detail.startsWith("ảnh")) return "itineraryImage_" + day;
        }

        return null;
    }

    protected TourFormData readTourFormData(HttpServletRequest request) throws ServletException, IOException {
        TourFormData data = new TourFormData();
        List<String> uploadErrors = new ArrayList<>();

        data.tourIDRaw = request.getParameter("tourID");
        data.tourCategoryIDRaw = request.getParameter("tourCategoryID");
        data.tourName = safeTrim(request.getParameter("tourName"));
        data.tourType = "Package";
        data.numberOfDayRaw = request.getParameter("numberOfDay");
        data.numberOfNightsRaw = request.getParameter("numberOfNights");
        data.startPlace = safeTrim(request.getParameter("startPlace"));
        data.endPlace = safeTrim(request.getParameter("endPlace"));
        data.image = firstNonBlank(
                saveImageFile(request, "coverImageFile", "Ảnh bìa", uploadErrors),
                request.getParameter("coverImageUrl"),
                request.getParameter("existingImage")
        );
        data.introImage = firstNonBlank(
                saveImageFile(request, "introImageFile", "Ảnh giới thiệu", uploadErrors),
                request.getParameter("introImageUrl"),
                request.getParameter("existingIntroImage")
        );
        data.adultPriceRaw = request.getParameter("adultPrice");
        data.singleRoomSurchargeRaw = request.getParameter("singleRoomSurcharge");
        data.tourIntroduce = "";
        data.tourHighlights = safeTrim(request.getParameter("tourHighlights"));
        data.pickupAddress = "";
        data.arriveBeforeMinutesRaw = null;
        data.mainTransportType = safeTrim(request.getParameter("mainTransportType"));
        if (isBlank(data.mainTransportType)) {
            data.mainTransportType = "Xe Du Lịch";
        }
        data.status = safeTrim(request.getParameter("status"));
        data.featured = "true".equalsIgnoreCase(request.getParameter("featured"));
        data.regionIDRaw = request.getParameter("regionID");

        data.scheduleStartDateRaw = request.getParameter("scheduleStartDate");
        data.scheduleEndDateRaw = request.getParameter("scheduleEndDate");
        data.departureTimeRaw = request.getParameter("departureTime");
        data.expectedReturnTimeRaw = request.getParameter("expectedReturnTime");
        data.maxParticipantsRaw = request.getParameter("maxParticipants");
        data.scheduleAdultPriceRaw = request.getParameter("scheduleAdultPrice");

        Integer numberOfDay = parsePositiveInt(data.numberOfDayRaw);
        int dayCount = normalizeDayCount(numberOfDay == null ? 1 : numberOfDay);

        for (int day = 1; day <= dayCount; day++) {
            TourItinerary itinerary = new TourItinerary();
            itinerary.setDayNumber(day);
            itinerary.setTitle(safeTrim(request.getParameter("itineraryTitle_" + day)));
            itinerary.setDescription(safeTrim(request.getParameter("itineraryDescription_" + day)));
            itinerary.setMealPlan("");
            itinerary.setTransportNote("");
            itinerary.setImageUrl(firstNonBlank(
                    saveImageFile(request, "itineraryImageFile_" + day, "Ngày " + day + ": ảnh lịch trình", uploadErrors),
                    request.getParameter("itineraryImageUrl_" + day),
                    request.getParameter("existingItineraryImage_" + day)
            ));
            itinerary.setStatus("Active");
            data.itineraries.add(itinerary);
        }
        data.uploadErrors.addAll(uploadErrors);

        return data;
    }

    protected List<String> validateTourData(TourFormData data, boolean editMode) {
        List<String> errors = new ArrayList<>();
        errors.addAll(data.uploadErrors);

        if (editMode && parsePositiveInt(data.tourIDRaw) == null) {
            errors.add("Mã tour không hợp lệ.");
        }

        Integer categoryID = parsePositiveInt(data.tourCategoryIDRaw);
        if (categoryID == null || !tourDAO.existsActiveCategory(categoryID)) {
            errors.add("Danh mục tour không hợp lệ hoặc đã ngừng hoạt động.");
        }

        if (isBlank(data.tourName) || data.tourName.length() < 5 || data.tourName.length() > 255) {
            errors.add("Tên tour phải từ 5 đến 255 ký tự.");
        }

        if (!isValidTourType(data.tourType)) {
            errors.add("Loại tour không hợp lệ.");
        }

        Integer numberOfDay = parsePositiveInt(data.numberOfDayRaw);
        if (numberOfDay == null || numberOfDay > 15) {
            errors.add("Số ngày tour phải là số từ 1 đến 15.");
        }

        Integer numberOfNights = parseNonNegativeInt(data.numberOfNightsRaw);
        if (numberOfNights == null || numberOfNights > 15) {
            errors.add("Số đêm phải là số từ 0 đến 15.");
        }

        if (isBlank(data.startPlace) || data.startPlace.length() < 2 || data.startPlace.length() > 255) {
            errors.add("Điểm khởi hành phải được chọn từ danh sách tỉnh/thành.");
        } else if (!administrativeUnitDAO.isValidProvinceName(data.startPlace)) {
            errors.add("Điểm khởi hành phải là tỉnh/thành đang hoạt động trong hệ thống.");
        }

        if (isBlank(data.endPlace) || data.endPlace.length() < 2 || data.endPlace.length() > 255) {
            errors.add("Điểm đến phải được chọn từ danh sách tỉnh/thành.");
        } else if (!administrativeUnitDAO.isValidProvinceName(data.endPlace)) {
            errors.add("Điểm đến phải là tỉnh/thành đang hoạt động trong hệ thống.");
        }

        if (!isBlank(data.image) && !isValidImagePath(data.image)) {
            errors.add("Ảnh bìa không hợp lệ. Hãy upload ảnh hoặc dùng URL bắt đầu bằng http:// hoặc https://.");
        }

        if (!isBlank(data.introImage) && !isValidImagePath(data.introImage)) {
            errors.add("Ảnh giới thiệu không hợp lệ. Hãy upload ảnh hoặc dùng URL bắt đầu bằng http:// hoặc https://.");
        }

        if (!isValidStatus(data.status)) {
            errors.add("Trạng thái tour không hợp lệ.");
        }

        Integer regionID = parsePositiveInt(data.regionIDRaw);
        if (regionID == null || !tourDAO.existsActiveRegion(regionID)) {
            errors.add("Khu vực là bắt buộc và phải đang hoạt động.");
        }

        if (!TRANSPORT_SEATS.containsKey(data.mainTransportType)) {
            errors.add("Phương tiện chính không hợp lệ.");
        }

        validateLength(data.tourIntroduce, "Giới thiệu tour", 0, 5000, errors);
        validateLength(data.tourHighlights, "Điểm nổi bật của tour", 0, 5000, errors);
        validateLength(data.mainTransportType, "Phương tiện chính", 1, 50, errors);

        if (numberOfDay != null) {
            if (data.itineraries.size() != numberOfDay) {
                errors.add("Số dòng lịch trình phải khớp với số ngày tour.");
            }

            for (TourItinerary itinerary : data.itineraries) {
                if (isBlank(itinerary.getTitle()) || itinerary.getTitle().length() < 2 || itinerary.getTitle().length() > 255) {
                    errors.add("Ngày " + itinerary.getDayNumber() + ": tiêu đề lịch trình phải từ 2 đến 255 ký tự.");
                }

                validateLength(itinerary.getDescription(), "Ngày " + itinerary.getDayNumber() + ": mô tả lịch trình", 0, 5000, errors);

                if (!isBlank(itinerary.getImageUrl()) && !isValidImagePath(itinerary.getImageUrl())) {
                    errors.add("Ngày " + itinerary.getDayNumber() + ": ảnh lịch trình không hợp lệ.");
                }
            }
        }

        return errors;
    }

    private void validateInitialSchedule(TourFormData data, Integer numberOfDay, List<String> errors) {
        LocalDate startDate = parseLocalDate(data.scheduleStartDateRaw);
        LocalDate endDate = parseLocalDate(data.scheduleEndDateRaw);

        if (startDate == null) {
            errors.add("Ngày xuất phát là bắt buộc.");
        }

        if (endDate == null) {
            errors.add("Ngày kết thúc là bắt buộc.");
        }

        LocalDate today = LocalDate.now();
        if (startDate != null && startDate.isBefore(today)) {
            errors.add("Ngày xuất phát không được nhỏ hơn ngày hiện tại.");
        }
        if (endDate != null && endDate.isBefore(today)) {
            errors.add("Ngày kết thúc không được nhỏ hơn ngày hiện tại.");
        }

        if (startDate != null && endDate != null) {
            if (endDate.isBefore(startDate)) {
                errors.add("Ngày kết thúc không được trước ngày xuất phát.");
            }
            if (numberOfDay != null) {
                long actualDays = ChronoUnit.DAYS.between(startDate, endDate) + 1;
                if (actualDays != numberOfDay) {
                    errors.add("Ngày xuất phát và ngày kết thúc phải khớp đúng số ngày tour. Ví dụ tour 3 ngày thì ngày kết thúc phải cách ngày xuất phát 2 ngày.");
                }
            }
        }

        Integer maxParticipants = parsePositiveInt(data.maxParticipantsRaw);
        if (maxParticipants == null) {
            errors.add("Số ghế/tổng số khách tối đa là bắt buộc.");
        } else if (TRANSPORT_SEATS.containsKey(data.mainTransportType)
                && !TRANSPORT_SEATS.get(data.mainTransportType).contains(maxParticipants)) {
            errors.add("Số ghế không phù hợp với phương tiện đã chọn.");
        }

        if (!isBlank(data.departureTimeRaw) && parseLocalTime(data.departureTimeRaw) == null) {
            errors.add("Giờ xuất phát không hợp lệ.");
        }

        if (!isBlank(data.expectedReturnTimeRaw) && parseLocalTime(data.expectedReturnTimeRaw) == null) {
            errors.add("Giờ về dự kiến không hợp lệ.");
        }
    }

    protected Tour buildTourFromData(TourFormData data, Integer currentUserID, boolean includeInitialSchedule) {
        Tour tour = new Tour();

        BigDecimal adultPrice = parseBigDecimal(data.adultPriceRaw);
        if (adultPrice == null) {
            adultPrice = BigDecimal.ZERO;
        }

        Integer tourID = parsePositiveInt(data.tourIDRaw);
        tour.setTourID(tourID == null ? 0 : tourID);
        tour.setTourCategoryID(defaultInt(parsePositiveInt(data.tourCategoryIDRaw), 0));
        tour.setTourName(data.tourName);
        tour.setTourType(data.tourType);
        tour.setNumberOfDay(defaultInt(parsePositiveInt(data.numberOfDayRaw), 1));
        tour.setNumberOfNights(parseNonNegativeInt(data.numberOfNightsRaw));
        tour.setStartPlace(data.startPlace);
        tour.setEndPlace(data.endPlace);
        tour.setImage(data.image);
        tour.setIntroImage(data.introImage);
        tour.setAdultPrice(adultPrice);
        tour.setChildrenPrice(calculatePercentWithVat(adultPrice, CHILD_RATE));
        tour.setInfantPrice(calculatePercentWithVat(adultPrice, INFANT_SECOND_RATE));
        tour.setSingleRoomSurcharge(parseMoneyOrZero(data.singleRoomSurchargeRaw));
        tour.setDepositPercent(0);
        tour.setVatPercent(DEFAULT_VAT);
        tour.setTourIntroduce(data.tourIntroduce);
        tour.setTourInclude(data.tourHighlights);
        tour.setTourNonInclude("");
        tour.setPickupPointName("");
        tour.setPickupAddress(data.pickupAddress);
        tour.setArriveBeforeMinutes(null);
        tour.setPickupNote("");
        tour.setMainTransportType(data.mainTransportType);
        tour.setChildPolicyNote("");
        tour.setStatus(isBlank(data.status) ? "Draft" : data.status);
        tour.setFeatured(data.featured);
        tour.setRegionID(parsePositiveInt(data.regionIDRaw));
        tour.setCreatedByUserID(currentUserID);
        tour.setItineraryList(data.itineraries);

        if (includeInitialSchedule) {
            TourSchedule schedule = buildInitialSchedule(data, tour);
            if (schedule != null) {
                tour.getScheduleList().add(schedule);
            }
        }

        return tour;
    }

    private TourSchedule buildInitialSchedule(TourFormData data, Tour tour) {
        LocalDate startDate = parseLocalDate(data.scheduleStartDateRaw);
        LocalDate endDate = parseLocalDate(data.scheduleEndDateRaw);
        Integer maxParticipants = parsePositiveInt(data.maxParticipantsRaw);
        BigDecimal scheduleAdultPrice = parseBigDecimal(data.adultPriceRaw);

        if (startDate == null || endDate == null || maxParticipants == null || scheduleAdultPrice == null) {
            return null;
        }

        TourSchedule schedule = new TourSchedule();
        schedule.setScheduleTransportType(data.mainTransportType);
        schedule.setStartDate(Timestamp.valueOf(startDate.atStartOfDay()));
        schedule.setEndDate(Timestamp.valueOf(endDate.atStartOfDay()));
        schedule.setDepartureTime(toSqlTime(data.departureTimeRaw));
        schedule.setExpectedReturnTime(toSqlTime(data.expectedReturnTimeRaw));
        schedule.setBookingDeadline(Timestamp.valueOf(startDate.minusDays(1).atTime(23, 59)));
        schedule.setMaxParticipants(maxParticipants);
        schedule.setMinParticipants((int) Math.ceil(maxParticipants * 0.5));
        schedule.setQuantity(0);
        schedule.setBookedSeats(0);
        schedule.setMaxParticipantsPerBooking(Math.min(10, maxParticipants));
        schedule.setAdultPrice(scheduleAdultPrice);
        schedule.setChildPrice(calculatePercentWithVat(scheduleAdultPrice, CHILD_RATE));
        schedule.setInfantPrice(calculatePercentWithVat(scheduleAdultPrice, INFANT_SECOND_RATE));
        schedule.setSingleRoomSurcharge(tour.getSingleRoomSurcharge());
        schedule.setDepositPercent(0);
        schedule.setVatPercent(DEFAULT_VAT);
        schedule.setCancellationPolicy(DEFAULT_CANCELLATION_POLICY);
        schedule.setScheduleStatus("Active".equals(tour.getStatus()) ? "Open" : "Planned");
        return schedule;
    }

    protected Tour buildDefaultTour(int dayCount) {
        Tour tour = new Tour();
        tour.setTourType("Package");
        tour.setNumberOfDay(dayCount);
        tour.setNumberOfNights(0);
        tour.setDepositPercent(0);
        tour.setVatPercent(DEFAULT_VAT);
        tour.setArriveBeforeMinutes(null);
        tour.setMainTransportType("Xe Du Lịch");
        tour.setStatus("Draft");
        tour.setFeatured(false);
        return tour;
    }

    protected List<TourItinerary> buildBlankItineraries(int dayCount) {
        List<TourItinerary> itineraries = new ArrayList<>();

        for (int day = 1; day <= normalizeDayCount(dayCount); day++) {
            TourItinerary itinerary = new TourItinerary();
            itinerary.setDayNumber(day);
            itinerary.setStatus("Active");
            itineraries.add(itinerary);
        }

        return itineraries;
    }

    protected Map<Integer, TourItinerary> buildItineraryMap(List<TourItinerary> itineraries) {
        Map<Integer, TourItinerary> map = new HashMap<>();

        if (itineraries != null) {
            for (TourItinerary itinerary : itineraries) {
                map.put(itinerary.getDayNumber(), itinerary);
            }
        }

        return map;
    }

    protected int resolveDayCount(HttpServletRequest request, Tour tour) {
        Integer paramDayCount = parsePositiveInt(request.getParameter("dayCount"));
        if (paramDayCount != null) {
            return normalizeDayCount(paramDayCount);
        }

        Integer numberOfDay = parsePositiveInt(request.getParameter("numberOfDay"));
        if (numberOfDay != null) {
            return normalizeDayCount(numberOfDay);
        }

        if (tour != null && tour.getNumberOfDay() > 0) {
            return normalizeDayCount(tour.getNumberOfDay());
        }

        return 2;
    }

    protected int normalizeDayCount(int dayCount) {
        if (dayCount < 1) {
            return 1;
        }

        return Math.min(dayCount, 15);
    }

    protected Integer getCurrentUserID(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object userObject = session == null ? null : session.getAttribute("user");

        if (userObject instanceof User) {
            return ((User) userObject).getUserID();
        }

        return null;
    }

    protected int defaultInt(Integer value, int defaultValue) {
        return value == null ? defaultValue : value;
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

    protected Integer parseNonNegativeInt(String value) {
        try {
            if (isBlank(value)) {
                return null;
            }

            int number = Integer.parseInt(value.trim());
            return number >= 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    protected String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    protected String encode(String value) {
        return value == null ? "" : URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    protected boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    protected boolean canEditTourStatus(String status) {
        return isFullEditableStatus(status) || isLimitedEditableStatus(status);
    }

    protected boolean isFullEditableStatus(String status) {
        return "Draft".equals(status) || "Rejected".equals(status);
    }

    protected boolean isLimitedEditableStatus(String status) {
        return "Pending".equals(status) || "Active".equals(status);
    }

    protected boolean isPriceAndScheduleLocked(String status) {
        return isLimitedEditableStatus(status);
    }

    protected void preservePriceRouteAndScheduleFields(TourFormData data, Tour existingTour) {
        if (data == null || existingTour == null) {
            return;
        }

        data.numberOfDayRaw = String.valueOf(existingTour.getNumberOfDay());
        data.numberOfNightsRaw = existingTour.getNumberOfNights() == null ? "0" : String.valueOf(existingTour.getNumberOfNights());
        data.startPlace = safeTrim(existingTour.getStartPlace());
        data.endPlace = safeTrim(existingTour.getEndPlace());
        data.mainTransportType = safeTrim(existingTour.getMainTransportType());
        data.regionIDRaw = existingTour.getRegionID() == null ? null : String.valueOf(existingTour.getRegionID());

        data.adultPriceRaw = existingTour.getAdultPrice() == null ? "0" : existingTour.getAdultPrice().toPlainString();
        data.singleRoomSurchargeRaw = existingTour.getSingleRoomSurcharge() == null ? "0" : existingTour.getSingleRoomSurcharge().toPlainString();
        data.status = safeTrim(existingTour.getStatus());
    }

    protected void preserveTourPricingFields(TourFormData data, Tour existingTour) {
        if (data == null || existingTour == null) {
            return;
        }

        data.adultPriceRaw = existingTour.getAdultPrice() == null ? "0" : existingTour.getAdultPrice().toPlainString();
        data.singleRoomSurchargeRaw = existingTour.getSingleRoomSurcharge() == null ? "0" : existingTour.getSingleRoomSurcharge().toPlainString();
    }

    protected String getChildPricingPolicy() {
        return "Trẻ em dưới 05 tuổi, cao dưới 1m: miễn phí, cha mẹ lo chi phí phát sinh; 02 người lớn chỉ kèm 01 trẻ miễn phí. Trẻ em thứ 2 dưới 05 tuổi tính 50% giá người lớn. Phụ thu ghế ngồi trên xe nếu yêu cầu thêm chỗ: 40% giá người lớn. Trẻ em từ 05–10 tuổi tính 75% giá người lớn, gồm chi phí và ghế riêng, ngủ chung giường với bố mẹ. Trẻ em từ 10 tuổi tính 100% giá tour như người lớn. VAT áp dụng 8%.";
    }

    protected String getSingleRoomPolicy() {
        return "Phụ thu phòng đơn áp dụng khi khách muốn ngủ riêng một phòng trong tour ghép đoàn. Mức phí thường dựa trên phần chênh lệch so với cơ sở 2 khách/phòng, tùy khách sạn, resort và số đêm lưu trú. Với tour trọn gói, phụ thu thường được nhập theo toàn bộ chuyến đi.";
    }

    private void validateAdultPrice(String rawValue, List<String> errors) {
        BigDecimal value = parseBigDecimal(rawValue);

        if (value == null) {
            errors.add("Giá người lớn là bắt buộc và phải là số hợp lệ.");
            return;
        }

        if (value.compareTo(new BigDecimal("500000")) <= 0 || value.compareTo(MAX_MONEY) > 0) {
            errors.add("Giá người lớn phải lớn hơn 500.000 và không vượt quá 1.000.000.000.");
        }
    }

    private void validateMoney(String rawValue, String label, List<String> errors) {
        BigDecimal value = parseBigDecimal(rawValue);

        if (value == null || value.compareTo(BigDecimal.ZERO) < 0 || value.compareTo(MAX_MONEY) > 0) {
            errors.add(label + " phải từ 0 đến 1.000.000.000.");
        }
    }

    private void validateLength(String value, String label, int min, int max, List<String> errors) {
        String safeValue = safeTrim(value);

        if (safeValue.length() < min || safeValue.length() > max) {
            errors.add(label + " phải từ " + min + " đến " + max + " ký tự.");
        }
    }

    private boolean isValidTourType(String value) {
        return "Package".equals(value);
    }

    private boolean isValidStatus(String value) {
        return "Draft".equals(value)
                || "Pending".equals(value)
                || "Active".equals(value)
                || "Inactive".equals(value)
                || "Rejected".equals(value);
    }

    private boolean isValidImagePath(String value) {
        return value != null && (value.matches("^https?://.+") || value.startsWith("/") || value.startsWith("assets/"));
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

    private BigDecimal calculatePercent(BigDecimal base, BigDecimal rate) {
        if (base == null) {
            return BigDecimal.ZERO;
        }
        return base.multiply(rate).setScale(0, RoundingMode.HALF_UP);
    }

    private BigDecimal calculatePercentWithVat(BigDecimal base, BigDecimal rate) {
        if (base == null) {
            return BigDecimal.ZERO;
        }
        return base.multiply(rate)
                .multiply(BigDecimal.valueOf(100 + DEFAULT_VAT))
                .divide(BigDecimal.valueOf(100), 0, RoundingMode.HALF_UP);
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

    private String firstNonBlank(String... values) {
        if (values == null) {
            return "";
        }
        for (String value : values) {
            if (!isBlank(value)) {
                return value.trim();
            }
        }
        return "";
    }

    private String saveImageFile(HttpServletRequest request,
                                 String fieldName,
                                 String label,
                                 List<String> errors) throws IOException {
        if (request.getContentType() == null || !request.getContentType().toLowerCase().startsWith("multipart/")) {
            return "";
        }

        Part part;
        try {
            part = request.getPart(fieldName);
        } catch (IllegalStateException e) {
            throw e;
        } catch (Exception e) {
            return "";
        }

        if (part == null || part.getSize() <= 0 || isBlank(part.getSubmittedFileName())) {
            return "";
        }

        if (part.getSize() > 5L * 1024 * 1024) {
            errors.add(label + " không được vượt quá 5MB.");
            return "";
        }

        String contentType = part.getContentType() == null ? "" : part.getContentType().toLowerCase();
        if (!Set.of("image/jpeg", "image/png", "image/webp", "image/gif").contains(contentType)) {
            errors.add(label + " chỉ hỗ trợ JPG, PNG, WEBP hoặc GIF.");
            return "";
        }

        String originalFileName = Path.of(part.getSubmittedFileName()).getFileName().toString();
        String extension = "";
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex >= 0 && dotIndex < originalFileName.length() - 1) {
            extension = originalFileName.substring(dotIndex).toLowerCase().replaceAll("[^a-z0-9.]", "");
        }
        if (isBlank(extension)) {
            extension = ".jpg";
        }

        String fileName = UUID.randomUUID() + extension;
        String uploadRelativePath = "/assets/uploads/tours";
        String realPath = request.getServletContext().getRealPath(uploadRelativePath);
        if (realPath == null) {
            errors.add("Không xác định được thư mục upload ảnh trong ứng dụng.");
            return "";
        }

        Path uploadDir = Path.of(realPath);
        Path target;
        try {
            Files.createDirectories(uploadDir);
            target = uploadDir.resolve(fileName);
        } catch (IOException e) {
            errors.add("Không thể tạo thư mục upload ảnh trong ứng dụng.");
            return "";
        }

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, target);
        } catch (IOException e) {
            errors.add("Không thể lưu " + label.toLowerCase() + ". Hãy thử lại hoặc dùng URL ảnh hợp lệ.");
            return "";
        }

        return uploadRelativePath.substring(1) + "/" + fileName;
    }

    protected static class TourFormData {
        String tourIDRaw;
        String tourCategoryIDRaw;
        String tourName;
        String tourType;
        String numberOfDayRaw;
        String numberOfNightsRaw;
        String startPlace;
        String endPlace;
        String image;
        String introImage;
        String adultPriceRaw;
        String singleRoomSurchargeRaw;
        String tourIntroduce;
        String tourHighlights;
        String pickupAddress;
        String arriveBeforeMinutesRaw;
        String mainTransportType;
        String status;
        boolean featured;
        List<String> uploadErrors = new ArrayList<>();
        String regionIDRaw;
        String scheduleStartDateRaw;
        String scheduleEndDateRaw;
        String departureTimeRaw;
        String expectedReturnTimeRaw;
        String maxParticipantsRaw;
        String scheduleAdultPriceRaw;
        List<TourItinerary> itineraries = new ArrayList<>();
    }
}
