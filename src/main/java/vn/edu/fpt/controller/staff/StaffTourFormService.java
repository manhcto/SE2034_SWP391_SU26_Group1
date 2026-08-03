package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.common.TourImageStorage;
import vn.edu.fpt.model.Tour;
import vn.edu.fpt.model.TourItinerary;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/*
 * Mot noi duy nhat cho nghiep vu form Add/Edit Tour cua Staff.
 * Controller chi dieu huong request; class nay doc form, validate, map sang model va render JSP.
 */
class StaffTourFormService {
    static final String DEFAULT_TOUR_TYPE = "Package";

    private final TourDAO tourDAO;
    private final AdministrativeUnitDAO administrativeUnitDAO;

    StaffTourFormService(TourDAO tourDAO, AdministrativeUnitDAO administrativeUnitDAO) {
        this.tourDAO = tourDAO;
        this.administrativeUnitDAO = administrativeUnitDAO;
    }

    /*
     * Tu AddTourController/EditTourController di vao day khi can hien form.
     * Ham nap dropdown, tour, itinerary, loi validate roi forward den /views/staff/tour-form.jsp.
     */
    void showTourFormPage(HttpServletRequest request,
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
        /*
         * Chuc nang: chuan bi du lieu cho tour-form.jsp.
         * Y nghia trong luong: AddTourController/EditTourController goi ham nay de day dropdown,
         * du lieu tour, itinerary va fieldErrors ve front-end.
         */
        request.setAttribute("tour", tour);
        request.setAttribute("itineraryList", itineraries);
        request.setAttribute("itineraryMap", mapItinerariesByDayNumber(itineraries));
        request.setAttribute("dayCount", limitDayCountToAllowedRange(dayCount));
        request.setAttribute("mode", mode);
        request.setAttribute("formAction", formAction);
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("submitLabel", submitLabel);
        request.setAttribute("categoryList", tourDAO.getActiveCategories());
        request.setAttribute("regionList", tourDAO.getActiveRegions());
        request.setAttribute("administrativeUnitList", administrativeUnitDAO.getActiveProvinces());
        request.setAttribute("nextTourCode", tourDAO.getNextTourCodePreview());

        String status = tour == null ? "" : safeTrim(tour.getStatus());
        boolean editMode = "edit".equalsIgnoreCase(mode);
        boolean coreTourInfoLocked = editMode && isCoreTourInfoLocked(status);
        request.setAttribute("fullEditAllowed", !editMode || canStaffEditAllTourFields(status));
        request.setAttribute("limitedEditAllowed", editMode && canStaffEditLimitedTourFields(status));
        request.setAttribute("coreTourInfoLocked", coreTourInfoLocked);
        request.setAttribute("activeTourContentOnly", editMode && isTourAlreadySelling(status));

        prepareValidationAttributes(request, errors);
        request.getRequestDispatcher("/views/staff/tour-form.jsp").forward(request, response);
    }

