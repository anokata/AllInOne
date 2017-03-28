main = putStrLn "hello world!"
lenVec3 x y z =  sqrt (x*x +  y*y +  z*z)
sign x = if x > 0 then 1 else if x < 0 then (-1) else 0
infix |-| 6
x |-| y = abs (x - y)
