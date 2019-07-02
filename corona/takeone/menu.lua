local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
saveGame = {}

-- liba.logt({1})
widget.setTheme( "widget_theme_android_holo_light" )

local playButton 
local menuButton

function goToMenu(self) 
    liba.saveProgress(saveGame)
    print("LOOADDDDDD", saveGame.tick)
    playButton.isVisible = true
    menuButton.isVisible = false
    composer.gotoScene( "menu") 
end 

local function gotoGame()
    playButton.isVisible = false
    menuButton.isVisible = true
    saveGame = liba.loadProgress()
    composer.gotoScene( "game" )
end

function scene:create( event )
	local sceneGroup = self.view
    local background = display.newImageRect(sceneGroup, "title.png", 260, 300)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    playButton = widget.newButton(
        {
            left = display.contentCenterX,
            top = display.contentHeight,
            id = "startbutton",
            label = "Play",
            onEvent = gotoGame
        })
    -- display.newText( sceneGroup, "Play", display.contentCenterX, 20, native.systemFont, 44 )
    -- playButton:setFillColor( 0.82, 0.86, 1 )
    -- playButton:addEventListener( "tap", gotoGame )
    menuButton = widget.newButton(
        {
            left = display.contentCenterX,
            top = display.contentHeight,
            id = "button1",
            label = "menu",
            onEvent = goToMenu,
        }
    )
    menuButton.isVisible = false


end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
        playButton.isVisible = true

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
