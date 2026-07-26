package vn.edu.fpt.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class AssignmentStatusFlowTest {

    @Test
    void guideMustFollowTheTourLifecycleBeforeCompleting() {
        assertTrue(AssignmentView.canGuideTransitionStatus("Pending", "Accepted"));
        assertTrue(AssignmentView.canGuideTransitionStatus("Accepted", "Confirmed"));
        assertTrue(AssignmentView.canGuideTransitionStatus("Confirmed", "In Progress"));
        assertTrue(AssignmentView.canGuideTransitionStatus("In Progress", "Completed"));

        assertFalse(AssignmentView.canGuideTransitionStatus("Pending", "Completed"));
        assertFalse(AssignmentView.canGuideTransitionStatus("Completed", "In Progress"));
    }
}
