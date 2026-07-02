package vn.edu.fpt.controller.tour;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.edu.fpt.dao.LookupDAO;
import vn.edu.fpt.dao.StaffDAO;
import vn.edu.fpt.dao.impl.LookupDAOImpl;
import vn.edu.fpt.dao.impl.StaffDAOImpl;
import vn.edu.fpt.model.TourCreateRequest;
import vn.edu.fpt.model.TourDetailDTO;
import vn.edu.fpt.model.TourItineraryRequest;
import vn.edu.fpt.model.TourOptionalServiceRequest;
import vn.edu.fpt.model.TourScheduleDTO;
import vn.edu.fpt.model.TourScheduleRequest;
import vn.edu.fpt.service.Staff.StaffTourService;
import vn.edu.fpt.utils.FileUploadUtils;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Base servlet dùng chung cho nhóm màn hình quản lý tour.
 * Class này KHÔNG có @WebServlet nên không tạo mapping, không gây conflict URL.
 * Nhiệm vụ chỉ là gom các hàm lặp lại: UTF-8, redirect, load dropdown, parse form.
 */
public abstract class BaseTourServlet extends HttpServlet {
    protected static final String TOUR_LIST_JSP = "/WEB-INF/views/staff/tour-list.jsp";
    protected static final String TOUR_VIEW_JSP = "/WEB-INF/views/staff/tour-view.jsp";
    protected static final String TOUR_CREATE_JSP = "/WEB-INF/views/staff/tour-create.jsp";
    protected static final String TOUR_EDIT_JSP = "/WEB-INF/views/staff/tour-edit.jsp";

    protected final StaffTourService tourService = new StaffTourService();
    protected final LookupDAO lookupDAO = new LookupDAOImpl();
    protected final StaffDAO staffDAO = new StaffDAOImpl();

    protected void setUtf8(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    protected void loadListFiltersSafe(HttpServletRequest request) {
        try {
            request.setAttribute("regions", lookupDAO.getActiveRegions());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("regions", new ArrayList<>());
        }

        try {
            request.setAttribute("categories", lookupDAO.getActiveTourCategories());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("categories", new ArrayList<>());
        }
    }

    protected void loadTourLookupsSafe(HttpServletRequest request) {
        try {
            request.setAttribute("categories", lookupDAO.getActiveTourCategories());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("categories", new ArrayList<>());
        }

        try {
            request.setAttribute("regions", lookupDAO.getActiveRegions());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("regions", new ArrayList<>());
        }

        try {
            request.setAttribute("destinations", lookupDAO.getActiveDestinations());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("destinations", new ArrayList<>());
        }

        try {
            request.setAttribute("guides", staffDAO.getActiveGuides());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("guides", new ArrayList<>());
        }

        try {
            request.setAttribute("drivers", staffDAO.getActiveDrivers());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("drivers", new ArrayList<>());
        }
    }

    protected void redirectToTourView(HttpServletRequest request,
                                      HttpServletResponse response,
                                      int tourID,
                                      String paramName,
                                      String message) throws IOException {
        StringBuilder url = new StringBuilder(request.getContextPath())
                .append("/staff/tours/view?id=")
                .append(tourID);

        if (paramName != null && !paramName.isBlank() && message != null && !message.isBlank()) {
            url.append('&')
                    .append(paramName)
                    .append('=')
                    .append(URLEncoder.encode(message, StandardCharsets.UTF_8));
        }
        response.sendRedirect(url.toString());
    }

    protected void forwardCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadTourLookupsSafe(request);
        request.getRequestDispatcher(TOUR_CREATE_JSP).forward(request, response);
    }

    protected void forwardEdit(HttpServletRequest request, HttpServletResponse response, int tourID)
            throws ServletException, IOException {
        try {
            request.setAttribute("tour", tourService.getTourDetail(tourID));
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("systemError", "Không thể tải lại dữ liệu tour sau khi validate lỗi.");
        }
        loadTourLookupsSafe(request);
        request.getRequestDispatcher(TOUR_EDIT_JSP).forward(request, response);
    }

