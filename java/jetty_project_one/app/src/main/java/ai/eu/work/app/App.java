package ai.eu.work.app;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.eclipse.jetty.servlet.DefaultServlet;

import ai.eu.work.app.Frontend;
import ai.eu.work.app.SignUpServlet;
//import ai.eu.work.app.SignInServlet;
import ai.eu.work.app.accounts.AccountService;
import ai.eu.work.app.accounts.UserProfile;

public class App 
{
    public static void main( String[] args ) throws Exception
    {
        AccountService accountService = new AccountService();

        accountService.addNewUser(new UserProfile("test", "123", "no@mail.org"));

        Frontend frontend = new Frontend();
        Server server = new Server(8080);
        ServletContextHandler context = 
            new ServletContextHandler(ServletContextHandler.SESSIONS);
        server.setHandler(context);
        context.addServlet(new ServletHolder(frontend), "/mirror");

        DefaultServlet defaultServlet = new DefaultServlet();
        ServletHolder holderPwd = new ServletHolder("default", defaultServlet);
        holderPwd.setInitParameter("resourceBase", "./src/webapp/");
        context.addServlet(holderPwd, "/*");

        context.addServlet(new ServletHolder(new SignUpServlet(accountService)), "/signup");
        context.addServlet(new ServletHolder(new SignInServlet(accountService)), "/signin");

        server.start();
        java.util.logging.Logger.getGlobal().info("Server started");
        server.join();
    }
}
