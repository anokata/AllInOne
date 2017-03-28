using System;


namespace test1
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			Console.WriteLine ("Hello World!");
			Console.WriteLine (3.magic (9));
		}
	}

	class Abracadabra 
	{
		public static Id<int> magic (this int a, int b)
		{
			return a * b;
		}
	}

public class Id<Type> {
	public Type Val { get; set;}
	public Id() {}
	public Id(Type val){
		Val = val;
	}
}

}






