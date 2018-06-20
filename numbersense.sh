#!/bin/bash
clear
A=5
B=10
C=$(expr $B - $A)
number=$(shuf -i $A-$B -n1)
x=$number

printf "         " 
while [ $x -gt 0 ]  ; do 
    dec=$(shuf -i 1-$x -n1)
    x=$(expr $x - $dec)
    #printf "%${dec}s\n" |tr " " "="
    printf "%${dec}s" |tr " " "="
done

tput cup 0 0
read
echo $number
