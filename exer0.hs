module Void where
import Prelude (Show(..), Eq(..), Num(..),error,print,Int,($),Bool(..),otherwise,(++),
    putStrLn,getLine)

class Group a where
    e :: a
    groupPlus :: a -> a -> a
    inv :: a -> a
   -- e + a == a
   -- (inv a) + a == e
{-
data SystemConfig = SystemConfig [Config] -- конфиг системы это множество конкретных конфигов
data Config = Config [Setting] -- конфиг это множество правильных установок
data Setting = Setting Name Separator Expression -- установка это две имя разделитель выражение
data Name = Name String
data Separator = Char
data Expression = String
-- связи
-- ну например получить из конфига все установки на имя
--getConfigByName :: Config -> Config
-- упорядочить конфиг по именам с пом фун
--orderConfigByName :: Config -> (Name -> Name -> Bool) -> Config
-}

data Nat = Zero | Succ Nat deriving (Show, Eq)

instance Num Nat where
    a + Zero = a
    -- for fastest ?
    Zero + a = a
    (+) (Succ a) (Succ b) = Succ (Succ (a + b))
    (+) a (Succ b) = Succ (a + b)

    
    negate _ = error "Not def for Nat"
    a * Zero = Zero
    a * (Succ b) = a + (a * b)
    abs x = x
    signum Zero = Zero
    signum _ = Succ Zero
    fromInteger 0 = Zero
    fromInteger n = Succ (fromInteger (n-1))

natToInteger :: Nat -> Int
natToInteger Zero = 0
natToInteger (Succ n) = 1+(natToInteger n)

beside :: Nat -> Nat -> Bool
beside x y | (x == (Succ y)) = True
           | (y == (Succ x)) = True
           | otherwise = False

beside2 :: Nat -> Nat -> Bool
beside2 x y | (x == Succ(Succ y)) = True
           | (y == Succ(Succ x)) = True
           | otherwise = False

pow :: Nat -> Nat -> Nat
pow a Zero = Succ Zero
pow a (Succ Zero) = a
pow a (Succ b) = a * pow a b

max :: Nat -> Nat -> Nat
max x Zero = x
max Zero x = x
max (Succ x) (Succ y) = Succ (max x y)

data BinTree a = Leaf a | Branch (BinTree a) (BinTree a) deriving (Show, Eq)
reverse :: BinTree a -> BinTree a
reverse (Leaf x) = (Leaf x)
reverse (Branch x y) = Branch (reverse y) (reverse x)

depth :: BinTree a -> Nat
depth (Leaf x) = Zero
depth (Branch x y) = max (Succ (depth x)) (Succ (depth y))

leaves :: BinTree a -> [a]
leaves (Leaf x) = [x]
leaves (Branch x y) = (leaves x) ++ (leaves y)
{-
data Impl a b = Impl a b -- a->b
-- MP: A->B, A | B
-- expr.1 impl expr.2, expr.2
-- modusponens :: (Impl a b) -> a -> b
-- modusponens :: IsTheorem (Impl a b) -> IsTheorem a -> IsTheorem b
data IsTheorem = IsTheorem LogicExpr
data LogicExpr = LogicExpr1 | LogicExpr2
data LogicExpr1 = 
-}


main = do
    print (8::Nat)
    --print (2*3 :: Nat)
    --print $ natToInteger ((Succ (Succ Zero)) * (Succ (Succ (Succ Zero))))
    --print $ natToInteger ((80::Nat)*(120::Nat))
    --print $ beside2 5 7
    --print $ natToInteger (pow 4 4)
    let a = Branch (Branch (Leaf 1) (Leaf 2)) (Branch (Leaf 3) (Branch (Leaf 3) (Leaf 4))) in
        do print a
           print $ reverse a
           print $ depth a
           print $ leaves a
           print $ leaves (reverse a)
    
    putStrLn "Enter string:"
    s <- getLine
    --putStrLn $ toUpper s
    
    print "End."
    
