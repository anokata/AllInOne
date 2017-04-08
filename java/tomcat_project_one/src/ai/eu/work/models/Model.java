package ai.eu.work.models;
import java.sql.ResultSet;

public interface Model extends AutoCloseable {
    ResultSet getData() throws ModelException;
}
