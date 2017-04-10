/*
 * TableView
 *
 * Version 0.1
 *
 * 2017 (c) by S.T.
 *
 */
package ai.eu.work.views;

import java.io.*;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import ai.eu.work.models.*;
import ai.eu.work.views.ViewException;
import ai.eu.work.views.View;


public abstract class TableView implements View {

    public TableView() { }

    int idColumn;

    public void printTableHead(PrintWriter out, ResultSetMetaData rsmd)
    throws SQLException {
        out.print("<thead><tr>");
        int numberOfColumns = rsmd.getColumnCount();
        for (int i = 1; i <= numberOfColumns; i++) {
            if (rsmd.getColumnName(i).toLowerCase().equals("id"))
                idColumn = i;
            out.print("<th>");
            out.print(rsmd.getColumnName(i)); 
            out.print("</th>");
        }
        out.print("</tr></thead>");
    }

    public void printIdForm(PrintWriter out, int id) {
        out.print("<form method='post' action=''>");
        out.print("<input type='submit' value='delete' />");
        out.print("<input type='hidden' name='id' value='" + id + "' />");
        out.print("<input type='hidden' name='action' value='delete' />");
        out.print("</form>");
    }

    public void printTableRows(PrintWriter out, ResultSet rs, int columns)
    throws SQLException {
        if (!rs.first()) return;
        do {
           out.print("<tr>");
           for (int i = 1; i <= columns; i++) {
               if (i == idColumn) {
                   out.print("<td>");
                   printIdForm(out, (int)rs.getObject(i));
                   out.print("</td>");
               } else {
                   out.print("<td>");
                   out.println(rs.getObject(i));
                   out.print("</td>");
               }
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
