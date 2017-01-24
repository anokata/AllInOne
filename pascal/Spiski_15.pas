Program list123;
Uses GraphABC, Cross2;
const
  sLineBreak = #13#10;
Var
  list: ref; // Указатель на список кругов.
  no_cross: ref; // Указатель на список не пересекающихся кругов.
  e: integer;
  fn: string;
  textX, textY, fontSize: integer;

// Вернуть текстовый курсор в начало.
procedure textStart();
begin
textY:=10;
end;
// Начать с новой строки.
procedure newline();
begin
textY:=textY + fontSize*2;
end;
// Очистка окна.
procedure clear();
begin
SetBrushStyle(bsSolid);
SetPenStyle(psClear);
Rectangle(0,0,Window.Width, Window.Height);
textStart();
end;
// Вывод текста.
procedure writeText(s:string);
begin
TextOut(textX,textY,s);
newline();
end;

// Ввод данных в список.
procedure input_circles(var list:ref);
var 
  cur, pred : ref;
  x, y, r: integer;
begin
  new(list);
  cur:=list;
  list^.next := nil;
  writeln('Введите координату х точки центра окружности');
  readln(x);
  writeln('Введите координату y точки центра окружности');
  readln(y);
  writeln('Введите радиус окружности');
  readln(r);
  cur^.x := x;
  cur^.y := y;
  cur^.r := r; 
  pred:=cur;
  
  while  not((x = 0) and (y=0) and (r=0)) do begin   
    writeln('Введите координату х точки центра окружности');
    readln(x);
    writeln('Введите координату y точки центра окружности');
    readln(y);        
    writeln('Введите радиус окружности');
    readln(r);
    pred:=cur;
    if (x = 0) and (y=0) and (r=0) then break; // досрочный выход
    new(cur^.next);
    
    cur^.next^.x := x;
    cur^.next^.y := y;
    cur^.next^.r := r; 
    cur := cur^.next;
  end ;
  dispose(pred^.next);
  pred^.next:=nil;
end;

// Вывод списка кружков на экран.
// list - ссылка на начало списка кружков.
procedure screen_cirles_output(list: ref);
var
  cur:ref;
begin
//вывод на экран
  cur:=list;
  textX:=400;
  if list <> nil then
  repeat
      writeText('x=' + (cur^.x) + '; ' + 'y=' + (cur^.y) + '; ' + 'r=' + (cur^.r) + ';');
      cur:=cur^.next;
  until cur=nil;
  textX:=10;
end;
  
//рисование окружностей   
procedure drawing_circles(list: ref; c:Color; w:integer);
var
  cur: ref;
begin
  cur:=list;
  SetBrushStyle(bsClear);
  SetPenColor(c);
  SetPenStyle(psSolid);
  SetPenWidth(w);
  if list <> nil then
  repeat
  circle (cur^.x,cur^.y,cur^.r);
  cur:=cur^.next;
  until cur=nil;
end;


//чтение из файла
procedure input_circles_from_file(var list:ref;fn:string);
var 
  cur, pred : ref;
  dok: text;
  //s:string;
begin
  assign(dok,fn);
  reset(dok);
  new(list);
  cur:=list;
  list^.next := nil;
  while not eof(dok) do
    begin
      read(dok, cur^.x, cur^.y, cur^.r);
      new(cur^.next);
      pred:=cur;
      cur:=cur^.next;
    end;
      dispose(pred^.next);
      pred^.next := nil;
      close(dok);
end;

// запись в файл
procedure save_circles_from_file(var list:ref;fn:string);
var 
  cur : ref;
  dok: text;
  //s:string;
begin
  assign(dok,fn);
  rewrite(dok);
  writeln(dok, 'Список не пересекающихся окружностей:');
  cur:=list;
  if list <> nil then
  repeat
      writeln(dok, 'x=',(cur^.x),'; ','y=',(cur^.y),'; ','r=',(cur^.r),';');
      cur:=cur^.next;
  until (cur = nil) 
  else writeln(dok, 'нет не пересекающихся =(');
  close(dok);
end;

