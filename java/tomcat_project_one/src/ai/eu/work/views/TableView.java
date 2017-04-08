package ai.eu.work.views;
import java.io.*;
import ai.eu.work.models.*;
import ai.eu.work.views.ViewException;
import ai.eu.work.views.View;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

public abstract class TableView implements View {

    public TableView() {
    }

    public void printTableHead(PrintWriter out, ResultSetMetaData rsmd)
    throws SQLException {
        out.print("<thead><tr>");
        int numberOfColumns = rsmd.getColumnCount();
        for (int i = 1; i <= numberOfColumns; i++) {
            out.print("<th>");
            out.print(rsmd.getColumnName(i)); 
            out.print("</th>");
        }
        out.print("</tr></thead>");
    }

    public void printTableRows(PrintWriter out, ResultSet rs, int columns)
    throws SQLException {
        if (!rs.first()) return;
        do {
           out.print("<tr>");
           for (int i = 1; i <= columns; i++) {
               out.print("<td>");
               out.println(rs.getObject(i));
               out.print("</td>");
           }
           out.print("</tr>");
        } while (rs.next());
        rs.close();
    }

    public void printTable(PrintWriter out, Model model)
    throws SQLException, ModelException {
        out.print("<table>");
        ResultSet rs = model.getData();
        ResultSetMetaData rsmd = rs.getMetaData();
        printTableHead(out, rsmd);
        printTableRows(out, rs, rsmd.getColumnCount());
        out.print("</table>");
    }
}
