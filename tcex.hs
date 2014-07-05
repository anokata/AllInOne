-- tcex.hs
import qualified Prelude as P

class Functor f where
    fmap :: (a -> b) -> f a -> f b

data Either e a = Left e | Right a

instance (P.Show e, P.Show a) => P.Show (Either e a) where
    show (Left e) = "Err: " P.++ P.show e
    show (Right a) = "The: " P.++ P.show a

instance Functor (Either e) where
    fmap _ (Left x) = Left x
    fmap f (Right x) = Right (f x)

instance Functor ((->) e) where -- fmap :: (a -> b) -> (->) e a -> (->) e b == (a -> b) -> (e->a) -> (e->b)
    fmap f x = f P.. x 

instance Functor ((,) e) where -- fmap :: (a -> b) -> (e, a) -> (e, b)
    fmap f (e, x) = (e, f x) -- (,) e (f x)

data Pair a = Pair a a

instance Functor Pair where -- fmap :: (a -> b) -> Pair a -> Pair b
    fmap f (Pair x y) = Pair (f x) (f y)
instance P.Show a => P.Show (Pair a) where
    show (Pair x y) = "<:" ++ P.show x ++ ", " ++ P.show y ++ ":>"

data ITree a = Leaf (P.Int -> a) | Node [ITree a]

instance Functor ITree where -- fmap :: (a->b) -> ITree a -> ITree b -- Leaf (P.Int -> a) -> Leaf (P.Int -> b)
    fmap f (Leaf x) = Leaf (fmap f x)
    fmap f (Node x) = Node (P.fmap (fmap f) x)

main = P.print t

----
x1 = Left 3 :: Either P.Int a
x2 = Right 4 :: Either e P.Int
y1 = fmap (P.*42) x1
y2 = fmap (P.*42) x2
x3 = (\x -> P.show (x P.* 20)) :: (->) P.Int P.String
y3 = (fmap ((\(x:xx) -> x) :: (->) P.String P.Char) x3) :: (->) P.Int P.Char
y33 = y3 32
x33 = x3 33
s = P.show
(++) = (P.++)
x4 = ('a', 8) :: (P.Char, P.Int)
y4 = fmap (P.*42) x4
x5 = Pair 8 9 :: Pair P.Int
y5 = fmap (P.*42) x5

t = P.concat (P.map P.show [x1, y1, x2, y2]) ++ s x33 ++ P.show y33 ++ P.show x4 ++ P.show y4 ++ P.show x5 ++ P.show y5
