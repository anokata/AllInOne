#!/usr/bin/env runhaskell
import Prelude hiding (catch)
import Data.Either
--import qualified Data.Map as M

test1 = "10 4 3 + 2 * -"
test2 = "90  34  12  33  55  66  +  *  -  +"
test3 = "90  34  12  33  55  66  +  *  -  +  -"
test4 = "2.7  ln"
test5 = "10  10  10  10  sum  4  /"
test6 =  "10  10  10  10  10  sum  4  /"
test7 = "10  2 ^"

main = do
    print $ calculate test1
    print $ calculate test2
    print $ calculate test3
    print $ calculate test4
    print $ calculate test5
    print $ calculate test6
    print $ calculate test7

calculate :: String -> Either String Double
calculate [] = Left "Empty!"
calculate x = let res = foldl dispatch emptyStack (words x) in
                {-case res of
                    [] -> Left "Error!"
                    [x] -> Right x
                    _ -> Left "Err: Too many args!" -}
                    Right $ head res


type Stack a = [a]
emptyStack = []

dispatch :: Stack Double -> String -> Stack Double
dispatch (x:y:t) "+" =  (x+y):t
dispatch (x:y:t) "-" =  (y-x):t
dispatch (x:y:t) "*" =  (x*y):t
dispatch (x:y:t) "/" =  (y/x):t
dispatch (x:y:t) "^" =  (y**x):t
dispatch (x:t) "ln" =  (log x):t
dispatch x "sum" =  [sum x]
dispatch x ns =  read ns : x --reads !!
-- видимо хватит пытаться всюду засунуть дата-драйвен паттерн!!! ТАк лучше!
-- и не надо пытаться заранее улучшить. напр. делать обработку ошибок. Сначала пусть просто работает!

