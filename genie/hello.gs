[indent=2]

uses Gee

struct gs
  turn:char
  name:string

enum GAME_STATE
  RUN
  STOP
  WIN
  
def fn1(x:GAME_STATE):string
  if x == GAME_STATE.RUN
    return "run"
  else 
    return "norun"

init
  a:string
  c:int
  c = 123
  var b = gs()
  b.name = "start"
  a = "some" + c.to_string()
  a = a[1:7] + ".end|"
  print( "Hello World" + " " + a)
  c = 10
  while c-- > 0
    print ("%i",c)
  print(fn1(GAME_STATE.RUN))
  
  var l = new list of string
  l.add("a1")
  l.add("b2")
  for s in l
    print s
  print args[0]
