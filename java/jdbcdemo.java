import java.sql.DriverManager;
import java.util.Enumeration;
import java.sql.Driver;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

class jdbcdemo {
    public static void main(String[] args) throws SQLException {
        String url = "jdbc:postgresql://localhost/phonebook?user=test&password=test&ssl=false";
        Connection conn = DriverManager.getConnection(url);
        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = stmt.executeQuery("select * from phones");
        ResultSetMetaData rsmd = rs.getMetaData();
        int numberOfColumns = rsmd.getColumnCount();
        rs.first();
        while (rs.next()) {
           for (int i = 1; i <= numberOfColumns; i++) {
               System.out.print(rs.getObject(i) + " | "); 
           }
           System.out.println();
        }
        rs.close();
        stmt.close();
        conn.close();
    }
}
