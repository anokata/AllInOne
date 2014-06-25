import qualified Prelude as P
import Prelude hiding (head,tail,(!!),take,map,filter,zip,zipWith)
import Data.Char

data Stream a = a :& Stream a

ints :: Int -> Stream Int
ints x = x :& ints (x+1)

constStream :: a -> Stream a
constStream x = x :& constStream x

head :: Stream a -> a
head (x :& _) = x

tail :: Stream a -> Stream a
tail (_ :& xs) = xs

(!!) :: Stream a -> Int -> a
(!!) (s :& _) 0 = s
(!!) (_ :& s) n = (!!) s (n-1)

take :: Int -> Stream a -> [a]
take 0 _ = []
take n (s :& ss) = s : take (n-1) ss

instance Show a => Show (Stream a) where
    show xs = P.init (show (take 5 xs)) P.++ "..."
--
map :: (a->b)-> Stream a -> Stream b
map f (s :& ss) = f s :& map f ss

ints1 = ints 1
test1 = map (\x-> chr x) (ints 40)

filter :: (a->Bool) -> Stream a -> Stream a
filter p (s :& ss) | p s = s :& filter p ss
                   | otherwise = filter p ss

test2 = filter even ints1

zip :: Stream a -> Stream b -> Stream (a, b)
zip (a :& aa) (b :& bb) = (a, b) :& (zip aa bb)

test3 = zip ints1 test2 -- ха. равномощность чётных и целых, посчитали

zipWith (a->b->c) -> Stream a -> Stream b -> Stream c
zipWith 




