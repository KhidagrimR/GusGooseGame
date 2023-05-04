Player = {}

function Player:load()
    self.x = 0
    self.y = 0
    self.width = Grid.info.playerWidth
    self.height = Grid.info.playerHeight

    self.state = "idle"

    Grid:movePlayerToPosition(Grid.info.playerStartX,Grid.info.playerStartY)
end

function Player:update(dt)

end

function Player:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
