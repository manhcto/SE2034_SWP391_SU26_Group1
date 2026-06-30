package vn.edu.fpt.DAO;

import vn.edu.fpt.DAO.AssignmentDAOImpl;
import vn.edu.fpt.model.AssignmentView;

import java.util.List;

public class TestAssignmentDAO {

    public static void main(String[] args) {

        AssignmentDAOImpl dao = new AssignmentDAOImpl();

        List<AssignmentView> list = dao.getAllAssignments();

        System.out.println("Size = " + list.size());

        for (AssignmentView a : list) {
            System.out.println(
                    a.getAssignmentID() + " | "
                            + a.getTourName() + " | "
                            + a.getGuideName()
            );
        }
    }
}