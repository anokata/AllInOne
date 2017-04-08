package ai.eu.work.phonebook;
import ai.eu.work.models.*;
import ai.eu.work.views.*;

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

class PhoneBookView extends TableView {

    public void view(PrintWriter out, Model model) throws ViewException, ModelException {
        try {
            printTable(out, model);
        } catch (SQLException e) {
            throw new ViewException();
        }
    }
}

public class Phonebook extends HttpServlet {

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
