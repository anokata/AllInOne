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
--blockVWall = '\x2501'

main = do 
    v <- VT.mkVty
    
    let defAttr = with_fore_color (with_back_color current_attr black) bright_red
        img = (string defAttr "test\ntest") <-> (background_fill 20 20) <-> (string defAttr "test\ntest") <|> (string defAttr "test\ntest") <|> (char defAttr 'F')
        teststring = (string defAttr "(1) list node.")
        ts2 = (string defAttr horBlock)
        ts3 = char_fill defAttr blockLWall 1 10
        
        luCorner = char defAttr blockCornerLU
        ruCorner = char defAttr blockCornerRU
        ldCorner = char defAttr blockCornerLD
        rdCorner = char defAttr blockCornerRD
        topb = char_fill defAttr blockHWall 20 1
        top = luCorner <|> topb <|> ruCorner
        bot = ldCorner <|> topb <|> rdCorner

        vWall = char_fill defAttr blockLWall 1 3
        rightWall = translate (20,0) vWall
        testlist = translate (0,0) (teststring <-> teststring <-> teststring)
        frame = top <-> vWall <|> rightWall <-> bot
        img2 = teststring <-> top <-> vWall <|> testlist <-> bot
        img3 = frame

        pic = Picture (Cursor 0 0) img3 (Background '.' defAttr)
        --empty_image
    
    VT.update v pic
    event <- VT.next_event v
    print event
    --threadDelay 100000
    
    --print "End."
