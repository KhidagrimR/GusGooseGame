require("map/map")
Grid = {}

function Grid:load()
    Grid:loadMapDatas()

    self.tiles = {}
    self.tiles.width = Grid.mymap.tilewidth * CONS.scale
    self.tiles.height = Grid.mymap.tileheight * CONS.scale

    print("tile width = "..self.tiles.width)
    print("tile height = "..self.tiles.height)

    self.width = Grid.mymap.width * CONS.scale
    self.height = Grid.mymap.height * CONS.scale

    print("width = "..self.width)
    print("height = "..self.height)
    
    self.info = {}
    self.info.playerSizeModifier = 10
    self.info.playerWidth = self.tiles.width * 2 - self.info.playerSizeModifier
    self.info.playerHeight = self.tiles.height * 2 - self.info.playerSizeModifier 

    self.info.playerStartX, self.info.playerStartY = Grid:getStartPosition()
    print("start pos X = "..self.info.playerStartX)
    print("start pos Y = "..self.info.playerStartY)
end

function Grid:loadMapDatas()
    -- Load maps
    Grid.mymap = love.filesystem.load("map/map.lua")()
    Grid.startMapData = Grid.mymap.layers[3].data       --.layers[CONS.layersName.start].data
    Grid.pathMapData = Grid.mymap.layers[2].data  
    Grid.decorsMapData = Grid.mymap.layers[1].data  
end

function Grid:movePlayerToPosition(x,y)
    Player.x = (x * self.tiles.width) + self.info.playerSizeModifier / 2 --+ (self.tiles.width - self.info.playerWidth) / 2
    Player.y = (y * self.tiles.height) + self.info.playerSizeModifier / 2--+ (self.tiles.height - self.info.playerHeight) / 2
end

function Grid:getStartPosition()
    local width = self.width -- 20
    local height = self.height -- 11.5

    --print(Map.layers.Start.data[1][1])
    for y = 1, height - 1, 1 do
        for x = 1, width - 1, 1 do
            print (Grid.startMapData[x + (y * width)])
            print("Tile done on ("..x..","..y.."), value = ")--..Grid.startMapData[1 + x + (y * width)])--..Map.layers.Start.data[1 + x + (y * self.width)])
            if Grid.startMapData[1 + x + (y * width)] ~= 0 then
                return x, y
            end
        end
    end
    return 0,0
end

function love:update(dt)
	
end

function love:draw()
	
end