    /*
     * Tu submit form HTML di vao day.
     * Ham gom cac input name="..." va file upload thanh FormData de validate truoc khi luu DB.
     */
    FormData collectTourFormInput(HttpServletRequest request) throws ServletException, IOException {
        /*
         * Chuc nang: doc input tu form HTML.
         * Y nghia trong luong: cac name="tourName", "numberOfDay", "coverImageFile"...
         * o tour-form.jsp se duoc gom vao FormData de validate va map sang model Tour.
         */
        FormData data = new FormData();
        List<String> uploadErrors = new ArrayList<>();

        data.tourIDRaw = request.getParameter("tourID");
        data.tourCategoryIDRaw = request.getParameter("tourCategoryID");
        data.tourNameRaw = trimTrailingWhitespace(request.getParameter("tourName"));
        data.tourName = safeTrim(data.tourNameRaw);
        data.tourType = DEFAULT_TOUR_TYPE;
        data.numberOfDayRaw = request.getParameter("numberOfDay");
        data.numberOfNightsRaw = request.getParameter("numberOfNights");
        data.startPlace = safeTrim(request.getParameter("startPlace"));
        data.endPlace = safeTrim(request.getParameter("endPlace"));
        data.image = firstNonBlank(
                saveImageFile(request, "coverImageFile", "Ảnh b\u00ECa", uploadErrors),
                request.getParameter("existingImage")
        );
        data.introImage = firstNonBlank(
                saveImageFile(request, "introImageFile", "Ảnh giới thi\u1EC7u", uploadErrors),
                request.getParameter("existingIntroImage")
        );
        data.tourIntroduceRaw = trimTrailingWhitespace(request.getParameter("tourIntroduce"));
        data.tourHighlightsRaw = trimTrailingWhitespace(request.getParameter("tourHighlights"));
        data.tourIntroduce = safeTrim(data.tourIntroduceRaw);
        data.tourHighlights = safeTrim(data.tourHighlightsRaw);
        data.pickupAddress = "";
        data.arriveBeforeMinutesRaw = null;
        data.status = safeTrim(request.getParameter("status"));
        data.featured = "true".equalsIgnoreCase(request.getParameter("featured"));
        data.regionIDRaw = request.getParameter("regionID");

        int dayCount = limitDayCountToAllowedRange(defaultInt(parsePositiveInt(data.numberOfDayRaw), 1));
        for (int day = 1; day <= dayCount; day++) {
            TourItinerary itinerary = new TourItinerary();
            itinerary.setDayNumber(day);
            String titleRaw = trimTrailingWhitespace(request.getParameter("itineraryTitle_" + day));
            String descriptionRaw = trimTrailingWhitespace(request.getParameter("itineraryDescription_" + day));
            data.itineraryTitleRaw.put(day, titleRaw);
            data.itineraryDescriptionRaw.put(day, descriptionRaw);
            itinerary.setTitle(safeTrim(titleRaw));
            itinerary.setDescription(safeTrim(descriptionRaw));
            itinerary.setMealPlan("");
            itinerary.setTransportNote("");
            itinerary.setImageUrl(firstNonBlank(
                    saveImageFile(request, "itineraryImageFile_" + day,
                            "Ngày " + day + ": ảnh lịch trình", uploadErrors),
                    request.getParameter("existingItineraryImage_" + day)
            ));
            itinerary.setStatus("Active");
            data.itineraries.add(itinerary);
        }
        data.uploadErrors.addAll(uploadErrors);
        return data;
    }

