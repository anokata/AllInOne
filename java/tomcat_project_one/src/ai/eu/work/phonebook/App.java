package ai.eu.work.phonebook;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.DriverManager;
import java.util.Enumeration;
import java.sql.Driver;
import java.sql.Connection;
import java.sql.SQLException;

public class App extends HttpServlet {
    final String url = "jdbc:postgresql://localhost/phonebook?user=test&password=test&ssl=false";
    protected Connection conn;

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
        request.getRequestDispatcher("/WEB-INF/head.jsp").include(request, response);
        appDoGet(request, response);
        request.getRequestDispatcher("/WEB-INF/foot.jsp").include(request, response);
        response.getWriter().close();
    }

    public void appDoGet(HttpServletRequest request,
                    HttpServletResponse response)
            throws ServletException, IOException {
    
        PrintWriter out = response.getWriter();
        out.print("Main App");
    }
}