//заполнение рандомом
procedure input_circles_from_random(var list:ref; nc:integer);
var 
  cur, pred: ref;
  i:integer;
  //s:string;
begin
  new(list);
  cur:=list;
  list^.next := nil;
  randomize;
  for i:=1 to nc do
    begin
      cur^.x := random(100,250);
      cur^.y := random(100,250);
      cur^.r := random(1,150); 
      new(cur^.next);
      pred:=cur;
      cur:=cur^.next;
    end;
    dispose(pred^.next);
    pred^.next:=nil;
end;

procedure menu_22; forward;

//главное меню
{
procedure menu_1n;         
begin
ClearWindow;
writeln('1) ввод данных с клавиатуры.' + sLineBreak + '2) ввод данных из файла.'
+ sLineBreak + '3) Случайный набор окружностей.' + sLineBreak + '0) выход.');
  readln(e);
  case e of 
  1:begin
    ClearWindow;
    input_circles(list);
    end;
     
  2: begin
    writeln('Введите имя файла:');
    //readln(fn);
    ClearWindow;
    fn:='C:\Users\rainlin\Desktop\учеба\Контрольные\Программирование\1.txt';
    input_circles_from_file(list, fn);
    writeln;
    end;
    
  3: begin
    writeln('Введите количество окружностей:');
    ClearWindow;
    //readln(nс);
    //nc:=10;
    input_circles_from_random(list, 1);
    writeln;
    end;
  0: CloseWindow();
  end;
end;}

procedure menu_11;  
var 
nc:integer;       
begin
clear;
writeText('1) ввод данных с клавиатуры.' + sLineBreak + '2) ввод данных из файла.'
+ sLineBreak + '3) Случайный набор окружностей.' + sLineBreak + '0) выход.');
  readln(e);
  case e of 
  1:begin
    clear;
    input_circles(list);
    menu_22;
    end;
     
  2: begin
    clear;
    writeText('Введите имя файла:');
    readln(fn);
    clear;
    fn:='C:\Users\rainlin\Desktop\учеба\Контрольные\Программирование\1.txt';
    input_circles_from_file(list, fn);
    newline;
    menu_22;
    end;
    
  3: begin
    clear;
    writeText('Введите количество окружностей:');
    readln(nc);
    //nc:=10;
    input_circles_from_random(list, nc);
    newline;
    menu_22;
    end;
  0: CloseWindow();
  end;
end;

procedure menu_33;
begin
clear();
    writeText('1) сохранить результат в файл.' + sLineBreak + '2) вернуться к началу.' + sLineBreak + '0) выход.');
    readln(e);
    clear;
      case e of 
      1:begin
        writeText('Введите имя файла:');
        readln(fn);
        clear;
        save_circles_from_file(no_cross, fn);
        writeText('1) Вернуться к началу.' + sLineBreak + '0) выход.');
        readln(e);
        clear;
          case e of 
          1: menu_11;
          0: CloseWindow();
        end;   
        end;
       2:
       menu_11;
       0: CloseWindow();
        end; 
end;

procedure menu_22;  
begin
clear;
drawing_circles(list, clBlack, 1);
screen_cirles_output(list);
readln();
clear;
writeText('1) найти не пересекающиеся окружности.' + sLineBreak + '2) вернуться к началу.' + sLineBreak + '0) выход.');
readln(e);
case e of 
    1:begin
    clear;
    
    // Выявление пересечений
    no_cross := cross_circles(list);
   
    //Вывод списка непересекающихся кружков на экран.
    screen_cirles_output(no_cross);
    drawing_circles(list, clBlack, 1);
    drawing_circles(no_cross, RGB(255,0,0), 2);
    if no_cross=nil then begin
      textX:=400;
      writeText('нет не пересекающихся :)');
      textX:=10;
      end;
    readln();
    menu_33
            end;
     2: menu_11;
     0: CloseWindow(); 
end;
end;

// Основная программа.
Begin
//SetWindowSize(800,800);
  textX := 10;
  textY := 10;
  fontSize:= 11;
  SetFontSize(fontSize);
  
menu_11;


            
End.