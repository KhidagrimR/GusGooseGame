require("map/map")
Grid = {}

function Grid:load()
    Grid:loadMapDatas()

    self.tiles = {}
    self.tiles.width = Grid.mymap.tilewidth
    self.tiles.height = Grid.mymap.tileheight

    print("tile width = " .. self.tiles.width)
    print("tile height = " .. self.tiles.height)

    self.width = Grid.mymap.width
    self.height = Grid.mymap.height

    print("width = " .. self.width)
    print("height = " .. self.height)

    self.info = {}
    self.info.playerSizeModifier = 10
    self.info.playerWidth = self.tiles.width * 4 - self.info.playerSizeModifier
    self.info.playerHeight = self.tiles.height * 4 - self.info.playerSizeModifier

    self.info.playerStartX, self.info.playerStartY = Grid:getStartPosition()
    print("start pos X = " .. self.info.playerStartX)
    print("start pos Y = " .. self.info.playerStartY)
end

function Grid:loadMapDatas()
    -- Load maps
    Grid.mymap = love.filesystem.load("map/map.lua")()
    Grid.startMapData = Grid.mymap.layers[3].data -- .layers[CONS.layersName.start].data
    Grid.pathMapData = Grid.mymap.layers[2].data
    Grid.decorsMapData = Grid.mymap.layers[1].data
end

function Grid:movePlayerToPosition(x, y)
    print("player must move to coordinate : " .. x .. " , " .. y)
    Player.x = (x * self.tiles.width) +
    self.info.playerSizeModifier / 2                                      -- + (self.tiles.width - self.info.playerWidth) / 2 =>  133 ->
    Player.y = (y * self.tiles.height) +
    self.info.playerSizeModifier / 2                                      -- + (self.tiles.height - self.info.playerHeight) / 2
    Player.currentTile.x = x
    Player.currentTile.y = y
end

function Grid:convertGridToWorldPosition(x, y)
    local rX = x * self.tiles.width
    local rY = y * self.tiles.height
    print(" X and Y : " .. x .. " , " .. y .. " are converted into : " .. rX .. " , " .. rY)
    return rX, rY
end

function Grid:getStartPosition()
    local width = self.width   -- 20
    local height = self.height -- 11.5

    -- print(Map.layers.Start.data[1][1])
    for y = 1, height, 1 do
        for x = 1, width, 1 do
            --print(Grid.startMapData[1 + x + (y * width)])
            --print("Tile done on (" .. x .. "," .. y .. "), value = ") -- ..Grid.startMapData[1 + x + (y * width)])--..Map.layers.Start.data[1 + x + (y * self.width)])
            if Grid.startMapData[1 + x + (y * width)] ~= 0 then
                return x * 2, y * 2
            end
        end
    end
    return 0, 0
end

function Grid:findAdjacentTile(tileX, tileY, exceptionX, exceptionY) -- if no exception, use exceptionX = -1 and exceptionY = -1
    print("current tile = " .. tileX .. " and " .. tileY)
    local chosenTileX = nil
    local chosenTileY = nil

    -- NORTH
    chosenTileX, chosenTileY = Grid:getNorthTile(tileX, tileY)
    if chosenTileX ~= nil and chosenTileY ~= nil and chosenTileX ~= exceptionX and chosenTileY ~= exceptionY then
        print("North Was Chosen")
        return chosenTileX, chosenTileY
    end

    -- SOUTH
    chosenTileX, chosenTileY = Grid:getSouthTile(tileX, tileY)
    if chosenTileX ~= nil and chosenTileY ~= nil and chosenTileX ~= exceptionX and chosenTileY ~= exceptionY then
        print("South Was Chosen")
        return chosenTileX, chosenTileY
    end

    -- EAST
    chosenTileX, chosenTileY = Grid:getEastTile(tileX, tileY)
    if chosenTileX ~= nil and chosenTileY ~= nil and chosenTileX ~= exceptionX and chosenTileY ~= exceptionY then
        print("East Was Chosen")
        return chosenTileX, chosenTileY
    end

    -- WEST
    chosenTileX, chosenTileY = Grid:getWestTile(tileX, tileY)
    if chosenTileX ~= nil and chosenTileY ~= nil and chosenTileX ~= exceptionX and chosenTileY ~= exceptionY then
        print("West Was Chosen")
        return chosenTileX, chosenTileY
    end

    print("None Was Chosen")
    return chosenTileX, chosenTileY
end

function Grid:getNorthTile(tileX, tileY)
    local tileModifier = 4
    -- y - 4
    if tileY - tileModifier > 0 then
        -- tile is reachable
        print("North value = " ..Grid.pathMapData[tileX + ((tileY - tileModifier) * self.width)] .." on : " .. tileX .. " , " .. (tileY - tileModifier) .. " tile number : " .. tileX + ((tileY - tileModifier) * self.width))
        if Grid.pathMapData[tileX + ((tileY - tileModifier) * self.width)] == 0 then
            return nil
        else
            return tileX, tileY - tileModifier
        end
    end
    return nil
end

function Grid:getSouthTile(tileX, tileY)
    local tileModifier = 2
    -- y + 2
    if tileY + tileModifier < self.height then
        -- tile is reachable
        print("From tile on : "..tileX.." , "..tileY.." , tile number : "..(tileX + (tileY / 2 * self.width)))
        print("South value = " ..Grid.pathMapData[tileX + ((tileY + tileModifier) * self.width)] .. " on : " .. tileX .. " , " .. (tileY + tileModifier) .. " tile number : " .. tileX + ((tileY + tileModifier) * self.width))
        if Grid.pathMapData[tileX + ((tileY + tileModifier) * self.width)] == 0 then
            return nil
        else
            return tileX, tileY + tileModifier
        end
    end
    return nil
end

function Grid:getEastTile(tileX, tileY)
    local tileModifier = 4
    -- x + 4
    if tileX + tileModifier < self.width then
        -- tile is reachable
        print("East value = " ..Grid.pathMapData[tileX + tileModifier + (tileY * self.width)] .. " on : " .. (tileX + tileModifier) .. " , " .. tileY .. " tile number : " .. tileX + tileModifier + (tileY * self.width))
       
        if Grid.pathMapData[tileX + tileModifier + (tileY * self.width)] == 0 then
            return nil
        else
            return tileX + tileModifier, tileY
        end
    end
    return nil
end

function Grid:getWestTile(tileX, tileY)
    local tileModifier = 4
    -- x - 4
    if tileX - tileModifier > 0 then
        -- tile is reachable
        print("West value = " ..Grid.pathMapData[tileX - tileModifier + (tileY * self.width)] .. " on : " .. (tileX - tileModifier) .. " , " .. tileY.. " tile number : " .. tileX - tileModifier + (tileY * self.width))
        if Grid.pathMapData[tileX - tileModifier + (tileY * self.width)] == 0 then
            return nil
        else
            return tileX - tileModifier, tileY
        end
    end
    return nil
end

function Grid:update(dt)

end

function Grid:draw()
    local width = self.width
    local height = self.height

    -- print(Map.layers.Start.data[1][1])
    for y = 1, height, 1 do
        for x = 1, width, 1 do
            if Grid.pathMapData[1 + x + (y * width)] ~= 0 then
                love.graphics.rectangle("fill", x * Grid.tiles.width * 2, y * Grid.tiles.height * 2, Grid.tiles.width,Grid.tiles.height)
            end
        end
    end
end
