package vn.edu.fpt.service.Staff;

import vn.edu.fpt.dao.LookupDAO;
import vn.edu.fpt.dao.StaffDAO;
import vn.edu.fpt.dao.TourDAO;
import vn.edu.fpt.dao.impl.LookupDAOImpl;
import vn.edu.fpt.dao.impl.StaffDAOImpl;
import vn.edu.fpt.dao.impl.TourDAOImpl;
import vn.edu.fpt.exception.BusinessException;
import vn.edu.fpt.exception.FieldValidationException;
import vn.edu.fpt.model.TourCreateRequest;
import vn.edu.fpt.model.TourItineraryRequest;
import vn.edu.fpt.model.TourListItem;
import vn.edu.fpt.model.TourScheduleRequest;
import vn.edu.fpt.model.TourDetailDTO;
import vn.edu.fpt.utils.DBContext;
import vn.edu.fpt.utils.TourBusinessRule;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StaffTourService {
    private final TourDAO tourDAO = new TourDAOImpl();
    private final LookupDAO lookupDAO = new LookupDAOImpl();
    private final StaffDAO staffDAO = new StaffDAOImpl();

    public List<TourListItem> searchTours(String keyword, String status, Integer regionID, Integer categoryID)
            throws SQLException {
        return tourDAO.searchTours(keyword, status, regionID, categoryID);
    }

    public TourDetailDTO getTourDetail(int tourID) throws SQLException {
        return tourDAO.getTourDetailByID(tourID);
    }

    public int createTour(TourCreateRequest request, Integer createdByUserID) throws Exception {
        Map<String, String> errors = validateCreateTour(request, true, null);
        if (!errors.isEmpty()) throw new FieldValidationException(errors);

        try (Connection conn = DBContext.getConnection()) {
            try {
                conn.setAutoCommit(false);
                request.setTourCode(tourDAO.generateNextTourCode(conn));
                for (TourScheduleRequest s : request.getSchedules()) {
                    s.setDisplayPrice(TourBusinessRule.calculateDisplayPrice(s.getAdultPrice(), s.isHasVAT(), s.getVatPercent()));
                }
                int tourID = tourDAO.createTourWithSchedules(conn, request, createdByUserID);
                conn.commit();
                return tourID;
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public void updateTour(int tourID, TourCreateRequest request, Integer updatedByUserID) throws Exception {
        String status = tourDAO.getTourStatus(tourID);
        if (status == null) throw new BusinessException("Không tìm thấy tour.");

        boolean canEditBasic = TourBusinessRule.canEditTourBasic(status);
        boolean canEditSchedule = TourBusinessRule.canAddOrEditSchedule(status);

        if (!canEditBasic && !canEditSchedule) {
            throw new BusinessException("Trạng thái hiện tại không cho phép chỉnh sửa tour.");
        }

        Map<String, String> errors = validateCreateTour(request, canEditBasic, tourID, false);
        if (!errors.isEmpty()) throw new FieldValidationException(errors);

        try (Connection conn = DBContext.getConnection()) {
            try {
                conn.setAutoCommit(false);
                for (TourScheduleRequest s : request.getSchedules()) {
                    s.setDisplayPrice(TourBusinessRule.calculateDisplayPrice(s.getAdultPrice(), s.isHasVAT(), s.getVatPercent()));
                }

                if (canEditBasic) {
                    tourDAO.updateTourFull(conn, tourID, request, updatedByUserID);
                } else {
                    tourDAO.updateSchedulesOnly(conn, tourID, request, updatedByUserID);
                }
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public void submitForApproval(int tourID, Integer userID) throws Exception {
        String status = tourDAO.getTourStatus(tourID);
        if (!TourBusinessRule.canSubmitForApproval(status)) {
            throw new BusinessException("Chỉ tour Nháp hoặc Bị từ chối mới được gửi duyệt.");
        }
        tourDAO.submitForApproval(tourID, userID);
    }

    public void approveTour(int tourID, Integer userID) throws Exception {
        String status = tourDAO.getTourStatus(tourID);
        if (!TourBusinessRule.canApprove(status)) {
            throw new BusinessException("Chỉ tour ở trạng thái Chờ duyệt mới được Admin duyệt và mở bán.");
        }
        tourDAO.approveTour(tourID, userID);
    }

    public void markTourSoldOut(int tourID, Integer userID) throws Exception {
        String status = tourDAO.getTourStatus(tourID);
        if (!TourBusinessRule.canMarkSoldOut(status)) {
            throw new BusinessException("Chỉ tour đang bán mới được chuyển sang trạng thái đã bán.");
        }
        tourDAO.markTourSoldOut(tourID, userID);
    }

    private Map<String, String> validateCreateTour(TourCreateRequest request, boolean validateBasic, Integer editingTourID) throws Exception {
        return validateCreateTour(request, validateBasic, editingTourID, editingTourID == null);
    }

    private Map<String, String> validateCreateTour(TourCreateRequest request, boolean validateBasic, Integer editingTourID, boolean requireLookupIds) throws Exception {
        Map<String, String> errors = new HashMap<>();
        if (validateBasic) {
            validateBasic(request, errors, requireLookupIds);
            validateTransport(request, errors);
            validateItineraries(request, errors);
        }
        validateSchedules(request, errors, editingTourID);
        validateScheduleMonthPriceRule(request.getSchedules(), errors);
        return errors;
    }

    public Map<String, String> validateCreateTour(TourCreateRequest request) throws Exception {
        return validateCreateTour(request, true, null);
    }

    private void validateBasic(TourCreateRequest request, Map<String, String> errors, boolean requireLookupIds) throws SQLException {
        if (isBlank(request.getTourName())) errors.put("tourName", "Tên tour không được để trống.");
        else if (containsBlockedCharacters(request.getTourName())) errors.put("tourName", "Tên tour chứa ký tự không hợp lệ.");

        if (requireLookupIds && request.getTourCategoryID() <= 0) errors.put("tourCategoryID", "Vui lòng chọn danh mục tour.");
        if (requireLookupIds && (request.getRegionID() == null || request.getRegionID() <= 0)) errors.put("regionID", "Vui lòng chọn khu vực.");
        if (requireLookupIds && (request.getDepartureDestinationID() == null || request.getDepartureDestinationID() <= 0)) errors.put("departureDestinationID", "Vui lòng chọn điểm khởi hành.");
        if (requireLookupIds && (request.getDestinationID() == null || request.getDestinationID() <= 0)) errors.put("destinationID", "Vui lòng chọn điểm đến.");

        if (request.getRegionID() != null && request.getRegionID() > 0) {
            if (request.getDepartureDestinationID() != null && request.getDepartureDestinationID() > 0) {
                Integer depRegion = lookupDAO.getRegionIDByDestinationID(request.getDepartureDestinationID());
                if (depRegion == null || !depRegion.equals(request.getRegionID())) errors.put("departureDestinationID", "Điểm khởi hành không thuộc khu vực đã chọn.");
            }
            if (request.getDestinationID() != null && request.getDestinationID() > 0) {
                Integer desRegion = lookupDAO.getRegionIDByDestinationID(request.getDestinationID());
                if (desRegion == null || !desRegion.equals(request.getRegionID())) errors.put("destinationID", "Điểm đến không thuộc khu vực đã chọn.");
            }
        }

        if (isBlank(request.getPickupPointName())) errors.put("pickupPointName", "Vui lòng nhập điểm tập kết cụ thể.");
        else if (containsBlockedCharacters(request.getPickupPointName())) errors.put("pickupPointName", "Điểm tập kết chứa ký tự không hợp lệ.");
        if (request.getPickupTime() == null) errors.put("pickupTime", "Vui lòng nhập giờ tập kết.");
        if (request.getNumberOfDays() <= 0) errors.put("numberOfDays", "Số ngày phải lớn hơn 0.");
        if (request.getNumberOfNights() < 0) errors.put("numberOfNights", "Số đêm không hợp lệ.");
        if (request.getNumberOfNights() >= request.getNumberOfDays()) errors.put("numberOfNights", "Số đêm phải nhỏ hơn số ngày.");
        if (!isBlank(request.getShortDescription()) && containsBlockedCharacters(request.getShortDescription())) errors.put("shortDescription", "Mô tả ngắn chứa ký tự không hợp lệ.");
        if (!isBlank(request.getDescription()) && containsBlockedCharacters(request.getDescription())) errors.put("description", "Mô tả chi tiết chứa ký tự không hợp lệ.");
    }

    private void validateTransport(TourCreateRequest request, Map<String, String> errors) {
        if (!TourBusinessRule.isValidTransport(request.getMainTransportType())) {
            errors.put("mainTransportType", "Phương tiện chỉ được chọn: Ô tô, Xe khách, Xe giường nằm hoặc Đường sắt.");
        }
        if (request.getVehicleSeatCount() == null || request.getVehicleSeatCount() <= 0) {
            errors.put("vehicleSeatCount", "Vui lòng nhập số chỗ phương tiện.");
        }
    }

    private void validateSchedules(TourCreateRequest request, Map<String, String> errors, Integer editingTourID) throws SQLException {
        List<TourScheduleRequest> schedules = request.getSchedules();
        if (schedules == null || schedules.isEmpty()) {
            errors.put("schedules", "Vui lòng thêm ít nhất một lịch khởi hành.");
            return;
        }

        LocalDate today = LocalDate.now();
        for (int i = 0; i < schedules.size(); i++) {
            TourScheduleRequest schedule = schedules.get(i);
            String prefix = "schedule_" + (i + 1);

            if (schedule.getDepartureDate() == null) errors.put(prefix + "_departureDate", "Vui lòng nhập ngày khởi hành.");
            else if (!schedule.getDepartureDate().isAfter(today)) errors.put(prefix + "_departureDate", "Ngày khởi hành phải từ ngày mai trở đi vì ngày chốt bán phải trước ngày khởi hành.");
            if (schedule.getReturnDate() == null) errors.put(prefix + "_returnDate", "Vui lòng nhập ngày về.");

            if (schedule.getDepartureDate() != null && schedule.getReturnDate() != null) {
                if (schedule.getReturnDate().isBefore(schedule.getDepartureDate())) errors.put(prefix + "_returnDate", "Ngày về không được trước ngày khởi hành.");
                long diff = ChronoUnit.DAYS.between(schedule.getDepartureDate(), schedule.getReturnDate()) + 1;
                if (request.getNumberOfDays() > 0 && diff != request.getNumberOfDays()) errors.put(prefix + "_returnDate", "Ngày về phải khớp số ngày của tour.");
            }

            if (schedule.getBookingCloseDate() == null) errors.put(prefix + "_bookingCloseDate", "Vui lòng nhập ngày chốt bán.");
            else {
                if (schedule.getBookingCloseDate().isBefore(today)) errors.put(prefix + "_bookingCloseDate", "Ngày chốt bán không được ở quá khứ.");
                if (schedule.getDepartureDate() != null && !schedule.getBookingCloseDate().isBefore(schedule.getDepartureDate())) errors.put(prefix + "_bookingCloseDate", "Ngày chốt bán phải trước ngày khởi hành.");
            }

            if (schedule.getMinParticipants() <= 0) errors.put(prefix + "_minParticipants", "Số khách tối thiểu phải lớn hơn 0.");
            if (schedule.getMaxParticipants() < schedule.getMinParticipants()) errors.put(prefix + "_maxParticipants", "Số khách tối đa phải lớn hơn hoặc bằng số khách tối thiểu.");
            if (request.getVehicleSeatCount() != null && schedule.getMaxParticipants() > request.getVehicleSeatCount()) errors.put(prefix + "_maxParticipants", "Số khách tối đa không được vượt quá số chỗ phương tiện.");

            if (schedule.getGuideStaffID() == null || schedule.getGuideStaffID() <= 0) errors.put(prefix + "_guideStaffID", "Vui lòng chọn hướng dẫn viên.");
            else if (schedule.getDepartureDate() != null && schedule.getReturnDate() != null) {
                boolean available = staffDAO.isGuideAvailable(schedule.getGuideStaffID(), schedule.getDepartureDate(), schedule.getReturnDate(), schedule.getTourScheduleID());
                if (!available) errors.put(prefix + "_guideStaffID", "Hướng dẫn viên đã có lịch trùng.");
            }

            if (TourBusinessRule.requiresDriver(request.getMainTransportType())) {
                if (schedule.getDriverStaffID() == null || schedule.getDriverStaffID() <= 0) errors.put(prefix + "_driverStaffID", "Vui lòng chọn nhân viên lái xe.");
                else if (schedule.getDepartureDate() != null && schedule.getReturnDate() != null) {
                    boolean driverAvailable = staffDAO.isDriverAvailable(schedule.getDriverStaffID(), schedule.getDepartureDate(), schedule.getReturnDate(), schedule.getTourScheduleID());
                    if (!driverAvailable) errors.put(prefix + "_driverStaffID", "Nhân viên lái xe đã có lịch trùng.");
                }
            } else {
                schedule.setDriverStaffID(null);
            }

            validatePrice(schedule, errors, prefix);
        }
    }

    private void validatePrice(TourScheduleRequest schedule, Map<String, String> errors, String prefix) {
        if (schedule.getAdultPrice() < TourBusinessRule.MIN_ADULT_PRICE || schedule.getAdultPrice() > TourBusinessRule.MAX_ADULT_PRICE) errors.put(prefix + "_adultPrice", "Giá người lớn không hợp lệ.");
        if (schedule.getChildPrice() < 0 || schedule.getChildPrice() > schedule.getAdultPrice()) errors.put(prefix + "_childPrice", "Giá trẻ em phải từ 0 và không vượt giá người lớn.");
        if (schedule.getInfantPrice() < 0 || schedule.getInfantPrice() > schedule.getChildPrice()) errors.put(prefix + "_infantPrice", "Giá em bé phải từ 0 và không vượt giá trẻ em.");
        if (schedule.getSingleRoomSurcharge() < 0 || schedule.getSingleRoomSurcharge() > TourBusinessRule.MAX_SINGLE_ROOM_SURCHARGE) errors.put(prefix + "_singleRoomSurcharge", "Phụ thu phòng đơn không hợp lệ.");
        if (schedule.getDepositPercent() < 0 || schedule.getDepositPercent() > 100) errors.put(prefix + "_depositPercent", "Đặt cọc phải từ 0 đến 100%.");
        if (schedule.isHasVAT() && schedule.getVatPercent() != TourBusinessRule.DEFAULT_VAT_PERCENT) errors.put(prefix + "_vatPercent", "VAT mặc định hiện tại là 8%. Nếu khác cần kiểm tra quy định.");
        if (!schedule.isHasVAT() && schedule.getVatPercent() != 0) errors.put(prefix + "_vatPercent", "Không áp dụng VAT thì VAT phải bằng 0.");
    }

    private void validateScheduleMonthPriceRule(List<TourScheduleRequest> schedules, Map<String, String> errors) {
        Map<String, TourScheduleRequest> priceByMonth = new HashMap<>();
        for (int i = 0; i < schedules.size(); i++) {
            TourScheduleRequest current = schedules.get(i);
            if (current.getDepartureDate() == null) continue;
            String month = current.getDepartureDate().getYear() + "-" + current.getDepartureDate().getMonthValue();
            if (!priceByMonth.containsKey(month)) {
                priceByMonth.put(month, current);
                continue;
            }
            TourScheduleRequest base = priceByMonth.get(month);
            boolean samePrice = current.getAdultPrice() == base.getAdultPrice()
                    && current.getChildPrice() == base.getChildPrice()
                    && current.getInfantPrice() == base.getInfantPrice()
                    && current.getSingleRoomSurcharge() == base.getSingleRoomSurcharge()
                    && current.getDepositPercent() == base.getDepositPercent()
                    && current.isHasVAT() == base.isHasVAT()
                    && current.getVatPercent() == base.getVatPercent();
            if (!samePrice) errors.put("schedulePrice_" + (i + 1), "Các lịch trong cùng tháng phải dùng cùng một giá.");
        }
    }

    private void validateItineraries(TourCreateRequest request, Map<String, String> errors) {
        List<TourItineraryRequest> itineraries = request.getItineraries();
        if (itineraries == null || itineraries.isEmpty()) { errors.put("itineraries", "Vui lòng nhập lịch trình theo ngày."); return; }
        if (request.getNumberOfDays() != itineraries.size()) { errors.put("itineraries", "Số ngày tour phải khớp số ngày lịch trình."); return; }
        for (TourItineraryRequest item : itineraries) {
            if (isBlank(item.getTransportDescription())) errors.put("transportDescription", "Mỗi ngày phải có mô tả di chuyển.");
            if (isBlank(item.getExperienceActivities())) errors.put("experienceActivities", "Mỗi ngày phải có hoạt động trải nghiệm.");
            if (!isBlank(item.getTransportDescription()) && containsBlockedCharacters(item.getTransportDescription())) errors.put("transportDescription", "Mô tả di chuyển chứa ký tự không hợp lệ.");
            if (!isBlank(item.getExperienceActivities()) && containsBlockedCharacters(item.getExperienceActivities())) errors.put("experienceActivities", "Hoạt động trải nghiệm chứa ký tự không hợp lệ.");
        }
    }

    private boolean isBlank(String value) { return value == null || value.trim().isEmpty(); }
    private boolean containsBlockedCharacters(String value) {
        if (value == null) return false;
        String v = value.toLowerCase();
        return v.contains("<") || v.contains(">") || v.contains("{") || v.contains("}") || v.contains("[") || v.contains("]") || v.contains("script");
    }
}
