
a=list("1001010101111010100101")
b=list("1010101010101110101010")
#a=list("11")
#b=list("11")

def binsum(a, b):
    #print((int("".join(a), 2) , int("".join(b), 2)))
    #print((int("".join(a), 2) + int("".join(b), 2)))
    print("{0:b}".format((int("".join(a), 2) + int("".join(b), 2))))
    n = len(a)
    i = n - 1
    c = list("0" * (n+1))
    c1 = 0
    while i >= 0:
        b1 = int(a[i])
        b2 = int(b[i])
        sum = b1 + b2 + c1
        #print(i, c, c1, a[i], b[i], '|', b1, b2, sum)
        if sum >= 2:
            c1 = 1
            c[i+1] = str(sum % 2)
        else:
            c[i+1] = str(sum)
            c1 = 0
        i -= 1
    #print(i, c, c1, a[i], b[i], '|', b1, b2, sum)
    c[0] = str(c1)

    #print((int("".join(c), 2)))
    return c

print("".join(binsum(a, b)))
