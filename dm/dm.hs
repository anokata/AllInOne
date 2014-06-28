#!/usr/bin/env runhaskell
--Download manager via wget/ Menu Lib
import qualified Graphics.Vty as VT
import Graphics.Vty.Picture
import Graphics.Vty.Attributes
--import Control.Concurrent --(threadDelay, forkIO)
--import Control.Monad(forever)
--import System.Exit
import Data.Char

data MenuState = MenuState {
    gCurrentMenuEl::Int, 
    gLenMenu::Int, 
    gBook::Bookmarks, 
    gFinput::InputMenuFunc, 
    gFpaint::RepaintMenuFunc
    , gBuffer::String,
    gIDFIM::InternalDataForInfoMenu
    }
data StateID = Exit | Proceed deriving (Eq, Show, Read)
data InternalDataForInfoMenu = IDFIM {
    gState::StateID,
    gVty::VT.Vty
    }
-- emptyMenuState = (0, 0, [],handleInput,paintMenu) 
--TODO: bind keys, menu selected up down, show url,help, del, add,Edit, open with. Folders of bm, open close(expand). gzip it save. open unzip in ram.
--file format: bookTitle URL. Haskell data! show read.
-- HOW? folder unexpand!?
-- scroll
-- переделывать структуру что ли? дерево или как? или может по другому, отдельно выбор каталога.. но каталоги тож могут быть вложенными?
-- проще сначала обычный список но уж хорошо и скрольно
--type Bookma = [BookmarksE] 
--data BookmarksElem = Bookmark BookmarkE | Folder FolderE deriving (Show, Read)
type ExecCmd = String
type Opened = Bool
type BTitle = String
type URL = String
type BookmarkE = (BTitle, URL, ExecCmd)
--type FolderE = (BTitle, Bookmarks, Opened)
type Bookmarks = [BookmarkE]
type InputMenuFunc = VT.Event -> MenuState -> IO MenuState
type RepaintMenuFunc = MenuState -> Image


testbookmarks :: Bookmarks
testbookmarks = [
    ("filesystem root", "file://", "dillo")
    ,("home", "file:///home/ksi", "pcmanfm")
    ,("google", "google.com", "dillo")
    ,("elementy.ru", "elementy.ru", "dillo")
    ,("term", "", "xterm")
    ]

savebookmarks :: String -> Bookmarks -> IO ()
savebookmarks file b = writeFile file (show b)

loadbookmarks :: String -> IO Bookmarks
loadbookmarks file = (readFile file) >>= return . read

showbookmarksMenu :: Bookmarks -> String
showbookmarksMenu b = foldl (\acc (t,_,_)-> acc ++ t ++ "\n") "" b

showbookmarksSMenu :: Bookmarks -> String -> String--Image
showbookmarksSMenu b prefix = foldl showOneBookmarkMenu "" b
    where
        showOneBookmarkMenu :: String -> BookmarkE -> String
        showOneBookmarkMenu acc  (t,_,_) = acc ++ prefix ++ t ++ "\n"


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

mkMenuWithSelected :: MenuState -> [(String, Attr)]
mkMenuWithSelected (MenuState i  _ b _ _ _ _) = zipWith (\s n-> if (n==i) then (s, defSelAttr) else (s, defAttr)) (lines $ showbookmarksMenu b) [1..]


menuToImage :: MenuState -> Int -> Image
menuToImage s w = framedMenu (mkMenuWithSelected s) w defAttr
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

repaintOnEvent :: (VT.Event, VT.Vty) -> MenuState -> IO MenuState
repaintOnEvent (e, v) m = 
    let 
    f = gFinput m 
    in do   
        newmenustate <- f e m
        repaint (e, v) newmenustate
        return newmenustate

--data Opt a = Opt a | Nopt (IO a)

