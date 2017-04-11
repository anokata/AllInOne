package ai.eu.work.phonebook;

import java.io.*;
import java.util.Enumeration;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.http.*;

import ai.eu.work.models.*;
import ai.eu.work.views.*;


public class App extends HttpServlet {
    final String url = "jdbc:postgresql://localhost/phonebook?user=test&password=test&ssl=false";
    protected Connection conn;

    protected Model model;
    protected View view;

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

    public void accept(PrintWriter out) 
            throws ServletException, IOException {
        try {
            view.view(out, model);
        } catch (ViewException | ModelException e) {
            out.println(e.getMessage());
            throw new ServletException(e);
        } catch (Exception e) {
            out.println("serious exception" + e.getMessage());
            throw new ServletException(e);
        } finally {
            try {
                if (model == null) {
                    out.println("empty model");
                    return;
                }
                model.close();
            } catch (Exception e) {
                out.println("very serious exception at close model" + e.getMessage() + "<BR>");
                e.printStackTrace(out);
                throw new ServletException(e);
            }
        }
    }
}
