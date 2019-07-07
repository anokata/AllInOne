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

M.split = function (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

M.addToSet = function(set, key)
    set[key] = true
end

M.removeFromSet = function(set, key)
    set[key] = nil
end

M.setContains = function(set, key)
    return set[key] ~= nil
end

return M

