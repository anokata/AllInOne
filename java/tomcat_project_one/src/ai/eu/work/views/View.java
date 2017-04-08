package ai.eu.work.views;
import java.io.*;
import ai.eu.work.models.*;
import ai.eu.work.views.ViewException;

public interface View {
    void view(PrintWriter out, Model model) throws ViewException, ModelException;
}
