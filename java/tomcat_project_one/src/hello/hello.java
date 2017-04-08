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

interface Model {
    ResultSet getData() throws ModelException;
}

class ModelException extends RuntimeException {}

class PhoneBookModel implements Model {

    Connection connection;

    public PhoneBookModel(Connection connection) {
        this.connection = connection;
    }

    public ResultSet getData() throws ModelException {
        if (connection == null) {
            return null;
        }
        try {
            Statement stmt = connection.createStatement(
                    ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = stmt.executeQuery("select * from phones");
            //stmt.close(); // TODO need close? who?
            return rs;
        } catch (SQLException e) {
            throw new ModelException();
        }
    }
}

interface View {
    void view(PrintWriter out, Model model) throws ViewException;
}

class ViewException extends RuntimeException {}

class PhoneBookView implements View {

    public void view(PrintWriter out, Model model) throws ViewException {
        try {
            out.print("<table>");
            ResultSet rs = model.getData();
            ResultSetMetaData rsmd = rs.getMetaData();
            int numberOfColumns = rsmd.getColumnCount();
            rs.first();
            while (rs.next()) {
               out.print("<tr>");
               for (int i = 1; i <= numberOfColumns; i++) {
                   out.print("<td>");
                   out.println(rs.getObject(i));
                   out.print("</td>");
               }
               out.print("</tr>");
            }
            out.print("</table>");
            rs.close();
        } catch (SQLException e) {
            throw new ViewException();
        }
    }
}

public class hello extends HttpServlet {

    final String url = "jdbc:postgresql://localhost/phonebook?user=test&password=test&ssl=false";
    Connection conn;

    public void init() throws ServletException { 
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("can not found pgsql driver class");
        }
        try {
            conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            throw new ServletException("can not connect");
        }
    }
        
    public void destroy() { 
        try {
            conn.close();
        } catch (SQLException e) {
        }
    }

    public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        request.getRequestDispatcher("/WEB-INF/head.jsp").include(request, response);

        //controller
        Model model = new PhoneBookModel(conn);
        View v = new PhoneBookView();
        v.view(out, model);

        out.println("<hr>");
        out.println("</body></html>");
        out.close();
    }

}
