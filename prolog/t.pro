cat(anim).
main1 :- write("hello byte!").
puts(S) :- S=[H|T], put_char(H), puts(T).
main :- puts("Hello Logic Universe!").
