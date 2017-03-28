#!/usr/bin/env runhaskell
import System.IO
import Data.List
import System.Directory

menufile = "menu.mn"

main = do 
    putStrLn "Enter element to add:"
    e <- getLine
    {-withFile "menu.mn" AppendMode 
        (\h->
            --strings <- hGetContents h
            hPutStrLn h e)-}
    appendFile menufile (e++"\n")
    
    
        


