package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.CartItems;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    private static final String CART_ITEM_SELECT =
            "SELECT "
                    + "ci.cartItemID, "
                    + "ci.cartID, "
                    + "ci.tourScheduleID, "
                    + "ci.serviceID, "
                    + "ci.roomID, "
                    + "ci.numberAdult, "
                    + "ci.numberChildren, "
                    + "ci.quantity, "
                    + "ci.startDate, "
                    + "ci.endDate, "
                    + "ci.addedAt, "
                    + "CASE "
                    + "    WHEN ci.roomID IS NOT NULL THEN N'Room' "
                    + "    WHEN s.serviceType = N'Vehicle' THEN N'Vehicle' "
                    + "    ELSE s.serviceType "
                    + "END AS itemType, "
                    + "CASE "
                    + "    WHEN ci.roomID IS NOT NULL THEN r.roomType "
                    + "    WHEN s.serviceType = N'Vehicle' THEN COALESCE(NULLIF(CONCAT(COALESCE(vb.brandName + N' ', N''), v.vehicleModel), N''), s.serviceName) "
                    + "    ELSE s.serviceName "
                    + "END AS itemName, "
                    + "CASE "
                    + "    WHEN ci.roomID IS NOT NULL THEN r.image "
                    + "    WHEN s.serviceType = N'Vehicle' THEN v.image "
                    + "    ELSE NULL "
                    + "END AS image, "
                    + "CASE "
                    + "    WHEN ci.roomID IS NOT NULL THEN a.[name] "
                    + "    WHEN s.serviceType = N'Vehicle' THEN COALESCE(v.pickup_province, N'') "
                    + "    ELSE NULL "
                    + "END AS providerName, "
                    + "CASE "
                    + "    WHEN ci.roomID IS NOT NULL THEN CONCAT(N'Số phòng: ', ci.quantity, N' | Người lớn: ', ci.numberAdult, N' | Trẻ em: ', ci.numberChildren) "
                    + "    WHEN s.serviceType = N'Vehicle' THEN N'Ngày thuê sẽ chọn ở bước đặt đơn' "
                    + "    ELSE N'' "
                    + "END AS detailText, "
                    + "CASE "
                    + "    WHEN ci.roomID IS NOT NULL THEN CONCAT(N'/accommodation/room/detail?id=', ci.roomID, N'&accommodationId=', a.serviceID, "
                    + "        CASE WHEN ci.startDate IS NOT NULL THEN CONCAT(N'&checkIn=', CONVERT(VARCHAR(10), ci.startDate, 23)) ELSE N'' END, "
                    + "        CASE WHEN ci.endDate IS NOT NULL THEN CONCAT(N'&checkOut=', CONVERT(VARCHAR(10), ci.endDate, 23)) ELSE N'' END, "
                    + "        N'&adults=', ci.numberAdult, N'&children=', ci.numberChildren, N'&rooms=', ci.quantity, N'&guests=', ci.numberAdult + ci.numberChildren) "
                    + "    WHEN s.serviceType = N'Vehicle' THEN CONCAT(N'/vehicle/detail?id=', ci.serviceID) "
                    + "    ELSE N'#' "
                    + "END AS detailUrl, "
                    + "CASE "
                    + "    WHEN ci.roomID IS NOT NULL THEN CONCAT(N'/booking?type=accommodation&roomID=', ci.roomID, N'&accommodationID=', a.serviceID) "
                    + "    WHEN s.serviceType = N'Vehicle' THEN CONCAT(N'/booking?type=vehicle&vehicleID=', ci.serviceID) "
                    + "    ELSE N'#' "
                    + "END AS bookingUrl, "
                    + "CASE "
                    + "    WHEN ci.roomID IS NOT NULL THEN r.priceOfRoom "
                    + "    WHEN s.serviceType = N'Vehicle' THEN v.price_per_day "
                    + "    ELSE 0 "
                    + "END AS unitPrice, "
                    + "CASE "
                    + "    WHEN ci.roomID IS NOT NULL THEN r.priceOfRoom * ci.quantity * "
                    + "        CASE WHEN ci.startDate IS NOT NULL AND ci.endDate IS NOT NULL AND DATEDIFF(DAY, ci.startDate, ci.endDate) > 0 "
                    + "             THEN DATEDIFF(DAY, ci.startDate, ci.endDate) ELSE 1 END "
                    + "    WHEN s.serviceType = N'Vehicle' THEN v.price_per_day * ci.quantity "
                    + "    ELSE 0 "
                    + "END AS subTotal "
                    + "FROM [dbo].[Carts] c "
                    + "JOIN [dbo].[Cart_Items] ci ON c.cartID = ci.cartID "
                    + "LEFT JOIN [dbo].[Service] s ON ci.serviceID = s.serviceID "
                    + "LEFT JOIN [dbo].[Vehicle] v ON ci.serviceID = v.serviceID "
                    + "LEFT JOIN [dbo].[Vehicle_Brand] vb ON v.brandID = vb.brandID "
                    + "LEFT JOIN [dbo].[Room] r ON ci.roomID = r.roomID "
                    + "LEFT JOIN [dbo].[Accommodation] a ON r.serviceID = a.serviceID ";

    public int countCartItems(int userID) {
        String sql = "SELECT COUNT(*) AS total "
                + "FROM [dbo].[Carts] c "
                + "JOIN [dbo].[Cart_Items] ci ON c.cartID = ci.cartID "
                + "WHERE c.userID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi đếm giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public List<CartItems> getCartItems(int userID) {
        List<CartItems> items = new ArrayList<>();

        String sql = CART_ITEM_SELECT
                + "WHERE c.userID = ? "
                + "AND (ci.roomID IS NOT NULL OR s.serviceType = N'Vehicle') "
                + "ORDER BY ci.addedAt DESC, ci.cartItemID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapCartItem(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return items;
    }

    public List<CartItems> getCartItemsByIds(int userID, int[] cartItemIDs) {
        List<CartItems> items = new ArrayList<>();

        if (cartItemIDs == null || cartItemIDs.length == 0) {
            return items;
        }

        String sql = CART_ITEM_SELECT
                + "WHERE c.userID = ? "
                + "AND ci.cartItemID IN (" + buildPlaceholders(cartItemIDs.length) + ") "
                + "AND (ci.roomID IS NOT NULL OR s.serviceType = N'Vehicle') "
                + "ORDER BY ci.addedAt DESC, ci.cartItemID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);

            for (int i = 0; i < cartItemIDs.length; i++) {
                ps.setInt(i + 2, cartItemIDs[i]);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapCartItem(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy mục giỏ hàng đã chọn: " + e.getMessage());
            e.printStackTrace();
        }

        return items;
    }

    public int addServiceItem(int userID, int serviceID, int numberAdult, int numberChildren, int quantity) {
        if (userID <= 0 || serviceID <= 0 || quantity <= 0 || !isValidVehicleService(serviceID)) {
            return 0;
        }

        int cartID = getOrCreateCartID(userID);

        if (cartID <= 0) {
            return 0;
        }

        int existingCartItemID = findExistingServiceItem(cartID, serviceID);

        if (existingCartItemID > 0) {
            boolean updated = updateExistingItem(existingCartItemID, numberAdult, numberChildren, quantity);
            updateCartTimestamp(cartID);
            return updated ? existingCartItemID : 0;
        }

        int cartItemID = insertCartItem(cartID, null, serviceID, null, null, null, numberAdult, numberChildren, quantity);
        updateCartTimestamp(cartID);
        return cartItemID;
    }

    public int addRoomItem(int userID, int roomID, int numberAdult, int numberChildren, int quantity, String checkIn, String checkOut) {
        Date startDate = parseValidDate(checkIn);
        Date endDate = parseValidDate(checkOut);

        if (userID <= 0 || roomID <= 0 || quantity <= 0 || startDate == null || endDate == null || !isValidStayRange(startDate, endDate) || !isValidRoom(roomID)) {
            return 0;
        }

        int cartID = getOrCreateCartID(userID);

        if (cartID <= 0) {
            return 0;
        }

        int existingCartItemID = findExistingRoomItem(cartID, roomID, startDate, endDate);

        if (existingCartItemID > 0) {
            boolean updated = updateExistingItem(existingCartItemID, numberAdult, numberChildren, quantity);
            updateCartTimestamp(cartID);
            return updated ? existingCartItemID : 0;
        }

        int cartItemID = insertCartItem(cartID, null, null, roomID, startDate, endDate, numberAdult, numberChildren, quantity);
        updateCartTimestamp(cartID);
        return cartItemID;
    }

    public boolean updateQuantity(int userID, int cartItemID, int quantity) {
        if (userID <= 0 || cartItemID <= 0 || quantity <= 0) {
            return false;
        }

        String sql = "UPDATE ci "
                + "SET ci.quantity = ?, "
                + "ci.addedAt = GETDATE() "
                + "FROM [dbo].[Cart_Items] ci "
                + "JOIN [dbo].[Carts] c ON ci.cartID = c.cartID "
                + "WHERE c.userID = ? "
                + "AND ci.cartItemID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, userID);
            ps.setInt(3, cartItemID);

            boolean updated = ps.executeUpdate() > 0;

            if (updated) {
                updateCartTimestampByCartItemID(cartItemID);
            }

            return updated;

        } catch (Exception e) {
            System.out.println("Lỗi cập nhật số lượng giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean removeItem(int userID, int cartItemID) {
        if (userID <= 0 || cartItemID <= 0) {
            return false;
        }

        String sql = "DELETE ci "
                + "FROM [dbo].[Cart_Items] ci "
                + "JOIN [dbo].[Carts] c ON ci.cartID = c.cartID "
                + "WHERE c.userID = ? "
                + "AND ci.cartItemID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);
            ps.setInt(2, cartItemID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Lỗi xóa mục giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public BigDecimal calculateTotal(List<CartItems> cartItems) {
        BigDecimal total = BigDecimal.ZERO;

        if (cartItems == null) {
            return total;
        }

        for (CartItems item : cartItems) {
            if (item != null && item.getSubTotal() != null) {
                total = total.add(item.getSubTotal());
            }
        }

        return total;
    }

    private CartItems mapCartItem(ResultSet rs) throws Exception {
        CartItems item = new CartItems();

        item.setCartItemID(rs.getInt("cartItemID"));
        item.setCartID(rs.getInt("cartID"));

        int tourScheduleID = rs.getInt("tourScheduleID");
        item.setTourScheduleID(rs.wasNull() ? null : tourScheduleID);

        int serviceID = rs.getInt("serviceID");
        item.setServiceID(rs.wasNull() ? null : serviceID);

        int roomID = rs.getInt("roomID");
        item.setRoomID(rs.wasNull() ? null : roomID);

        item.setNumberAdult(rs.getInt("numberAdult"));
        item.setNumberChildren(rs.getInt("numberChildren"));
        item.setQuantity(rs.getInt("quantity"));
        item.setStartDate(rs.getDate("startDate"));
        item.setEndDate(rs.getDate("endDate"));
        item.setAddedAt(rs.getTimestamp("addedAt"));
        item.setItemType(rs.getString("itemType"));
        item.setItemName(rs.getString("itemName"));
        item.setImage(rs.getString("image"));
        item.setProviderName(rs.getString("providerName"));
        item.setDetailUrl(rs.getString("detailUrl"));
        item.setBookingUrl(rs.getString("bookingUrl"));
        item.setUnitPrice(rs.getBigDecimal("unitPrice"));
        item.setSubTotal(rs.getBigDecimal("subTotal"));

        String detailText = rs.getString("detailText");

        if ("Room".equalsIgnoreCase(item.getItemType())) {
            if (item.getStartDate() != null && item.getEndDate() != null && item.getNights() > 0) {
                detailText = detailText
                        + " | Nhận phòng: " + item.getStartDate()
                        + " | Trả phòng: " + item.getEndDate()
                        + " | " + item.getNights() + " đêm";
            } else {
                detailText = detailText + " | Chưa có ngày lưu trú";
            }
        }

        item.setDetailText(detailText);

        return item;
    }

    private int getOrCreateCartID(int userID) {
        String sqlSelect = "SELECT cartID FROM [dbo].[Carts] WHERE userID = ?";
        String sqlInsert = "INSERT INTO [dbo].[Carts] (userID, createdAt, updatedAt) VALUES (?, GETDATE(), GETDATE())";

        try (Connection conn = new DBConnection().getConnection()) {
            try (PreparedStatement psSelect = conn.prepareStatement(sqlSelect)) {
                psSelect.setInt(1, userID);

                try (ResultSet rs = psSelect.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("cartID");
                    }
                }
            }

            try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
                psInsert.setInt(1, userID);

                if (psInsert.executeUpdate() == 0) {
                    return 0;
                }

                try (ResultSet keys = psInsert.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi tạo giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    private int insertCartItem(
            int cartID,
            Integer tourScheduleID,
            Integer serviceID,
            Integer roomID,
            Date startDate,
            Date endDate,
            int numberAdult,
            int numberChildren,
            int quantity) {

        String sql = "INSERT INTO [dbo].[Cart_Items] "
                + "(cartID, tourScheduleID, serviceID, roomID, startDate, endDate, numberAdult, numberChildren, quantity, addedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, cartID);

            if (tourScheduleID == null) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, tourScheduleID);
            }

            if (serviceID == null) {
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(3, serviceID);
            }

            if (roomID == null) {
                ps.setNull(4, Types.INTEGER);
            } else {
                ps.setInt(4, roomID);
            }

            if (startDate == null) {
                ps.setNull(5, Types.DATE);
            } else {
                ps.setDate(5, startDate);
            }

            if (endDate == null) {
                ps.setNull(6, Types.DATE);
            } else {
                ps.setDate(6, endDate);
            }

            ps.setInt(7, numberAdult);
            ps.setInt(8, numberChildren);
            ps.setInt(9, quantity);

            if (ps.executeUpdate() == 0) {
                return 0;
            }

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi thêm mục vào giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    private int findExistingServiceItem(int cartID, int serviceID) {
        String sql = "SELECT cartItemID "
                + "FROM [dbo].[Cart_Items] "
                + "WHERE cartID = ? "
                + "AND serviceID = ? "
                + "AND roomID IS NULL "
                + "AND tourScheduleID IS NULL";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartID);
            ps.setInt(2, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cartItemID");
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi kiểm tra dịch vụ trong giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    private int findExistingRoomItem(int cartID, int roomID, Date startDate, Date endDate) {
        String sql = "SELECT cartItemID "
                + "FROM [dbo].[Cart_Items] "
                + "WHERE cartID = ? "
                + "AND roomID = ? "
                + "AND serviceID IS NULL "
                + "AND tourScheduleID IS NULL "
                + "AND startDate = ? "
                + "AND endDate = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartID);
            ps.setInt(2, roomID);
            ps.setDate(3, startDate);
            ps.setDate(4, endDate);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cartItemID");
                }
            }

        } catch (Exception e) {
            System.out.println("Lỗi kiểm tra phòng trong giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    private boolean updateExistingItem(int cartItemID, int numberAdult, int numberChildren, int quantity) {
        String sql = "UPDATE [dbo].[Cart_Items] "
                + "SET numberAdult = ?, "
                + "numberChildren = ?, "
                + "quantity = quantity + ?, "
                + "addedAt = GETDATE() "
                + "WHERE cartItemID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, numberAdult);
            ps.setInt(2, numberChildren);
            ps.setInt(3, quantity);
            ps.setInt(4, cartItemID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Lỗi cập nhật mục đã có trong giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private boolean isValidVehicleService(int serviceID) {
        String sql = "SELECT 1 "
                + "FROM [dbo].[Service] s "
                + "JOIN [dbo].[Vehicle] v ON s.serviceID = v.serviceID "
                + "WHERE s.serviceID = ? "
                + "AND s.serviceType = N'Vehicle' "
                + "AND s.[status] = N'Active' "
                + "AND v.[status] = N'Available'";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            System.out.println("Lỗi kiểm tra xe trước khi thêm giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private boolean isValidRoom(int roomID) {
        String sql = "SELECT 1 "
                + "FROM [dbo].[Room] r "
                + "JOIN [dbo].[Accommodation] a ON r.serviceID = a.serviceID "
                + "JOIN [dbo].[Service] s ON a.serviceID = s.serviceID "
                + "WHERE r.roomID = ? "
                + "AND s.[status] = N'Active' "
                + "AND a.[status] = N'Available' "
                + "AND r.[status] = N'Available' "
                + "AND r.roomAvailability > 0";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            System.out.println("Lỗi kiểm tra phòng trước khi thêm giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private Date parseValidDate(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            return Date.valueOf(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private boolean isValidStayRange(Date startDate, Date endDate) {
        if (startDate == null || endDate == null) {
            return false;
        }

        LocalDate start = startDate.toLocalDate();
        LocalDate end = endDate.toLocalDate();

        if (start.isBefore(LocalDate.now())) {
            return false;
        }

        return ChronoUnit.DAYS.between(start, end) > 0;
    }

    private void updateCartTimestamp(int cartID) {
        String sql = "UPDATE [dbo].[Carts] SET updatedAt = GETDATE() WHERE cartID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartID);
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println("Lỗi cập nhật thời gian giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void updateCartTimestampByCartItemID(int cartItemID) {
        String sql = "UPDATE c "
                + "SET c.updatedAt = GETDATE() "
                + "FROM [dbo].[Carts] c "
                + "JOIN [dbo].[Cart_Items] ci ON c.cartID = ci.cartID "
                + "WHERE ci.cartItemID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartItemID);
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println("Lỗi cập nhật thời gian giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private String buildPlaceholders(int count) {
        StringBuilder builder = new StringBuilder();

        for (int i = 0; i < count; i++) {
            if (i > 0) {
                builder.append(",");
            }

            builder.append("?");
        }

        return builder.toString();
    }
}
