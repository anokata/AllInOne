import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;
import java.util.*;

public class ListDemo extends JPanel
            implements KeyListener {
    private JList list;
    private DefaultListModel listModel;

    private static final String hireString = "Hire";
    private JTextField employeeName;

    public ListDemo() {
        super(new BorderLayout());

        listModel = new DefaultListModel();

        for (Object s : Elements.getRoot()) {
            listModel.addElement(s);
        }


        list = new JList(listModel);
        list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        list.setSelectedIndex(0);
        list.setVisibleRowCount(5);
        JScrollPane listScrollPane = new JScrollPane(list);

        JButton hireButton = new JButton(hireString);
        hireButton.setActionCommand(hireString);
        //hireButton.addActionListener(hireListener);
        hireButton.setEnabled(false);

        employeeName = new JTextField(10);
        String name = listModel.getElementAt(
                              list.getSelectedIndex()).toString();

        JPanel buttonPane = new JPanel();
        buttonPane.setLayout(new BoxLayout(buttonPane,
                                           BoxLayout.LINE_AXIS));
        buttonPane.add(new JSeparator(SwingConstants.VERTICAL));
        buttonPane.add(Box.createHorizontalStrut(5));
        buttonPane.add(employeeName);
        buttonPane.add(hireButton);
        buttonPane.setBorder(BorderFactory.createEmptyBorder(5,5,5,5));

        add(listScrollPane, BorderLayout.CENTER);
        add(buttonPane, BorderLayout.PAGE_END);
        list.addKeyListener(this);
    }


    /** Handle the key typed event from the text field. */
    public void keyTyped(KeyEvent e) {
        displayInfo(e, "KEY TYPED: ");
    }
    
    /** Handle the key pressed event from the text field. */
    public void keyPressed(KeyEvent e) {
        displayInfo(e, "KEY PRESSED: ");
    }
    
    /** Handle the key released event from the text field. */
    public void keyReleased(KeyEvent e) {
        displayInfo(e, "KEY RELEASED: ");
    }

    private void displayInfo(KeyEvent e, String keyStatus){
        int id = e.getID();
        String keyString;
        if (id != KeyEvent.KEY_PRESSED) return;
        char c = '0';
        int keyCode = 0;
        if (id == KeyEvent.KEY_TYPED) {
            c = e.getKeyChar();
            keyString = "char= '" + c + "'";
        } else {
            keyCode = e.getKeyCode();
            keyString = "code= " + keyCode
                    + " ("
                    + KeyEvent.getKeyText(keyCode)
                    + ")";
        }

        if (keyCode == 81) System.exit(0);
        
        int modifiersEx = e.getModifiersEx();
        String modString = " " + modifiersEx;
        String tmpString = KeyEvent.getModifiersExText(modifiersEx);
        modString += " (" + tmpString + ")";
        System.out.println(keyString + " : " + modString);
        //listModel.addElement(keyString + modString);
    }

    private static void createAndShowGUI() {
        //Create and set up the window.
        JFrame frame = new JFrame("ListDemo");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        //Create and set up the content pane.
        JComponent newContentPane = new ListDemo();
        newContentPane.setOpaque(true); //content panes must be opaque
        frame.setContentPane(newContentPane);

        //Display the window.
        frame.pack();
        frame.setVisible(true);
    }

    public static void main(String[] args) {
        javax.swing.SwingUtilities.invokeLater(() -> createAndShowGUI());
    }
}

class Elements {

    static ArrayList<String> path;

    static String[] root = {
        "packages",
        "test",
        "urls",
    };

    public static Collection getRoot() {
        return Arrays.asList(root);
    }

    public static Collection getPackages() {
        ArrayList list = new ArrayList();
        int limit = 10;
        final Package[] packages = Package.getPackages();
        java.util.Arrays.sort(packages, (x, y) -> x.getName().compareTo(y.getName()));
        for (Package pkg : packages) {
            if (limit-- < 0) break;
            list.add(pkg.getName());
        }
        return list;
    }

    public static Collection go(String name) {
        ArrayList list = new ArrayList();

        return list;
    }
}

class Element {
    public String title;

    public Element(String title) {
        this.title = title;
    }
}

class ElementDir {

}

class JavaPackagesDir extends ElementDir {

    public static Collection<Element> getElements() {
        ArrayList<Element> list = new ArrayList<Element>();
        int limit = 10;
        final Package[] packages = Package.getPackages();
        java.util.Arrays.sort(packages, (x, y) -> x.getName().compareTo(y.getName()));
        for (Package pkg : packages) {
            if (limit-- < 0) break;
            list.add(new Element(pkg.getName()));
        }
        return list;
    }
}

class FixedDir extends ElementDir {

}

// read from file structure
