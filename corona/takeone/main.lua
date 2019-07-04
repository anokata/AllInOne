local composer = require( "composer" )
local physics = require( "physics" )
local widget = require( "widget" )
saveGame = {}
widget.setTheme( "widget_theme_android_holo_light" )
liba = require("liba")
display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1 } )

-- physics.start()
composer.gotoScene("game")
