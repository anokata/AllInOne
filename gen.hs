import System.IO
--import Data.Matrix
import Data.Maybe
import Data.List

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
movePlayer w@(World (m, (Player p))) d = 
-- проверки на возможность двиг
-- if canMove World Dir Who(point - откуда)
    case d of 
    North -> World (m , Player p{px=px p - 1})
    South -> World (m , Player p{px=px p + 1})
    East -> World (m , Player p{py=py p + 1})
    West -> World (m , Player p{py=py p - 1})

testworld = World (testmapdata, testplayer)
-- сделать showmap для мира

-- переделать. всё статичное останется в массиве. а вот всё динамичнее удобнее просто списком. а искать по карте можно и сгенереной
-- тогда мир выглядит так.. (статик-карта, список-динамик-объектов-типа1, игрок, предметы)
--data World2 = World2 (StaticMap, Player, Items) deriving (Show, Read)
-- StaticMap состоит из статик элементов
-- Player, Items имеют такое общее, они динамик-элементы
-- общее всех элементов! - имя для показа при будущем экплоринге да и просто для понимания
--      - символ id?... - свойства\(тип это уже расширенные наследованные элементы)
-- как учесть что часть свойств элементов будет общая для всего типа и неизменная, а часть индивидуальная?. надо ли
--data Element = Element {ename::String, echar::Char} deriving (Show, Read)
--data PlayerElement = Player {playerPlace::Point, } --ха так не понаследуешь
-- любой элемент где то находится и как то печатается
{- class MapElement a where
    ecoord :: a -> Point
    echar :: a -> Char
    --имя
-- более конкретные элементы. статичный может быть непроходим
class (MapElement a) => MapStaticElement a where
    passable :: a -> Bool
    
class (MapElement a) => MapDynamicElement a --where
class (MapDynamicElement a) => MapPlayerElement a --where
class (MapDynamicElement a) => MapItemElement a --where
-}
--instance MapPlayerElement Player where
  --  ecoord = 
--logic
--data Imp a = Imp a a
--data Ax1 a = Ax1 (Imp (Imp a a) a)
--data A = A
--imp :: A -> A
--modusPonens :: 
-- переделать. ElemDescription не обязан же быть списком or
 -- надо дальше учить язык особо монады и функторы
map1 =  ["#####",
         "#$  #", 
         "#   #",
         "#$ T#",
         "#####"]
map2 =  ["     ",
         " $  .", 
         "     ",
         " $ T ",
         "     "]
-- еденичный элемент
data DynElem = DynElem {echar::Char, epassable::Bool, eitemable::Bool} deriving (Show, Read)
-- элемент в ячейке, нет или множество
data DynamicElem = Nothing | Elems [DynElem] deriving (Show, Read)
fromDynamicElem :: DynamicElem -> [DynElem]
fromDynamicElem (Elems d) = d
fromDynamicElem _ = error ""
defaultDynElem = (DynElem ' ' True False)

data MyMatrix a = MyMatrix [[a]] deriving (Show, Read)

myMatrixfmap :: (a -> b) -> MyMatrix a -> MyMatrix b
myMatrixfmap f (MyMatrix m) = MyMatrix $ fmap (fmap f) m

instance Functor MyMatrix where
    fmap = myMatrixfmap

fromLists :: [[a]] -> MyMatrix a
fromLists = MyMatrix

-- фун замены карты динамик объектов из символьного представления, основываясь на описании для символов, матрицей с этими объектами
-- описание есть DynamicElem
fromCharMatrixToElemMatrix :: MyMatrix Char -> DynamicElem -> MyMatrix DynamicElem
fromCharMatrixToElemMatrix m d = fmap elemForChar m where
    -- доп фун. для выбора элемента по символу из описания
    elemForChar :: Char -> DynamicElem
    elemForChar c = Elems [(fromMaybe defaultDynElem (find (\x->echar x == c) (fromDynamicElem d)))]

staticObjMap = fromLists map1
dynamicObjMap = fromLists map2

elems :: DynamicElem
elems = Elems [DynElem '$' True True, DynElem '.' True False, DynElem 'T' False False]
dynamicObjMap2 = fromCharMatrixToElemMatrix dynamicObjMap elems

--showStaticMap :: MyMatrix Char -> String
--showStaticMap m = fmap (\x->)

--showallMap :: MyMatrix Char -> MyMatrix DynamicElem -> Player -> String
--showallMap staticMap dynamicMap player = (showPlayer player) `showOver` (showStaticMap staticMap)  `showOver` (showDynMap dynamicMap)



main = do 
{-	print "#####"
	print "# @ #"
	print "#   #"
	print "# $ #"
	print "#####"  -}
	--print (CharLocalmap $ Lmap [stringTolistMapChar "###!!.###"])
	--print (inputMapFromStrings ["!@#","abc"])
    --print testmapdataR
    --print testmapdataR1
    --print testworld
    --print $ movePlayer testworld South
    print dynamicObjMap2

    
    
	
