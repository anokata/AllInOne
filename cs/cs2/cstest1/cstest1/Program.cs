using System;
using System.Collections;
using System.IO;
// в чём разница между var и dynamic?
namespace cstest1
{
	class ConMenu{

		class MenuElement
		{
			ArrayList efields;
			public string show(string separator)
			{
				string a = "";
				foreach (string s in efields) // my: foreach s efields
					a += separator+s;
				return a.Substring(separator.Length);
			}
			public MenuElement(string a, string separator)
			{
				efields = new ArrayList ();
				foreach (string s in a.Split(separator.ToCharArray()))
					efields.Add (s);
			}
		}

		ArrayList elements;
		string separator = "|";
		string separator2 = "||";
		uint selected;
		ConsoleColor bkcolor = ConsoleColor.Black;
		ConsoleColor fgcolor = ConsoleColor.Blue;
		int x = 0;
		int y = 0;
		int maxwidth = 0;

		public ConMenu(){
			elements = new ArrayList();
		}
		public void changeSeparator(string s)
		{
			separator2 = s;
			updatemaxw ();
		}
		void updatemaxw()
		{
			if (maxwidth < ((MenuElement)elements [elements.Count - 1]).show (separator2).Length)
				maxwidth = ((MenuElement)elements [elements.Count - 1]).show (separator2).Length;
		}
		public void add(string s)
		{
			elements.Add (new MenuElement (s, separator));
			updatemaxw ();
		}
		public string showall()
		{
			string a = "";
			foreach (MenuElement i in elements)
				a += i.show(this.separator2) +"\n";
			return a;
		}
		//char blockFull = '\x2588';
		//char blockLWall = '\x2503';
		char blockRWall = '\x2503';
		char blockCornerRU = '\x2513';
		char blockCornerLU = '\x250F';
		char blockCornerRD = '\x251B';
		char blockCornerLD = '\x2517';
		char blockHWall = '\x2501';
		public string inframe(int h)
		{
			string a = "";
			a += topframe (h);

			foreach (MenuElement i in elements) {
				string e = (i.show (this.separator2));
				string dop = "";
				for (int j=e.Length; j<h; j++) dop+=' ';
				a += blockRWall + e + dop + blockRWall + "\n";
			}
			//bottom
			a += botframe (h);
			return a;
		}
		string topframe(int w)
		{
			string a = "";
			a+=blockCornerLU;
			for (int i=0; i<w; i++)
				a += blockHWall;
			a+=blockCornerRU+"\n";
			return a;
		}
		string botframe(int w)
		{
			string a = "";
			a+=blockCornerLD;
			for (int i=0; i<w; i++)
				a += blockHWall;
			a+=blockCornerRD;
			return a;
		}
		/*int maxW()
		{
			int max = 0;
			foreach (MenuElement e in elements)
				if ((e.show(this.separator2).Length) > max)
					max = e.show (this.separator2).Length;
			return max;
		}*/
		//toselected
		//fromselected
		public void print()
		{
			Console.BackgroundColor = bkcolor;
			Console.ForegroundColor = fgcolor;
			Console.SetCursorPosition (x, y);
			Console.Write (inframe (this.maxwidth));
		}


	}
	class MainClass
	{
		public static void Main (string[] args)
		{
			Console.BackgroundColor = ConsoleColor.DarkGray;
			Console.ForegroundColor = ConsoleColor.Yellow;
			Console.SetCursorPosition (10, 10);
			Console.Clear ();

			ArrayList cont = new ArrayList ();
			//FileStream f = new FileStream("/home/ksi/dev/cs/.downloads", FileMode.Open);
			//StreamReader r = new StreamReader(f);
			StreamReader r = new StreamReader ("/home/ksi/dev/cs/.downloads");
			while (!r.EndOfStream){
				cont.Add (r.ReadLine ());
			}
			r.Close ();


			ConMenu m = new ConMenu ();
			foreach (string i in cont)
				m.add (i);
			Console.Write (m.showall ());
			m.changeSeparator(" -\x2588 ");
			Console.Write (m.showall ());
			Console.Write (m.inframe(26));

			m.print ();
	

		}
		static void showarray(byte[] a){
			Console.Write ("[");
			foreach(byte x in a) Console.Write(x+" ");
			Console.Write("]");
		}
		static void Ln() {Console.WriteLine ();}
	}
}
