package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Room;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    private static final String BASE_SELECT =
            "SELECT " +
                    "roomID, roomType, numberOfRooms, priceOfRoom, [status], serviceID, " +
                    "roomAvailability, [image], [description], bedCount, bedType, " +
                    "maxAdults, maxChildren, roomSize " +
                    "FROM [dbo].[Room] ";

    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();

        String sql = BASE_SELECT +
                "ORDER BY roomID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRoom(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Room> getRoomsByAccommodation(int serviceID) {
        List<Room> list = new ArrayList<>();

        String sql = BASE_SELECT +
                "WHERE serviceID = ? " +
                "ORDER BY priceOfRoom ASC, roomID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRoom(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Room> getAvailableRoomsByAccommodation(int serviceID) {
        List<Room> list = new ArrayList<>();

        String sql = BASE_SELECT +
                "WHERE serviceID = ? " +
                "AND [status] = N'Available' " +
                "AND roomAvailability > 0 " +
                "ORDER BY priceOfRoom ASC, roomID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRoom(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Room> getAvailableRoomsByAccommodationAndDate(int serviceID, String checkIn, String checkOut) {
        List<Room> list = new ArrayList<>();

        LocalDate checkInDate;
        LocalDate checkOutDate;

        try {
            checkInDate = LocalDate.parse(checkIn);
            checkOutDate = LocalDate.parse(checkOut);

            if (!checkOutDate.isAfter(checkInDate)) {
                return list;
            }
        } catch (Exception e) {
            return list;
        }

        String sql =
                "SELECT r.roomID, r.roomType, r.numberOfRooms, r.priceOfRoom, r.[status], r.serviceID, " +
                        "(r.roomAvailability - ISNULL(booked.bookedQuantity, 0)) AS roomAvailability, " +
                        "r.[image], r.[description], r.bedCount, r.bedType, " +
                        "r.maxAdults, r.maxChildren, r.roomSize " +
                        "FROM [dbo].[Room] r " +
                        "LEFT JOIN ( " +
                        "    SELECT bookedRoom.roomID, SUM(bd.quantity) AS bookedQuantity " +
                        "    FROM [dbo].[Booking_Detail] bd " +
                        "    INNER JOIN [dbo].[Booking] b ON bd.bookingID = b.bookingID " +
                        "    INNER JOIN [dbo].[Room] bookedRoom ON bookedRoom.serviceID = bd.serviceID " +
                        "    AND bd.note LIKE CONCAT(N'ROOM_ID=', bookedRoom.roomID, N';%') " +
                        "    WHERE b.bookingType = N'Accommodation' " +
                        "    AND b.[status] IN (N'Pending', N'Confirmed') " +
                        "    AND bd.startDate < ? " +
                        "    AND bd.endDate > ? " +
                        "    GROUP BY bookedRoom.roomID " +
                        ") booked ON booked.roomID = r.roomID " +
                        "WHERE r.serviceID = ? " +
                        "AND r.[status] = N'Available' " +
                        "AND (r.roomAvailability - ISNULL(booked.bookedQuantity, 0)) > 0 " +
                        "ORDER BY r.priceOfRoom ASC, r.roomID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(checkOutDate));
            ps.setDate(2, Date.valueOf(checkInDate));
            ps.setInt(3, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRoom(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Room getRoomById(int roomID) {
        String sql = BASE_SELECT +
                "WHERE roomID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRoom(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean addRoom(Room room) {
        String sql =
                "INSERT INTO [dbo].[Room] " +
                        "(roomType, numberOfRooms, priceOfRoom, [status], serviceID, roomAvailability, " +
                        "[image], [description], bedCount, bedType, maxAdults, maxChildren, roomSize) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, room.getRoomType());
            ps.setInt(2, room.getNumberOfRooms());
            ps.setBigDecimal(3, room.getPriceOfRoom());
            ps.setString(4, room.getStatus());
            ps.setInt(5, room.getServiceID());
            ps.setInt(6, room.getRoomAvailability());
            ps.setString(7, room.getImage());
            ps.setString(8, room.getDescription());
            ps.setInt(9, room.getBedCount());
            ps.setString(10, room.getBedType());
            ps.setInt(11, room.getMaxAdults());
            ps.setInt(12, room.getMaxChildren());
            ps.setBigDecimal(13, room.getRoomSize());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateRoom(Room room) {
        String sql =
                "UPDATE [dbo].[Room] " +
                        "SET roomType = ?, numberOfRooms = ?, priceOfRoom = ?, [status] = ?, " +
                        "serviceID = ?, roomAvailability = ?, [image] = ?, [description] = ?, " +
                        "bedCount = ?, bedType = ?, maxAdults = ?, maxChildren = ?, roomSize = ? " +
                        "WHERE roomID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, room.getRoomType());
            ps.setInt(2, room.getNumberOfRooms());
            ps.setBigDecimal(3, room.getPriceOfRoom());
            ps.setString(4, room.getStatus());
            ps.setInt(5, room.getServiceID());
            ps.setInt(6, room.getRoomAvailability());
            ps.setString(7, room.getImage());
            ps.setString(8, room.getDescription());
            ps.setInt(9, room.getBedCount());
            ps.setString(10, room.getBedType());
            ps.setInt(11, room.getMaxAdults());
            ps.setInt(12, room.getMaxChildren());
            ps.setBigDecimal(13, room.getRoomSize());
            ps.setInt(14, room.getRoomID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteRoom(int roomID) {
        String sqlDeleteFacility =
                "DELETE FROM [dbo].[Room_Facility] WHERE roomID = ?";

        String sqlDeleteRoom =
                "DELETE FROM [dbo].[Room] WHERE roomID = ?";

        Connection conn = null;

        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psFacility = conn.prepareStatement(sqlDeleteFacility)) {
                psFacility.setInt(1, roomID);
                psFacility.executeUpdate();
            }

            try (PreparedStatement psRoom = conn.prepareStatement(sqlDeleteRoom)) {
                psRoom.setInt(1, roomID);
                psRoom.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            rollbackQuietly(conn);
            e.printStackTrace();

        } finally {
            closeQuietly(conn);
        }

        return false;
    }

    public BigDecimal getMinRoomPriceByAccommodation(int serviceID) {
        String sql =
                "SELECT MIN(priceOfRoom) AS minPrice " +
                        "FROM [dbo].[Room] " +
                        "WHERE serviceID = ? " +
                        "AND [status] = N'Available' " +
                        "AND roomAvailability > 0";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal minPrice = rs.getBigDecimal("minPrice");
                    return minPrice == null ? BigDecimal.ZERO : minPrice;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    public int getTotalAvailableRoomsByAccommodation(int serviceID) {
        String sql =
                "SELECT SUM(roomAvailability) AS totalAvailable " +
                        "FROM [dbo].[Room] " +
                        "WHERE serviceID = ? " +
                        "AND [status] = N'Available'";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totalAvailable");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    private Room mapRoom(ResultSet rs) throws Exception {
        Room room = new Room();

        room.setRoomID(rs.getInt("roomID"));
        room.setRoomType(rs.getString("roomType"));
        room.setNumberOfRooms(rs.getInt("numberOfRooms"));

        BigDecimal price = rs.getBigDecimal("priceOfRoom");
        room.setPriceOfRoom(price == null ? BigDecimal.ZERO : price);

        room.setStatus(rs.getString("status"));
        room.setServiceID(rs.getInt("serviceID"));
        room.setRoomAvailability(rs.getInt("roomAvailability"));
        room.setImage(rs.getString("image"));
        room.setDescription(rs.getString("description"));
        room.setBedCount(rs.getInt("bedCount"));
        room.setBedType(rs.getString("bedType"));
        room.setMaxAdults(rs.getInt("maxAdults"));
        room.setMaxChildren(rs.getInt("maxChildren"));

        BigDecimal roomSize = rs.getBigDecimal("roomSize");
        room.setRoomSize(roomSize == null ? BigDecimal.ZERO : roomSize);

        return room;
    }

    private void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void closeQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
