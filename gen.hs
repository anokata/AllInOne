import System.IO
-- #!/usr/bin/env runhaskell
-- import Text.JSON
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
-- допустим так: "{"item": '$';  map = ["   $  "," $$   "] "
-- use Json or parsec?
-- так как же будет...
{- пусть так описывается

Map2 (
ElemDescription [
ElemProp (ElemChar '#'
ElemColor 1
ElemName "Wall"
ElemPropertys [Ppassable False])
,
ElemProp (ElemChar 'T'
ElemColor 2
ElemName "Tree"
ElemPropertys [Ppassable False])
,
ElemProp (ElemChar ' '
ElemColor 0
ElemName "Stone floor"
ElemPropertys [Ppassable True])
],
CharLocalmap 
["#####",
 "#   #", 
 "#   #",
 "#  T#",
 "#####"])

итак имеем следующую структуру
-}
data Map2 = Map2 (ElemDescription, CharLocalmap)
data ElemDescription = ElemDescription [ElemProp]
data ElemProp = ElemProp (ElemChar, ElemColor, ElemName, ElemPropertys)
data ElemChar = ElemChar Char
data ElemColor = ElemColor Int
data ElemName = ElemName String
data ElemPropertys = ElemPropertys [ElemOthProp]
data ElemOthProp = Ppassable Bool | Other
-- уф, как то великовато. ну чтож...
-- теперь надо это как то считывать. пусть будет для примера теста
testmapdata = Map2 (
    ElemDescription [
        ElemProp (
            ElemChar '#',
            ElemColor 1,
            ElemName "Wall",
            ElemPropertys [Ppassable False])
        ,
        ElemProp (ElemChar 'T',
            ElemColor 2,
            ElemName "Tree",
            ElemPropertys [Ppassable False])
        ,
        ElemProp (ElemChar ' ',
            ElemColor 0,
            ElemName "Stone floor",
            ElemPropertys [Ppassable True])
    ],
    --CharLocalmap 
    inputMapFromStrings
        ["#####",
         "#   #", 
         "#   #",
         "#  T#",
         "#####"])


main = do 
{-	print "#####"
	print "# @ #"
	print "#   #"
	print "# $ #"
	print "#####"  -}
	--print (CharLocalmap $ Lmap [stringTolistMapChar "###!!.###"])
	--print (inputMapFromStrings ["!@#","abc"])
    --print testmapdata

    
    
	
