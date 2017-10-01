package hello;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.ArrayList;

public class HelloWorld extends HttpServlet {
 
  private String message;
  //static final int blob[] = new int[1024 * 1024 * 1024 * 100];
  //static final ArrayList list = new ArrayList(1024 * 1024);

  public void init() throws ServletException {
      message = "5mem leak.";
  }

  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
            throws ServletException, IOException
  {
      response.setContentType("text/html");

      PrintWriter out = response.getWriter();
      out.println("<h4>" + message + "</h4>");
      out.println("<h4>" + message + "</h4>");
      int blob[] = new int[1024 * 1024 * 1024 * 1000];
      ArrayList list = new ArrayList(102004);
      for (int i = 0; i < 10000; i++) {
		  Object[] objects = new Object[10000000];
          blob[i*2] = blob[i] + 1023;
      }
      out.println("<br> sleep Allocated 2" + Integer.toString(blob[1024]));
      out.println("<h4>" + message + "</h4>");
  }
  
  public void destroy() { }
}
