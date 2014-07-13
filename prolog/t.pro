cat(anim).
main1 :- write("hello byte!").
puts(S) :- S=[H|T], put_char(H), puts(T).
main :- puts("Hello Logic Universe!").

setA(a).
setA(b).
setA(c).
setA(d).

setB(c).
setB(d).
setB(X) :- setA(X).

f(a, b).
f(b, c).
f(c, d).
f(a, e).
g(X, Y) :- f(Y, Z), f(Z, X) .
h(X, Y):- f(X, Z), f(Y, Z), not(X=Y).
j(X, Y):- f(Z, X), f(Z, Y), not(X=Y).
 f('z', X).
point(X, Y) :- number(X), number(Y).
dup(X) :- [X, X].
%D :- K.
:-f(X,Y).

%parent(torn,bob).
parent(pam,bob).
parent(tom,bob).
parent(tom,liz).
parent(bob,ann).
parent(bob,pat).
parent(pat,jim).
child(X,Y) :- parent(Y,X).
grandparent(X,Y) :- parent(X,Z), parent(Z, Y).
sameparent(Z,X,Y) :- parent(Z,X), parent(Z, Y).
female(pam).
male(tom).
male(bob).
female(liz).
female(ann).
male(jim).
sex(pam,fem).
sex(tom,mas).
sex(bob,mas).
offspring(Y,X) :- parent(X,Y).
mother(X,Y) :- parent(X,Y), female(X).
sister(X,Y) :- female(X), parent(Z,X), parent(Z,Y).
haschild(X) :- parent(X,Y).
happy(X) :- haschild(X).
has2c(X) :- parent(X,Y), sister(Z,Y).
grandchild(X,Y) :- parent(Z, X), parent(Y, Z). 
aunt(X,Y) :- parent(Z,Y), sister(X,Z).
predo(X,Z) :- parent(X,Z).
predo(X,Z) :- parent(X,Y), predo(Y,Z).
pred(X,Z) :- parent(X,Z); parent(X,Y), pred(Y,Z).
p(X,Z) :- parent(X,Z).
p(X,Z) :- parent(Y,Z), p(X,Y).

'A AA'(a).
'some'('of some элементов').
%a +:+ a.
% A1 is predo(bob,X).
% A2 is pred(bob,X).
% A1=A2
n(1,one).
n(s(1),two).
n(s(s(1)),three).
n(s(s(s(X))), N) :- n(X,N).
trans(Num,Word) :- Num = 1 , Word = one.

%send(@display, inform, 'Goodbye, World !').

%lists
member(X,L) :- L=[H|_], X=H; L=[_|T], member(X,T).
%member(X,[X|_]). member(X,[_|T]) :- member(X,T).
%appent(X,Y,S) == X+Y=S
appent(X,[],X).
appent([],Y,Y).
appent([H|T],Y,[H|S]) :- appent(T,Y,S).
%список R без 3х элементов в конце это список Х который получен добавлением к R каких то 3 элем. в конце.
del3(X,R):- appent(R,[_,_,_],X).
%список R без 3х эл. 
del3f(X,R) :- appent([_,_,_],R,X).
del3fl(X,R) :- del3f(Y,R), del3(X,Y).
%элемент ялвяется последним для списка, если 
last(I,[I | []]). % last(I,[I]).
last(I,[_|T]) :- last(I,T).  %иначе ищем в хвосте
lastc(I,L) :- appent(_,[I],L).








