using System;
using System.Collections;
using System.IO;
// dynamic?
// TODO: edit(url,.. choise class) save load Folders
namespace cstest1
{
	class ConFrame
	{
		protected ConsoleColor bkcolor = ConsoleColor.Black;
		protected ConsoleColor fgcolor = ConsoleColor.Blue;
		//char blockFull = '\x2588';
		//char blockLWall = '\x2503';
		protected char blockRWall = '\x2503';
		protected char blockCornerRU = '\x2513';
		protected char blockCornerLU = '\x250F';
		protected char blockCornerRD = '\x251B';
		protected char blockCornerLD = '\x2517';
		protected char blockHWall = '\x2501';
		protected int x = 0;
		protected int y = 0;

		protected string topframe(int w)
		{
			string a = "";
			a+=blockCornerLU;
			for (int i=0; i<w; i++)
				a += blockHWall;
			a+=blockCornerRU+"\n";
			return a;
		}
		protected string botframe(int w)
		{
			string a = "";
			a+=blockCornerLD;
			for (int i=0; i<w; i++)
				a += blockHWall;
			a+=blockCornerRD;
			return a;
		}
		protected string textframe(string s)
		{
			return  blockRWall + s + blockRWall + "\n";
		}
		protected void print()
		{
			Console.Clear ();
			Console.BackgroundColor = bkcolor;
			Console.ForegroundColor = fgcolor;
			Console.SetCursorPosition (x, y);
		}
		protected string dopspace(int len)
		{
			string dop = "";
			for (int j=0; j<len; j++) dop+=' ';
			return dop;
		}
	}

	//=====add dialog
	class AddDia : ConFrame
	{
		string text;
		string title;
		string buf = "";
		public AddDia(string title)
		{
			text = "";
			this.title = title;
		}
		public string process()
		{
			bool exit = false;
			print ();
			while (!exit) {
				ConsoleKeyInfo keyi = Console.ReadKey (true);
				char key = keyi.KeyChar;
				ConsoleKey ckey = keyi.Key;
				switch (ckey)
				{
				case ConsoleKey.Enter:
					exit = true;
					break;
				case ConsoleKey.Backspace:
					if (text.Length>0)
					text = text.Substring (0, text.Length - 1);
					break;
				default: 
					text += key;

					break;
				}
				print ();
			}
			return text;
		}
		new public void print()
		{
			base.print ();
			int w = Math.Max (title.Length, text.Length+4);
			buf = topframe(w) + textframe(title + dopspace(w-title.Length)) ;
			buf += textframe ("> " + text + dopspace(w-text.Length-2));
			buf += botframe (w);
			Console.Write (buf);
			Console.SetCursorPosition (x + 3 + text.Length, y+2); // +frame + ">" , +frame+title

		}
	}
	//=====

	class ConMenu : ConFrame {

		//public static string operator ++(ConMenu a){}

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
			public string showAScmd()
			{
				string a = "";
				if (efields.Count > 2)
					a = efields [2] + "@" + efields [1];
				return a;
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
		int selected;
		ConsoleColor sbkcolor = ConsoleColor.DarkGray;
		ConsoleColor sfgcolor = ConsoleColor.Cyan;
		string filename;

		int maxwidth = 0;


		delegate bool ConKeyEventC (char k);
		//event ConKeyEventC keyEvent;
		//onkey
		//processKeys : console.readkey...
		public void processKeys()
		{
			bool exit = false;
			Console.Clear ();	
			print ();

			while (!exit) 
			{
				char key = Console.ReadKey (true).KeyChar;
				switch (key) {
				case 'q':
					exit = true;
					break;
					case 'k':
						if (selected < elements.Count-1)
							selected++; else selected = 0;
					break;
					case 'i':
						if (selected > 0)
							selected--;
						else
							selected = elements.Count - 1;
					break;
					case 'd':
					if (elements.Count>0)
					{
						elements.RemoveAt (selected);
						if (selected == elements.Count && elements.Count!=0)
							selected--;
					}
						break;
				case 'a':
					//AddDia adddialog = new AddDia ("Enter new url");
					add (new AddDia ("Enter new name").process () + separator +
						new AddDia ("Enter new url").process () + separator +
						new AddDia ("Enter new cmd").process ());
					break;
				default:
						Console.Write (key);
					break;

				}
				Console.Clear ();	
				print ();

			}
		}

		public ConMenu(){
			elements = new ArrayList();
			selected = 0;
		}
		public ConMenu(string file){
			elements = new ArrayList();
			selected = 0;
			loadFromFile (file);
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
			updateMaxFull();
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

		public string inframe(int h)
		{
			string a = "";
			a += topframe (h);

			foreach (MenuElement i in elements) {
				a += showElem (h, i);
			}
			//bottom
			a += botframe (h);
			return a;
		}

		int updateMaxFull()
		{
			int max = 0;
			foreach (MenuElement e in elements)
				if ((e.show(this.separator2).Length) > max)
					max = e.show (this.separator2).Length;
			maxwidth = max;
			return max;
		}
		//toselected
		public string inframeToSel(int h)
		{
			string a = "";
			a += topframe (h);
			if (elements.Count>0)
			for (int i=0; i<selected;i++) {
				a += showElem (h, (MenuElement)elements [i]);
			}
			return a;
		}
		private string showElem(int h, MenuElement e)
		{
			string a = "";
			string s = e.show (separator2);
			string dop = dopspace (h - s.Length);
			//for (int j=s.Length; j<h; j++) dop+=' ';

			//a += blockRWall + s + dop + blockRWall + "\n";
			a += textframe (s + dop);
			return a;
		}

		//fromselected
		public string inframeFromSel(int h)
		{
			string a = "";
			if (elements.Count>0)
			for (int i=selected+1; i<elements.Count;i++) {
					a += showElem (h, (MenuElement)elements [i]);
			}
			a += botframe (h);
			return a;
		}
		new public void print()
		{
			base.print ();
			Console.Write (inframeToSel (maxwidth));
			//Console.Write (inframe (this.maxwidth));
			Console.BackgroundColor = sbkcolor;
			Console.ForegroundColor = sfgcolor;
			if (elements.Count>0)
			Console.Write (showElem (maxwidth, (MenuElement)elements [selected]));
			Console.BackgroundColor = bkcolor;
			Console.ForegroundColor = fgcolor;
			Console.Write (inframeFromSel (maxwidth));
			Console.WriteLine ();
			if (elements.Count>0)
			Console.WriteLine (((MenuElement)elements [selected]).showAScmd ());
			Console.Write (filename);
		}
		public void loadFromFile(string file)
		{
			filename = file;
			ArrayList cont = new ArrayList ();
			StreamReader r = new StreamReader (file);
			while (!r.EndOfStream){
				cont.Add (r.ReadLine ());
			}
			r.Close ();
			foreach (string i in cont)
				add (i);
		}


	}
	class MainClass
	{
		public static void Main (string[] args)
		{
			Console.SetCursorPosition (10, 10);
			Console.Clear ();

			ConMenu m = new ConMenu ("/home/ksi/dev/cs/.downloads");
			//m.loadFromFile ("/home/ksi/dev/cs/.downloads");
			//AddDia d = new AddDia ("testdialog");
			//d.print ();
			//d.process ();


			m.changeSeparator("  ");
			m.processKeys ();

		}
		static void showarray<Type>(Type [] a){
			Console.Write ("[");
			foreach(Type x in a) Console.Write(x+" ");
			Console.Write("]");
		}
		static void Ln() {Console.WriteLine ();}
		delegate void Dln ();
		//Dln Lnd = Ln;
	}
}
