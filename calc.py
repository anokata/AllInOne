#!/usr/bin/env python
def a():
    x = (7-6.35)/6.5 + 9.9
    y = (1.2/36 + 1.2/0.25) - (1 + 5/16.0)
    z = y/(169/24.0)
    u = x/z
    print(x, y, z, u)
    return u

a()

def b():
    print((0.1 + 7/40.0)/0.4 -19/25.0)
    return ((7/9.0 - 47/72.0)/1.25 + 7/40.0)/(0.358-0.108)*1.6 - 19/25.0

print(b())
