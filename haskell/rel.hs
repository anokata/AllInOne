f ('a':x) = 'b':f x
f ('b':x) = "ff"++f x
f (y:x) = y : f x
f [] = []

t = f ""
