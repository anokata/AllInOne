package ai.eu.work.phonebook;

import java.io.*;
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import ai.eu.work.models.*;
import ai.eu.work.views.*;
import ai.eu.work.phonebook.App;


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
        PeopleModel pmodel = (PeopleModel) model;
        String name = request.getParameter("name");
        if (name != null) {
            try {
                pmodel.addPeople(name);
            } catch (ModelException e) {
                out.println("not add " + e.getMessage());
                throw new ServletException(e);
            }
        }

        String action = request.getParameter("action");
        String id = request.getParameter("id");
        if (id != null && action.equals("delete")) {
            out.println("try delete ");
            int ID = Integer.parseInt(id);
            out.println(ID + "!");
            try {
                pmodel.deletePeople(ID);
            } catch (ModelException e) {
                out.println("not del " + e.getMessage());
                throw new ServletException(e);
            }
        }
        out.println("bye add");
        response.sendRedirect("people");
        out.close();
    }

}

class Person {
    private String name;
    private long id;

    public Person(String name, long id) {
        this.name = name;
        this.id = id;
    }

    public String getName() {
        return this.name;
    }

    public long getId() {
        return this.id;
    }

}

class PeopleModel extends DBModel {

    public PeopleModel(Connection connection) {
        super(connection);
    }

    public ResultSet getData() throws ModelException {
        super.getData();
        try {
            ResultSet rs = statment.executeQuery(
                    "select id, name from people");
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

    public void deletePeople(int id) throws ModelException {
        try { // TODO delete first all phones or cascade?
            PreparedStatement ps = connection.prepareStatement(
                    "delete from people where id = ? ");
            ps.setInt(1, id);
            ps.execute();
        } catch (SQLException e) {
            throw new ModelException("failed delete");
        }
    }

    public List<Person> getRowsForTable() {
        LinkedList list<Person> = new LinkedList<>();
        ResultSet rs = getData();
        ResultSetMetaData rsmd = rs.getMetaData();

        int numberOfColumns = rsmd.getColumnCount();
        /*for (int i = 1; i <= numberOfColumns; i++) {
            (rsmd.getColumnName(i)); 
        }*/
        if (!rs.first()) return;
        do {
            for (int i = 1; i <= columns; i++) {
                //(rs.getObject()); 
            }
            //list.add(new Person());

        } while (rs.next());
        rs.close();
        return list;
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

    public String getRow(Person p) {
        StringBuilder sb = new StringBuilder();
        sb.append("<tr>");
        sb.append("<td>");
        sb.append("_form_");
        sb.append("</td>");
        sb.append("<td>");
        sb.append(p.getName());
        sb.append("</td>");
        sb.append("</tr>");
        return sb.toString();
    }
}

