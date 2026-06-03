package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.Room;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<Room> getRoomsByAccommodation(int serviceID) {
        List<Room> list = new ArrayList<>();

        String sql = "SELECT * FROM [dbo].[Room] WHERE serviceID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room r = mapRoom(rs);
                    list.add(r);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Room getRoomById(int roomID) {
        String sql = "SELECT * FROM [dbo].[Room] WHERE roomID = ?";

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

    public boolean addRoom(Room r) {
        String sql = "INSERT INTO [dbo].[Room] " +
                "(roomType, numberOfRooms, priceOfRoom, [status], serviceID, roomAvailability) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, r.getRoomType());
            ps.setInt(2, r.getNumberOfRooms());
            ps.setDouble(3, r.getPriceOfRoom());
            ps.setString(4, r.getStatus());
            ps.setInt(5, r.getServiceID());
            ps.setInt(6, r.getRoomAvailability());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateRoom(Room r) {
        String sql = "UPDATE [dbo].[Room] " +
                "SET roomType = ?, numberOfRooms = ?, priceOfRoom = ?, " +
                "[status] = ?, roomAvailability = ? " +
                "WHERE roomID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, r.getRoomType());
            ps.setInt(2, r.getNumberOfRooms());
            ps.setDouble(3, r.getPriceOfRoom());
            ps.setString(4, r.getStatus());
            ps.setInt(5, r.getRoomAvailability());
            ps.setInt(6, r.getRoomID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteRoom(int roomID) {
        String sql = "DELETE FROM [dbo].[Room] WHERE roomID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteRoomsByAccommodation(int serviceID) {
        String sql = "DELETE FROM [dbo].[Room] WHERE serviceID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceID);
            return ps.executeUpdate() >= 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Room mapRoom(ResultSet rs) throws Exception {
        Room r = new Room();

        r.setRoomID(rs.getInt("roomID"));
        r.setRoomType(rs.getString("roomType"));
        r.setNumberOfRooms(rs.getInt("numberOfRooms"));
        r.setPriceOfRoom(rs.getDouble("priceOfRoom"));
        r.setStatus(rs.getString("status"));
        r.setServiceID(rs.getInt("serviceID"));
        r.setRoomAvailability(rs.getInt("roomAvailability"));

        return r;
    }
}