module BinTree where

data Btree a = Node a | B a (Btree a) (Btree a) deriving (Show, Read)
type IntTree = Btree Int

t :: IntTree
t = B 18 (B 77 (Node 2) (Node 3)) (B 31 (Node 88) (B 0 (B 23 (Node 323) (Node 222)) (B 999 (Node 22112) (Node 333))))

prettyPrintTree :: (Show a) => Btree a -> String
prettyPrintTree t = prettyPrintTree' t ""
  where
    prettyPrintTree' :: (Show a) => Btree a -> String -> String
    prettyPrintTree' (Node x) prefix = prefix ++ "|-> "++(show x)
    prettyPrintTree' (B x l r) prefix = prefix ++ "[+] "++(show x) ++ "\n" ++ (prettyPrintTree' l (prefix++"  ")) ++ "\n" ++ (prettyPrintTree' r (prefix++"  "))

instance Functor Btree where
    fmap = btreefmap

btreefmap :: (a -> b) -> (Btree a) -> (Btree b)
btreefmap f (Node x) = Node (f x)
btreefmap f (B x l r) = B (f x) (btreefmap f l) (btreefmap f r)

-- проще и правильнее наверно будет с id/key значением дополнительным
changeAt :: Btree a -> Btree a -> ? -> Btree a

{-instance Monoid Btree where
    mempty = -}

--и надо всё же решить всяки упражнений. найди и выпиши все. распредели по порядку сложности. (книги,лек,(realworld) + та статья + моё)
--TODO: +fmap fold changeAt +prettyPrint \ Same for infinity tree \ maybe monad\app instance?
main = putStr (prettyPrintTree t) >> putStr (prettyPrintTree (fmap (\x-> log (fromIntegral x)) t))
{-
>18
 |-77
 | |-2
 | |-3
 |-31
 | |-88
 | |-0
 | | \-23
 |
-}
