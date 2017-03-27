import java.lang.*;
import java.math.*;
import java.util.*;

public class Hello {
    public static void main(String[] args) {
        System.out.println("Hi!\u03A9");
        System.out.println(Double.toString(5.3 % 2));
        System.out.println(Double.toString(0.1+0.1+0.2-0.1));
        System.out.println(Double.toString(2/0d));
        types();

        booleanExpression(false, false, false, false);
        booleanExpression(false, false, false, true);
        booleanExpression(false, false, true, false);
        booleanExpression(false, false, true, true);
        booleanExpression(false, true, false, false);
        booleanExpression(false, true, false, true);
        booleanExpression(false, true, true, false);
        booleanExpression(false, true, true, true);
        booleanExpression(true, false, false, false);
        booleanExpression(true, false, false, true);
        booleanExpression(true, false, true, false);
        booleanExpression(true, false, true, true);
        booleanExpression(true, true, false, false);
        booleanExpression(true, true, false, true);
        booleanExpression(true, true, true, false);
        booleanExpression(true, true, true, true);
        System.out.println(leapYearCount(1));
        System.out.println(leapYearCount(4));
        System.out.println(leapYearCount(100));
        System.out.println(Integer.toString(flipBit(0, 1)));
        System.out.println(charExpression(52));
        System.out.println(isPowerOfTwo(1));
        System.out.println(isPowerOfTwo(2));
        System.out.println(isPowerOfTwo(3));
        System.out.println(isPowerOfTwo(4));
        System.out.println(isPowerOfTwo(8));
        System.out.println(isPowerOfTwo(9));
        System.out.println("Pali");
        System.out.println(isPalindrome("Madam, I'm Adam!"));
        System.out.println(isPalindrome("Madm, I'm Adam!"));
        System.out.println(factorial(0));
        System.out.println(factorial(1));
        System.out.println(factorial(2));
        System.out.println(factorial(3));
        System.out.println(factorial(4));
        System.out.println(factorial(5));
        System.out.println(factorial(-5));
        System.out.println(factorial(6));
		for (int i = 0; i < 20; i++) {
			System.out.println("fact (" + i + ") = " + factorial(i));
		}
		System.out.println(Arrays.toString(mergeArrays(new int[] {1,2,5}, new int[] {1, 3, 4})));
    }
    static void types() {
        // 4 primitive types; as values
        boolean b = true;
        char c = 'a';
        byte bt = 1; // not use without ness
        bt = (byte) (bt * 2); // cast to int implicit
        short sh = 2; // not use without ness
        int i = 3000;
        long l = 4;
        float fl = 3.2f;
        double da = 3.14;
        //4 reference types;
        int arri[];

        // && &(not lazy) || |(not lazy)
        // import java.math.*;
        // BigInteger
        // BigDecimal
        // boxing
        Integer r1 = Integer.valueOf(i);
        // unboxing
        r1 = 2000;
        i = r1.intValue();
        i = r1;
        System.out.println(Integer.toString(i));
        i = Integer.parseInt("66661");
        System.out.println(Integer.toString(i));
        System.out.println("" + r1);
        System.out.println(Character.isLetter('1'));

        byte bbb = 123;
        //char bc = bbb;
        int zc = 'a';
        Character zzc = 'a';
        float flz = 123L;
        // REF
        BigInteger bi;
        bi = new BigInteger("332123211193120313123123123");
        System.out.println(bi);
        int[] arrint;
        i = 123;
        arrint = new int[i]; 
        System.out.println(arrint);
        for (int idx = 0; idx < arrint.length; idx++) {
            System.out.print(arrint[idx]+" ");
        }
        System.out.println(Arrays.toString(arrint));
        for (int ii : arrint) {
            System.out.print((ii+12) + ",");
        }
        System.out.println(maxi(1,2,3,5,21,1,3,2,1,1));
		switch ("") {
			case "":
		}

        String s1 = "str1";
        String s2 = s1;
        char[] s1c = s1.toCharArray();
        s1c[1] = 'A';
        System.out.println(s1);
        s1 = new String(s1c);
        System.out.println(s1);
        StringBuilder sb = new StringBuilder();
        sb.append(s1);
        sb.append(s1);
        System.out.println(sb);
        System.out.println('a'+ 'b'+"12");
        arrint = new int[0];

    }
    public static boolean booleanExpression(boolean a, boolean b, boolean c, boolean d) {
        boolean r = (a&b&!c&!d)|(a&c&!b&!d)|(a&d&!b&!c)|(c&b&!a&!d)|(c&d&!a&!b)|(b&d&!a&!c);

        System.out.println(Boolean.toString(a)+" "+ Boolean.toString(b)+" "+ 
                Boolean.toString(c)+ " "+Boolean.toString(d) + 
                " r= " + Boolean.toString(r));
        return r;
    }
    public static int leapYearCount(int year) {
        int f = year / 4;
        int h = year / 100;
        int fh = year / 400;
        return f + fh - h;
    }
    public static boolean doubleExpression(double a, double b, double c) {
        return Math.abs((a + b) - c) < 0.0001;
    }
    public static int flipBit(int value, int bitIndex) {
        int mask = 1 << (bitIndex - 1);
        int res = mask ^ value;
        return res;
    }
    public static char charExpression(int a) {
        return (char) ('\\' + a);
    }
    public static boolean isPowerOfTwo(int value) {
        return Integer.bitCount(Math.abs(value)) == 1;
        //return (value & (value - 1)) == 0;
    }
    public static int maxi(int... a) {
        int max = a[0];
        for (int i = 0; i < a.length; i++)
            if (max < a[i])
                max = a[i];
        return max;
    }
    public static boolean isPalindrome(String text) {
        text = text.replaceAll("[^a-zA-Z0-9]", "");
        String textr = new StringBuilder(text).reverse().toString();
        return text.equalsIgnoreCase(textr);
    }
	public static BigInteger factorial(int value) {
		BigInteger x = BigInteger.ONE;
		for (int i = 2; i <= value; i++) {
			x = x.multiply(BigInteger.valueOf(i));
		}
		return x;
	}
	public static int[] mergeArrays(int[] a1, int[] a2) {
		int[] a = new int[(a1.length + a2.length)];
		int i1 = 0;
		int i2 = 0;
		for (int i = 0; i < a.length; i++) {
			if (i1 == a1.length) {
				a[i] = a2[i2];
				i2++;
			} else if (i2 == a2.length) {
				a[i] = a1[i1];
				i1++;
			} else if (a1[i1] < a2[i2]) {
				a[i] = a1[i1];
				i1++;
			} else {
				a[i] = a2[i2];
				i2++;
			}
		}
		return a;
	}
}
