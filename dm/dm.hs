#!/usr/bin/env runhaskell
--Download manager via wget
--choose: vty(very nativ), vty-ui, hscurses(example bad work?)
import qualified Graphics.Vty as VT
import Graphics.Vty.Picture
import Graphics.Vty.Attributes
import Control.Concurrent --(threadDelay, forkIO)
import Control.Monad(forever)
import System.Exit

discard :: Functor f => f a -> f ()
discard = fmap (const ())

blockFull = '\x2588'
horBlock = replicate 20 blockFull
horBlockX x = replicate x blockFull
blockLWall = '\x2503'--'\x258D'
blockRWall = '\x2503'--'\x2590'
blockCornerRU = '\x2513'
blockCornerLU = '\x250F'
blockCornerRD = '\x251B'
blockCornerLD = '\x2517'
blockHWall = '\x2501'

defAttr = with_fore_color (with_back_color current_attr black) bright_white
defSelAttr = with_fore_color (with_back_color current_attr black) blue
luCorner a = char a blockCornerLU
ruCorner a = char a blockCornerRU
ldCorner a = char a blockCornerLD
rdCorner a = char a blockCornerRD
lWall a = char a blockLWall
--blockVWall = '\x2501'

framedList :: [String] -> Int -> Attr -> Image  -- list, width
framedList [] _ _ = empty_image
framedList l w attr = 
    let h = length l 
    in
    drawTop <-> drawList <-> drawBottom
    where 
        drawTop = (luCorner attr) <|> (char_fill attr blockHWall w 1) <|> (ruCorner attr)
        drawBottom = (ldCorner attr) <|> (char_fill attr blockHWall w 1) <|> (rdCorner attr) 
        lWalla = lWall attr
        drawList = foldl 
          (\acc x->acc <-> lWalla <|> (string attr x) <|> (translate (w - length x, 0) lWalla)) empty_image l

mkMenuWithSelected :: BookmarksFile -> MenuState -> [(String, Attr)]
mkMenuWithSelected b (i, _) = zipWith (\s n-> if (n==i) then (s, defSelAttr) else (s, defAttr)) (lines $ showbookmarks b) [1..]


menuToImage :: BookmarksFile -> MenuState -> Int -> Image
--menuToImage b s@(i,_) w = 
 {- let menu = (mkMenuWithSelected b s)
      (text,_) = menu !! (i-1)
  in 
    framedMenu menu w defAttr -}
menuToImage b s w = framedMenu (mkMenuWithSelected b s) w defAttr
--menuToImage = framedMenu . mkMenuWithSelected

framedMenu :: [(String, Attr)] -> Int -> Attr -> Image
framedMenu [] _ _ = empty_image
framedMenu l w attr = 
    let h = length l 
    in
    drawTop <-> drawList <-> drawBottom
    where 
        drawTop = (luCorner attr) <|> (char_fill attr blockHWall w 1) <|> (ruCorner attr)
        drawBottom = (ldCorner attr) <|> (char_fill attr blockHWall w 1) <|> (rdCorner attr) 
        lWalla = lWall attr
        drawList = foldl 
          (\acc (s,a)->acc <-> lWalla <|> (string a s) <|> (translate (w - length s, 0) lWalla)) empty_image l

--handledAKeys = ['d','i','k']

repaintOnEvent :: (VT.Event, VT.Vty) -> MenuState -> IO MenuState
repaintOnEvent (e, v) m = 
    let  
    newmenustate = (handleInput e m)
    in do   
        repaint (e, v) newmenustate
        return newmenustate


handleInput :: VT.Event -> MenuState -> MenuState
handleInput e m@(i,l) = 
    case e of 
        (VT.EvKey (VT.KASCII k) []) -> 
            case k of
                'i' | i>1 -> (i-1,l)
                'i' -> (l,l)
                'k' | i<l -> (i+1,l)
                'k' -> (1,l)
                otherwise -> m
        otherwise -> m

