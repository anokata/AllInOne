{-есть правила удлинняющие и укорачивающие (условно же). = подстановка вместо символа или нескольких символов других

substitue :: what -> where -> in -> out

ex: substitue /(A->Not A)/ `with` /B and C/  = fun on in to out даёт фун - праволо какое то.

что мы хотим получть
1 имея какую либо начальну "строку" типа "А-В" получить операцией с параметром "С+З" и "А" строку "С+З-В"
2 
есть начальное множество правильных строк. из каждой можно подстановкой в термы любой из этого множества строки получить новую правильную.
т.е. есть ещё множество термов-переменных.
похоже на аппликативный функтор на списках или генераторы
-}
t = ["A","B","C"]
a = ["(A->(B->A))","((A->(B->C))->((A->B)->(A->C)))","((-B->-A)->((-B->A)->B))"]
-- neXt :: Theorems\aximos -> Terms -> NewTheorems
x :: S->S->S
x a t = [s y t b | y<-a, t<-t, b<-a]
xx = x a t
{-надо бы ещё одновременную подстановку нескольких? или переименование?(оно=подстановка напр "А" на "В")
-}
-- +MP! X->Y , X => Y  -- если мы подставим в Х Теорему и в Y что? и это окажется теоремой то Y Теорема
-- если подставив в Х теорему, это является началом какой то строки "(Х->" то есть то остаток этой строки можно добавить в теоремы
-- применять его пока не станет не к чему, без изменений
-- убрать ещё : (:) ++ tail == (,) []
import Data.List (isPrefixOf)
-- isTheorem :: I->AxiomaticSystem->B
-- getTheoremProof :: I->AxiomaticSystem->Proof
--allPossibleWithMP :: Theorems->TermsVar->Theorems
--allPossibleWithMP a t = findMPTheorems a (generateAllSubst a)  -- "X->"
generateAllSubst :: Theorems->S -- get all "X->"...
generateAllSubst a = fmap (\x-> "("++(s x "X" "X->")++")") a
findMPTheorems :: Theorems->S->Theorems
findMPTheorems a b = getSecondImplication b $ filter (startWithOneOf b) a
startWithOneOf :: I->S->B
startWithOneOf i sts = any id (fmap (isPrefixOf i) sts)
getSecondImplication :: S->Theorems->Theorems
getSecondImplication st tr = 

--import Prelude ()
type Axiom = I
type Theorem = I
type Axioms = S
type Theorems = S
type TermsVar = S
type I = String
type B = Bool
type S = [I]
data M a = N | J a deriving (Show,Eq)
{--}
--получив список разбитый b, надо лишь вставить между каждой строкой a --intersparse
s :: I->I->I->I
s a b i = n a $ f b i 

n :: I->[I]->I
n "" s = concat s
n i [s] = s
n i (s:ss) = s ++ i ++ n i ss

--разбить строку i согласно а на множество частей: на список строк до каждого из вхождения(не считая предыдущие)
f :: I->I->[I]
f a i = b a i []
  where  
    b :: I->I->[I]->[I] -- b "a" "ccaccaccb" = ["cc","cc","ccb"]
    b a i c = case e a i of
        J (n,m) -> b a m (c++[n])
        N -> c++[i]
--найти вхождение подстроки а. отрезать до неё и после. найти остальные вхождения в остатке.
e :: I->I->M (I,I)
e a i = c a i "" 
  where
    c :: I->I->I->M (I,I)
    c a i k = case d a i of
                N | i=="" -> N
                N -> c a (tail i) (k++[head i])
                J j -> J (k,j)
--сравнив первые элементы. при равенстве - продолжить со след символов. иначе начать заново со сдел символов
d :: I->I->M I
d [] j@(i:_) = J j
d (a:_) [] = N
d (a:[]) (i:[]) | a==i = J ""
                | otherwise = N
d (a:aa) (i:ii) | a==i = d aa ii
                | otherwise = N

test1 = d "ab" "dsfabsdf" 
test2 = d "ab" "abdsfabsdf" 
test3 = e "ab" "dsfabsdf" 
test4 = e "a->b" "get the a-> b in a->b and otehr" 
test5 = e "a->b" "get the a-> b in a and otehr" 
test6 = e "a" "abc" 
test7 = e "a" "bca" 
test8 = f "a->b" "get the a-> b in a->b and otehr" 
test9 = f "a->b" "get the a-> b in a and otehr" 
test10 = f "a" "abc" 
test11 = f "a" "bca" 
test12 = f "a" "abca" 
test13 = f "a" "baca_a aaa" 
test14 = n "," ["f","a","c","k","u"]
test15 = n "," ["","a","c","k",""]
test16 = s "-" "b" "bttattbttbttbb"

assert :: Int -> Bool
assert 1 = test1 == N
assert 2 = test2 == J "dsfabsdf"
assert 3 = test3 == J ("dsf","sdf")
assert 4 = test4 == J ("get the a-> b in "," and otehr")
assert 5 = test5 == N
assert 6 = test6 == J ("","bc")
assert 7 = test7 == J ("bc","")
assert 8 = test8 == ["a->b", "get the a-> b in "," and otehr"]
assert 9 = test9 == ["get the a-> b in a and otehr"]
assert 10 = test10 == ["","bc"]
assert 11 = test11 == ["bc",""]
assert 12 = test12 == ["","bc",""]
assert 13 = test13 == ["b","c","_"," ","","",""]
assert 14 = test14 == "f,a,c,k,u"
assert 15 = test15 == ",a,c,k,"

allassert = all id (map assert [1..7])


