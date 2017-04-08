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

interface Model extends AutoCloseable {
    ResultSet getData() throws ModelException;
}

class ModelException extends Exception {

    public ModelException(Throwable e) { 
        initCause(e); 
    } 

    public ModelException(String message) { 
        super(message);
    } 
}

class DBModel implements Model {

    Connection connection;
    Statement statment;

    public DBModel(Connection connection) {
        this.connection = connection;
    }

    public void close() throws Exception {
        try {
            statment.close();
            connection.close();
        } catch (SQLException e) {
            throw new Exception(e);
        }
    }

    public ResultSet getData() throws ModelException {
        if (connection == null) {
            throw new ModelException("no connection while getData");
        }
        try {
            this.statment = connection.createStatement(
                    ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
        } catch (SQLException e) {
            throw new ModelException("fail create statement");
        }
        return null;
    }
}

class PhoneBookModel extends DBModel {

    public PhoneBookModel(Connection connection) {
        super(connection);
    }

    public ResultSet getData() throws ModelException {
        super.getData();
        try {
            ResultSet rs = statment.executeQuery(
                    "select name, phone from phones inner join people on phones.people_id = people.id");
            return rs;
        } catch (SQLException e) {
            throw new ModelException("failed execute query");
        }
    }
}

interface View {
    void view(PrintWriter out, Model model) throws ViewException, ModelException;
}

abstract class TableView implements View {

    public void printTableHead(PrintWriter out, ResultSetMetaData rsmd)
    throws SQLException {
        out.print("<thead><tr>");
        int numberOfColumns = rsmd.getColumnCount();
        for (int i = 1; i <= numberOfColumns; i++) {
            out.print("<th>");
            out.print(rsmd.getColumnName(i)); 
            out.print("</th>");
        }
        out.print("</tr></thead>");
    }

    public void printTableRows(PrintWriter out, ResultSet rs, int columns)
    throws SQLException {
        rs.first();
        while (rs.next()) {
           out.print("<tr>");
           for (int i = 1; i <= columns; i++) {
               out.print("<td>");
               out.println(rs.getObject(i));
               out.print("</td>");
           }
           out.print("</tr>");
        }
        rs.close();
    }

    public void printTable(PrintWriter out, Model model)
    throws SQLException, ModelException {
        out.print("<table>");
        ResultSet rs = model.getData();
        ResultSetMetaData rsmd = rs.getMetaData();
        printTableHead(out, rsmd);
        printTableRows(out, rs, rsmd.getColumnCount());
        out.print("</table>");
    }
}

class ViewException extends RuntimeException {}

class PhoneBookView extends TableView {

    public void view(PrintWriter out, Model model) throws ViewException, ModelException {
        try {
            printTable(out, model);
        } catch (SQLException e) {
            throw new ViewException();
        }
    }
}

public class hello extends HttpServlet {

    final String url = "jdbc:postgresql://localhost/phonebook?user=test&password=test&ssl=false";
    Connection conn;

    public void init() throws ServletException { 
        // TODO DB abstraction
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
        try (Model model = new PhoneBookModel(conn)) {
            View v = new PhoneBookView();
            v.view(out, model);
        } catch (ViewException | ModelException e) {
            out.print(e.getMessage());
            throw new ServletException(e);
        } catch (Exception e) {
            out.print("serious exception");
            throw new ServletException(e);
        }


        out.println("</body></html>");
        out.close();
    }

}
