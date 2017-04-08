package ai.eu.work.phonebook;

import ai.eu.work.models.*;
import ai.eu.work.views.*;
import ai.eu.work.phonebook.App;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.ResultSet;

class PeopleModel extends DBModel {

    public PeopleModel(Connection connection) {
        super(connection);
    }

    public ResultSet getData() throws ModelException {
        super.getData();
        try {
            ResultSet rs = statment.executeQuery(
                    "select name from people");
            return rs;
        } catch (SQLException e) {
            throw new ModelException("failed execute query");
        }
    }
}

class PeopleView extends TableView {

    public PeopleView() { }

    public void view(PrintWriter out, Model model) throws ViewException, ModelException {
        try {
            printTable(out, model);
        } catch (SQLException e) {
            throw new ViewException("Table view fail print");
        }
    }
}

public class People extends App {

    public void init() throws ServletException { 
        super.init();
        model = new PeopleModel(conn);
        view = new PeopleView();
    }

    public void appDoGet(HttpServletRequest request,
                    HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        accept(out);
        request.getRequestDispatcher("/WEB-INF/nameInputForm.jsp").include(request, response);
    }

    public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("hi post name is: " + request.getParameter("name"));
        out.close();
    }

}
