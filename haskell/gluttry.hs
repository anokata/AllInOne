import Graphics.UI.GLUT
--import Graphics.Rendering.OpenGL
{-
-- go client local net
рассмотреть строку как число и операции на строках как операции над числом. "abc" = 979899 head = ?
- [ ] фун с удобной адресацией для вывода текста: gprint "string" 20 30 (Screen 200 200)
ortho2D 
-}

reshape :: ReshapeCallback
reshape size@(Size w h) = do
   viewport $= (Position 0 0, size)
   matrixMode $= Projection
   loadIdentity
   ortho2D 0 (fromIntegral w) 0 (fromIntegral h)
   matrixMode $= Modelview 0
   loadIdentity 
   
scrx = 390
scr = 400

drawOneLine :: Vertex2 GLfloat -> Vertex2 GLfloat -> IO ()
drawOneLine p1 p2 = renderPrimitive Lines $ do vertex p1; vertex p2

drawQuad2d :: Vertex2 GLfloat -> Vertex2 GLfloat -> Vertex2 GLfloat -> Vertex2 GLfloat -> IO ()
drawQuad2d p1 p2 p3 p4 = renderPrimitive Quads $ do vertex p1; vertex p2; vertex p3; vertex p4
drawQuad :: (GLfloat, GLfloat) -> (GLfloat, GLfloat) -> (GLfloat, GLfloat) -> (GLfloat, GLfloat) -> IO ()
drawQuad (x1,y1) (x2,y2) (x3,y3) (x4,y4) = drawQuad2d (Vertex2 x1 y1) (Vertex2 x2 y2) (Vertex2 x3 y3) (Vertex2 x4 y4) 

printString :: Vertex2 GLfloat -> String -> IO ()
printString pos@(Vertex2 x y) s = do
   --color white
   let pos' = (Vertex2 (scrx-x) (scrx-y)) :: Vertex2 GLfloat
   rasterPos pos'
   renderString Fixed8By13 s

a  = (Vector3 0.0 1.0 0.0 :: Vector3 GLdouble)
petrol, orange, white :: Color3 GLfloat
petrol = Color3 0.0 0.6 0.8
orange = Color3 1.0 0.7 0.3
white  = Color3 1.0 1.0 1.0
display = do
    clear [ ColorBuffer, DepthBuffer ] 
    --matrixMode $= Modelview 0
    loadIdentity
    --renderObject Solid (Teapot 0.5)
    --lighting $= Enabled    
    --light (Light 0) $= Enabled 
    lineWidth $= 1
    color white
    renderPrimitive Lines $ do vertex ((Vertex3  0 0 (-1) ) :: Vertex3 GLfloat)
                               vertex ((Vertex3  (-1) 0 1 ) :: Vertex3 GLfloat)
    drawOneLine (Vertex2  50 125) (Vertex2 150 125)
    drawQuad (0,0)  (0,scr)  (scr,scr)  (scr,0) 
    color $ ((Color3 0.0 0.1 0.8) :: Color3 GLfloat)
    renderQuadric (QuadricStyle (Just Flat) NoTextureCoordinates Outside FillStyle)  (Disk 100 100 30 5)
    renderQuadric (QuadricStyle (Just Flat) NoTextureCoordinates Outside FillStyle)  (Sphere 10 30 5)
    drawOneLine (Vertex2  50 125) (Vertex2 150 125)
     
    printString (Vertex2 (200) (200)) "O"
    
    color petrol
    --translate (Vector3 0.0 0.0 (-0.2) :: Vector3 GLdouble)
    --rotate 180.0 a
    --renderObject Solid Dodecahedron --(Cube 0.7)
    color orange 
    --printString (Vertex2 (-0.25) (-0.8)) "Fully Occluded"
    --printString (Vertex2 (0.0) (0.0)) "Fully Occluded"
    printString (Vertex2 (scrx) (scrx)) "B"
    printString (Vertex2 (0) (0)) "T"
    --printString (Vertex2 (10) (0)) "C"
    --printString (Vertex2 (0) (10)) "D"
    printString (Vertex2 (scrx) (0)) "R"
    printString (Vertex2 (0) (scrx)) "L"
    --renderString MonoRoman "hello glut world."
    --scale 0.001 0.001 (0.001 :: GLfloat)
    --renderString Roman "Test string"
    swapBuffers 
    --print "display"

keyboard :: KeyboardCallback 
keyboard c p = case c of 
    'q' -> exit 
    _ -> return ()

m = do
    (progName, _args) <- getArgsAndInitialize
    initialWindowPosition $= Position 0 0
    initialWindowSize $= Size 400 400
    initialDisplayMode $= [ RGBMode, DoubleBuffered, WithDepthBuffer ] 
    
    --initialize "some" []
    win <- createWindow "[test]"
    --state <- makeState 
    --setIdleCallback state
    reshapeCallback $= Just reshape
    displayCallback $= display
    keyboardCallback $= Just keyboard
    attachMenu RightButton (Menu [MenuEntry "clickME!" (print "clicked")])
    --addTimerCallback 100 (postRedisplay (Just win))
    mainLoop
