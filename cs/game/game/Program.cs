using System;
using System.IO;
//using System.Collections;
using System.Collections.Generic;

namespace game
{
	class Game
	{
		static Player player = new Player ();
		public static void Main (string[] args)
		{
			Console.Clear ();
			Console.CursorVisible = false;

			player.teleport(10,20);
			//player.symbol = '&';
			Wall w = new Wall (2, 2);
			walls.Add(w);
			w.passable = true;
			walls.AddRange(WallConstructor.lineFromTo(3,3,10,5));

			keyProcessAndRepaint ();
		}

		public static void draw(){
			//Console.Clear ();
			drawFloor ();
			foreach (Wall w in walls)
				w.draw ();

			player.draw ();
		}
		public static List<Wall> walls = new List<Wall>();

		public static void keyProcessAndRepaint(){
			bool exit = false;
			Game.draw ();
			while (!exit) {
				ConsoleKeyInfo keyInfo = Console.ReadKey (true);
				char keyChar = keyInfo.KeyChar;
				ConsoleKey key = keyInfo.Key;
				switch (keyChar) {
				case 'q':
					exit = true;
					break;
				
				}
				switch (key) {
				case ConsoleKey.LeftArrow:
					player.move (MoveDirection.Left);
					break;
				case ConsoleKey.RightArrow:
					player.move (MoveDirection.Right);
					break;
				case ConsoleKey.UpArrow:
					player.move (MoveDirection.Up);
					break;
				case ConsoleKey.DownArrow:
					player.move (MoveDirection.Down);
					break;
				}
				//
				Game.draw ();
			}
		}
		public static bool canMove(int x, int y){
			foreach (GameObj i in walls) {
				if (!i.passable && (i.intersect (x, y)))
					return false;
			}
			return true;
		}

		public static bool inConsoleWindow (int x, int y) {
			return (x<Console.WindowWidth && x>=0 && y>=0 && y<Console.WindowHeight);
		}

		public static void drawFloor(){
			string floor="";
			for (int i = 0; i< Console.WindowWidth*Console.WindowHeight; i++)
				floor += '.';

			Console.SetCursorPosition (0, 0);
			Console.Write (floor);
		}


	}

	class GameObj {
		protected int x;
		protected int y;
		protected char symbol='*';
		public bool passable = true;
		protected ConsoleColor bkcolor = ConsoleColor.Black;
		protected ConsoleColor fgcolor = ConsoleColor.Blue;
		protected void draw(){
			Console.SetCursorPosition (x, y);
			Console.BackgroundColor = bkcolor;
			Console.ForegroundColor = fgcolor;
			Console.Write (symbol);

		}
		public void teleport(int x, int y){
			this.x = x;
			this.y = y;
		}
		public bool intersect(int x, int y){
			return (this.x == x) && (this.y == y);
		}
	}

	class Player : GameObj {
		protected int life=1;
		public Player(){
			symbol = '@';
		}

		new public void draw() {
			base.draw();
		}
		public void move(MoveDirection direction){
			switch (direction) {
			case MoveDirection.Left:
				if (x>0)
					if (Game.canMove(x-1,y))
				x--;
				break;
			case MoveDirection.Right:
				if (Game.inConsoleWindow(x+1,y))
					if (Game.canMove(x+1,y))
				x++;
				break;
			case MoveDirection.Up:
				if (y>0)
					if (Game.canMove(x,y-1))
				y--;
				break;
			case MoveDirection.Down:
				if (Game.inConsoleWindow(x,y+1))
					if (Game.canMove(x,y+1))
				y++;
				break;

			}
		}
	}
	enum MoveDirection {Left, Right, Up, Down };
	class Wall : GameObj {
		public Wall(int x, int y) {
			teleport (x, y);
			symbol = '#';
			fgcolor = ConsoleColor.White;
			passable = false;
		}
		new public void draw() {
			base.draw();
		}
	}
	class WallConstructor {
			public static List<Wall> lineFromTo(int x, int y, int u, int v){
			List<Wall> result = new List<Wall>();
			bool AtEnd = false;
			int currentX = x;
			int currentY = y;
			Random rnd = new Random();
			int dirX = whereGo (x, u);
			int dirY = whereGo (y, v);
			do {
				Wall wall = new Wall(currentX, currentY);
				result.Add(wall);
				//выберем куда повернуть
				//int leftRightUpDownRate = (currentX - u)/(currentY - v);
				switch (rnd.Next(0,2)) {
				case 0: currentX+=dirX;break;
				case 1: currentY+=dirY;break;
				}
				if (currentX == u) dirX = 0;
				if (currentY == v) dirY = 0;

				AtEnd = (currentX == u) && (currentY == v);
			} while (!AtEnd);
			return result;
			}

			static int whereGo(int frm, int to){
			if (frm < to)
				return 1;
			else if (frm > to)
				return -1;
			else
				return 0;
			}
	}
}








