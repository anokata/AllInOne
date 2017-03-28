#!/usr/bin/env runhaskell
--get args num and sum it
import System.Environment
import System.IO
main = do
    args <- getArgs
    --print args
    -- hGetLine stdin
    if not (null args) then
        print (sum (map read args :: [Int]))
    --hIsEOF stdin
    else do
        c <- hGetContents stdin
        print (sum (map read (lines c) :: [Int]))
    
