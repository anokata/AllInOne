{-есть правила удлинняющие и укорачивающие (условно же). = подстановка вместо символа или нескольких символов других

substitue :: what -> where -> in -> out

ex: substitue /(A->Not A)/ `with` /B and C/  = fun on in to out даёт фун - праволо какое то.

что мы хотим получть
1 имея какую либо начальну "строку" типа "А-В" получить операцией с параметром "С+З" и "А" строку "С+З-В"
2 
-}
-- убрать ещё : (:) ++ tail == (,) []
--import Prelude ()
type I = String
data M a = N | J a deriving (Show,Eq)
{-
s :: I->I->I->I
s a b i = 
--разбить строку i согласно а на множество частей: на список строк до каждого из вхождения(не считая предыдущие)
b :: I->I->[I] -- b "a" "ccaccaccb" = ["cc","cc","ccb"]
b a i = case e a i "" of
    (n,m) ->-}
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

assert :: Int -> Bool
assert 1 = test1 == N
assert 2 = test2 == J "dsfabsdf"
assert 3 = test3 == J ("dsf","sdf")
assert 4 = test4 == J ("get the a-> b in "," and otehr")
assert 5 = test5 == N
assert 6 = test6 == J ("","bc")
assert 7 = test7 == J ("bc","")

allassert = all id (map assert [1..7])


