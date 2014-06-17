#!/usr/bin/env runhaskell
import Prelude hiding (catch)
import Data.Either

test1 = "10 4 3 + 2 * -"

main = do
    print $ calculate test1 --input

calculate :: String -> Either String Int
calculate [] = Left "Empty!"


