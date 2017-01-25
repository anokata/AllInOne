'use strict';
const assert = require('assert');
const log = console.log;
function solution(A) {
    if (A.length < 3) return 0;
    A.sort((a,b) => {return a-b});
    for (let i = 0; i < A.length - 2; i++) {
        if (A[i] + A[i+1] > A[i+2]) return 1;
    }
    return 0;
}
log(solution([1,10, 50, 5]));
const isPrime = (x) => {
  if (x === 2) return true;
  if (x === 1) return false;
  for (let i = 2; i <= x / 2; i++) {
    if (x % i === 0) return false;
  }
  return true;
}
//0.0  Написать процедуру тестирующую все следующие функции, и выводящую отчёт.
assert(1==1);
const assertAndLog = (fun, args, val) => {
    var result = fun.apply(null, args);
    console.log(fun.name, result, args, ' ?= ', val);
    //assert(result == val);
    assert.equal(result, val, 'not ok');
    console.log('ok');
}
const testAll = () => { // Make fun snippet
    assertAndLog(sumArray, [[1]], 1);
    assertAndLog(sumArray, [[1,2]], 3);
    assertAndLog(sumArray, [[1,2,0,10]], 13);
    assertAndLog(avgArray, [[1,1,0,10]], 3);
    assertAndLog(isPrime, [1], false);
    assertAndLog(isPrime, [10], false);
    assertAndLog(isPrime, [12], false);
    assertAndLog(isPrime, [8], false);
    assertAndLog(isPrime, [2], true);
    assertAndLog(isPrime, [3], true);
    assertAndLog(isPrime, [7], true);
    assertAndLog(isPrime, [13], true);
    assertAndLog(isPrime, [83], true);
    assertAndLog(isPrime, [81], false);
    assertAndLog(isPrime, [24], false);
    assertAndLog(isPrime, [4], false);
    assertAndLog(isPrime, [1], false);
}
//1.0  написать функцию sumArray принимающую массив целых чисел и вычисляющих сумму.
function sumArray(arr) {
    var sum = 0;
    for (var i = 0; i < arr.length; i++) { //Make forvar snippet
       sum += arr[i]; 
    }
    return sum;
}
//1.1  написать функцию avgArray принимающую массив целых чисел и вычисляющих среднее арифметическое.
const avgArray = (arr) => {
    var sum = 0;
    for (var item of arr) {
        sum += item;
    }
    return sum/arr.length;
}
//1.2  написать функцию lenString вычисляющую длинну переданной строки.
function lenString(str) {

}
//2.0  Написать функцию max2 возвращающую большее из двух чисел.
//2.1  Написать функцию max3 принимающую 3 числа и возвращающую максимальное.
//2.2  Написать функцию sortArray принимающую массив чисел и сортирующую его с помощью функции max2
//2.3  Написать функцию maxArray принимающую массив целых чисел и находящую максимальное значение.
//2.4  Написать функцию is_member проверяющая встречается ли строка в массиве строк.
//2.5  Написать функцию overlapping принимающую два массива и возвращую True если у массивов есть хотя бы один общий элемент. можно использовать is_member.
//3.0  написать функцию принимающую два массива целых чисел и возвращающую массив разности элементов. Result = X - Y
//3.1  написать функцию принимающую массив целых чисел и целое число, и вычисляющих сумму элементов меньших переданного числа.
//4.0  написать функцию isInRectangle принимающую 4 целых числа - декартовы координаты углов прямоугольника и два числа - координаты точки. функция должна определять находится ли точка внутри прямоугольника.
//4.1  написать функцию greaterThan принимающую массив целых чисел и число, возвращающую массив чисел превыщающих переданное. (смотри про динамические массивы)
//5.0  написать функцию isVowel проверяющая символ на гласный(True)\согласный(False)
//5.1  написать функцию is_palindrome проверяющая строку на палиндром, вида "радар"
//5.2  написать функцию reverseString переворачивающую строку. 'abcd' -> 'dcba'
//5.3  написать функцию stringToNumber для преобразования строки содержащую десятичное число в число integer. строка состоит из символов, подобна массиву из char. каждый char это код символа в кодировке. коды цифр - 48 = '0'  можно использовать функции ORD CHR, смотрим справку, ищем примеры. CHR(50) == '2', ORD('3')==51
//5.4  написать функцию numberToString преобразования числа в строку.
//5.5  Написать функцию strCmpGT принимающую две строки и возвращающую True если первая больше второй.(сравнивая в лексикографическом порядке) Например:  ab > aa    aba < ca    aba < z    abc < abca
//5.6  Напсать функцию sortStringArray сортирующую массив строк в лексикографическом порядке, пользуясь функцией strCmpGT.
//6.0  написать функцию fileStringChange для замены в файле заданной строку на другую заданную.
//6.1  написать функцию fileStringReverse для переворачивания файла построчно, с конца в начало и обращающую и каждую строку функцией reverseString.
//7.0  написать функцию вычисляющую факториал числа не используя циклы. 
//7.1  написать функцию суммирующую массив чисел не используя циклы.
//7.2  написать функцию перемножающую массив чисел не используя циклы.
//8.0  написать функцию принимающую матрицу(двумерный массив) символов и два символа и заполняющую первыми символами диагонали, а вторыми символами элементы с обоими чётными индексами.
//8.1  написать процедуру печатающую матрицу символов, поэлементно, без пробелов, каждую строку с новой строки.
//8.2 Напиши функцию которая преобразует массив слов в массив чисел представляющих длинну каждого слова.
//8.3 Напиши функцию find_longest_word которая принимает массив слов и возвращает длинну самого длинного.
//8.4 Напиши функцию filter_long_words которая принимает массив слов и целое число N, и возвращает массив слов длинны больше N.
//
//
//
//
//
//
testAll();
/*
>= приводит тип к числу 
=== не приводит типы.
NaN не равен себе. есть isNaN()
isZero isPositive 
sort сортирует в виде строк - надо задавать функцию для чисел (a,b) => {return a-b}
num.toFixed(n);
isFinite not NaN not Inf
+num -> convert to Number
round : ~~num num^0 
toLocaleString
`xxx ${somevar} xxx`
''.slice()
let a = {};
a.a = 1; delete a.a; if 'a' in a
for (let key in obj)
Object.keys(obj).length
arr [] 
  pop push shift unshift конец и начало
Надо узнать:
    переменное кол-во аргументов.
  */
function isNumeric(n) {
      return !isNaN(parseFloat(n)) && isFinite(n);
}
