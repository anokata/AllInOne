local composer = require( "composer" )
local physics = require( "physics" )
local widget = require( "widget" )
saveGame = {}

x = 'string'
string_mt = getmetatable(x)
string_mt.__add = function(a, b)
 return a..b
end
string_mt.__index = function(s, i)
 return string.format('%c', string.byte(s, i))
end


widget.setTheme( "widget_theme_android_holo_light" )
liba = require("liba")
display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1 } )

-- physics.start()
composer.gotoScene("game")
