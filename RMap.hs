module RMap(Point(..)) 
where

import RPlayer
import Point

{-
все тлен.
будет так. общая структура - вся карта = мир. состоящий из (список) локальных мирков
локальный мирок же будет структурой включающей всё, тоже список, элементов - ячеек
список этот есть конкатенация "строк" карты. то есть зная ширину(кот. тоже храним в где? мир или лок мир?) можно построчно его выстроить и адресовать
ячейка же это и бэкграунд и игрок и объекты - списки, возможно пустые
-}
type Items = [Item]
type Buildings = [Building]

data Cell =  Cell {cellItems::Items, cellBuildings::Buildings, cellPlayer::Maybe Player    
    } deriving (Show)

data ItItem = ItItem {itemName::String, itemChar::Char} deriving (Show)
data Item = Item {itemID::ItItem, itemCount::Int} deriving (Show)
data BuildingID = BuildingID {buildingDescription::String, buildingChar::Char} deriving (Show)
data Building = Building {buildingID::BuildingID} deriving (Show)
type MiniMap = [Cell]
data WorldMap = WorldMap {minimaps::[MiniMap], minimapWidth::Int, minimapHeight::Int, wmapWidth::Int
    --current minimap
    } deriving (Show)

addrForPoint :: Point -> Int -> Int
addrForPoint p width = (pointx p) + ((pointy p) * width)

showminimap :: WorldMap -> Point -> String
showminimap w p = 
    let wd = minimapWidth w
        a = addrForPoint p wd
        m = (minimaps w) !! a
        
    in 
        insertEveryN (map getCellChar m) "\n" wd

getCellChar :: Cell -> Char 
getCellChar c = 
    case (cellPlayer c) of
        Just p -> getPchar p
        Nothing -> 
            case (cellBuildings c) of
            (x:xs) -> buildingChar (buildingID x)
            [] -> 
                case (cellItems c) of
                (x:xs) -> itemChar (itemID x)
                [] -> '-'

insertEveryN :: [a] -> [a] -> Int -> [a]
insertEveryN [] _ _ = []
insertEveryN _ _ 0 = []
--insertEveryN 
insertEveryN x i n = (take n x) ++ i ++ (insertEveryN (drop n x) i n)

--TODO: фун для адресации ячеек. фун отображения лок карты. поиск? игрока. 
--test
i1 = ItItem "potion" '!'
i2 = ItItem "something" '$'
i11 = Item i1 1
i22 = Item i2 1
is1 = [i11]
is2 = [i22]
b1 = BuildingID "" '#'
b11 = Building b1
bs = [b11]
--c = Cell is bs p
p = Player (Point 0 1) "z" 1 1 1 1 '@'
c0 = Cell [] [] Nothing
c1 = Cell is1 [] Nothing
c2 = Cell is2 [] Nothing
c3 = Cell [] bs Nothing
c4 = Cell [] [] (Just p)
-- 10x10 minimap -- будем использовать упорядоченность списка
l = replicate 10 c0
l2 = [c0,c0,c0,c0,c1,c0,c0,c0,c0,c0]
l3 = [c0,c0,c0,c0,c0,c2,c0,c0,c0,c0]
l4 = [c0,c3,c3,c0,c0,c0,c3,c0,c0,c0]
l5 = [c0,c0,c0,c0,c0,c0,c0,c4,c0,c0]
mm = l++l2++l3++l4++l5++l++(concat $ replicate 4 l)
w = WorldMap [mm] 10 10 1

main = putStr (showminimap w (Point 0 0))
