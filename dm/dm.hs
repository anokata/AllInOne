#!/usr/bin/env runhaskell
--Download manager via wget
--choose: vty(very nativ), vty-ui, hscurses(example bad work?)
import qualified Graphics.Vty as VT
import Graphics.Vty.Picture
import Graphics.Vty.Attributes
import Control.Concurrent(threadDelay)

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

defAttr = with_fore_color (with_back_color current_attr black) bright_red
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
        --lWalla = lWall attr
    in
    drawTop <-> drawList <-> drawBottom
    where 
        drawTop = (luCorner attr) <|> (char_fill attr blockHWall w 1) <|> (ruCorner attr)
        drawBottom = (ldCorner attr) <|> (char_fill attr blockHWall w 1) <|> (rdCorner attr) 
        lWalla = lWall attr
        drawList = foldl (\acc x->acc <-> lWalla <|> (string attr x) <|> (translate (w - length x, 0) lWalla)) empty_image l

main = do 
    v <- VT.mkVty
    
    let 
        img = (string defAttr "test\ntest") <-> (background_fill 20 20) <-> (string defAttr "test\ntest") <|> (string defAttr "test\ntest") <|> (char defAttr 'F')
        teststring = (string defAttr "(1) list node.")
        ts2 = (string defAttr horBlock)
        ts3 = char_fill defAttr blockLWall 1 10
        

        topb = char_fill defAttr blockHWall 20 1
        top = (luCorner defAttr) <|> topb <|> (ruCorner defAttr)
        bot = (ldCorner defAttr) <|> topb <|> (rdCorner defAttr)

        vWall = char_fill defAttr blockLWall 1 3
        rightWall = translate (20,0) vWall
        testlist = translate (0,0) (teststring <-> teststring <-> teststring)
        frame = top <-> vWall <|> rightWall <-> bot
        img2 = teststring <-> top <-> vWall <|> testlist <-> bot
        img3 = frame
        img4 = framedList ["(1.)","(2.) - ","(1) list node.","abraCaDabra","------"] 15 defAttr

        pic = Picture (Cursor 0 0) img4 (Background '.' defAttr)
        --empty_image
    
    VT.update v pic
    event <- VT.next_event v
    print event
    --threadDelay 100000
    
    --print "End."
