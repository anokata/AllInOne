module Void where
import Prelude (Show(..), Eq(..), Num(..),error,print,Int,($),Bool(..),otherwise)

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

main = do
    print (8::Nat)
    print (2*3 :: Nat)
    print $ natToInteger ((Succ (Succ Zero)) * (Succ (Succ (Succ Zero))))
    --print $ natToInteger ((80::Nat)*(120::Nat))
    print $ beside2 5 7
    print $ natToInteger (pow 4 4)
    
    
