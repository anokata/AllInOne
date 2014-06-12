import System.IO
-- #!/usr/bin/env runhaskell
-- import Text.JSON
-- одна сущность - один тип
-- карты могут быть разные (карта местности, объектов) различающиеся поведением но имеющие общее.
-- значит будут наследоваться от общей
-- локальная карта(чего угодно). фиксированного размера? 
data MapElem = MapChar Char | MapNone deriving (Read, Show)
data Localmap a = Lmap [[a]]  deriving (Read, Show)

--instance Show a => Show (Localmap a) where
showLmap (Lmap x) = concatMap (concatMap showMapElem) x
{-
data MapChar = MapChar Char
instance Show MapChar where
	show (MapChar x) = [x]
-}
--instance Show MapElem where
showMapElem (MapChar x) = [x]
showMapElem MapNone = [' ']

stringTolistMapChar :: String -> [MapElem]
stringTolistMapChar [] = []
stringTolistMapChar (x:y) = MapChar x : stringTolistMapChar y

-- простейшая карта с объектами символами
data CharLocalmap = CharLocalmap (Localmap MapElem)  deriving (Read, Show)
-- даже почти не надо доопределять show?
--instance Show CharLocalmap where
showCharLocalmap (CharLocalmap x) = showLmap x

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
data Map2 = Map2 (ElemDescription, CharLocalmap) deriving (Read, Show)
data ElemDescription = ElemDescription [ElemProp] deriving (Read, Show)
data ElemProp = ElemProp (ElemChar, ElemColor, ElemName, ElemPropertys) 
    deriving (Read, Show)
data ElemChar = ElemChar Char deriving (Read, Show)
data ElemColor = ElemColor Int deriving (Read, Show)
data ElemName = ElemName String deriving (Read, Show)
data ElemPropertys = ElemPropertys [ElemOthProp] deriving (Read, Show)
data ElemOthProp = Ppassable Bool | Other | IsPlayer | Item deriving (Read, Show)
-- уф, как то великовато. ну чтож...
-- теперь надо это как то считывать. пусть будет для примера теста
testmapdata = Map2 (
    ElemDescription [
        ElemProp (
            ElemChar '@',
            ElemColor 1,
            ElemName "Player",
            ElemPropertys [Other, IsPlayer])
        ,
        ElemProp (
            ElemChar '$',
            ElemColor 1,
            ElemName "Item1",
            ElemPropertys [Item])
        ,
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
         "#@  #", 
         "#   #",
         "#$ T#",
         "#####"])
         
testmapdataR = " Map2 (     \
\    ElemDescription [       \
\        ElemProp (          \
\            ElemChar '#',   \
\            ElemColor 1,    \
\            ElemName \"Wall\",\
\            ElemPropertys [Ppassable False])\
\        ,\
\        ElemProp (ElemChar 'T', \
\            ElemColor 2,        \
\            ElemName \"Tree\",    \
\            ElemPropertys [Ppassable False])\
\        ,\
\        ElemProp (ElemChar ' ', \
\            ElemColor 0,        \
\            ElemName \"Stone floor\",\
\            ElemPropertys [Ppassable True])\
\    ],"++ show
        (inputMapFromStrings
        ["#####",   
         "#   #",   
         "#   #",   
         "#  T#",   
         "#####"]) ++ ")"
-- такое мы должны получить. как сохранить и прочитать в текст?
-- то есть должны быть функции
--readMap2 :: String -> Map2
--writeMap2 :: Map2 -> String
-- надо просто методы showForSave
testmapdataR1 :: Map2
testmapdataR1 = read testmapdataR
-- собственно.. это и получились сами read & show
-- чтож, теперь надо эти данные задействовать.
-- сначала добавим игрока(на карту и ссылочную точку для доступа)
data Player = Player Point  deriving (Show, Read)
data Point = Point{px::Int, py::Int}  deriving (Show, Read)
testplayer = Player Point{px=1, py=1}
-- далее функции перемещения игрока, с "изменением" структур его и карты
-- двиг игрок :: мир (карта игрок) куда -> новый мир
-- добавим мир
data World = World (Map2, Player) deriving (Show, Read) -- так что можно сохр и загр весь мир, как и передавать по сети
data Direction = North | South | East | West
movePlayer :: World->Direction->World
movePlayer w@(World (m, (Player p))) d = case d of 
    North -> World (m , Player p{px=px p - 1})
    South -> World (m , Player p{px=px p + 1})
    East -> World (m , Player p{py=py p + 1})
    West -> World (m , Player p{py=py p - 1})

testworld = World (testmapdata, testplayer)
-- сделать showmap для мира


main = do 
{-	print "#####"
	print "# @ #"
	print "#   #"
	print "# $ #"
	print "#####"  -}
	--print (CharLocalmap $ Lmap [stringTolistMapChar "###!!.###"])
	--print (inputMapFromStrings ["!@#","abc"])
    print testmapdataR
    print testmapdataR1
    print testworld
    print $ movePlayer testworld South

    
    
	
