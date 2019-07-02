local M = {}
local json = require( "json" )
local filePath = system.pathForFile( "saveGame.json", system.DocumentsDirectory )

M.logt = function (t)
    print('')
    for k,v in pairs(t) do print(k,v) end
end

M.loadProgress = function ()
    local saveGame 
    local file = io.open( filePath, "r" )
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        saveGame = json.decode( contents )
    end
 
    if ( saveGame == nil) then
        saveGame = { }
    end
    return saveGame
end

M.saveProgress = function (saveGame)

    local file = io.open( filePath, "w" )

    if file then
        file:write( json.encode( saveGame ) )
        io.close( file )
    end
end

return M

