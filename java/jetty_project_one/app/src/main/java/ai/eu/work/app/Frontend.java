package ai.eu.work.app;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class Frontend extends HttpServlet {

    private int counter = 0;

    public void doGet(HttpServletRequest request,
            HttpServletResponse response)
        throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        String s = request.getParameter("key");
        out.println(s);

        /* auth */
        HttpSession session = request.getSession();
        //Long userId = (Long) session.getAttribute("userId");
        //if (userId == null) {
            //userId = userIdGenerator.getAndIncrement();
            //session.setAttribute("userId", userId);
        //}
        String key = session.toString();
        out.println(key);

        out.println("requested: " + counter++);
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