getSelectedUrl :: BookmarksFile -> MenuState -> String
getSelectedUrl b (i,_) = 
    case (b !! (i-1)) of 
        (Folder t _) -> t
        (Bookmark (_,u,e)) -> e++":"++u
        --otherwise -> ""
    

repaint :: (VT.Event, VT.Vty) -> MenuState -> IO ()
repaint (e, v) m = 
    let 
        --img = framedList ["(1.)","(2.) - ","(1) list node.","abraCaDabra","------",show e] 15 defAttr
        --img = framedList (lines $ showbookmarks testbookmarks) 25 defAttr
        img = menuToImage testbookmarks m 25 <-> (string defAttr (show m ++(show e))) -- <-> (string defAttr (getSelectedUrl testbookmarks m))
        pic = Picture (Cursor 0 0) img (Background ' ' defAttr)
    in
        VT.update v pic



main = do 

    --savebookmarks "bm.bms" testbookmarks
    n<-loadbookmarks "bm.bms"
    putStrLn (showbookmarks n)
    
    v <- VT.mkVty
    
    let 
        img4 = framedList ["(1.)","(2.) - ","(1) list node.","abraCaDabra","------"] 15 defAttr
        pic = Picture (Cursor 0 0) img4 (Background ' ' defAttr)
        m = (1, length (lines $ showbookmarks testbookmarks))
    VT.update v pic
    
    endI <- newEmptyMVar
    
    
    let inputloop m = do
            event <- VT.next_event v
            
            menustate <- case event of
                (VT.EvKey k []) -> if (k == (VT.KASCII 'q')) 
                    then do 
                        putMVar endI ()
                        exitSuccess 
                        else
                    --print event
                    repaintOnEvent (event, v) m
                    --refresh
                otherwise -> repaintOnEvent (event, v) m
            inputloop menustate
    
    repaintOnEvent ((VT.EvResize 0 0), v) m
    tid <- forkIO (inputloop m)
    
    --wait until input write in endI
    takeMVar endI
    VT.shutdown v
    
type MenuState = (Int, Int) --(current, length, bookmarks) 
emptyMenuState = (1, 1)
--TODO: bind keys, menu selected up down, show url,help, del, add,Edit, open with. Folders of bm, open close(expand). gzip it save. open unzip in ram.
--file format: bookTitle URL. Haskell data! show read.
type BookmarksFile = [BookmarksFileElement] 
data BookmarksFileElement = Bookmark BookmarkE | Folder BTitle BookmarksFile deriving (Show, Read)
type ExecCmd = String
type BTitle = String
type URL = String
type BookmarkE = (BTitle, URL, ExecCmd)

testbookmarks :: BookmarksFile
testbookmarks = [
     Bookmark ("filesystem root", "file://", "dillo")
    ,Bookmark ("home", "file:///home/ksi", "pcmanfm")
    ,Folder "web urls" [
             Bookmark ("google", "google.com", "dillo")
             ,Bookmark ("elementy.ru", "elementy.ru", "dillo")
            ]
    ,Bookmark ("term", "", "xterm")
        ]

savebookmarks :: String -> BookmarksFile -> IO ()
savebookmarks file b = writeFile file (show b)

loadbookmarks :: String -> IO BookmarksFile
loadbookmarks file = (readFile file) >>= return . read

showbookmarks :: BookmarksFile -> String
showbookmarks b = showbookmarksS b ""

showbookmarksS :: BookmarksFile -> String -> String--Image
showbookmarksS b prefix = foldl showOneBookmark "" b
    where
        showOneBookmark :: String -> BookmarksFileElement -> String
        showOneBookmark acc (Bookmark (t,_,_)) = acc ++ prefix ++ t ++ "\n"
        showOneBookmark acc (Folder t b) = acc ++ (prefix ++ "["++t++"]"++"\n") ++ (showbookmarksS b (prefix++"*")) 




