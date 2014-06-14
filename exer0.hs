module Void where
import Prelude (Show(..), Eq(..), Num(..),error,print,Int,($))

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



main = do
    print (8::Nat)
    print (2*3 :: Nat)
    print $ natToInteger ((Succ (Succ Zero)) * (Succ (Succ (Succ Zero))))
    
