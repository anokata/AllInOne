package ai.eu.work.models;

public class ModelException extends Exception {

    public ModelException(Throwable e) { 
        initCause(e); 
    } 

    public ModelException(String message) { 
        super(message);
    } 
}
