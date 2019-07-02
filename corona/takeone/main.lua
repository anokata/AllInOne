local composer = require( "composer" )
local physics = require( "physics" )
liba = require("liba")
display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1 } )

physics.start()
composer.gotoScene("menu")
