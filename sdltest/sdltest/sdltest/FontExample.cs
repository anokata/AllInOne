using System;
using System.Drawing;
using System.Threading;
using System.IO;
using SdlDotNet.Core;
using SdlDotNet.Input;
using SdlDotNet.Graphics;
using SdlDotNet.Graphics.Sprites;
using System.Collections.Generic;

namespace SdlDotNetExamples.SmallDemos
{
   

	public class Game : IDisposable
    {
		static public Surface screen;
		Surface text;
		static public int size = 14;
		static int width = 640;
		static int height = 480;
		static int tileSize = 15;
		static int tilesX = width/tileSize;
		static int tilesY = height/tileSize;

		public static SdlDotNet.Graphics.Font font;
		string filePath = Path.Combine("..", "..");
		string fileName = "DejaVuSansMono.ttf";
		static public string eventText = String.Empty;
		static public int curY = 0;
		static Player player;
		public static List<Wall> walls;

        [STAThread]
        public static void Main()
        {
            Game t = new Game();
            t.Go();
        }

        public void Go()
        {
			string file = Path.Combine(filePath, fileName);
			font = new SdlDotNet.Graphics.Font(file, size);
			player = new Player ("A",30,30);
			player.teleport(10,20);
			walls = new List<Wall>();
			//Wall w = new Wall ("#",2, 2);
			//walls.Add(w);
			//w.passable = true;
			//walls.AddRange(WallConstructor.lineFromTo(3,3,10,5));


			Events.KeyboardDown +=
				new EventHandler<KeyboardEventArgs>(this.KeyboardDown);
			Events.Quit += new EventHandler<QuitEventArgs>(this.Quit);

			Video.WindowIcon();
			Video.WindowCaption = "[NOITPAC]";
			screen = Video.SetVideoMode(width, height, true);

			Surface surf = screen.CreateCompatibleSurface(width, height, true);
			surf.Fill(new Rectangle(new Point(0, 0), surf.Size), Color.White);
			Events.Run();
        }

        private void Events_TickEvent(object sender, TickEventArgs e)
        {
                screen.Update();
                Thread.Sleep(500);
        }

        private void KeyboardDown(object sender, KeyboardEventArgs e)
        {
			
            // Check if the key pressed was a Q or Escape
            if (e.Key == Key.Escape || e.Key == Key.Q)
            {
                Events.QuitApplication();
            }
			eventText = "key: " + e.Key.ToString () + " char? " + e.KeyboardCharacter;
			font.Style = Styles.Bold;
			text = font.Render(eventText, Color.LightBlue, true);
			screen.Blit(text,new Rectangle(new Point(0, curY), text.Size));

			keyProcessAndRepaint (e.Key);

			screen.Update();
			curY += 20;
        }

		public static void draw(){
			//drawFloor ();f
			foreach (Wall w in walls)
				w.draw ();

			player.draw ();
		}

		public static void keyProcessAndRepaint(Key k){
			//Game.draw ();
				switch (k) {
					case Key.LeftArrow:
					player.move (MoveDirection.Left);
					break;
					case Key.RightArrow:
					player.move (MoveDirection.Right);
					break;
					case Key.UpArrow:
					player.move (MoveDirection.Up);
					break;
					case Key.DownArrow:
					player.move (MoveDirection.Down);
					break;
				}
				//
				Game.draw ();
		}

		public static Surface gameMakeFace(Styles style, string symbol, Color bkcolor, Color fgcolor)
		{
			Game.font.Style = style;
			return Game.font.Render(symbol, bkcolor,fgcolor , true);
		}

		public static bool isInWindow (int x, int y) {
			return (x<Game.tilesX && x>=0 && y>=0 && y<Game.tilesY);
		}

		public static bool canMove(int x, int y){
			/*foreach (GameObj i in walls) {
				if (!i.passable && (i.intersect (x, y)))
					return false;
			}*/
			return true;
		}

        private void Quit(object sender, QuitEventArgs e)
        {
            Events.QuitApplication();
        }

        public static string Title
        {
            get
            {
                return "[ELTIT]";
            }
        }

        #region IDisposable Members

        private bool disposed;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    if (Game.font != null)
                    {
						Game.font.Dispose();
						Game.font = null;
                    }
                }
                this.disposed = true;
            }
        }

        public void Dispose()
        {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }

        public void Close()
        {
            Dispose();
        }

        ~Game()
        {
            Dispose(false);
        }

        #endregion
    }




	public class GameObj {
		protected int x;
		protected int y;
		protected string symbol="*";
		protected Surface symbolFace;
		public bool passable = true;
		protected Color bkcolor = Color.Black;
		protected Color fgcolor = Color.Blue;
		protected void draw(){
			Game.screen.Blit(symbolFace,new Rectangle(x*Game.size, y*Game.size, 
			                                                 Game.size, Game.size));

		}
		public void teleport(int x, int y){
			this.x = x;
			this.y = y;
		}
		public bool intersect(int x, int y){
			return (this.x == x) && (this.y == y);
		}
		protected GameObj(string symbol, int x, int y){
			this.symbol = symbol;
			this.x = x;
			this.y = y;
			//Game.font.Style = Styles.Bold;
			//		symbolFace = Game.font.Render(symbol, bkcolor,fgcolor , true);
			symbolFace = Game.gameMakeFace (Styles.Bold, this.symbol, this.bkcolor, this.fgcolor);
		}
	
	}

	class Player : GameObj {
		protected int life=1;
		public Player(string symbol, int x, int y) : base(symbol , x ,y)
		{
			//symbol = "@";
			bkcolor = Color.AliceBlue;
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
				if (Game.isInWindow(x+1,y))
					if (Game.canMove(x+1,y))
						x++;
				break;
				case MoveDirection.Up:
				if (y>0)
					if (Game.canMove(x,y-1))
						y--;
				break;
				case MoveDirection.Down:
				if (Game.isInWindow(x,y+1))
					if (Game.canMove(x,y+1))
						y++;
				break;

			}
		}
	}
	enum MoveDirection {Left, Right, Up, Down };
	public class Wall : GameObj {
		public Wall(string symbol, int x, int y) : base(symbol , x ,y)
		{
			//teleport (x, y);
			//symbol = "#";
			fgcolor = Color.White;
			bkcolor = Color.Lime;
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
				Wall wall = new Wall("#", currentX, currentY);
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