    /*
     * Sau collectTourFormInput(), controller goi ham nay.
     * Neu tra ve errors thi controller quay lai JSP; neu khong co loi moi goi TourDAO de insert/update.
     */
    List<String> validateTourFormInput(FormData data, boolean editMode) {
        /*
         * Chuc nang: validate server-side cho Add/Edit Tour.
         * Y nghia trong luong: neu errors khong rong, controller khong goi DAO luu DB
         * ma forward lai tour-form.jsp de hien loi duoi tung o nhap.
         */
        List<String> errors = new ArrayList<>(data.uploadErrors);

        if (editMode && parsePositiveInt(data.tourIDRaw) == null) {
            errors.add("M\u00E3 tour kh\u00F4ng h\u1EE3p l\u1EC7.");
        }

        Integer categoryID = parsePositiveInt(data.tourCategoryIDRaw);
        if (categoryID == null || !tourDAO.existsActiveCategory(categoryID)) {
            errors.add("Danh mục tour không h\u1EE3p l\u1EC7 ho\u1EB7c \u0111\u00E3 ng\u1EEBng ho\u1EA1t \u0111\u1ED9ng.");
        }

        if (isBlank(data.tourName) || data.tourName.length() < 5 || data.tourName.length() > 100) {
            errors.add("Tên tour ph\u1EA3i t\u1EEB 5 \u0111\u1EBFn 100 k\u00FD t\u1EF1.");
        }
        validateCleanText(data.tourNameRaw, data.tourName, "T\u00EAn tour", 100, true, errors);

        Integer numberOfDay = parsePositiveInt(data.numberOfDayRaw);
        if (numberOfDay == null || numberOfDay > 15) {
            errors.add("S\u1ED1 ng\u00E0y tour ph\u1EA3i l\u00E0 s\u1ED1 t\u1EEB 1 \u0111\u1EBFn 15.");
        }

        String nightsRaw = safeTrim(data.numberOfNightsRaw);
        boolean negativeNights = nightsRaw.startsWith("-");
        Integer numberOfNights = parseNonNegativeInt(data.numberOfNightsRaw);
        if (negativeNights) {
            errors.add("S\u1ED1 \u0111\u00EAm kh\u00F4ng \u0111\u01B0\u1EE3c \u00E2m.");
        }
        if ((!negativeNights && numberOfNights == null) || numberOfNights != null && numberOfNights > 15) {
            errors.add("S\u1ED1 \u0111\u00EAm ph\u1EA3i l\u00E0 s\u1ED1 t\u1EEB 0 \u0111\u1EBFn 15.");
        }
        if (numberOfDay != null && numberOfNights != null) {
            int expectedNights = Math.max(0, numberOfDay - 1);
            if (numberOfNights > numberOfDay) {
                errors.add("S\u1ED1 \u0111\u00EAm kh\u00F4ng \u0111\u01B0\u1EE3c l\u1EDBn h\u01A1n s\u1ED1 ng\u00E0y c\u1EE7a tour.");
            } else if (numberOfNights != expectedNights) {
                errors.add("S\u1ED1 \u0111\u00EAm ph\u1EA3i b\u1EB1ng s\u1ED1 ng\u00E0y tr\u1EEB 1. V\u00ED d\u1EE5 tour 3 ng\u00E0y th\u00EC l\u00E0 2 \u0111\u00EAm.");
            }
        }

        validateProvince(data.startPlace, "\u0110i\u1EC3m kh\u1EDFi h\u00E0nh", errors);
        validateProvince(data.endPlace, "\u0110i\u1EC3m \u0111\u1EBFn", errors);
        validateImage(data.image, "\u1EA2nh b\u00ECa", errors);
        validateImage(data.introImage, "\u1EA2nh gi\u1EDBi thi\u1EC7u", errors);

        if (!isValidStatus(data.status)) {
            errors.add("Trạng thái tour không hợp lệ.");
        }

        Integer regionID = parsePositiveInt(data.regionIDRaw);
        if (regionID == null || !tourDAO.existsActiveRegion(regionID)) {
            errors.add("Khu v\u1EF1c l\u00E0 bắt buộc v\u00E0 ph\u1EA3i \u0111ang ho\u1EA1t \u0111\u1ED9ng.");
        }

        validateLength(data.tourIntroduce, "M\u00F4 t\u1EA3 ng\u1EAFn", 0, 5000, errors);
        validateLength(data.tourHighlights, "\u0110i\u1EC3m n\u1ED5i b\u1EADt c\u1EE7a tour", 0, 5000, errors);
        validateCleanText(data.tourIntroduceRaw, data.tourIntroduce, "M\u00F4 t\u1EA3 ng\u1EAFn", 5000, true, errors);
        validateCleanText(data.tourHighlightsRaw, data.tourHighlights, "Điểm n\u1ED5i b\u1EADt c\u1EE7a tour", 5000, true, errors);
        validateItineraries(data, numberOfDay, errors);
        return errors;
    }

