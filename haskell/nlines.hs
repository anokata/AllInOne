#!/usr/bin/env runhaskell
--read file, count lines, out
import System.Environment
import Data.List

main = do
    (f:args) <- getArgs
    con <- readFile f 
    print $ length (nub (lines con))
