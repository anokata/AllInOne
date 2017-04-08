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
import java.lang.reflect.Constructor;

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

    public void accept(Class modelClass, Class viewClass, PrintWriter out) 
            throws ServletException, IOException {
        Model model = null;
        try {
            Constructor<?> ctor = modelClass.getConstructor(Connection.class);
            model = (Model) ctor.newInstance(conn);
            ctor = viewClass.getConstructor();
            View view = (View) ctor.newInstance();
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
