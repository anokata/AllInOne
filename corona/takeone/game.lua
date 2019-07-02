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
local piuSound
local introSound
local tick = 0

function loadMap() 
    tiled = require "com.ponywolf.ponytiled"
    local mapData = require "map32" 
    map = tiled.new(mapData)
    map:translate(0,0)
end

local function goToMap(event)
    -- transition.to(entity, { y=event.y, x=event.x, time=500, } )
    local dx = entity.x - event.x
    local dy = entity.y - event.y
    -- dx = dx / math.abs(dx)
    -- dy = dy / math.abs(dy)

    -- entity:setLinearVelocity(-100 * dx , -100 * dy)
    entity:setLinearVelocity(-10* dx , -10* dy)

    -- map:centerObject(entity)
    audio.play( piuSound )
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
    print("LOOADDDDDD", saveGame.tick, tick)
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
        physics.setGravity( 0, 0 )
        physics.addBody(entity, "dynamic", { radius=30, isSensor=false } )
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