    protected TourCreateRequest buildTourRequest(HttpServletRequest request) {
        TourCreateRequest dto = new TourCreateRequest();
        dto.setTourName(trim(request.getParameter("tourName")));
        dto.setTourCategoryID(parseInt(request.getParameter("tourCategoryID"), 0));
        dto.setRegionID(parseNullableInt(request.getParameter("regionID")));
        dto.setDepartureDestinationID(parseNullableInt(request.getParameter("departureDestinationID")));
        dto.setDestinationID(parseNullableInt(request.getParameter("destinationID")));
        dto.setPickupPointName(trim(request.getParameter("pickupPointName")));
        dto.setPickupTime(parseTime(request.getParameter("pickupTime")));
        dto.setNumberOfDays(parseInt(request.getParameter("numberOfDays"), 1));
        dto.setNumberOfNights(parseInt(request.getParameter("numberOfNights"), 0));
        dto.setMainTransportType(trim(request.getParameter("mainTransportType")));
        dto.setVehicleSeatCount(parseNullableInt(request.getParameter("vehicleSeatCount")));
        dto.setShortDescription(trim(request.getParameter("shortDescription")));
        dto.setDescription(trim(request.getParameter("description")));
        dto.setCoverImageUrl(trim(request.getParameter("existingCoverImageUrl")));
        dto.setImageUrls(parseImageUrls(request));
        dto.setSchedules(parseSchedules(request));
        dto.setItineraries(parseItineraries(request, dto.getNumberOfDays()));
        dto.setOptionalServices(parseOptionalServices(request));
        return dto;
    }

    protected void applyUploadedImages(HttpServletRequest request,
                                       ServletContext servletContext,
                                       TourCreateRequest dto) throws Exception {
        Part cover = getPartQuietly(request, "coverImage");
        String savedCover = FileUploadUtils.saveTourImage(servletContext, cover);
        if (savedCover != null) {
            dto.setCoverImageUrl(savedCover);
        }

        for (Part part : request.getParts()) {
            if ("galleryImages".equals(part.getName()) && part.getSize() > 0) {
                String saved = FileUploadUtils.saveTourImage(servletContext, part);
                if (saved != null) {
                    dto.getImageUrls().add(saved);
                }
            }
        }
    }

    protected TourCreateRequest toRequest(TourDetailDTO tour) {
        TourCreateRequest dto = new TourCreateRequest();
        dto.setTourName(tour.getTourName());
        dto.setTourCategoryID(tour.getTourCategoryID());
        dto.setRegionID(tour.getRegionID());
        dto.setPickupPointName(tour.getPickupPointName());
        dto.setPickupTime(tour.getPickupTime() == null ? null : tour.getPickupTime().toLocalTime());
        dto.setNumberOfDays(tour.getNumberOfDays());
        dto.setNumberOfNights(tour.getNumberOfNights());
        dto.setMainTransportType(tour.getMainTransportType());
        dto.setVehicleSeatCount(tour.getVehicleSeatCount());
        dto.setShortDescription(tour.getShortDescription());
        dto.setDescription(tour.getDescription());
        dto.setCoverImageUrl(tour.getCoverImageUrl());
        dto.setImageUrls(tour.getImageUrls() == null ? new ArrayList<>() : tour.getImageUrls());

        if (tour.getSchedules() != null) {
            for (TourScheduleDTO s : tour.getSchedules()) {
                TourScheduleRequest r = new TourScheduleRequest();
                r.setTourScheduleID(s.getTourScheduleID());
                r.setDepartureDate(s.getDepartureDate() == null ? null : s.getDepartureDate().toLocalDate());
                r.setReturnDate(s.getReturnDate() == null ? null : s.getReturnDate().toLocalDate());
                r.setBookingCloseDate(s.getBookingCloseDate() == null ? null : s.getBookingCloseDate().toLocalDate());
                r.setMinParticipants(s.getMinParticipants());
                r.setMaxParticipants(s.getMaxParticipants());
                r.setGuideStaffID(s.getGuideStaffID());
                r.setDriverStaffID(s.getDriverStaffID());
                r.setAdultPrice(s.getAdultPrice());
                r.setChildPrice(s.getChildPrice());
                r.setInfantPrice(s.getInfantPrice());
                r.setSingleRoomSurcharge(s.getSingleRoomSurcharge());
                r.setDepositPercent(s.getDepositPercent());
                r.setHasVAT(s.isHasVAT());
                r.setVatPercent(s.getVatPercent());
                dto.getSchedules().add(r);
            }
        }

        dto.setItineraries(tour.getItineraries() == null ? new ArrayList<>() : tour.getItineraries());
        dto.setOptionalServices(tour.getOptionalServices() == null ? new ArrayList<>() : tour.getOptionalServices());
        return dto;
    }

