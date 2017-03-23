<?php
//0.1

/*
0.0  Написать процедуру тестирующую все следующие функции, и выводящую отчёт.
1.0  написать функцию sumArray принимающую массив целых чисел и вычисляющих сумму.
1.1  написать функцию avgArray принимающую массив целых чисел и вычисляющих среднее арифметическое.
1.2  написать функцию lenString вычисляющую длинну переданной строки.
2.0  Написать функцию max2 возвращающую большее из двух чисел.
2.1  Написать функцию max3 принимающую 3 числа и возвращающую максимальное.
2.2  Написать функцию sortArray принимающую массив чисел и сортирующую его
2.3  Написать функцию maxArray принимающую массив целых чисел и находящую максимальное значение.
2.4  Написать функцию is_member проверяющая встречается ли строка в массиве строк.
2.5  Написать функцию overlapping принимающую два массива и возвращую True если у массивов есть хотя бы один общий элемент. можно использовать is_member.
3.0  написать функцию принимающую два массива целых чисел и возвращающую массив разности элементов. Result = X - Y
3.1  написать функцию принимающую массив целых чисел и целое число, и вычисляющих сумму элементов меньших переданного числа.
4.0  написать функцию isInRectangle принимающую 4 целых числа - декартовы координаты углов прямоугольника и два числа - координаты точки. функция должна определять находится ли точка внутри прямоугольника.
4.1  написать функцию greaterThan принимающую массив целых чисел и число, возвращающую массив чисел превыщающих переданное. (смотри про динамические массивы)
5.0  написать функцию isVowel проверяющая символ на гласный(True)\согласный(False)
5.1  написать функцию is_palindrome проверяющая строку на палиндром, вида "радар"
5.2  написать функцию reverseString переворачивающую строку. 'abcd' -> 'dcba'
5.3  написать функцию stringToNumber для преобразования строки содержащую десятичное число в число integer. строка состоит из символов, подобна массиву из char. каждый char это код символа в кодировке. коды цифр - 48 = '0'  можно использовать функции ORD CHR, смотрим справку, ищем примеры. CHR(50) == '2', ORD('3')==51
5.4  написать функцию numberToString преобразования числа в строку.
5.5  Написать функцию strCmpGT принимающую две строки и возвращающую True если первая больше второй.(сравнивая в лексикографическом порядке) Например:  ab > aa    aba < ca    aba < z    abc < abca
5.6  Напсать функцию sortStringArray сортирующую массив строк в лексикографическом порядке, пользуясь функцией strCmpGT.
6.0  написать функцию fileStringChange для замены в файле заданной строку на другую заданную.
6.1  написать функцию fileStringReverse для переворачивания файла построчно, с конца в начало и обращающую и каждую строку функцией reverseString.
7.0  написать функцию вычисляющую факториал числа не используя циклы. 
7.1  написать функцию суммирующую массив чисел не используя циклы.
7.2  написать функцию перемножающую массив чисел не используя циклы.
8.0  написать функцию принимающую матрицу(двумерный массив) символов и два символа и заполняющую первыми символами диагонали, а вторыми символами элементы с обоими чётными индексами.
8.1  написать процедуру печатающую матрицу символов, поэлементно, без пробелов, каждую строку с новой строки.
8.2 Напиши функцию которая преобразует массив слов в массив чисел представляющих длинну каждого слова.
8.3 Напиши функцию find_longest_word которая принимает массив слов и возвращает длинну самого длинного.
8.4 Напиши функцию filter_long_words которая принимает массив слов и целое число N, и возвращает массив слов длинны больше N.


-8.A Написать функцию принимающую два символа и число-длинну, возвращающую строку символов состоящую из случайных символов между заданными двумя включительно, заданной длинны. (использовать функции ord chr для преревода символов)
9.0 Функция принимающая строку и возвращающая количество согласных букв.
9.1 Функция принимающая 3 числа и определяющая могут ли они быть стороанми треугольника. (сумма длин любых двух сторон треугольника больше чем длина третей стороны)
9.2 Функцию перевода времени в формат 24х часов. Например time24hr('12:34am')= '0034'   time24hr('12:15pm')= '1215'
9.3 Функцию определения високосного года, принимает номер года, возвращает True если високосный. (високосным считается год делящийся на 4 но не делящийся на 100, но делящийся на 400)
9.4 Создать функцию создающую массив чисел - generateNumbers(start, end, step) start - начальное значение, end - конечное значение, step - шаг до следующего числа. Например range(1, 11, 2) = [1,3,5,7,9]
9.5 Функцию uniqe принимающую массив и возращающая массив в котором удалены все повторяющиеся значения(строки)
9.6 Написать процедуру принимающую имя файла, и преобразующего его следующим образом:
  каждый байт файла преобразуется в шестнацатеричное число (по 4 бита на цифру) в строковом виде 
  (один байт - два символа от 0 до F, например 0 = "00" 11 = "0B" 65 = "41") 
  которые записываются в выходной файл под именем <имя файла>.enc
9.7 Написать процедуру принимающую имя файла.enc, и преобразующего его следующим образом:
 каждые два прочитанных символа (являющиеся цифрами шестнацатиричного числа) преобразуются в целое число(байт)
 который записывается в выходной файл (без .enc)
9.8 Функцию generateNchars принимающую число и символ и возвращающую строку из данной длинны из этих символов.
9.9 Процедуру печатающую гистограмму массива чисел, используя функцию generateNchars9.9 Процедуру печатающую гистограмму массива чисел, используя функцию generateNchars. Например:
    histogram([4, 9, 7]) ->
      ****
      *********
      *******

A.0 Получить список текстовых (или файлов pas) в текущей директории.
A.1 Прочитывая каждый файл из текущей директории(текстовый или pas), записать в выходной файл содержимое каждого файла добавляя перед каждым файлом его имя а после каждого файла символ конца страницы - '\f'
A.2 Написать функцию принимающую имя файла и возвращающую запись, содержащую длинну файла в символах, количество строк, количество пустых строк и количество каждого встреченного символа(частотный словарь).
A.9 Структуру и модуль для операций с комплексными числами, векторами.

********************************************************************************
БАзы Данных!!!!
Автомат принимающий деньги(разного номинала) и дающий товар и сдачу. Фун принимает список монет и определяет давать ли товар(указанной стоимости) и сдачу и какими монетами.
Количество слов в строке разделённых пробелом(или несколькими).
Создать структуру для двумерной точки. Написать функции создания точки, ...
Создать структура для прямоугольника(две точки, или в одной структуре) с получением ширины и высоты, центра, длинны диагонали, определения правильности, квадрата..
создать стурктуру данных для треугольника(точка, три точки). Написать функции для создания (возможного) треугольника, вычисления периметра, площади...

рекурсивная функция вычисляющая - НОД(алг евкл), сумму цифр.

динамические структуры данных. указатели?

задачи на структуры

50. написать консольные крестики-нолики
А.0  Написать программу выводящую в точности свой исходный код, не читая файл.
9.0  Простая напоминалка-расписание. Программа читает файл представленного вида и выполняет ожидание и вывод сообщения. (работа со временем. msgbox.)
    12:00 разомнись!
    13:00 поешь!
    13:30 решай!
Задачи за которыми скрыт простой алгоритм с массивами\строками.. - минимальная потребность в формализации.
простые олимпиадные задачи для школьников.

write a program that takes a file as an argument and counts the total number of lines. Lines are defined as ending with a newline character. Program usage should be 

In this challenge, given the name of a file, print out the size of the file, in bytes. If no file is given, provide a help string to the user that indicates how to use the program. You might need help with taking parameters via the command line or file I/O in C++

 String Permutation Challenge
Here is another mathematical problem, where the trick is as much to discover the algorithm as it is to write the code: write a program to display all possible permutations of a given input string--if the string contains duplicate characters, you may have multiple repeated results. Input should be of the form 
 */
?>
