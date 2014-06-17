import System.IO
--import Data.Matrix
import Data.Maybe
import Data.List
import System.Random
-- #!/usr/bin/env runhaskell
-- import Text.JSON
-- одна сущность - один тип
-- карты могут быть разные (карта местности, объектов) различающиеся поведением но имеющие общее.
-- локальная карта(чего угодно). фиксированного размера? 
-- основная структура для карт - матрица
data MyMatrix a = MyMatrix [[a]] deriving (Show, Read)
-- функтор для моей матрицы
myMatrixfmap :: (a -> b) -> MyMatrix a -> MyMatrix b
myMatrixfmap f (MyMatrix m) = MyMatrix $ fmap (fmap f) m

instance Functor MyMatrix where
    fmap = myMatrixfmap
-- чтение из списка
fromLists :: [[a]] -> MyMatrix a
fromLists = MyMatrix
-- количество элементов по горизонтали. предполагаем матрицы прямоугольными
mcols :: MyMatrix a -> Int
mcols (MyMatrix m) = length (m!!0)

mrows :: MyMatrix a -> Int
mrows (MyMatrix m) = length m
-- две свёртки для матриц
myMatrixfoldl :: (a -> b -> a) -> a -> MyMatrix b -> a
--типа myMatrixfoldlSC :: (String -> Char -> String) -> String -> MyMatrix Char -> String
--типа myMatrixfoldlSC (\s x->s++[x]) "" matr  --> "asdf"
myMatrixfoldl f init (MyMatrix m) = foldl (\s x-> foldl f s x) init m -- удивительно. написал интуитивно и оно таки работает сразу о_О
--как бы так изменить чтобы оно каждое новое начало сврётки внутренней выполняло ещё фун над элементом
--чтобы передать ей (\x->x++"\n")
myMatrixfoldl2 f finner init (MyMatrix m) = foldl (\s x-> finner (foldl f s x)) init m
-- Преобразования между разными матрицами для представления карт
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
-- ----------------------------------
-- сначала добавим игрока(на карту и ссылочную точку для доступа)
data Player = Player {pcoord::Point, pchar::Char} deriving (Show, Read)
data Point = Point{px::Int, py::Int}  deriving (Show, Read)
{-
data MapElem = MapChar Char | MapNone deriving (Read, Show)
data Localmap a = Lmap [[a]]  deriving (Read, Show)

showLmap (Lmap x) = concatMap (concatMap showMapElem) x

showMapElem (MapChar x) = [x]
showMapElem MapNone = [' ']

stringTolistMapChar :: String -> [MapElem]
stringTolistMapChar [] = []
stringTolistMapChar (x:y) = MapChar x : stringTolistMapChar y

-- простейшая карта с объектами символами
data CharLocalmap = CharLocalmap (Localmap MapElem)  deriving (Read, Show)
--или лучше type CharLocalmap = Localmap MapElem --!!

showCharLocalmap (CharLocalmap x) = showLmap x

-- теперь хочу: пусть будет список строк - простая карта, будет фун для преобразования 
-- этого в карту
inputMapFromStrings :: [String] ->  CharLocalmap
inputMapFromStrings [[]] = CharLocalmap $ Lmap [[]]
-- обработаем каждую строку - элемент списка и результат в список типа Lmap - concatMap
inputMapFromStrings x = CharLocalmap $ Lmap $ map stringTolistMapChar x

{- итак имеем следующую структуру -}
-- ТОЖЕ чаще исп синонимы
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
-}
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
-- Новое представление на матрицах
-- еденичный элемент
data DynElem = DynElem {echar::Char, epassable::Bool, eitemable::Bool} deriving (Show, Read)
-- элемент в ячейке, нет или множество
data DynamicElem = Nothing | Elems [DynElem] deriving (Show, Read)
fromDynamicElem :: DynamicElem -> [DynElem]
fromDynamicElem (Elems d) = d
fromDynamicElem _ = error ""
defaultDynElem = (DynElem ' ' True False)

stdElemWall = DynElem '#' False False
--genLabirynt sizex sizey seed
-- fromLists replicate sizey [replicate sizex defaultDynElem]
-- choose rand point. choose rand: 
--  choose rand direction, choose rand nums of tunel(rand len), room(rand size)
-- let x = mkStdGen seed
--    fst x is random num -- take `mod` n
--    snd x is next generator.. and take there recursive genLab
{-
genLabirynt :: Int -> Int -> Int -> Int -> DynamicMap -- StaticMap
genLabirynt sizex sizey seed deep = 
    let randGenX = (mkStdGen seed)
        randGenY = (mkStdGen seed*2)
        initLab = fromLists replicate sizey [replicate sizex defaultDynElem]
        in genLabiryntRecurs initLab randGenX randGenY deep
        where 
            genLabiryntRecurs lab genX genY deep curX curY = 
                -- выберем точку
                let
                {-(rxnm, genX2) = (random genX)
                (rynm, genY2) = (random genY)
                (dirnm, genX3) = (random genX2)
                (_, genY3) = (random genY2)
                rx = rxnm `mod` sizex 
                ry = rynm `mod` sizey
                -- выберем количество направлений
                dirs = dirnm `mod` 4 -}
                (rx, genX2) = (randomR (0, sizeX) genX)
                (rx, genY2) = (randomR (0, sizeY) genY)
                (dir, genX3) = (randomR (1,4) genX2)
                (_, genY3) = (randomR (1,2) genY2)
                
                -- основная генерация
                genTunel :: DynamicMap ->  -> DynamicMap
                genTunel lab x y len wid
                -- следующие генераторы
                if (deep > 0) then
                genLabiryntRecurs lab genX3 genY3 (deep-1)
                else lab

-}

type StaticMap = MyMatrix Char
type DynamicMap = MyMatrix DynamicElem

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



main :: IO ()
main = do 
    putStr $ showallMap staticObjMap dynamicObjMap2 testplayer
    print "End."
	
