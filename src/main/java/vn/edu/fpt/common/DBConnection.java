package vn.edu.fpt.common;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBConnection {
    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    // Khai báo thông tin kết nối SQL Server của bạn
    private final String serverName = "localhost";
    private final String dbName = "WonderVn";
    private final String portNumber = "1433";
    private final String userID = "sa";        // Thay bằng username SQL Server của bạn
    private final String password = "123";    // Thay bằng password SQL Server của bạn

    public Connection getConnection() throws SQLException {
        String url = "jdbc:sqlserver://" + serverName + ":" + portNumber + ";databaseName=" + dbName + ";encrypt=true;trustServerCertificate=true;";
        return DriverManager.getConnection(url, userID, password);
    }

    // Hàm main dùng để chạy thử xem kết nối thành công hay chưa
    public static void main(String[] args) {
        try {
            DBConnection db = new DBConnection();
            Connection conn = db.getConnection();
            if (conn != null) {
                System.out.println("Kết nối tới cơ sở dữ liệu WonderVn THÀNH CÔNG!");
            }
        } catch (Exception e) {
            System.out.println("Kết nối THẤT BẠI: " + e.getMessage());
        }
    }
}
