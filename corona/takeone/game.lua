local composer = require( "composer" )
local physics = require( "physics" )
local scene = composer.newScene()
local entity
local background
local backGroup
local mainGroup
local uiGroup
local text 
local map
local mapData
local tiles 
local walkable
local piuSound
local introSound
local tick = 0
local mapBoxMinI = 2
local mapBoxMinJ = 2
local mapBoxMaxI = 6
local mapBoxMaxJ = 10

function mapXY2IJ(x, y)
    local i = math.floor(x / mapData.tilewidth)
    local j = math.floor(y / mapData.tileheight)
    return i, j
end

function mapTileIJ(i, j)
    -- сдвиг карты на тайлы
    local mi = -math.floor(map.x / mapData.tilewidth)
    local mj = -math.floor(map.y / mapData.tileheight)
    -- print(i, j, mi, mj)
    return i + mi + 1, j + mj
end

function mapIJ2XY(i, j)
    local x = i * mapData.tilewidth
    local y = j * mapData.tileheight
    return x, y
end

function mapLinearIndex(i, j)
    return j * mapData.width + i
end

function mapTileId(i, j)
    return tiles[mapLinearIndex(i, j)]
end

function mapIsWalkable(i, j)
    local tileId = mapTileId(i, j)
    -- print(tileId, walkable[tileId])
    return liba.setContains(walkable, tileId)
end

function loadMap() 
    tiled = require "com.ponywolf.ponytiled"
    mapData = require "map32" 
    map = tiled.new(mapData)
    map:translate(0,0)
    -- извлечём данные тайлов из слоя земли
    for i, layer in pairs(mapData.layers) do
        if (layer.type == "tilelayer" and layer.name == "Ground") then
            tiles = layer.data
            break
        end
    end
    walkable = {}
    local walkableT = liba.split(mapData.properties.walktiles, ",")
    for i, t in pairs(walkableT) do
        liba.addToSet(walkable, tonumber(t))
    end
end

local function goToMap(event)
    --transition.to(entity, { y=event.y, x=event.x, time=500} )
    --transition.to(map, { y=-event.y, x=-event.x, time=500} )
    -- local dx = entity.x - event.x
    -- local dy = entity.y - event.y
    -- entity:setLinearVelocity(-10* dx , -10* dy)
    --audio.play( piuSound )
    i, j = mapXY2IJ(event.x, event.y)
    ti, tj = mapTileIJ(i, j)
    local iswalk = mapIsWalkable(ti, tj)
    -- print(iswalk)
    if (not iswalk) then return end

    -- print(i, j)
    -- карта уже сдвинута на mapData.y
    local mapDx = 0
    local mapDy = 0
    if (i > mapBoxMaxI) then
        mapDx = -mapData.tilewidth* (i - mapBoxMaxI)
        i = mapBoxMaxI
    end
    if (j > mapBoxMaxJ) then
        mapDy = -mapData.tileheight * (j - mapBoxMaxJ)
        j = mapBoxMaxJ
    end
    if (i < mapBoxMinI) then
        mapDx = mapData.tilewidth* (mapBoxMinI - i)
        i = mapBoxMinI
    end
    if (j < mapBoxMinJ) then
        mapDy = mapData.tileheight * (mapBoxMinJ - j)
        j = mapBoxMinJ
    end
    transition.to(map, { y=map.y+mapDy, x=map.x+mapDx, time=150} )
    -- print(mapIJ2XY(i, j))
    x, y = mapIJ2XY(i, j)
    transition.to(entity, { y=y+entity.height/2, x=x+entity.width/2, time=150} )
end

local function drag(event)
    local phase = event.phase
 
    if ( "began" == phase ) then
        display.currentStage:setFocus(entity)
    elseif ( "ended" == phase or "cancelled" == phase ) then
        display.currentStage:setFocus( nil )
    end
    return true  -- Prevents touch propagation to underlying objects
end


local function gameLoop()
    tick = tick + 1 
    composer.setVariable( "tick", tick )
    saveGame.tick = tick
    display.remove(text)
    text = display.newText(uiGroup, "t=" .. tick, display.contentCenterX, 20, native.systemFont, 40 )
    text:setFillColor(20, 100, 0)
end

-- create()
function scene:create( event )
	local sceneGroup = self.view

    loadMap()
    sceneGroup:insert( map )

    backGroup = display.newGroup()
    sceneGroup:insert( backGroup )
 
    mainGroup = display.newGroup()
    sceneGroup:insert( mainGroup )
 
    uiGroup = display.newGroup()
    sceneGroup:insert( uiGroup )

    background = display.newImageRect(backGroup, "map.png", 1000, 1000)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background.fill.effect = "filter.blur"

    entity = display.newImage(mainGroup, "g2.png")
    entity.x = 200
    entity.y = 200
    entity.myName = "entity"
    background:addEventListener("tap", goToMap)
    entity:addEventListener("touch", drag)

    --composer.setVariable( "tick", saveGame.tick )
    -- print("LOOADDDDDD", saveGame.tick, tick)
    if (saveGame.tick ~= nil) then
        tick = saveGame.tick
    end

    piuSound= audio.loadSound( "sound/piu.wav" )
    introSound= audio.loadSound( "sound/meowtekA.wav" )

end

local function handleButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
    end
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
        gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
        Runtime:addEventListener( "collision", onCollision )
        -- physics.setGravity( 0, 0 )
        -- physics.addBody(entity, "dynamic", { radius=30, isSensor=false } )
        --audio.play( introSound,  { channel=1, loops=-1 } )


	end
end

function onCollision() 
print("collide")
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        if ( gameLoopTimer ~= nil ) then
            timer.cancel( gameLoopTimer )
        end

	elseif ( phase == "did" ) then
        --Runtime:removeEventListener( "collision", onCollision )
        -- physics.pause()
        audio.stop( 1 )
        composer.removeScene( "game" )

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
    audio.dispose( piuSound)
    audio.dispose( introSound )
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
