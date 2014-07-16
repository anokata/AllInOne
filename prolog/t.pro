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

%del from Source the X to Dest
del([X|S],X,S). % если этот эл в говове то результат это хвост
del([S|T],X,[S|T2]) :- del(T,X,T2).
%de(S,X,D) :- S=[H|T], H=X, D=T.
%de(S,X,D) :- S=[A|T], del(T,X, D).
subl([],L).
subl([S|SS],[S|LL]) :- subl(SS,LL).
subl(S,[L|LL]) :- subl(S,LL).
sub(S,L) :- appent(L1,L2,L), appent(S,L3,L2).
perm(S,D) :- S=[H|T], member(H,D), del(D,H,X) , perm(T,X).

:- op(600, xfx, has).

?- sub([1,3,4],X).

:- op(950, xfx, [==>, abracadabra]).
:- op(900, fy, ~~).
%A ==> A.

teor((A ==> (B ==> C)) ==> ((A ==> B) ==> (A ==> C))).
teor(A ==> (B ==> A)).
teor((~~ B ==> ~~ A) ==> ((~~ B ==> A) ==> B)).
teor(B) :- teor((A ==> B)), teor(A).
%mp! A==>B, A

 
display_date :-
    get_time(Time),
    format_time(atom(Short), '%Y-%M-%d',      Time),
    format_time(atom(Long),  '%A, %B %d, %Y', Time),
    format('~w~n~w~n', [Short, Long]).

:- op(300, xfx, plays).
:- op(200, xfy, and).
% jim plays foot and sq. - plays(jim, and(foot, sq))
% sus plays ten and bas and vol. - plays(sus, and(ten, and(bas,vol))).
:- op(300, xfx, was).
:- op(200, xfx, of).
:- op(100, fy, the).
diana was the secretary of the department.

t(0+1,1+0).
t(X+0+1, X+1+0).
t(X+1+1, Z) :-
    t(X+1, X1),
    t(X+1, Z).

% BBk
% T in U . T e. U.
% определим множество С(назовём setC) = {a,b,c}
:- op(300, xfy, in). % x in y in z = (x in y) in z or ..?
% отношение принадлежность это суть предикат от объекта и множества (оба терма).
a in setC.
b in setC.
c in setC.
% множество включим в отношение, характеризующее его как множество. (т.е. множество множеств будет).
isSet(setC).
% можно узнать все объекты множества : X in setC. или все множества в которых есть данный объект b in X.
% опр. отношение включения x => y х вложено в у или у включает х. Так: Если произвольный элемент принадлежит одному множеству, то он должен принадлежать и второму. прологовская :- тут и есть импликация (только обратная). и разумеется оба они должны быть множествами.
:- op(290, xfy, =>).
%X => Y :- (A in X :- A in Y). %, isSet(X), isSet(Y).
%X => Y :- not(A in X) ; A in Y. % переведя импликацию в НЕ А или В. ОП не хватает квантора!
X => Y :- forall(A in X, A in Y). % есть ->
%X => Y :- forall(A, A in X -> A in Y).
% сделаем ещё одно множество d = {a,b} 
b in setD.
a in setD.
isSet(setD).
b in setE.
a in setE.
e in setE.
isSet(setE).
b in setF.
a in setF.
isSet(setF).
% и спросим вложено ли оно в С: setD => setC. setE => setC.
:- op(280, xfy, =-=).
X =-= Y :- X=>Y, Y=>X.
% coll ? coll(R) :- R(_).

нравится(мэри, пища).
нравится(мэри, вино).
нравится(джон, вино).
нравится(джон, мэри).
% нравится(мэри, X), нравится(джон, X). trace.
%gtrace. gdebug.
нравится(джон, X) :- нравится(X, вино).

sentence --> noun_phrase, verb_phrase. 
noun_phrase --> det, noun. 
verb_phrase --> verb, noun_phrase. 
det --> [the]. 
det --> [a]. 
noun --> [cat]. 
noun --> [bat]. 
verb --> [eats]. 
% ?- sentence(X,[]).
s --> symbols(Sem,a), symbols(Sem,b), symbols(Sem,c). 
symbols(end,_) --> []. 
symbols(s(Sem),S) --> [S], symbols(Sem,S). 

tr([],[]).
tr([H|T],[B|A]) :- za(H,B), tr(T,A).
za(is,am).
za(i,you).
za(X,X).

% tr([am,i,is],X).
% name(X,Y). name(some,"some").
sm(X,Y) :- name(X,A), name(Y,B), sm1(A,B).
sm1([],[_|_]).
sm1([H|_],[A|_]) :- H<A.
sm1([H|T],[H|B]) :- sm1(T,B).

sme(X,Y) :- name(X,A), name(Y,B), sme1(A,B).
sme1([],[_|_]).
sme1([],[]).
sme1([H|_],[A|_]) :- H<A.
sme1([H|T],[H|B]) :- sme1(T,B).

