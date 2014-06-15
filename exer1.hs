main = do
    putStrLn "Enter string:"
    s <- getLine
    if (s /= "") then 
            do
            putStrLn $ reverse s
            main
        else
        print "End."
