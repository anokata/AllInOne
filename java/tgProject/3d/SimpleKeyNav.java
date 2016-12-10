import java.awt.BorderLayout;
import java.awt.Button;
import java.awt.Frame;
import java.awt.Panel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.media.j3d.AmbientLight;
import javax.media.j3d.Appearance;
import javax.media.j3d.BoundingLeaf;
import javax.media.j3d.BoundingSphere;
import javax.media.j3d.BranchGroup;
import javax.media.j3d.Canvas3D;
import javax.media.j3d.DirectionalLight;
import javax.media.j3d.Locale;
import javax.media.j3d.Material;
import javax.media.j3d.PhysicalBody;
import javax.media.j3d.PhysicalEnvironment;
import javax.media.j3d.Transform3D;
import javax.media.j3d.TransformGroup;
import javax.media.j3d.View;
import javax.media.j3d.ViewPlatform;
import javax.media.j3d.VirtualUniverse;
import javax.vecmath.Color3f;
import javax.vecmath.Point3d;
import javax.vecmath.Vector3d;
import javax.vecmath.Vector3f;

import com.sun.j3d.utils.behaviors.keyboard.KeyNavigatorBehavior;
import com.sun.j3d.utils.geometry.Box;

/**
 * This application uses the mouse keyboard utility class to allow navigation
 * around the scene. The scene consists of a yellow and red cube.
 * 
 * @author I.J.Palmer
 * @version 1.0
 */
public class SimpleKeyNav extends Frame implements ActionListener {
  protected Canvas3D myCanvas3D = new Canvas3D(null);

  protected Button exitButton = new Button("Exit");

  protected BoundingSphere bounds = new BoundingSphere(new Point3d(0.0, 0.0,
      0.0), 100.0);

  /**
   * Build the view branch of the scene graph. In this case a key navigation
   * utility object is created and associated with the view transform so that
   * the view can be changed via the keyboard.
   * 
   * @return BranchGroup that is the root of the view branch
   */
  protected BranchGroup buildViewBranch(Canvas3D c) {
    BranchGroup viewBranch = new BranchGroup();
    Transform3D viewXfm = new Transform3D();
    viewXfm.set(new Vector3f(0.0f, 0.0f, 10.0f));
    TransformGroup viewXfmGroup = new TransformGroup(viewXfm);
    viewXfmGroup.setCapability(TransformGroup.ALLOW_TRANSFORM_READ);
    viewXfmGroup.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE);
    BoundingSphere movingBounds = new BoundingSphere(new Point3d(0.0, 0.0,
        0.0), 100.0);
    BoundingLeaf boundLeaf = new BoundingLeaf(movingBounds);
    ViewPlatform myViewPlatform = new ViewPlatform();
    viewXfmGroup.addChild(boundLeaf);
    PhysicalBody myBody = new PhysicalBody();
    PhysicalEnvironment myEnvironment = new PhysicalEnvironment();
    viewXfmGroup.addChild(myViewPlatform);
    viewBranch.addChild(viewXfmGroup);
    View myView = new View();
    myView.addCanvas3D(c);
    myView.attachViewPlatform(myViewPlatform);
    myView.setPhysicalBody(myBody);
    myView.setPhysicalEnvironment(myEnvironment);

    KeyNavigatorBehavior keyNav = new KeyNavigatorBehavior(viewXfmGroup);
    keyNav.setSchedulingBounds(movingBounds);
    viewBranch.addChild(keyNav);

    return viewBranch;
  }

  /**
   * Add some lights to the scene graph
   * 
   * @param b
   *            BranchGroup that the lights are added to
   */
  protected void addLights(BranchGroup b) {
    // Create a bounds for the background and lights
    // Set up the global lights
    Color3f ambLightColour = new Color3f(0.5f, 0.5f, 0.5f);
    AmbientLight ambLight = new AmbientLight(ambLightColour);
    ambLight.setInfluencingBounds(bounds);
    Color3f dirLightColour = new Color3f(1.0f, 1.0f, 1.0f);
    Vector3f dirLightDir = new Vector3f(-1.0f, -1.0f, -1.0f);
    DirectionalLight dirLight = new DirectionalLight(dirLightColour,
        dirLightDir);
    dirLight.setInfluencingBounds(bounds);
    b.addChild(ambLight);
    b.addChild(dirLight);
  }

  /**
   * Build the content branch for the scene graph
   * 
   * @return BranchGroup that is the root of the content
   */
  protected BranchGroup buildContentBranch() {
    //Create the appearance an appearance for the two cubes
    Appearance app1 = new Appearance();
    Appearance app2 = new Appearance();
    Color3f ambientColour1 = new Color3f(1.0f, 0.0f, 0.0f);
    Color3f ambientColour2 = new Color3f(1.0f, 1.0f, 0.0f);
    Color3f emissiveColour = new Color3f(0.0f, 0.0f, 0.0f);
    Color3f specularColour = new Color3f(1.0f, 1.0f, 1.0f);
    Color3f diffuseColour1 = new Color3f(1.0f, 0.0f, 0.0f);
    Color3f diffuseColour2 = new Color3f(1.0f, 1.0f, 0.0f);
    float shininess = 20.0f;
    app1.setMaterial(new Material(ambientColour1, emissiveColour,
        diffuseColour1, specularColour, shininess));
    app2.setMaterial(new Material(ambientColour2, emissiveColour,
        diffuseColour2, specularColour, shininess));
    //Make two cubes
    Box leftCube = new Box(1.0f, 1.0f, 1.0f, app1);
    Box rightCube = new Box(1.0f, 1.0f, 1.0f, app2);

    BranchGroup contentBranch = new BranchGroup();
    addLights(contentBranch);
    //Put it all together
    Transform3D leftGroupXfm = new Transform3D();
    leftGroupXfm.set(new Vector3d(-1.5, 0.0, 0.0));
    TransformGroup leftGroup = new TransformGroup(leftGroupXfm);
    Transform3D rightGroupXfm = new Transform3D();
    rightGroupXfm.set(new Vector3d(1.5, 0.0, 0.0));
    TransformGroup rightGroup = new TransformGroup(rightGroupXfm);

    leftGroup.addChild(leftCube);
    rightGroup.addChild(rightCube);
    contentBranch.addChild(leftGroup);
    contentBranch.addChild(rightGroup);
    return contentBranch;

  }

  /**
   * Use the action event of the exit button to end the application.
   */
  public void actionPerformed(ActionEvent e) {
    dispose();
    System.exit(0);
  }

  public SimpleKeyNav() {
    VirtualUniverse myUniverse = new VirtualUniverse();
    Locale myLocale = new Locale(myUniverse);
    myLocale.addBranchGraph(buildViewBranch(myCanvas3D));
    myLocale.addBranchGraph(buildContentBranch());
    setTitle("SimpleKeyNav");
    setSize(400, 400);
    setLayout(new BorderLayout());
    Panel bottom = new Panel();
    bottom.add(exitButton);
    add(BorderLayout.CENTER, myCanvas3D);
    add(BorderLayout.SOUTH, bottom);
    exitButton.addActionListener(this);
    setVisible(true);
  }

  public static void main(String[] args) {
    SimpleKeyNav skn = new SimpleKeyNav();
  }
}