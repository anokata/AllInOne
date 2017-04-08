package ai.eu.work.models;
import ai.eu.work.models.Model;
import ai.eu.work.models.ModelException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class DBModel implements Model {

    Connection connection;
    protected Statement statment;

    public DBModel(Connection connection) {
        this.connection = connection;
    }

    public void close() throws Exception {
        try {
            statment.close();
            //connection.close();
        } catch (SQLException e) {
            throw new Exception(e);
        }
    }

    public ResultSet getData() throws ModelException {
        if (connection == null) {
            throw new ModelException("no connection while getData");
        }
        try {
            this.statment = connection.createStatement(
                    ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
        } catch (SQLException e) {
            throw new ModelException("fail create statement");
        }
        return null;
    }
}
