test = [1,4,6,3,7,9,7,9,2,3,1,2,3,1,5,6,4,1,2,3,4,6,5,4,6]

def lsearch(array, value):
    i = 0
    while i < len(array) and array[i] != value:
        i += 1
    if i < len(array):
        return i
    else: 
        return None

print(lsearch(test, 9))
print(lsearch(test, 8))

"""
Инвариaнт:

"""

