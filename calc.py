#!/usr/bin/env python
def a():
    x = (7-6.35)/6.5 + 9.9
    y = (1.2/36 + 1.2/0.25) - (1 + 5/16.0)
    z = y/(169/24.0)
    u = x/z
    print(x, y, z, u)
    return u

#a()

def b():
    #print((0.1 + 7/40.0)/0.4 -19/25.0)
    print((0.1 + 7/40.0)*6.4 - 19/25.0)
    print(0.64 + 7/40.0*6.4 - 19/25.0)
    print(7*6.4/40)

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
    e = 2.75 - (1.5)
    f = d/e
    r = c - f
    print(c)
    return f
#print(b())
#print(c())
print(d())
