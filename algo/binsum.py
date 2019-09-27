
a=list("1001010101111010100101")
b=list("1010101010101110101010")
a=list("10")
b=list("11")

def binsum(a, b):
    print((int("".join(a), 2) , int("".join(b), 2)))
    print((int("".join(a), 2) + int("".join(b), 2)))
    print("{0:b}".format((int("".join(a), 2) + int("".join(b), 2))))
    n = len(a)
    i = n - 1
    c = list("0" * (n+1))
    while i >= 0:
        c[i] = a[i] + b[i]
        i -= 1

    print((int("".join(c), 2)))
    return c

print("".join(binsum(a, b)))
