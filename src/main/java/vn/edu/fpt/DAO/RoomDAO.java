package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Room;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RoomDAO {

    private static final Logger LOGGER = Logger.getLogger(RoomDAO.class.getName());
    private static final String BASE_SELECT =
            "SELECT r.roomID, r.roomType, r.numberOfRooms, r.priceOfRoom, r.[status], " +
                    "r.accommodationID, r.roomAvailability, r.[image], r.[description], " +
                    "r.bedCount, r.bedType, r.maxAdults, r.maxChildren, r.roomSize, " +
                    "r.createdAt, r.updatedAt, " +
                    "COALESCE(fr.averageRate, CAST(0 AS decimal(3,2))) AS averageRate, " +
                    "COALESCE(fr.reviewCount, 0) AS reviewCount " +
                    "FROM [dbo].[Room] r " +
                    "LEFT JOIN (" +
                    "    SELECT rated.roomID, " +
                    "           CAST(AVG(CAST(rated.rate AS decimal(10,2))) AS decimal(3,2)) AS averageRate, " +
                    "           COUNT(*) AS reviewCount " +
                    "    FROM (" +
                    "        SELECT DISTINCT f.feedbackID, bd.roomID, f.rate " +
                    "        FROM [dbo].[Feedback] f " +
                    "        INNER JOIN [dbo].[Booking_Detail] bd ON bd.bookingID = f.bookingID " +
                    "        WHERE f.[status] = N'Visible' AND bd.roomID IS NOT NULL" +
                    "    ) rated " +
                    "    GROUP BY rated.roomID" +
                    ") fr ON fr.roomID = r.roomID ";
    private static final String INSERT_SQL =
            "INSERT INTO [dbo].[Room] " +
                    "(roomType, numberOfRooms, priceOfRoom, [status], accommodationID, roomAvailability, " +
                    "[image], [description], bedCount, bedType, maxAdults, maxChildren, roomSize) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    public List<Room> getAllRooms() {
        return findMany(BASE_SELECT + "ORDER BY r.roomID DESC", null);
    }

    public List<Room> getRoomsByAccommodation(int accommodationID) {
        String sql = BASE_SELECT +
                "WHERE r.accommodationID = ? ORDER BY r.priceOfRoom ASC, r.roomID DESC";
        return findMany(sql, accommodationID);
    }

    public List<Room> getAvailableRoomsByAccommodation(int accommodationID) {
        String sql = BASE_SELECT +
                "WHERE r.accommodationID = ? AND r.[status] = N'Available' " +
                "AND r.roomAvailability > 0 ORDER BY r.priceOfRoom ASC, r.roomID DESC";
        return findMany(sql, accommodationID);
    }

    public List<Room> getAllAvailableRooms() {
        String sql = BASE_SELECT +
                "WHERE r.[status] IN (N'Available', N'Active') AND r.roomAvailability > 0 " +
                "ORDER BY r.accommodationID, r.priceOfRoom, r.roomID";
        return findMany(sql, null);
    }

    public List<Room> getAllAvailableRoomsByDate(String checkIn, String checkOut) {
        if (!isValidDateRange(checkIn, checkOut)) {
            return new ArrayList<>();
        }

        return applyDateAvailability(getAllAvailableRooms(), checkIn, checkOut, null);
    }

    public List<Room> getAvailableRoomsByAccommodationAndDate(
            int accommodationID, String checkIn, String checkOut) {
        if (!isValidDateRange(checkIn, checkOut)) {
            return new ArrayList<>();
        }

        return applyDateAvailability(
                getAvailableRoomsByAccommodation(accommodationID),
                checkIn,
                checkOut,
                accommodationID);
    }

    public Room getRoomById(int roomID) {
        return findOne(BASE_SELECT + "WHERE r.roomID = ?", roomID, null);
    }

    public Room getRoomByIdAndAccommodation(int roomID, int accommodationID) {
        return findOne(
                BASE_SELECT + "WHERE r.roomID = ? AND r.accommodationID = ?",
                roomID,
                accommodationID);
    }

    public boolean addRoom(Room room) {
        return addRoomAndReturnId(room) > 0;
    }

    public int addRoomAndReturnId(Room room) {
        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(
                     INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            bindRoomForInsert(statement, room);

            if (statement.executeUpdate() == 0) {
                return 0;
            }

            try (ResultSet keys = statement.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : 0;
            }
        } catch (SQLException e) {
            logFailure("add room", e);
            return 0;
        }
    }

    public int addRoomWithFacilities(Room room, int[] facilityIDs) {
        try (Connection connection = new DBConnection().getConnection()) {
            connection.setAutoCommit(false);
            try {
                int roomID = insertRoom(connection, room);
                if (roomID == 0) {
                    connection.rollback();
                    return 0;
                }
                new FacilityDAO().replaceRoomFacilities(connection, roomID, facilityIDs);
                connection.commit();
                return roomID;
            } catch (SQLException e) {
                rollback(connection, e);
                logFailure("add room with facilities", e);
                return 0;
            } finally {
                restoreAutoCommit(connection);
            }
        } catch (SQLException e) {
            logFailure("open room insert transaction", e);
            return 0;
        }
    }

    public boolean updateRoom(Room room) {
        String sql =
                "UPDATE [dbo].[Room] SET roomType = ?, numberOfRooms = ?, priceOfRoom = ?, " +
                        "[status] = ?, roomAvailability = ?, [image] = ?, [description] = ?, " +
                        "bedCount = ?, bedType = ?, maxAdults = ?, maxChildren = ?, roomSize = ?, " +
                        "updatedAt = GETDATE() WHERE roomID = ? AND accommodationID = ?";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            bindRoomForUpdate(statement, room);
            return statement.executeUpdate() == 1;
        } catch (SQLException e) {
            logFailure("update room", e);
            return false;
        }
    }

    public boolean updateRoomWithFacilities(Room room, int[] facilityIDs) {
        String sql =
                "UPDATE [dbo].[Room] SET roomType = ?, numberOfRooms = ?, priceOfRoom = ?, " +
                        "[status] = ?, roomAvailability = ?, [image] = ?, [description] = ?, " +
                        "bedCount = ?, bedType = ?, maxAdults = ?, maxChildren = ?, roomSize = ?, " +
                        "updatedAt = GETDATE() WHERE roomID = ? AND accommodationID = ?";

        try (Connection connection = new DBConnection().getConnection()) {
            connection.setAutoCommit(false);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                bindRoomForUpdate(statement, room);
                if (statement.executeUpdate() != 1) {
                    connection.rollback();
                    return false;
                }
                new FacilityDAO().replaceRoomFacilities(
                        connection, room.getRoomID(), facilityIDs);
                connection.commit();
                return true;
            } catch (SQLException e) {
                rollback(connection, e);
                logFailure("update room with facilities", e);
                return false;
            } finally {
                restoreAutoCommit(connection);
            }
        } catch (SQLException e) {
            logFailure("open room update transaction", e);
            return false;
        }
    }

    public boolean deleteRoom(int roomID) {
        Room room = getRoomById(roomID);
        return room != null && deleteRoom(roomID, room.getAccommodationID());
    }

    public boolean deleteRoom(int roomID, int accommodationID) {
        String deleteRoom =
                "DELETE FROM [dbo].[Room] WHERE roomID = ? AND accommodationID = ?";

        try (Connection connection = new DBConnection().getConnection()) {
            connection.setAutoCommit(false);
            try {
                int deleted = executeRoomDelete(connection, deleteRoom, roomID, accommodationID);

                if (deleted != 1) {
                    connection.rollback();
                    return false;
                }

                connection.commit();
                return true;
            } catch (SQLException e) {
                rollback(connection, e);
                logFailure("delete room", e);
                return false;
            } finally {
                restoreAutoCommit(connection);
            }
        } catch (SQLException e) {
            logFailure("open connection to delete room", e);
            return false;
        }
    }

    public boolean hasBookingReferences(int roomID, int accommodationID) {
        String sql =
                "SELECT TOP 1 1 FROM [dbo].[Booking_Detail] " +
                        "WHERE roomID = ? AND accommodationID = ?";
        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, roomID);
            statement.setInt(2, accommodationID);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        } catch (SQLException e) {
            logFailure("check room booking reference", e);
            return true;
        }
    }

    public boolean deactivateRoom(int roomID, int accommodationID) {
        String sql =
                "UPDATE [dbo].[Room] SET [status] = N'Unavailable', updatedAt = GETDATE() " +
                        "WHERE roomID = ? AND accommodationID = ?";
        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, roomID);
            statement.setInt(2, accommodationID);
            return statement.executeUpdate() == 1;
        } catch (SQLException e) {
            logFailure("deactivate room", e);
            return false;
        }
    }

    public BigDecimal getMinRoomPriceByAccommodation(int accommodationID) {
        String sql =
                "SELECT MIN(priceOfRoom) AS minPrice FROM [dbo].[Room] " +
                        "WHERE accommodationID = ? AND [status] = N'Available' " +
                        "AND roomAvailability > 0";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accommodationID);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    BigDecimal minPrice = resultSet.getBigDecimal("minPrice");
                    return minPrice == null ? BigDecimal.ZERO : minPrice;
                }
            }
        } catch (SQLException e) {
            logFailure("load minimum room price", e);
        }
        return BigDecimal.ZERO;
    }

    public int getTotalAvailableRoomsByAccommodation(int accommodationID) {
        String sql =
                "SELECT SUM(roomAvailability) AS totalAvailable FROM [dbo].[Room] " +
                        "WHERE accommodationID = ? AND [status] = N'Available'";

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accommodationID);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getInt("totalAvailable") : 0;
            }
        } catch (SQLException e) {
            logFailure("load total available rooms", e);
            return 0;
        }
    }

    private List<Room> findMany(String sql, Integer accommodationID) {
        List<Room> rooms = new ArrayList<>();

        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            if (accommodationID != null) {
                statement.setInt(1, accommodationID);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    rooms.add(mapRoom(resultSet));
                }
            }
        } catch (SQLException e) {
            logFailure("load rooms", e);
        }
        return rooms;
    }

    private Room findOne(String sql, int roomID, Integer accommodationID) {
        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, roomID);
            if (accommodationID != null) {
                statement.setInt(2, accommodationID);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? mapRoom(resultSet) : null;
            }
        } catch (SQLException e) {
            logFailure("find room", e);
            return null;
        }
    }

    private void bindRoomForInsert(PreparedStatement statement, Room room) throws SQLException {
        statement.setString(1, room.getRoomType());
        statement.setInt(2, room.getNumberOfRooms());
        statement.setBigDecimal(3, room.getPriceOfRoom());
        statement.setString(4, room.getStatus());
        statement.setInt(5, room.getAccommodationID());
        statement.setInt(6, room.getRoomAvailability());
        statement.setString(7, room.getImage());
        statement.setString(8, room.getDescription());
        statement.setInt(9, room.getBedCount());
        statement.setString(10, room.getBedType());
        statement.setInt(11, room.getMaxAdults());
        statement.setInt(12, room.getMaxChildren());
        statement.setBigDecimal(13, room.getRoomSize());
    }

    private int insertRoom(Connection connection, Room room) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(
                INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            bindRoomForInsert(statement, room);
            if (statement.executeUpdate() != 1) {
                return 0;
            }
            try (ResultSet keys = statement.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : 0;
            }
        }
    }

    private void bindRoomForUpdate(PreparedStatement statement, Room room)
            throws SQLException {
        statement.setString(1, room.getRoomType());
        statement.setInt(2, room.getNumberOfRooms());
        statement.setBigDecimal(3, room.getPriceOfRoom());
        statement.setString(4, room.getStatus());
        statement.setInt(5, room.getRoomAvailability());
        statement.setString(6, room.getImage());
        statement.setString(7, room.getDescription());
        statement.setInt(8, room.getBedCount());
        statement.setString(9, room.getBedType());
        statement.setInt(10, room.getMaxAdults());
        statement.setInt(11, room.getMaxChildren());
        statement.setBigDecimal(12, room.getRoomSize());
        statement.setInt(13, room.getRoomID());
        statement.setInt(14, room.getAccommodationID());
    }

    private int executeRoomDelete(
            Connection connection, String sql, int roomID, int accommodationID) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, roomID);
            statement.setInt(2, accommodationID);
            return statement.executeUpdate();
        }
    }

    private Room mapRoom(ResultSet resultSet) throws SQLException {
        Room room = new Room();
        room.setRoomID(resultSet.getInt("roomID"));
        room.setRoomType(resultSet.getString("roomType"));
        room.setNumberOfRooms(resultSet.getInt("numberOfRooms"));
        room.setPriceOfRoom(resultSet.getBigDecimal("priceOfRoom"));
        room.setStatus(resultSet.getString("status"));
        room.setAccommodationID(resultSet.getInt("accommodationID"));
        room.setRoomAvailability(resultSet.getInt("roomAvailability"));
        room.setImage(resultSet.getString("image"));
        room.setDescription(resultSet.getString("description"));
        room.setBedCount(resultSet.getInt("bedCount"));
        room.setBedType(resultSet.getString("bedType"));
        room.setMaxAdults(resultSet.getInt("maxAdults"));
        room.setMaxChildren(resultSet.getInt("maxChildren"));
        room.setRoomSize(resultSet.getBigDecimal("roomSize"));
        room.setAverageRate(resultSet.getBigDecimal("averageRate"));
        room.setReviewCount(resultSet.getInt("reviewCount"));
        if (resultSet.getTimestamp("createdAt") != null) {
            room.setCreatedAt(resultSet.getTimestamp("createdAt").toLocalDateTime());
        }
        if (resultSet.getTimestamp("updatedAt") != null) {
            room.setUpdatedAt(resultSet.getTimestamp("updatedAt").toLocalDateTime());
        }
        return room;
    }

    private List<Room> applyDateAvailability(
            List<Room> rooms, String checkIn, String checkOut, Integer accommodationID) {
        Map<Integer, Integer> reservedByRoom = loadReservedRoomQuantities(
                checkIn, checkOut, accommodationID);
        if (reservedByRoom == null) {
            return new ArrayList<>();
        }

        List<Room> availableRooms = new ArrayList<>();
        for (Room room : rooms) {
            int available = calculateEffectiveAvailability(
                    room.getRoomAvailability(),
                    reservedByRoom.getOrDefault(room.getRoomID(), 0));
            if (available > 0) {
                room.setRoomAvailability(available);
                availableRooms.add(room);
            }
        }
        return availableRooms;
    }

    private Map<Integer, Integer> loadReservedRoomQuantities(
            String checkIn, String checkOut, Integer accommodationID) {
        String sql =
                "SELECT bd.roomID, SUM(bd.quantity) AS reservedQuantity " +
                        "FROM [dbo].[Booking_Detail] bd " +
                        "INNER JOIN [dbo].[Booking] b ON b.bookingID = bd.bookingID " +
                        "WHERE bd.roomID IS NOT NULL " +
                        "AND bd.startDate < ? AND bd.endDate > ? " +
                        "AND LTRIM(RTRIM(ISNULL(b.[status], N''))) " +
                        "NOT IN (N'Cancelled', N'Đã hủy', N'Hủy') " +
                        (accommodationID == null ? "" : "AND bd.accommodationID = ? ") +
                        "GROUP BY bd.roomID";

        Map<Integer, Integer> reservedByRoom = new HashMap<>();
        try (Connection connection = new DBConnection().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setDate(1, Date.valueOf(checkOut));
            statement.setDate(2, Date.valueOf(checkIn));
            if (accommodationID != null) {
                statement.setInt(3, accommodationID);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    reservedByRoom.put(
                            resultSet.getInt("roomID"),
                            resultSet.getInt("reservedQuantity"));
                }
            }
            return reservedByRoom;
        } catch (SQLException e) {
            logFailure("load date-based room availability", e);
            return null;
        }
    }

    static int calculateEffectiveAvailability(int operationalCapacity, int reservedQuantity) {
        return Math.max(0, operationalCapacity - Math.max(0, reservedQuantity));
    }

    private boolean isValidDateRange(String checkIn, String checkOut) {
        try {
            LocalDate checkInDate = LocalDate.parse(checkIn);
            LocalDate checkOutDate = LocalDate.parse(checkOut);
            return checkOutDate.isAfter(checkInDate);
        } catch (RuntimeException e) {
            return false;
        }
    }

    private void rollback(Connection connection, SQLException cause) {
        try {
            connection.rollback();
        } catch (SQLException rollbackError) {
            cause.addSuppressed(rollbackError);
        }
    }

    private void restoreAutoCommit(Connection connection) {
        try {
            connection.setAutoCommit(true);
        } catch (SQLException e) {
            logFailure("restore auto-commit", e);
        }
    }

    private void logFailure(String operation, SQLException error) {
        LOGGER.log(Level.SEVERE, "Failed to " + operation, error);
    }
}
