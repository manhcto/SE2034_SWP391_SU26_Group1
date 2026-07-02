package vn.edu.fpt.dao.impl;

import vn.edu.fpt.dao.LookupDAO;
import vn.edu.fpt.model.SelectOption;
import vn.edu.fpt.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LookupDAOImpl implements LookupDAO {

    @Override
    public List<SelectOption> getActiveTourCategories() throws SQLException {
        List<SelectOption> list = new ArrayList<>();
        String sql = "SELECT tourCategoryID, tourCategoryName "
                + "FROM dbo.Tour_Category "
                + "WHERE status = N'Active' "
                + "ORDER BY tourCategoryName";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new SelectOption(
                        rs.getInt("tourCategoryID"),
                        rs.getString("tourCategoryName")
                ));
            }
        }

        return list;
    }

    @Override
    public List<SelectOption> getActiveRegions() throws SQLException {
        List<SelectOption> list = new ArrayList<>();
        String sql = "SELECT regionID, regionName "
                + "FROM dbo.Region "
                + "WHERE status = N'Active' "
                + "ORDER BY regionID";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new SelectOption(
                        rs.getInt("regionID"),
                        rs.getString("regionName")
                ));
            }
        }

        return list;
    }

    @Override
    public List<SelectOption> getActiveDestinations() throws SQLException {
        List<SelectOption> list = new ArrayList<>();
        String sql = "SELECT destinationID, destinationName, regionID "
                + "FROM dbo.Destination "
                + "WHERE status = N'Active' "
                + "ORDER BY destinationName";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new SelectOption(
                        rs.getInt("destinationID"),
                        rs.getString("destinationName"),
                        (Integer) rs.getObject("regionID")
                ));
            }
        }

        return list;
    }

    @Override
    public Integer getRegionIDByDestinationID(int destinationID) throws SQLException {
        String sql = "SELECT regionID FROM dbo.Destination WHERE destinationID = ? AND status = N'Active'";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, destinationID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return (Integer) rs.getObject("regionID");
                }
            }
        }

        return null;
    }

    @Override
    public String getDestinationNameByID(int destinationID) throws SQLException {
        String sql = "SELECT destinationName FROM dbo.Destination WHERE destinationID = ? AND status = N'Active'";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, destinationID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("destinationName");
                }
            }
        }

        return null;
    }
}
