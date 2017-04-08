package ai.eu.work.phonebook;

import ai.eu.work.models.*;
import ai.eu.work.views.*;
import ai.eu.work.phonebook.App;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

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

    public void addPeople(String name) throws ModelException {
        try {
            PreparedStatement ps = connection.prepareStatement(
                    "insert into people (name) values (?)");
            ps.setString(1, name);
            ps.execute();
        } catch (SQLException e) {
            throw new ModelException("failed insert name");
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
        request.getRequestDispatcher("/WEB-INF/nameInputForm.jsp").include(request, response);
        accept(out);
    }

    public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("hi post name is: " + request.getParameter("name"));
        String name = request.getParameter("name");
        if (name != null) {
            PeopleModel pmodel = (PeopleModel) model;
            try {
                pmodel.addPeople(name);
            } catch (ModelException e) {
                out.println("not add " + e.getMessage());
                throw new ServletException(e);
            }
        }
        out.println("bye add");
        response.sendRedirect("people");
        out.close();
    }

}
