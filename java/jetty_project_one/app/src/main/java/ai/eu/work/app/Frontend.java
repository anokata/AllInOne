package ai.eu.work.app;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class Frontend extends HttpServlet {

    public void doGet(HttpServletRequest request,
            HttpServletResponse response)
        throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        out.println("hi");
    }
}
