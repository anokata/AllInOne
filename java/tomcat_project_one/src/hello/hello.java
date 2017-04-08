package hello;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

import java.sql.DriverManager;
import java.util.Enumeration;
import java.sql.Driver;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

public class hello extends HttpServlet {

    public void init() throws ServletException { }
    public void destroy() { }

    public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("Hi from code");
        doDB(out);

        out.println("</body></html>");
        out.close();
        throw new IOException("hi");
    }

    private void doDB(PrintWriter out) {
        try {
            // TODO connect and load in init
            try {
                Class.forName("org.postgresql.Driver");
            } catch (ClassNotFoundException e) {
                out.println("can not found pgsql driver class");
            }
            String url = "jdbc:postgresql://localhost/phonebook?user=test&password=test&ssl=false";
            Connection conn = DriverManager.getConnection(url);
            Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = stmt.executeQuery("select * from phones");
            ResultSetMetaData rsmd = rs.getMetaData();
            int numberOfColumns = rsmd.getColumnCount();
            rs.first();
            while (rs.next()) {
               for (int i = 1; i <= numberOfColumns; i++) {
                   out.println(rs.getObject(i));
                   out.println(" | ");
               }
               out.println("<br>");
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (SQLException e) {
            out.print("SQLException" + e.getMessage());
        }
    }
}
