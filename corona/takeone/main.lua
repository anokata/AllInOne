local composer = require( "composer" )
liba = require("liba")
display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1 } )

composer.gotoScene("menu")
