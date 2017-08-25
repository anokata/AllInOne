package hello;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.ArrayList;

public class HelloWorld extends HttpServlet {
 
  private String message;
  //static final int blob[] = new int[1024 * 1024 * 1024 * 100];
  static final ArrayList list = new ArrayList(1024 * 1024);

  public void init() throws ServletException {
      message = "mem leak.";
  }

  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
            throws ServletException, IOException
  {
      response.setContentType("text/html");

      PrintWriter out = response.getWriter();
      out.println("<h4>" + message + "</h4>");
      int blob[] = new int[1024 * 1024 * 1024 * 100];
      ArrayList list = new ArrayList(1024 * 1024 * 1024);
      for (int i = 0; i < 10; i++) {
          try {
              Thread.sleep(5000);
          } 
          catch(InterruptedException ex) {
              Thread.currentThread().interrupt();
          }
          blob = new int[1024 * 1024 * 1024 * 100];
          list = new ArrayList(1024 * 1024 * 1024);
          out.println("<br> sleep Allocated 1");
      }
  }
  
  public void destroy() { }
}
