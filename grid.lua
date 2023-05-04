require("map/map")
Grid = {}

function Grid:load()
    Grid:loadMapDatas()

    self.tiles = {}
    self.tiles.width = Grid.mymap.tilewidth * CONS.scale
    self.tiles.height = Grid.mymap.tileheight * CONS.scale

    print("tile width = " .. self.tiles.width)
    print("tile height = " .. self.tiles.height)

    self.width = Grid.mymap.width * CONS.scale
    self.height = Grid.mymap.height * CONS.scale

    print("width = " .. self.width)
    print("height = " .. self.height)

    self.info = {}
    self.info.playerSizeModifier = 10
    self.info.playerWidth = self.tiles.width * 2 - self.info.playerSizeModifier
    self.info.playerHeight = self.tiles.height * 2 - self.info.playerSizeModifier

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
    Player.x = (x * self.tiles.width) + self.info.playerSizeModifier / 2 -- + (self.tiles.width - self.info.playerWidth) / 2
    Player.y = (y * self.tiles.height) + self.info.playerSizeModifier / 2 -- + (self.tiles.height - self.info.playerHeight) / 2
end

function Grid:getGridFromWorldPosition(x,y)
    return x /  self.tiles.width, y / self.tiles.height
end

function Grid:getStartPosition()
    local width = self.width -- 20
    local height = self.height -- 11.5

    -- print(Map.layers.Start.data[1][1])
    for y = 1, height - 1, 1 do
        for x = 1, width - 1, 1 do
            --print(Grid.startMapData[1 + x + (y * width)])
            --print("Tile done on (" .. x .. "," .. y .. "), value = ") -- ..Grid.startMapData[1 + x + (y * width)])--..Map.layers.Start.data[1 + x + (y * self.width)])
            if Grid.startMapData[1 + x + (y * width)] ~= 0 then
                return x, y
            end
        end
    end
    return 0, 0
end

function Grid:findAdjacentTile(tileX, tileY, exceptionX, exceptionY) -- if no exception, use exceptionX = -1 and exceptionY = -1
    print("current tile = "..tileX.." and "..tileY)
    local chosenTileX = nil
    local chosenTileY = nil

    -- NORTH
    chosenTileX, chosenTileY = Grid:getNorthTile(tileX, tileY)
    if chosenTileX ~= nil and chosenTileY ~= nil and chosenTileX ~= exceptionX and chosenTileY ~= exceptionY then
        return  chosenTileX, chosenTileY
    end

    -- SOUTH
    chosenTileX, chosenTileY = Grid:getSouthTile(tileX, tileY)
    if chosenTileX ~= nil and chosenTileY ~= nil and chosenTileX ~= exceptionX and chosenTileY ~= exceptionY then
        return  chosenTileX, chosenTileY
    end

    -- EAST
    chosenTileX, chosenTileY = Grid:getEastTile(tileX, tileY)
    if chosenTileX ~= nil and chosenTileY ~= nil and chosenTileX ~= exceptionX and chosenTileY ~= exceptionY then
        return  chosenTileX, chosenTileY
    end

    -- WEST
    chosenTileX, chosenTileY = Grid:getWestTile(tileX, tileY)
    if chosenTileX ~= nil and chosenTileY ~= nil and chosenTileX ~= exceptionX and chosenTileY ~= exceptionY then
        return  chosenTileX, chosenTileY
    end

    return  chosenTileX, chosenTileY
end

function Grid:getNorthTile(tileX, tileY)
    -- y - 1
    if tileY - 1 > 0 then
        -- tile is reachable
        if Grid.pathMapData[tileX + ((tileY - 1) * self.width)] == 0 then
            return nil
        else
            return tileX, tileY - 1
        end
    end
    return nil
end

function Grid:getSouthTile(tileX, tileY)
    -- y + 1
    if tileY + 1 < self.height then
        -- tile is reachable
        if Grid.pathMapData[tileX + ((tileY + 1) * self.width)] == 0 then
            return nil
        else
            return tileX, tileY + 1
        end
    end
    return nil
end

function Grid:getEastTile(tileX, tileY)
    -- x + 1
    if tileX + 1 < self.width then
        -- tile is reachable
        if Grid.pathMapData[tileX + 1 + (tileY * self.width)] == 0 then
            return nil
        else
            return tileX + 1, tileY
        end
    end
    return nil
end

function Grid:getWestTile(tileX, tileY)
    -- x - 1
    if tileX - 1 > 0 then
        -- tile is reachable
        if Grid.pathMapData[tileX - 1 + (tileY * self.width)] == 0 then
            return nil
        else
            return tileX - 1, tileY
        end
    end
    return nil
end

function love:update(dt)

end

function love:draw()

end

