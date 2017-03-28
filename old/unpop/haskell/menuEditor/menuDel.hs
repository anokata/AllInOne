#!/usr/bin/env runhaskell
import System.IO
import Data.List
import System.Directory
import System.Environment

menufile = "menu.mn"

main = do 
    args <- getArgs
    mapM_ putStrLn args
    putStrLn "There we have:"
    strings <- readFile menufile
    let elements = lines strings
    mapM_ putStrLn (zipWith (\n l->"("++ (show n) ++")" ++ " - " ++ l) [0..] elements)
    putStrLn "Enter number corresponding entry to delete:"
    sn <- getLine
    let n = read sn
    writeFile menufile (unlines $ delete (elements !! n) elements)
