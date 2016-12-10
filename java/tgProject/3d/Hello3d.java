import com.sun.j3d.utils.universe.SimpleUniverse;
import com.sun.j3d.utils.geometry.ColorCube;
import javax.media.j3d.BranchGroup;

import com.sun.j3d.utils.behaviors.keyboard.KeyNavigatorBehavior;
import javax.media.j3d.Transform3D;
import javax.media.j3d.TransformGroup;
import javax.vecmath.Vector3d;
import javax.vecmath.Vector3f;
import javax.media.j3d.BoundingSphere;
import javax.vecmath.Color3f;
import javax.vecmath.Point3d;

import java.awt.event.*;
import javax.swing.*;

public class Hello3d {

	public Hello3d()
	{
	   SimpleUniverse universe = new SimpleUniverse();
	   BranchGroup group = new BranchGroup();
	   group.addChild(new ColorCube(0.3));
	   
    Transform3D viewXfm = new Transform3D();
    viewXfm.set(new Vector3f(0.0f, 0.0f, 10.0f));
    TransformGroup viewXfmGroup = new TransformGroup(viewXfm);
    viewXfmGroup.setCapability(TransformGroup.ALLOW_TRANSFORM_READ);
    viewXfmGroup.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE);
    BoundingSphere movingBounds = new BoundingSphere(new Point3d(0.0, 0.0,
        0.0), 100.0);
    KeyNavigatorBehavior keyNav = new KeyNavigatorBehavior(viewXfmGroup);
    keyNav.setSchedulingBounds(movingBounds);
    group.addChild(keyNav);    
	   
	   universe.getViewingPlatform().setNominalViewingTransform();
	   universe.addBranchGraph(group);
	   
	universe.getCanvas().addKeyListener().addKeyListener(new KeyAdapter() {
      public void keyPressed(KeyEvent event) {
        switch (event.keyCode) {
        case SWT.CR:
          System.out.println(SWT.CR);
        case SWT.ESC:
          System.out.println(SWT.ESC);
          break;
        }
      }
    });
	}

	public static void main( String[] args ) {
	   new Hello3d();
	}
}