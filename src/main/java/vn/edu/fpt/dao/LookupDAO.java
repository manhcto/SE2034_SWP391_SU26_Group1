package vn.edu.fpt.dao;

import vn.edu.fpt.model.SelectOption;

import java.sql.SQLException;
import java.util.List;

public interface LookupDAO {
    List<SelectOption> getActiveTourCategories() throws SQLException;

    List<SelectOption> getActiveRegions() throws SQLException;

    List<SelectOption> getActiveDestinations() throws SQLException;

    Integer getRegionIDByDestinationID(int destinationID) throws SQLException;

    String getDestinationNameByID(int destinationID) throws SQLException;
}
