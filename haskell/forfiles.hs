#!/usr/bin/env runhaskell
--get cmd & list of files, exec on every file cmd
import System.Environment
import System.Process

main = do
    (cmd:args) <- getArgs
    sequence_ $ fmap (\x-> runProcess cmd [x] Nothing Nothing Nothing Nothing Nothing) args

