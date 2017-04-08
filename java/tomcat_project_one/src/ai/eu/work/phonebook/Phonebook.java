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

class PhoneBookModel extends DBModel {

    public PhoneBookModel(Connection connection) {
        super(connection);
    }

    public ResultSet getData() throws ModelException {
        super.getData();
        try {
            ResultSet rs = statment.executeQuery(
                    "select name, phone from phones inner join people on phones.people_id = people.id");
            return rs;
        } catch (SQLException e) {
            throw new ModelException("failed execute query");
        }
    }
}

class PhoneBookView extends TableView {

    public PhoneBookView() {}

    public void view(PrintWriter out, Model model) throws ViewException, ModelException {
        try {
            printTable(out, model);
        } catch (SQLException e) {
            throw new ViewException("Phone table view fail");
        }
    }
}

public class Phonebook extends App {
        
    public void init() throws ServletException { 
        super.init();
        model = new PhoneBookModel(conn);
        view = new PhoneBookView();
    }

    public void appDoGet(HttpServletRequest request,
                    HttpServletResponse response)
            throws ServletException, IOException {

        accept(response.getWriter());
    }

}
