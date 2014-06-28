import qualified Prelude as P
import Prelude hiding (head,tail,(!!),take,map,filter,zip,zipWith,iterate)
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

zipWith :: (a->b->c) -> Stream a -> Stream b -> Stream c
zipWith f (a :& aa) (b :& bb) = f a b :& zipWith f aa bb

test4 = zipWith (\x y->  (show x)++"%"++[y]) ints1 test1
-- как из двух фун от одного арг. сделать фун от двух... и третьей связывающей рез? - аппфунктор?

iterate :: (a->a) -> a -> Stream a
iterate next a = a :& iterate next (next a)

test5 = iterate succ 'a'

--- (.)
ab :: Int -> Char
bc :: Char -> Bool
ab = chr
bc = (=='a')

abc = (.) bc ab
ac = bc . ab

infixl 0 :&
instance Num a => Num (Stream a) where -- + * - negate abs signum fromInteger
    (+) (s :& ss) (t :& tt) = s P.+ t :& ss+tt
    (-) (s :& ss) (t :& tt) = s-t :& ss-tt
    (*) (s :& ss) (t :& tt) = s*t :& ss*tt
    negate (s :& ss) = negate s :& negate ss
    abs (s :& ss) = abs s :& abs ss
    signum (s :& ss) = signum s :& signum ss
    fromInteger x = constStream (fromInteger x) --iterate id $ fromInteger x

data St a b = St (a -> (b, St a b))
ap :: St a b -> [a] -> [b]
ap (St s) a = map s a












