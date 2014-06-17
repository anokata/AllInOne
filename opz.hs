#!/usr/bin/env runhaskell
import Prelude hiding (catch)
import Data.Either
--import qualified Data.Map as M

test1 = "10 4 3 + 2 * -"

main = do
    print $ calculate test1 --input

calculate :: String -> Either String Double
calculate [] = Left "Empty!"
calculate x = let res = foldl dispatch emptyStack (words x) in
                case res of
                    [] -> Left "Error!"
                    [x] -> Right x
                    _ -> Left "Err: Too many args!"

-- = take 1 & drop 1
pop :: [a] -> (a, [a])
pop x = (head x, tail x)
--push :: [a] -> a -> [a]
--push = flip :
push :: a -> [a] -> [a]
push = (:)

type Stack a = [a]
emptyStack = []

dispatch :: Stack Double -> String -> Stack Double
dispatch (x:y:t) "+" =  (x+y):t
dispatch (x:y:t) "-" =  (x-y):t

