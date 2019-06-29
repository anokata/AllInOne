local background = display.newImageRect( "map.png", 1000, 1000 )
background.x = display.contentCenterX
background.y = display.contentCenterY
background.fill.effect = "filter.blur"

local entity = display.newImageRect("entity1.png", 30, 30)
entity.x = entity.width
entity.y = display.contentHeight - entity.height

local function logt(t)
    for k,v in pairs(t) do print(k,v) end
end

local function goToMap(event)
    logt(event)
    entity.x = event.x
    entity.y = event.y
end

background:addEventListener("tap", goToMap)

local text = display.newText("123", display.contentCenterX, 20, native.systemFont, 40 )
text:setFillColor(20, 100, 0)
