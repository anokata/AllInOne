#!/usr/bin/env runhaskell
import System.IO
import System.Environment
import Data.List
import System.Directory
import Control.Exception

showcmd = ["show","s","view","v"]
delcmd  = ["del","d","delete","remove","r"]
addcmd  = ["add","a","+"]
bumpcmd  = ["bump","b","top"]
-- cmd arg format: menu cmd file [arg]
help = "use menu CMD FILE [ARG]\n where\n CMD=show or del or add"
err_more = "need more arguments: "++help

dispatch :: String -> [String] -> IO ()
dispatch [] = (\x-> putStrLn err_more)
dispatch x | x `elem` showcmd = showcmdF
dispatch x | x `elem` addcmd = addcmdF
dispatch x | x `elem` delcmd = delcmdF
dispatch x | x `elem` bumpcmd = bumpcmdF

showcmdF :: [String] -> IO ()
showcmdF []  = putStrLn err_more
showcmdF (file:_) = do
    strings <- readFile file
    let elements = lines strings
    mapM_ putStrLn (zipWith (\n l->"("++ (show n) ++")" ++ " - " ++ l) [0..] elements)

addcmdF :: [String] -> IO ()
addcmdF []  = putStrLn err_more
addcmdF (_:[])  = putStrLn err_more
--addcmdF (file:line:_) = do appendFile file (line++"\n")
addcmdF [file,line] = do appendFile file (line++"\n")

delcmdF :: [String] -> IO ()
delcmdF []  = putStrLn err_more
delcmdF (_:[])  = putStrLn err_more
delcmdF (file:sn:_) = do
    let n = read sn
    strings <- readFile file
    let elements = lines strings 
        newElements = unlines $ delete (elements !! n) elements
    bracketOnError (openTempFile "." "temp") 
        (\(tempName, tempHandle)-> do -- в случае ошибки освобождаем
            hClose tempHandle
            removeFile tempName)
        (\(tempName, tempHandle)-> do -- пытаемся делать?
            hPutStr tempHandle newElements
            hClose tempHandle
            removeFile file
            renameFile tempName file)
    --writeFile file (unlines $ delete (elements !! n) elements)


bumpcmdF :: [String] -> IO ()
bumpcmdF (file:sn:_) = do
    let n = read sn
    strings <- readFile file
    let elements = lines strings 
        newElements = unlines $ (elements !! n) : (delete (elements !! n) elements)
    bracketOnError (openTempFile "." "temp") 
        (\(tempName, tempHandle)-> do -- в случае ошибки освобождаем
            hClose tempHandle
            removeFile tempName)
        (\(tempName, tempHandle)-> do -- пытаемся делать?
            hPutStr tempHandle newElements
            hClose tempHandle
            removeFile file
            renameFile tempName file)

main = do
    (cmd:args) <- getArgs
    dispatch cmd args
    putStrLn "."