handleInput :: VT.Event -> MenuState -> IO MenuState
handleInput e m@(MenuState i l b inpf rf _ _) = 
    case e of 
        (VT.EvKey (VT.KASCII k) []) -> 
            case k of
                'i' | i>1 -> return m {gCurrentMenuEl=(i-1)}
                'i' -> return m {gCurrentMenuEl=l}
                'k' | i<l -> return m{gCurrentMenuEl=(i+1)}
                'k' -> return m{gCurrentMenuEl=1}
                'd' -> return $ deleteCurrent m
                'a' -> do
                    let 
                        oldFinput = gFinput m
                        oldFpaint = gFpaint m
                    
                    newmenu <- runInterfaceAndWaitFor m {
                            gBuffer = "=",
                            gFinput = addInput,
                            gFpaint = addPaint
                         } (VT.EvKey VT.KEnter [])
                    return newmenu{gFinput=oldFinput, gFpaint = oldFpaint,
                        gLenMenu = 1+(gLenMenu newmenu),
                        gBook = addBookmark (gBook newmenu) ("added title",gBuffer newmenu ,"cmd")
                        }
                otherwise -> return m
        otherwise -> return m

getSelectedUrl :: MenuState -> String
getSelectedUrl (MenuState i l b _ _ _ _) = if l > 0 then
    case (bookmarkAt b i) of 
         (_,u,e) -> e++":"++u
    else ""

bookmarkAt :: Bookmarks -> Int -> BookmarkE
bookmarkAt b n = b !! (n-1)

repaint :: (VT.Event, VT.Vty) -> MenuState -> IO ()
repaint (e, v) m@(MenuState _ _ _ inputF paintF _ _) = 
    let 
        img = paintF m
        pic = Picture (Cursor 0 0) img (Background ' ' defAttr)
    in
        VT.update v pic

paintMenu :: RepaintMenuFunc -- MenuState -> Image
paintMenu m = menuToImage m 25   <-> (string defAttr (getSelectedUrl m))

deleteCurrent :: MenuState -> MenuState
deleteCurrent m@(MenuState i l b xf zf bf e) | l>1 = MenuState (if i==1 then i else i-1)  (l-1)  (deleteAt i b)  xf zf bf e
                        | otherwise = m

deleteAt :: Int -> [a] -> [a]
deleteAt n l = take (n-1) l ++ drop n l

addBookmark :: Bookmarks -> BookmarkE -> Bookmarks
addBookmark b x = b ++ [x]

-- функции рисования и обработки ввода для добавления записи
addPaint :: MenuState -> Image
addInput :: VT.Event -> MenuState -> IO MenuState

addPaint m = (string defAttr "Enter new:") <-> framedList [gBuffer m] 30 defAttr 

addInput e m = 
    return $ case e of 
        (VT.EvKey (VT.KASCII k) []) -> 
            case k of
                '\b' -> m{gBuffer= tail (gBuffer m)}
                otherwise -> m{gBuffer= (gBuffer m) ++ [k]}
        otherwise -> m

runInterfaceAndWaitFor :: MenuState -> VT.Event -> IO MenuState
runInterfaceAndWaitFor m exi = do
    let v = gVty $ gIDFIM m
    repaintOnEvent (VT.EvResize 0 0, v) m
    event <- VT.next_event v
    case event of
        k | k==exi -> return m {gIDFIM = (gIDFIM m){ gState = Exit}}
        otherwise -> do
            newmenu <- repaintOnEvent (event, v) m
            runInterfaceAndWaitFor newmenu exi

main = do 

    --savebookmarks "bm.bms" testbookmarks
    n<-loadbookmarks "bm.bms"
    --putStrLn (showbookmarks n)
    v <- VT.mkVty
    let 
        m = MenuState 1 (length (lines $ showbookmarksMenu n)) n handleInput paintMenu "" (IDFIM {gVty = v, gState = Proceed})

    repaintOnEvent ((VT.EvResize 0 0), v) m
    res <- runInterfaceAndWaitFor m (VT.EvKey (VT.KASCII 'q') [])
    VT.shutdown v
    

