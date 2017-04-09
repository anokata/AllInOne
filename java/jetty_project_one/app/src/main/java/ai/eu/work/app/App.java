package ai.eu.work.app;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;

import ai.eu.work.app.Frontend;

public class App 
{
    public static void main( String[] args ) throws Exception
    {
        System.out.println( "Hello World!" );
        Frontend frontend = new Frontend();
        Server server = new Server(8081);
        ServletContextHandler context = 
            new ServletContextHandler(ServletContextHandler.SESSIONS);
        server.setHandler(context);
        context.addServlet(new ServletHolder(frontend), "/authform");
        server.start();
        server.join();
    }
}
