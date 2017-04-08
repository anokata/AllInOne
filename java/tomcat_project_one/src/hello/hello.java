package hello;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;


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
        out.println("</body></html>");
        out.close();
        throw new IOException("hi");
    }
}
