import math

def s(n):
    return 1

def sM2(n):
    return n

def ss(n):
    return n*n

def fac(n):
    return n if n < 2 else n * fac(n-1)

def xn(n):
    return math.pow(n, 1/n)

def sum(f,g,n):
    s = 0
    for x in range(1,n+1):
        s += f(x)/g(x)
    return s

print(fac(2))
print(fac(3))
print(fac(10))
print(sum(s,sM2,20))
print(sum(s,sM2,120))
print(sum(s,sM2,1020))
print(sum(s,sM2,10000))
print(sum(s,sM2,100000))
print()
print(sum(sM2,fac,20))
print(sum(sM2,fac,120))

print(math.e - sum(s,fac,7))

print(sum(xn,ss,120))
print(sum(xn,ss,1020))
print(sum(xn,ss,10020))
print(sum(xn,ss,100020))
print(sum(xn,ss,1000020))
