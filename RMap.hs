module RMap(Point(..)) 
where

data Point = Point{px::Int, py::Int}  deriving (Show, Read)
type Terrains = [Terrain]
data Rmap = Rmap {getPlayer::Player, getTerrain::Terrains}

data Terrain = Terrain {getTChar::Char, getTPoint::Point}

t = Terrain '.' (Point 0 0)
blankTerrain :: Terrains
blankTerrain w h c = [Terrain c (Point x y)| x<-[1..w], y<-[1..h]]

type TerrainImage = [String]

showTerrain:: Terrains -> TerrainImage
showTerrain t = lines . map 

