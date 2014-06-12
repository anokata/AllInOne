import System.IO
-- #!/usr/bin/env runhaskell

-- одна сущность - один тип
-- карты могут быть разные (карта местности, объектов) различающиеся поведением но имеющие общее.
-- значит будут наследоваться от общей
-- локальная карта(чего угодно). фиксированного размера? 
data MapElem = MapChar Char | MapNone
data Localmap a = Lmap [[a]]

instance Show a => Show (Localmap a) where
	show (Lmap x) = concatMap (concatMap show) x
{-
data MapChar = MapChar Char
instance Show MapChar where
	show (MapChar x) = [x]
-}
instance Show MapElem where
	show (MapChar x) = [x]
	show MapNone = [' ']

stringTolistMapChar :: String -> [MapElem]
stringTolistMapChar [] = []
stringTolistMapChar (x:y) = MapChar x : stringTolistMapChar y

-- простейшая карта с объектами символами
data CharLocalmap = CharLocalmap (Localmap MapElem) 
-- даже почти не надо доопределять show?
instance Show CharLocalmap where
	show (CharLocalmap x) = show x

-- теперь хочу: пусть будет список строк - простая карта, будет фун для преобразования 
-- этого в карту
inputMapFromStrings :: [String] ->  CharLocalmap
inputMapFromStrings [[]] = CharLocalmap $ Lmap [[]]
-- обработаем каждую строку - элемент списка и результат в список типа Lmap - concatMap
inputMapFromStrings x = CharLocalmap $ Lmap $ map stringTolistMapChar x

-- теперь сделаю более сложные типы объектов

-- а также их преобразование из специально построенных строк описывающих карту
-- допустим так: "{item: '$';  map = ["   $  "," $$   "] "

main = do 
{-	print "#####"
	print "# @ #"
	print "#   #"
	print "# $ #"
	print "#####"  -}
	print (CharLocalmap $ Lmap [stringTolistMapChar "###!!.###"])
	print (inputMapFromStrings ["!@#","abc"])
	
