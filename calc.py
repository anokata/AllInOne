#!/usr/bin/env python
def a():
    """ doc 2 """
    x = (7-6.35)/6.5 + 9.9 # style
    y = (1.2/36 + 1.2/0.25) - (1 + 5/16.0)
    z = y/( 169/24.000)
    u = x/z
    a = x*x+y
    print(x, y, z, u)
    return u

#a()

def b():
    print((0.1 + 7/4.0)/0.4 -19/25.0)
    print((0.1 + 7/40.0)*6.4 - 19/25.0)
    print(8.64 + 7/40.0*6.4 - 19/25.0)
    print(7*6.4/40)
    print(2+2)

    return ((7/9.0 - 47/72.0)/1.25 + 7/40.0)/(0.358-0.108)*1.6 - 19/25.0

def c():
    print(((1.5 + 1/4.)/(18+1/3.)))
    print((0.4 + 49/55. - 3/11.) * (220/7.))
    return ((0.5/1.25+7/5.0/(1+4/7.)-3/11.) * 3)/((1.5 + 1/4.)/(18+1/3.))

def d():
    a = (2+3/4.)/1.1 + (3 + 1/3.)
    b = 2.5 - 0.4*(3+ 1/3.)
    c = (a/b) / ( 7/5.)
    d = (2+1/6. +4.5)*0.375
    e = 2.75 - (1.5) # hi
    f = d/e
    r = c - f
    print(c)
    return f
#print(b())
#print(c())
print(d())

def e():
    a = (13.75 + 9 + 1/6) * 1.2
    b = (11.3 - 8.5) * 5/10
    x = a/b
    print(a,b,x)
    c = (6.8 - 3.6) * (5 + 5/6)
    d = (3 + 2/3 - 3 - 1/6) * 56
    y = c/d
    print(c, d, y)
    z = x + y - 27 - 1/6
    return z

print(e())

def f():
    a = (3+1/3 + 2.5)/(2.5-1-1/3)*(4.6-2-1/3)/(4.6+2 + 1/3)*5.2
    print(a)
    b = (0.05/(1/7-0.125) + 5.7)
    print(b)
    print(a/b)
    print(0.05/(1/7-0.125))
    print((3+1/3 + 2.5)/(2.5-1-1/3))
    print((4.6-2-1/3)/(4.6+2 + 1/3))
    print(17/52)
    return a/b
print(f())

def g():
    a = (1.88+3/25)*3/16
    b = (0.625 - (13/18)/(26/9))
    c = (0.216/0.15 + 0.56)/0.5
    d = (7.7 / (24 + 3/4) + 2/15) * 4.5
    r = a/b + c/d

    return r
print(g())

print(2,2)

class TestOne():
    # no doc
    def __init__():
        pass
        print(28*28)