    /*
     * Sau khi validate thanh cong, controller goi ham nay de bien FormData thanh model Tour.
     * Tour tao ra se duoc truyen tiep sang TourDAO.insertTourWithItineraries()
     * hoac TourDAO.updateTourWithItineraries().
     */
    Tour convertFormInputToTour(FormData data, Integer currentUserID) {
        /*
         * Chuc nang: chuyen FormData thanh model Tour.
         * Y nghia trong luong: controller truyen object Tour nay vao TourDAO.insertTourWithItineraries()
         * hoac TourDAO.updateTourWithItineraries() de ghi xuong database.
         */
        Integer tourID = parsePositiveInt(data.tourIDRaw);
        Integer days = parsePositiveInt(data.numberOfDayRaw);
        Integer nights = parseNonNegativeInt(data.numberOfNightsRaw);

        Tour tour = new Tour();
        tour.setTourID(defaultInt(tourID, 0));
        tour.setTourCategoryID(defaultInt(parsePositiveInt(data.tourCategoryIDRaw), 0));
        tour.setTourName(data.tourName);
        tour.setTourType(data.tourType);
        tour.setNumberOfDay(defaultInt(days, 1));
        tour.setNumberOfNights(nights == null && days != null ? Math.max(0, days - 1) : nights);
        tour.setStartPlace(data.startPlace);
        tour.setEndPlace(data.endPlace);
        tour.setImage(data.image);
        tour.setIntroImage(data.introImage);
        tour.setAdultPrice(BigDecimal.ZERO);
        tour.setChildrenPrice(BigDecimal.ZERO);
        tour.setInfantPrice(BigDecimal.ZERO);
        tour.setSingleRoomSurcharge(BigDecimal.ZERO);
        tour.setDepositPercent(0);
        tour.setTourIntroduce(data.tourIntroduce);
        tour.setTourInclude(data.tourHighlights);
        tour.setTourNonInclude("");
        tour.setPickupPointName("");
        tour.setPickupAddress(data.pickupAddress);
        tour.setArriveBeforeMinutes(null);
        tour.setPickupNote("");
        tour.setMainTransportType("");
        tour.setChildPolicyNote("");
        tour.setStatus(isBlank(data.status) ? "Draft" : data.status);
        tour.setFeatured(data.featured);
        tour.setRegionID(parsePositiveInt(data.regionIDRaw));
        tour.setCreatedByUserID(currentUserID);
        tour.setItineraryList(data.itineraries);
        return tour;
    }

    /*
     * Dung khi Staff mo /staff/tour/add lan dau.
     * Tao mot Tour Draft rong de JSP co gia tri mac dinh de render.
     */
    Tour createDefaultDraftTour(int dayCount) {
        Tour tour = new Tour();
        tour.setTourType(DEFAULT_TOUR_TYPE);
        tour.setNumberOfDay(dayCount);
        tour.setNumberOfNights(Math.max(0, dayCount - 1));
        tour.setDepositPercent(0);
        tour.setArriveBeforeMinutes(null);
        tour.setMainTransportType("");
        tour.setStatus("Draft");
        tour.setFeatured(false);
        return tour;
    }

    /*
     * Dung truoc khi render JSP.
     * Dam bao so dong itinerary tren man hinh khop voi so ngay tour.
     */
    List<TourItinerary> buildCompleteItineraryList(List<TourItinerary> itineraries, int dayCount) {
        Map<Integer, TourItinerary> map = mapItinerariesByDayNumber(itineraries);
        List<TourItinerary> result = new ArrayList<>();
        for (int day = 1; day <= limitDayCountToAllowedRange(dayCount); day++) {
            TourItinerary itinerary = map.get(day);
            if (itinerary == null) {
                itinerary = new TourItinerary();
                itinerary.setDayNumber(day);
                itinerary.setStatus("Active");
            }
            result.add(itinerary);
        }
        return result;
    }

    /*
     * Chuyen List<TourItinerary> thanh Map<dayNumber, itinerary> de JSP lay nhanh theo tung ngay.
     */
    Map<Integer, TourItinerary> mapItinerariesByDayNumber(List<TourItinerary> itineraries) {
        Map<Integer, TourItinerary> map = new HashMap<>();
        if (itineraries != null) {
            for (TourItinerary itinerary : itineraries) {
                map.put(itinerary.getDayNumber(), itinerary);
            }
        }
        return map;
    }

    /*
     * Dung khi form can biet hien bao nhieu ngay itinerary.
     * Uu tien request, sau do tour trong DB, cuoi cung mac dinh 2 ngay.
     */
    int resolveDayCountForTourForm(HttpServletRequest request, Tour tour) {
        Integer dayCount = parsePositiveInt(request.getParameter("dayCount"));
        if (dayCount == null) {
            dayCount = parsePositiveInt(request.getParameter("numberOfDay"));
        }
        if (dayCount == null && tour != null && tour.getNumberOfDay() > 0) {
            dayCount = tour.getNumberOfDay();
        }
        return limitDayCountToAllowedRange(dayCount == null ? 2 : dayCount);
    }

    /*
     * Gioi han so ngay trong rule hien tai: it nhat 1 ngay, toi da 15 ngay.
     */
    int limitDayCountToAllowedRange(int dayCount) {
        return Math.min(Math.max(dayCount, 1), 15);
    }

