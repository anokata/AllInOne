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
data Player = Player {pcoord::Point, pchar::Char} deriving (Show, Read)
data Point = Point{px::Int, py::Int}  deriving (Show, Read)
-- далее функции перемещения игрока, с "изменением" структур его и карты
-- двиг игрок :: мир (карта игрок) куда -> новый мир
-- добавим мир
data World = World (Map2, Player) deriving (Show, Read) -- так что можно сохр и загр весь мир, как и передавать по сети
data Direction = North | South | East | West
movePlayer :: World->Direction->World
movePlayer w@(World (m, (Player p c))) d = 
-- проверки на возможность двиг
-- if canMove World Dir Who(point - откуда)
    case d of 
    North -> World (m , Player p{px=px p - 1} c)
    South -> World (m , Player p{px=px p + 1} c)
    East -> World (m , Player p{py=py p + 1} c)
    West -> World (m , Player p{py=py p - 1} c)

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
         "#   #", 
         "#   #",
         "#   #",
         "#####"]
map2 =  ["     ",
         " $ . ", 
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

mcols :: MyMatrix a -> Int
mcols (MyMatrix m) = length (m!!0)

mrows :: MyMatrix a -> Int
mrows (MyMatrix m) = length m

myMatrixfoldl :: (a -> b -> a) -> a -> MyMatrix b -> a
--myMatrixfoldlSC :: (String -> Char -> String) -> String -> MyMatrix Char -> String
--myMatrixfoldlSC (\s x->s++[x]) "" matr  --> "asdf"
myMatrixfoldl f init (MyMatrix m) = foldl (\s x-> foldl f s x) init m -- удивительно. написал интуитивно и оно таки работает сразу о_О
--как бы так изменить чтобы оно каждое новое начало сврётки внутренней выполняло ещё фун над элементом
--чтобы передать ей (\x->x++"\n")
myMatrixfoldl2 f finner init (MyMatrix m) = foldl (\s x-> finner (foldl f s x)) init m

-- фун замены карты динамик объектов из символьного представления, основываясь на описании для символов, матрицей с этими объектами
-- описание есть DynamicElem
fromCharMatrixToElemMatrix :: MyMatrix Char -> DynamicElem -> MyMatrix DynamicElem
fromCharMatrixToElemMatrix m d = fmap elemForChar m where
    -- доп фун. для выбора элемента по символу из описания
    elemForChar :: Char -> DynamicElem
    elemForChar c = Elems [(fromMaybe defaultDynElem (find (\x->echar x == c) (fromDynamicElem d)))]

--обратное преобразование
fromElemMatrixToCharMatrix :: MyMatrix DynamicElem -> MyMatrix Char
fromElemMatrixToCharMatrix m = fmap (\(Elems x)-> echar (head x)) m 

staticObjMap = fromLists map1
dynamicObjMap = fromLists map2
testplayer = Player Point{px=2, py=2} '@'

elems :: DynamicElem
elems = Elems [DynElem '$' True True, DynElem '.' True False, DynElem 'T' False False]
dynamicObjMap2 = fromCharMatrixToElemMatrix dynamicObjMap elems

showStaticMap :: MyMatrix Char -> String
showStaticMap m = myMatrixfoldl (\s x->s++[x]) "" m
showStaticMap2 m = myMatrixfoldl2 (\s x->s++[x]) (\x->x++"\n") "" m

showDynMap m = showStaticMap2 (fromElemMatrixToCharMatrix m)

showOver :: String -> String -> String
showOver a b = zipWith overMap a b where
    overMap x y | (x==y) = y
                | (y==' ') = x
                | otherwise = y

showallMap :: MyMatrix Char -> MyMatrix DynamicElem -> Player -> String
showallMap staticMap dynamicMap player = insertPlayer ( (showStaticMap2 staticMap)  `showOver` (showDynMap dynamicMap) ) (mcols staticMap) player

insertPlayer :: String -> Int -> Player -> String
insertPlayer s k pl@(Player xy c) = let addr = ((k+1)*(py xy)+(px xy)) in --каждая строка на 1 символ \n больше
    (take addr s) ++ [c] ++ (drop (addr+1) s)




main = do 
	--print (CharLocalmap $ Lmap [stringTolistMapChar "###!!.###"])
	--print (inputMapFromStrings ["!@#","abc"])
    --print testmapdataR
    --print testmapdataR1
    --print testworld
    --print $ movePlayer testworld South
    --print dynamicObjMap2
    --print $ showStaticMap staticObjMap
    --putStr $ showStaticMap2 staticObjMap
    --print $ showDynMap dynamicObjMap2
    --putStr $ showDynMap dynamicObjMap2
    --putStr $ (showStaticMap2 staticObjMap) `showOver` (showDynMap dynamicObjMap2)
    putStr $ showallMap staticObjMap dynamicObjMap2 testplayer
    
	
