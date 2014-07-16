using System;
// в чём разница между var и dynamic?
namespace cstest1
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			Console.WriteLine ("{0} | {0}",34);
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


		}
		int s(int i){return 2+i;}
		static void showarray(byte[] a){
			Console.Write ("[");
			foreach(byte x in a) Console.Write(x+" ");
			Console.Write("]");
		}
		static void Ln() {Console.WriteLine ();}
	}
}
