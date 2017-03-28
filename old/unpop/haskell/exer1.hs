import Control.Monad
import Data.Char
{-
main = do
    putStrLn "Enter string:"
    rs <- sequence [print 1, print 2]
    when False (print "not Lazy IO")
    s <- getLine
    if (s /= "") then 
            do
            putStrLn $ reverse s
            --main
        else
        print "End."
-}
main = do 
    {- forever $ do 
        i <- getLine
        putStrLn $ map toUpper i -}
  {-  c <- getContents
    putStr $ map toUpper c  -}
    interact $ map toUpper
