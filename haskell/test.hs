--test
import Data.Time
newtype A = A Int deriving (Show)
a = replicate (1000*100) (A 2); b = map (\(A x)->A (x+2)) a; c =foldr (\(A x) (A y)->A (x+y)) (A 0) b

a2 = replicate (1000*100) (A 2); b2 = map (\(A x)->A (x+2)) a2; c2 =foldl (\(A x) (A y)->A (x+y)) (A 0) b2
--time



data B = B A deriving (Show)
aa = replicate (1000*100) (B $ A 2); bb = map (\(B (A x))->B $ A (x+2)) aa; cc =foldr (\(B (A x)) (B (A y))->B $ A (x+y)) (B $ A 0) bb

main = do 
  x <- getCurrentTime 
  putStrLn (show c)
  y<-getCurrentTime
  print (diffUTCTime y x)

  x <- getCurrentTime 
  putStrLn (show c2)
  y<-getCurrentTime
  print (diffUTCTime y x)

  x <- getCurrentTime
  putStrLn (show cc)
  y<-getCurrentTime
  print (diffUTCTime y x)

