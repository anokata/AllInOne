-- tcex.hs
import qualified Prelude as P

class Applicative f where
    pure :: a -> f a
    (<*>) :: f (a->b) -> f a -> f b

class Functor f => Monoidal f where -- have already fmap
    unit :: f () -- :: () -> f ()
    (**) :: f a -> f b -> f (a, b)

-- Monoidal ~ Applicative
-- выразить pure & <*> через unit & **   и наоборот
-- посмотрим как это будет реализовываться для кого то хоть
instance Functor Maybe where fmap f (Just x) = Just (f x); fmap _ Nothing = Nothing
instance Monoidal Maybe where
    --unit Nothing = Nothing
    unit = Nothing
    (Just x) ** (Just y) = Just (x, y)

--- just use fmap :: (a -> b) -> f a -> f b !!!
pure' :: Monoidal a => b -> a b
pure' x = fmap (\_-> x) unit
(<<**>>) :: Monoidal f => f (a->b) -> f a -> f b
f <<**>> x = fmap (\(a,b)->a b) (f ** x)

{-
unit' :: Functor f => f ()
unit' = pure ()
-}

data Maybe a = Nothing | Just a
instance Applicative Maybe where
    pure = Just
    (Just f) <*> (Just x) = Just (f x)
    _ <*> _ = Nothing

newtype ZipList a = ZipList { getZipList :: [a] }
instance Applicative ZipList where
  pure x = ZipList (P.repeat x)
  (ZipList gs) <*> (ZipList xs) = ZipList (P.zipWith (P.$) gs xs)

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

instance P.Show a => P.Show (Maybe a) where
    show Nothing = "nothing"
    show (Just x) = "just# " ++ P.show x

instance P.Show a => P.Show (ZipList a) where
    show (ZipList a) = P.show a
    
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

{-
pure f <*> pure x = pure (f x)
u <*> pure y = pure ($ y) <*> u
u <*> (v <*> w) = pure (.) <*> u <*> v <*> w

pure (flip ($)) <*> (x <*> pure f) = pure (.) <*> pure (flip ($)) <*> x <*> pure f = 
 = pure ((flip ($)) .  ) <*> x <*> pure f = 




-}
