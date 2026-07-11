package vn.edu.fpt.DAO;

import vn.edu.fpt.model.AssignmentView;
import vn.edu.fpt.model.TourAssignments;

import java.util.List;

public interface AssignmentDAO {

    List<AssignmentView> getAllAssignments();

    TourAssignments getAssignmentById(int assignmentID);

    boolean addAssignment(TourAssignments assignment);

    boolean updateAssignment(TourAssignments assignment);

    boolean deleteAssignment(int assignmentID);

    List<AssignmentView> getAssignmentsByGuide(int guideID);

    List<AssignmentView> getAssignmentsByGuide(int guideID, String status, String dateFrom, String dateTo);
}
