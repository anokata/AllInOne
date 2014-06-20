module RPlayer(Player(..)) where

import Data.List
import RMap

type Stat = Int

data Player = Player {getPlayerCoord :: Point,
    getPname::String,
    getPStr::Stat,
    getPInt::Stat,
    getPL ::Stat, getPV ::Stat, --- ловкость, восприятие
    getPchar :: Char
    --getPTreats :: [Treat]
    
    
    } deriving (Show)



--tests
testplayer = Player $ Point 0 0
--test main
-- {-
main = do
    print testplayer
-- -}
