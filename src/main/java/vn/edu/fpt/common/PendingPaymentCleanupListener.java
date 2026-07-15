package vn.edu.fpt.common;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import vn.edu.fpt.DAO.BookingDAO;
import vn.edu.fpt.DAO.PaymentDAO;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class PendingPaymentCleanupListener implements ServletContextListener {
    private ScheduledExecutorService scheduler;
    private ServletContext servletContext;

    @Override
    public void contextInitialized(ServletContextEvent event) {
        servletContext = event.getServletContext();
        scheduler = Executors.newSingleThreadScheduledExecutor(task -> {
            Thread thread = new Thread(task, "wondervn-payment-expiry");
            thread.setDaemon(true);
            return thread;
        });
        scheduler.scheduleWithFixedDelay(this::releaseExpiredReservations,
                0, 1, TimeUnit.MINUTES);
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
    }

    private void releaseExpiredReservations() {
        try {
            PaymentDAO paymentDAO = new PaymentDAO();
            BookingDAO bookingDAO = new BookingDAO();
            for (int bookingID : paymentDAO.findExpiredPendingBookingIDs()) {
                bookingDAO.releasePendingPaymentReservation(
                        bookingID,
                        true,
                        "Hết thời gian giữ chỗ thanh toán 15 phút."
                );
            }
        } catch (Exception e) {
            if (servletContext != null) {
                servletContext.log("Không thể hoàn chỗ thanh toán quá hạn", e);
            }
        }
    }
}
