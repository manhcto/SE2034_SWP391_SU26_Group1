package vn.edu.fpt.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.Properties;

public class EmailUtil {

    private static final String EMAIL =
            "nguyen141712@gmail.com";

    private static final String APP_PASSWORD =
            "faml dkvc vaml vqtc";

    public static void sendOTP(
            String toEmail,
            String otp) {

        Properties props =
                new Properties();

        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable",
                "true");
        props.put("mail.smtp.host",
                "smtp.gmail.com");
        props.put("mail.smtp.port",
                "587");

        Session session =
                Session.getInstance(
                        props,
                        new Authenticator() {
                            protected PasswordAuthentication
                            getPasswordAuthentication() {

                                return new PasswordAuthentication(
                                        EMAIL,
                                        APP_PASSWORD);
                            }
                        });

        try {

            Message message =
                    new MimeMessage(session);

            message.setFrom(
                    new InternetAddress(EMAIL));

            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail));

            message.setSubject(
                    "WonderVN OTP");

            message.setText(
                    "Mã OTP của bạn là: "
                            + otp);

            Transport.send(message);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}