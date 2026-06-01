package vn.edu.fpt.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    private static final String SERVER_NAME = "XUANDAT\\SQLEXPRESS";
    private static final String DATABASE_NAME = "WonderVn";
    private static final String PORT_NUMBER = "1433";
    private static final String USER = "sa";
    private static final String PASSWORD = "1234";

    public Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        String url = "jdbc:sqlserver://" + SERVER_NAME + ":" + PORT_NUMBER
                + ";databaseName=" + DATABASE_NAME
                + ";encrypt=true"
                + ";trustServerCertificate=true";

        return DriverManager.getConnection(url, USER, PASSWORD);
    }

    public static void main(String[] args) {
        try {
            Connection connection = new DBContext().getConnection();

            if (connection != null) {
                System.out.println("Connect database successfully!");
            }

            connection.close();
        } catch (ClassNotFoundException e) {
            System.out.println("SQL Server JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Connect database failed!");
            e.printStackTrace();
        }
    }
}
