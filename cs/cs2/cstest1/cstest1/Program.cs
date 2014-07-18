using System;
using System.Collections;
using System.IO;
// using System.Windows;
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
		public string separator2 = "||";
		public ConMenu(){
			elements = new ArrayList();
		}
		public void add(string s)
		{
			elements.Add (new MenuElement (s, separator));
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
		public string inframe(uint h)
		{
			string a = "";
			// head
			a+=blockCornerLU;
			for (int i=0; i<h; i++)
				a += blockHWall;
			a+=blockCornerRU+"\n";

			foreach (MenuElement i in elements) {
				string e = (i.show (this.separator2));
				string dop = "";
				for (int j=e.Length; j<h; j++) dop+=' ';
				a += blockRWall + e + dop + blockRWall + "\n";
			}

			a+=blockCornerLD;
			for (int i=0; i<h; i++)
				a += blockHWall;
			a+=blockCornerRD;
			return a;
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
				//Console.WriteLine (cont [cont.Count - 1]);
			}
			r.Close ();
			//f.Close ();
			//foreach (string i in cont) 
			//	Console.WriteLine(i);

			ConMenu m = new ConMenu ();
			foreach (string i in cont)
				m.add (i);
			Console.Write (m.showall ());
			m.separator2 = " -\x2588 ";
			Console.Write (m.showall ());
			Console.Write (m.inframe(26));
			/*Console.WriteLine ("{0} | {0}",(char)9000);
			//sorting bubble!
			//int x = 0xFFF;
			//long y = 0xFFF;
			//byte z = 0xFF;
			//double Z = 0xFFF;
			//Array a;
			byte[] b = new byte[5];
			byte[] c = {32,0,35,87,65,31,42,12,8,87,55,4,90};
			Console.Write (b);
			char[] s1 = {'a','b','c','d'};
			string s2 = new string(s1);
			Console.Write(s1);
			Console.Write(s2+':');
			s1[3]='E';
			Console.Write(s1);
			Console.Write(s2+':');

			showarray(c);
			//bubble
			bool flag = true;
			byte buf;
			while (flag){
				flag = false;
				for (int i=0; i<c.Length-1;i++){
					if (c[i]>c[i+1]) {flag = true; buf = c[i]; c[i]=c[i+1]; c[i+1]=buf;}
			}}
			Ln(); showarray(c);
			// toehr
			c = new byte[] {32,0,35,1,65,31,42,12,8,87,55,4,90};
			for (int i=0; i<c.Length-2;i++){
				for (int j=i+1; j<c.Length-1;j++){
					if (c[i]>c[j]) {buf = c[i]; c[i]=c[j]; c[j]=buf;}
				}}
			Ln(); showarray(c);
			// 
		*/

		}
		static void showarray(byte[] a){
			Console.Write ("[");
			foreach(byte x in a) Console.Write(x+" ");
			Console.Write("]");
		}
		static void Ln() {Console.WriteLine ();}
	}
}
