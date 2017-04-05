import java.sql.DriverManager;
import java.util.Enumeration;
import java.sql.Driver;

class jdbcdemo {
    public static void main(String[] args) {
        Enumeration<Driver> ds = DriverManager.getDrivers();
        while (ds.hasMoreElements()) {
            System.out.println("Driver: ");
        }
    }
}
