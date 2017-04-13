package ai.eu.work.app;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

import ai.eu.work.app.accounts.AccountService;
import ai.eu.work.app.accounts.UserProfile;

public class SignInServlet extends HttpServlet {

    private final AccountService accountService;

    public SignInServlet(AccountService accountService) {
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
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.println("Unauthorized");
            return;
        }

        UserProfile profile = accountService.getUserByLogin(login);
        if (profile == null || !profile.getPass().equals(pwd)) {
            response.setContentType("text/html;charset=utf-8");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.println("Unauthorized");
            return;
        } else {
            response.setContentType("text/html;charset=utf-8");
            response.setStatus(HttpServletResponse.SC_OK);
            out.println("Authorized: " + login);
        }
    }
}