    protected int parseInt(String value, int defaultValue) {
        try {
            if (value == null || value.trim().isEmpty()) return defaultValue;
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    protected Integer parseNullableInt(String value) {
        try {
            if (value == null || value.trim().isEmpty()) return null;
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private Part getPartQuietly(HttpServletRequest request, String name) {
        try {
            return request.getPart(name);
        } catch (Exception ex) {
            return null;
        }
    }

    private List<TourScheduleRequest> parseSchedules(HttpServletRequest request) {
        List<TourScheduleRequest> schedules = new ArrayList<>();
        int count = parseInt(request.getParameter("scheduleCount"), 0);
        for (int i = 1; i <= count; i++) {
            if (request.getParameter("scheduleSkip_" + i) != null) {
                continue;
            }
            TourScheduleRequest item = new TourScheduleRequest();
            item.setTourScheduleID(parseNullableInt(request.getParameter("tourScheduleID_" + i)));
            item.setDepartureDate(parseDate(request.getParameter("departureDate_" + i)));
            item.setReturnDate(parseDate(request.getParameter("returnDate_" + i)));
            item.setBookingCloseDate(parseDate(request.getParameter("bookingCloseDate_" + i)));
            item.setMinParticipants(parseInt(request.getParameter("minParticipants_" + i), 0));
            item.setMaxParticipants(parseInt(request.getParameter("maxParticipants_" + i), 0));
            item.setGuideStaffID(parseNullableInt(request.getParameter("guideStaffID_" + i)));
            item.setDriverStaffID(parseNullableInt(request.getParameter("driverStaffID_" + i)));
            item.setAdultPrice(parseMoney(request.getParameter("adultPrice_" + i)));
            item.setChildPrice(parseMoney(request.getParameter("childPrice_" + i)));
            item.setInfantPrice(parseMoney(request.getParameter("infantPrice_" + i)));
            item.setSingleRoomSurcharge(parseMoney(request.getParameter("singleRoomSurcharge_" + i)));
            item.setDepositPercent(parseInt(request.getParameter("depositPercent_" + i), 30));
            boolean hasVAT = request.getParameter("hasVAT_" + i) != null;
            item.setHasVAT(hasVAT);
            item.setVatPercent(hasVAT ? parseInt(request.getParameter("vatPercent_" + i), 8) : 0);
            schedules.add(item);
        }
        return schedules;
    }

    private List<TourItineraryRequest> parseItineraries(HttpServletRequest request, int numberOfDays) {
        List<TourItineraryRequest> list = new ArrayList<>();
        for (int i = 1; i <= numberOfDays; i++) {
            TourItineraryRequest item = new TourItineraryRequest();
            item.setDayNumber(i);
            item.setTransportDescription(trim(request.getParameter("transportDescription_" + i)));
            item.setExperienceActivities(trim(request.getParameter("experienceActivities_" + i)));
            item.setAccommodationDescription(trim(request.getParameter("accommodationDescription_" + i)));
            item.setNote(trim(request.getParameter("note_" + i)));
            list.add(item);
        }
        return list;
    }

    private List<TourOptionalServiceRequest> parseOptionalServices(HttpServletRequest request) {
        List<TourOptionalServiceRequest> list = new ArrayList<>();
        int count = parseInt(request.getParameter("optionalServiceCount"), 0);
        for (int i = 1; i <= count; i++) {
            if (request.getParameter("optionalServiceSelected_" + i) == null) {
                continue;
            }
            TourOptionalServiceRequest item = new TourOptionalServiceRequest();
            item.setExternalServiceCode(trim(request.getParameter("optionalServiceCode_" + i)));
            item.setServiceName(trim(request.getParameter("optionalServiceName_" + i)));
            item.setImageUrl(trim(request.getParameter("optionalServiceImageUrl_" + i)));
            item.setDescription("Dịch vụ cộng thêm hiển thị cho khách khi thanh toán.");
            item.setPrice(parseMoney(request.getParameter("optionalServicePrice_" + i)));
            item.setDefaultSelected(true);
            list.add(item);
        }
        return list;
    }

    private List<String> parseImageUrls(HttpServletRequest request) {
        List<String> list = new ArrayList<>();
        String[] values = request.getParameterValues("existingImageUrls");
        if (values == null) values = request.getParameterValues("imageUrls");
        if (values == null) return list;
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                list.add(value.trim());
            }
        }
        return list;
    }

    private int parseMoney(String value) {
        if (value == null || value.trim().isEmpty()) return 0;
        return parseInt(value.replace(".", "").replace(",", "").replace("VND", "").replace("₫", "").trim(), 0);
    }

    private LocalDate parseDate(String value) {
        try {
            if (value == null || value.trim().isEmpty()) return null;
            return LocalDate.parse(value.trim());
        } catch (Exception ex) {
            return null;
        }
    }

    private LocalTime parseTime(String value) {
        try {
            if (value == null || value.trim().isEmpty()) return null;
            return LocalTime.parse(value.trim());
        } catch (Exception ex) {
            return null;
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
