import java.math.*;
import java.util.Arrays;

public class RobotMain {
    public static void main(String[] args) {
        Robot robot = new Robot(0,0, Direction.DOWN);
        robot.view();
        moveRobot(robot, -10, 20);
        robot.view();
    }

    public enum Direction {
        UP,
        DOWN,
        LEFT,
        RIGHT
    }

    public static class Robot {
        int x;
        int y;
        Direction dir;

        public Robot (int x, int y, Direction dir) {
            this.x = x;
            this.y = y;
            this.dir = dir;
        }

        public void view() {
            System.out.println("Robot at (" + x + ", " + y + ") dir " + dir.name());
        }

        public Direction getDirection() {return dir;}

        public int getX() {return x;}

        public int getY() {return y;}

        public void turnLeft() {
            if      (dir == Direction.UP)    {dir = Direction.LEFT;}
            else if (dir == Direction.DOWN)  {dir = Direction.RIGHT;}
            else if (dir == Direction.LEFT)  {dir = Direction.DOWN;}
            else if (dir == Direction.RIGHT) {dir = Direction.UP;}
        }

        public void turnRight() {
            if      (dir == Direction.UP)    {dir = Direction.RIGHT;}
            else if (dir == Direction.DOWN)  {dir = Direction.LEFT;}
            else if (dir == Direction.LEFT)  {dir = Direction.UP;}
            else if (dir == Direction.RIGHT) {dir = Direction.DOWN;}
        }

        public void stepForward() {
            if (dir == Direction.UP)    {y++;}
            if (dir == Direction.DOWN)  {y--;}
            if (dir == Direction.LEFT)  {x--;}
            if (dir == Direction.RIGHT) {x++;}
        }
    }

    public static void moveRobot(Robot robot, int toX, int toY) {
        int dx = Math.abs(robot.getX() - toX);
        int dy = Math.abs(robot.getY() - toY);
        switch (robot.getDirection()) {
            case UP:
                robot.turnRight();
                robot.turnRight();
                break;
            case RIGHT:
                robot.turnRight();
                break;
            case LEFT:
                robot.turnLeft();
                break;
        }
        if (robot.getX() > toX) {
            robot.turnRight();
        } else if (robot.getX() < toX) {
            robot.turnLeft();
        }
        for (int i = 0; i < dx; i ++) {
            robot.stepForward();
        }
        switch (robot.getDirection()) {
            case UP:
                robot.turnRight();
                robot.turnRight();
                break;
            case RIGHT:
                robot.turnRight();
                break;
            case LEFT:
                robot.turnLeft();
                break;
        }
        if (robot.getY() > toY) {
        } else if (robot.getY() < toY) {
            robot.turnRight();
            robot.turnRight();
        }
        for (int i = 0; i < dy; i ++) {
            robot.stepForward();
        }
    }
}
