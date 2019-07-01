local composer = require( "composer" )
local physics = require( "physics" )
local scene = composer.newScene()
local entity
local background
local backGroup
local mainGroup
local uiGroup
local tick = 0
local text 
local map

local function logt(t)
    print('')
    for k,v in pairs(t) do print(k,v) end
end

function loadMap() 
    tiled = require "com.ponywolf.ponytiled"
    local mapData = require "map1" 
    map = tiled.new(mapData)
    map:translate(0,0)
    --map:centerObject
    -- logt(map)
end

local function goToMap(event)
    transition.to(entity, { y=event.y, x=event.x, time=500, } )
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
    display.remove(text)
    text = display.newText("t=" .. tick, display.contentCenterX, 20, native.systemFont, 40 )
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

    entity = display.newImageRect(mainGroup, "entity1.png", 30, 30)
    entity.x = entity.width
    entity.y = display.contentHeight - entity.height
    entity.myName = "entity"
    background:addEventListener("tap", goToMap)
    entity:addEventListener("touch", drag)

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
        -- Runtime:addEventListener( "collision", onCollision )
        -- physics.start()
        -- physics.addBody(entity, { radius=30, isSensor=true } )


	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
