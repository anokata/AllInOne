import System.IO
import Data.Time

main = do 
    handle <- openFile "test.txt" ReadMode
    contents <- hGetContents handle
    putStr contents
    print handle
    hClose handle
    
    withFile "test.txt" ReadMode (\x->do 
        i <- (hGetContents x)
        putStr i)
    
    c <- readFile "test.txt" 
    print c
    
    time <- getCurrentTime
    zone <- getCurrentTimeZone
    print $ utcToLocalTime utc time
    print $ utcToLocalTime zone time
    
    
