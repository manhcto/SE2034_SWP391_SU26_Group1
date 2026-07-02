package vn.edu.fpt.dao;

import vn.edu.fpt.model.StaffProfileDTO;
import vn.edu.fpt.model.StaffProfileUpdateRequest;

public interface StaffProfileDAO {
    StaffProfileDTO findByUserID(Integer userID) throws Exception;

    StaffProfileDTO findDefaultWorkingStaff() throws Exception;

    void updateProfile(StaffProfileUpdateRequest request) throws Exception;
}
