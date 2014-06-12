import System.IO
-- #!/usr/bin/env runhaskell

-- одна сущность - один тип
-- карты могут быть разные (карта местности, объектов) различающиеся поведением но имеющие общее.
-- значит будут наследоваться от общей
-- локальная карта(чего угодно). фиксированного размера? 
data Localmap a = Lmap [[a]]

instance Show a => Show (Localmap a) where
	show (Lmap x) = concatMap (concatMap show) x

data MapChar = MapChar Char
instance Show MapChar where
	show (MapChar x) = [x]

stringTolistMapChar :: String -> [MapChar]
stringTolistMapChar [] = []
stringTolistMapChar (x:y) = MapChar x : stringTolistMapChar y

-- простейшая карта с объектами символами
data CharLocalmap = CharLocalmap (Localmap MapChar) 
-- даже почти не надо доопределять show?
instance Show CharLocalmap where
	show (CharLocalmap x) = show x



main = do 
{-	print "#####"
	print "# @ #"
	print "#   #"
	print "# $ #"
	print "#####"  -}
	print (CharLocalmap $ Lmap [stringTolistMapChar "###!!.###"])
	
