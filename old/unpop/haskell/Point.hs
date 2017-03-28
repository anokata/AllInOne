module Point (Point(..)) where

data Point = Point{pointx::Int, pointy::Int}  deriving (Show, Read)
