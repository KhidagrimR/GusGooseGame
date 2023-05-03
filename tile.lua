-- Tile states = "Neutral", "Choose_Direction"
Tile = {}
Tile.__index = Tile

function Tile.new(posX, posY)
    local instance = setmetatable({}, Tile)
    instance.name = "tile ("..posX..","..posY..")"
    instance.posX = posX
    instance.posY = posY


    return instance
end

function Tile:displayName()
    print(self.name)
end


--animal1 = Animal.new("doge")
--animal2 = Animal.new("cat")
--animal3 = Animal.new("quick")

--animal1:displayName()
--animal2:displayName()
--animal3:displayName()
