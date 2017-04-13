package ai.eu.work.app;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

import ai.eu.work.app.accounts.AccountService;
import ai.eu.work.app.accounts.UserProfile;

public class SignUpServlet extends HttpServlet {

    private final AccountService accountService;

    public SignUpServlet(AccountService accountService) {
        this.accountService = accountService;
    }

    public void doPost(HttpServletRequest request,
            HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession();
        String key = session.toString();
        PrintWriter out = response.getWriter();
        String login = request.getParameter("login");
        String pwd = request.getParameter("password");

        if (login == null || pwd == null) {
            response.setContentType("text/html;charset=utf-8");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println(".");
            return;
        }

        UserProfile profile = accountService.getUserByLogin(login);
        if (profile == null) {
            profile = new UserProfile(login, pwd, "no@email.com"); /* create user */
            accountService.addNewUser(profile);
            //accountService.addSession(key, profile);
            response.setContentType("text/html;charset=utf-8");
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }
    }
}
