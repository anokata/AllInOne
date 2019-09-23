#!/usr/bin/env python

# TODO Gtk visualize, speed test, modules for algos and ui

test1 = [5,4,3,2,1,8,4,3,2,2,1,8]

def insert_sort(a):
    for j in range(2, len(a)):
        current = a[j]
        i = j-1
        while i >= 0 and a[i] > current: # >=
            #print(a)
            a[i+1] = a[i]
            i -= 1
        a[i+1] = current
    return a

def insert_sort_back(a):
    for j in range(2, len(a)):
        current = a[j]
        i = j-1
        while i >= 0 and a[i] < current:
            a[i+1] = a[i]
            i -= 1
        a[i+1] = current
    return a

print(test1)
insert_sort(test1)
print(test1)
insert_sort_back(test1)
print(test1)
