import java.sql.DriverManager;
import java.util.Enumeration;
import java.sql.Driver;
import java.sql.Connection;
import java.sql.SQLException;

class jdbcdemo {
    public static void main(String[] args) throws SQLException {
        Enumeration<Driver> ds = DriverManager.getDrivers();
        while (ds.hasMoreElements()) {
            System.out.println("Driver: ");
        }
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("select * from test");
        rs.first();
        while (rs.next()) {
            
        }
        rs.close();
        stmt.close();
        conn.close();
    }
}