    /*
     * Lay userID Staff dang dang nhap trong session de gan createdByUserID cho tour.
     */
    Integer getLoggedInStaffId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object userObject = session == null ? null : session.getAttribute("user");
        return userObject instanceof User ? ((User) userObject).getUserID() : null;
    }

    Integer parsePositiveInt(String value) {
        try {
            if (isBlank(value)) return null;
            int number = Integer.parseInt(value.trim());
            return number > 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    /*
     * Kiem tra trang thai tour co duoc Staff mo man hinh Edit hay khong.
     */
    boolean canStaffEditTour(String status) {
        return canStaffEditAllTourFields(status) || canStaffEditLimitedTourFields(status);
    }

    /*
     * Draft/Rejected: Staff con duoc sua day du thong tin tour.
     */
    boolean canStaffEditAllTourFields(String status) {
        return "Draft".equals(status) || "Rejected".equals(status);
    }

    /*
     * Pending/Active: Staff chi duoc sua han che de tranh sai du lieu dang ban/cho duyet.
     */
    boolean canStaffEditLimitedTourFields(String status) {
        return "Pending".equals(status) || "Active".equals(status);
    }

    /*
     * Active nghia la tour da duoc Admin duyet va dang ban cho customer.
     */
    boolean isTourAlreadySelling(String status) {
        return "Active".equals(status);
    }

    /*
     * Pending/Active khong duoc sua cac thong tin cot loi de tranh lech voi tour da gui duyet/da ban.
     */
    boolean isCoreTourInfoLocked(String status) {
        return canStaffEditLimitedTourFields(status);
    }

    /*
     * Khi form edit bi khoa thong tin cot loi, khong tin gia tri gui tu browser.
     * Ham lay lai du lieu goc tu DB de tranh Staff sua bang devtools.
     */
    void keepLockedCoreFieldsFromDatabase(FormData data, Tour existingTour) {
        if (data == null || existingTour == null) return;
        data.numberOfDayRaw = String.valueOf(existingTour.getNumberOfDay());
        data.numberOfNightsRaw = existingTour.getNumberOfNights() == null ? "0" : String.valueOf(existingTour.getNumberOfNights());
        data.startPlace = safeTrim(existingTour.getStartPlace());
        data.endPlace = safeTrim(existingTour.getEndPlace());
        data.regionIDRaw = existingTour.getRegionID() == null ? null : String.valueOf(existingTour.getRegionID());
        data.status = safeTrim(existingTour.getStatus());
    }

    /*
     * Tour Active chi duoc sua anh/mo ta/diem noi bat.
     * Ham giu lai cac truong khong duoc sua tu DB, chi merge phan duoc phep thay doi.
     */
    void keepOnlyFieldsAllowedForActiveTour(FormData data, Tour existingTour) {
        if (data == null || existingTour == null) return;
        data.tourCategoryIDRaw = String.valueOf(existingTour.getTourCategoryID());
        data.tourName = safeTrim(existingTour.getTourName());
        data.tourType = isBlank(existingTour.getTourType()) ? DEFAULT_TOUR_TYPE : safeTrim(existingTour.getTourType());
        data.numberOfDayRaw = String.valueOf(existingTour.getNumberOfDay());
        data.numberOfNightsRaw = existingTour.getNumberOfNights() == null ? "0" : String.valueOf(existingTour.getNumberOfNights());
        data.startPlace = safeTrim(existingTour.getStartPlace());
        data.endPlace = safeTrim(existingTour.getEndPlace());
        data.tourIntroduce = firstNonBlank(data.tourIntroduce, existingTour.getTourIntroduce());
        data.pickupAddress = safeTrim(existingTour.getPickupAddress());
        data.arriveBeforeMinutesRaw = existingTour.getArriveBeforeMinutes() == null ? null : String.valueOf(existingTour.getArriveBeforeMinutes());
        data.status = safeTrim(existingTour.getStatus());
        data.featured = existingTour.isFeatured();
        data.regionIDRaw = existingTour.getRegionID() == null ? null : String.valueOf(existingTour.getRegionID());
        data.image = firstNonBlank(data.image, existingTour.getImage());
        data.introImage = firstNonBlank(data.introImage, existingTour.getIntroImage());
        data.itineraries = mergeActiveTourItineraries(data.itineraries, existingTour.getItineraryList());
    }

    private void prepareValidationAttributes(HttpServletRequest request, List<String> errors) {
        Map<String, String> fieldErrors = new LinkedHashMap<>();
        List<String> commonErrors = new ArrayList<>();

        if (errors != null) {
            for (String error : errors) {
                String key = resolveFieldErrorKey(error);
                if (key == null) {
                    commonErrors.add(error);
                } else {
                    fieldErrors.putIfAbsent(key, error);
                }
            }
        }

        request.setAttribute("errors", commonErrors);
        request.setAttribute("fieldErrors", fieldErrors);
    }

    private String resolveFieldErrorKey(String error) {
        String message = safeTrim(error);
        if (startsWithAny(message, "Tên tour")) return "tourName";
        if (startsWithAny(message, "M\u00E3 tour")) return "tourID";
        if (startsWithAny(message, "Danh m\u1EE5c")) return "tourCategoryID";
        if (startsWithAny(message, "S\u1ED1 ng\u00E0y")) return "numberOfDay";
        if (startsWithAny(message, "S\u1ED1 \u0111\u00EAm")) return "numberOfNights";
        if (startsWithAny(message, "\u0110i\u1EC3m kh\u1EDFi h\u00E0nh")) return "startPlace";
        if (startsWithAny(message, "\u0110i\u1EC3m \u0111\u1EBFn")) return "endPlace";
        if (startsWithAny(message, "\u1EA2nh b\u00ECa")) return "coverImage";
        if (startsWithAny(message, "\u1EA2nh gi\u1EDBi thi\u1EC7u")) return "introImage";
        if (startsWithAny(message, "Khu v\u1EF1c")) return "regionID";
        if (startsWithAny(message, "M\u00F4 t\u1EA3 ng\u1EAFn")) return "tourIntroduce";
        if (startsWithAny(message, "\u0110i\u1EC3m n\u1ED5i b\u1EADt")) return "tourHighlights";
        if (startsWithAny(message, "S\u1ED1 d\u00F2ng l\u1ECBch tr\u00ECnh")) return "itinerary";

        java.util.regex.Matcher matcher = java.util.regex.Pattern
                .compile("^Ng\u00E0y\\s+(\\d+):\\s+(.+)$")
                .matcher(message);
        if (matcher.matches()) {
            String day = matcher.group(1);
            String detail = matcher.group(2);
            if (detail.startsWith("ti\u00EAu \u0111\u1EC1")) return "itineraryTitle_" + day;
            if (detail.startsWith("m\u00F4 t\u1EA3")) return "itineraryDescription_" + day;
            if (detail.startsWith("\u1EA3nh")) return "itineraryImage_" + day;
        }
        return null;
    }

    private void validateProvince(String provinceName, String label, List<String> errors) {
        if (isBlank(provinceName) || provinceName.length() < 2 || provinceName.length() > 255) {
            errors.add(label + " phải \u0111\u01B0\u1EE3c ch\u1ECDn t\u1EEB danh s\u00E1ch t\u1EC9nh/th\u00E0nh.");
        } else if (!administrativeUnitDAO.isValidProvinceName(provinceName)) {
            errors.add(label + " ph\u1EA3i l\u00E0 t\u1EC9nh/th\u00E0nh \u0111ang ho\u1EA1t \u0111\u1ED9ng trong h\u1EC7 th\u1ED1ng.");
        }
    }

    private void validateItineraries(FormData data, Integer numberOfDay, List<String> errors) {
        if (numberOfDay == null) return;
        if (data.itineraries.size() != numberOfDay) {
            errors.add("Số d\u00F2ng l\u1ECBch tr\u00ECnh ph\u1EA3i kh\u1EDBp v\u1EDBi s\u1ED1 ng\u00E0y tour.");
        }

        for (TourItinerary itinerary : data.itineraries) {
            int day = itinerary.getDayNumber();
            if (isBlank(itinerary.getTitle()) || itinerary.getTitle().length() < 2 || itinerary.getTitle().length() > 200) {
                errors.add("Ng\u00E0y " + day + ": ti\u00EAu \u0111\u1EC1 l\u1ECBch tr\u00ECnh ph\u1EA3i t\u1EEB 2 \u0111\u1EBFn 200 k\u00FD t\u1EF1.");
            }
            validateLength(itinerary.getDescription(), "Ng\u00E0y " + day + ": m\u00F4 t\u1EA3 l\u1ECBch tr\u00ECnh", 1, 500, errors);
            validateCleanText(data.itineraryTitleRaw.get(day), itinerary.getTitle(),
                    "Ng\u00E0y " + day + ": ti\u00EAu \u0111\u1EC1 l\u1ECBch tr\u00ECnh", 200, true, errors);
            validateRequiredCleanText(data.itineraryDescriptionRaw.get(day), itinerary.getDescription(),
                    "Ng\u00E0y " + day + ": mô tả l\u1ECBch tr\u00ECnh", 500, false, errors);
            validateImage(itinerary.getImageUrl(), "Ngày " + day + ": ảnh l\u1ECBch tr\u00ECnh", errors);
        }
    }

    private void validateLength(String value, String label, int min, int max, List<String> errors) {
        String safeValue = safeTrim(value);
        if (safeValue.length() < min || safeValue.length() > max) {
            errors.add(label + " ph\u1EA3i t\u1EEB " + min + " \u0111\u1EBFn " + max + " k\u00FD t\u1EF1.");
        }
    }

    private void validateCleanText(String rawValue, String trimmedValue, String label,
                                   int max, boolean rejectRepeatedSpaces, List<String> errors) {
        if (isBlank(trimmedValue)) return;
        if (trimmedValue.length() > max) {
            errors.add(label + " không đư\u1EE3c v\u01B0\u1EE3t qu\u00E1 " + max + " k\u00FD t\u1EF1.");
        }
        if (rawValue != null && !rawValue.isEmpty() && Character.isWhitespace(rawValue.charAt(0))) {
            errors.add(label + " kh\u00F4ng \u0111\u01B0\u1EE3c b\u1EAFt \u0111\u1EA7u b\u1EB1ng kho\u1EA3ng tr\u1EAFng.");
        } else if (startsWithInvalidTextCharacter(rawValue)) {
            errors.add(label + " kh\u00F4ng \u0111\u01B0\u1EE3c b\u1EAFt \u0111\u1EA7u b\u1EB1ng ch\u1EEF s\u1ED1 ho\u1EB7c k\u00FD t\u1EF1 \u0111\u1EB7c bi\u1EC7t.");
        }
        if (rejectRepeatedSpaces && trimmedValue.matches(".*\\s{2,}.*")) {
            errors.add(label + " kh\u00F4ng \u0111\u01B0\u1EE3c ch\u1EE9a nhi\u1EC1u kho\u1EA3ng tr\u1EAFng li\u00EAn ti\u1EBFp.");
        }
    }

    private void validateRequiredCleanText(String rawValue, String trimmedValue, String label,
                                           int max, boolean rejectRepeatedSpaces, List<String> errors) {
        if (isBlank(trimmedValue)) {
            errors.add(label + " là bắt buộc.");
            return;
        }
        validateCleanText(rawValue, trimmedValue, label, max, rejectRepeatedSpaces, errors);
    }

    private void validateImage(String imagePath, String label, List<String> errors) {
        if (!isBlank(imagePath) && !isValidImagePath(imagePath)) {
            errors.add(label + " kh\u00F4ng h\u1EE3p l\u1EC7. H\u00E3y upload \u1EA3nh \u0111\u00FAng \u0111\u1ECBnh d\u1EA1ng.");
        }
    }

    private List<TourItinerary> mergeActiveTourItineraries(List<TourItinerary> submittedItineraries,
                                                           List<TourItinerary> existingItineraries) {
        Map<Integer, TourItinerary> submittedByDay = mapItinerariesByDayNumber(submittedItineraries);
        List<TourItinerary> result = new ArrayList<>();
        if (existingItineraries == null) return result;

        for (TourItinerary existing : existingItineraries) {
            TourItinerary submitted = submittedByDay.get(existing.getDayNumber());
            TourItinerary merged = new TourItinerary();
            merged.setItineraryID(existing.getItineraryID());
            merged.setTourID(existing.getTourID());
            merged.setDayNumber(existing.getDayNumber());
            merged.setTitle(existing.getTitle());
            merged.setDescription(existing.getDescription());
            merged.setMealPlan(existing.getMealPlan());
            merged.setTransportNote(existing.getTransportNote());
            merged.setStatus(existing.getStatus());
            merged.setImageUrl(firstNonBlank(submitted == null ? null : submitted.getImageUrl(), existing.getImageUrl()));
            result.add(merged);
        }
        return result;
    }

    private String saveImageFile(HttpServletRequest request, String fieldName, String label, List<String> errors)
            throws IOException, ServletException {
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
            errors.add(label + " kh\u00F4ng \u0111\u01B0\u1EE3c v\u01B0\u1EE3t qu\u00E1 5MB.");
            return "";
        }

        String contentType = part.getContentType() == null ? "" : part.getContentType().toLowerCase();
        if (!TourImageStorage.isAllowedContentType(contentType)) {
            errors.add(label + " ch\u1EC9 h\u1ED7 tr\u1EE3 JPG, PNG, WEBP ho\u1EB7c GIF.");
            return "";
        }

        String originalFileName = Path.of(part.getSubmittedFileName()).getFileName().toString();
        String extension = ".jpg";
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex >= 0 && dotIndex < originalFileName.length() - 1) {
            extension = originalFileName.substring(dotIndex).toLowerCase().replaceAll("[^a-z0-9.]", "");
        }

        try {
            return TourImageStorage.save(part, UUID.randomUUID() + extension);
        } catch (IOException e) {
            errors.add("Kh\u00F4ng th\u1EC3 l\u01B0u " + label.toLowerCase() + ". Hãy thử lại.");
            return "";
        }
    }

    private Integer parseNonNegativeInt(String value) {
        try {
            if (isBlank(value)) return null;
            int number = Integer.parseInt(value.trim());
            return number >= 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    private int defaultInt(Integer value, int defaultValue) {
        return value == null ? defaultValue : value;
    }

    private boolean startsWithAny(String message, String... prefixes) {
        for (String prefix : prefixes) {
            if (message.startsWith(prefix)) return true;
        }
        return false;
    }

    private boolean startsWithInvalidTextCharacter(String value) {
        if (value == null || value.isEmpty()) return false;
        char first = value.charAt(0);
        return Character.isWhitespace(first) || Character.isDigit(first) || !Character.isLetter(first);
    }

    private boolean isValidStatus(String value) {
        return "Draft".equals(value)
                || "Pending".equals(value)
                || "Active".equals(value)
                || "Inactive".equals(value)
                || "Rejected".equals(value);
    }

    private boolean isValidImagePath(String value) {
        return value != null && (value.matches("^https?://.+")
                || value.startsWith("/")
                || value.startsWith("assets/")
                || value.startsWith(TourImageStorage.PUBLIC_PATH_PREFIX));
    }

    private String trimTrailingWhitespace(String value) {
        if (value == null || value.isEmpty()) return value;
        int end = value.length();
        while (end > 0 && Character.isWhitespace(value.charAt(end - 1))) {
            end--;
        }
        return end == value.length() ? value : value.substring(0, end);
    }

    private String firstNonBlank(String... values) {
        if (values == null) return "";
        for (String value : values) {
            if (!isBlank(value)) return value.trim();
        }
        return "";
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    static class FormData {
        String tourIDRaw;
        String tourCategoryIDRaw;
        String tourNameRaw;
        String tourName;
        String tourType;
        String numberOfDayRaw;
        String numberOfNightsRaw;
        String startPlace;
        String endPlace;
        String image;
        String introImage;
        String tourIntroduceRaw;
        String tourIntroduce;
        String tourHighlightsRaw;
        String tourHighlights;
        String pickupAddress;
        String arriveBeforeMinutesRaw;
        String status;
        boolean featured;
        String regionIDRaw;
        List<String> uploadErrors = new ArrayList<>();
        List<TourItinerary> itineraries = new ArrayList<>();
        Map<Integer, String> itineraryTitleRaw = new HashMap<>();
        Map<Integer, String> itineraryDescriptionRaw = new HashMap<>();
    }
}
