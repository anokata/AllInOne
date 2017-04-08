package ai.eu.work.views;

public class ViewException extends RuntimeException {

    public ViewException(Throwable e) { 
        initCause(e); 
    } 

    public ViewException(String message) { 
        super(message);
    } 
}
