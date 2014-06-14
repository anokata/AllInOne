
class Group a where
    e :: a
    (+) :: a -> a -> a
    inv :: a -> a
   -- e + a == a
   -- (inv a) + a == e

data SystemConfig = SystemConfig [Config] -- конфиг системы это множество конкретных конфигов
data Config = Config [Setting] -- конфиг это множество правильных установок
data Setting = Setting Name Separator Expression -- установка это две имя разделитель выражение
data Name = Name String
data Separator = Char
data Expression = String


main = print 1
