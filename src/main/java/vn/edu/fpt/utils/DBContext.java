package vn.edu.fpt.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBContext {
    private static final String SERVER_NAME = "localhost";
    private static final String DATABASE_NAME = "WonderVn";
    private static final String PORT_NUMBER = "1433";
    private static final String USER = "sa";
    private static final String PASSWORD = "1234";
    private static final String DRIVER_CLASS = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

    private static boolean driverLoaded = false;

    private DBContext() {
    }

    public static Connection getConnection() throws SQLException {
        loadDriver();

        StringBuilder url = new StringBuilder("jdbc:sqlserver://");
        url.append(SERVER_NAME);

        if (PORT_NUMBER != null && !PORT_NUMBER.trim().isEmpty()) {
            url.append(":").append(PORT_NUMBER.trim());
        }

        url.append(";databaseName=").append(DATABASE_NAME);
        url.append(";encrypt=true");
        url.append(";trustServerCertificate=true");
        url.append(";loginTimeout=30");

        return DriverManager.getConnection(url.toString(), USER, PASSWORD);
    }

    private static synchronized void loadDriver() throws SQLException {
        if (driverLoaded) {
            return;
        }

        try {
            Class.forName(DRIVER_CLASS);
            driverLoaded = true;
        } catch (ClassNotFoundException ex) {
            throw new SQLException("Không tìm thấy SQL Server JDBC Driver. Kiểm tra dependency mssql-jdbc.", ex);
        }
    }

    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            System.out.println("Connect database successfully!");
        } catch (SQLException ex) {
            System.out.println("Connect database failed!");
            ex.printStackTrace();
        }
    }
}
