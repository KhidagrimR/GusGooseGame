Player = {}

function Player:load()
    self.x = 0
    self.y = 0
    self.width = Grid.info.playerWidth
    self.height = Grid.info.playerHeight

    self.state = "idle"

    Grid:movePlayerToPosition(Grid.info.playerStartX,Grid.info.playerStartY)

    self.targetTile = {}
    self.targetTile.x = 0
    self.targetTile.y = 0

    self.previousTile = {}
    self.previousTile.x = 0
    self.previousTile.y = 0

end

function Player:update(dt)

end

function Player:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Player:move(amount)
   for i = 1, amount, 1 do
      Player:move()
   end
end

function Player:move()
   self:findAdjacentTile()

   self.previousTile.x = self.x
   self.previousTile.y = self.y

   Grid:movePlayerToPosition(Grid:getGridFromWorldPosition(self.x, self.y))
   print("Player moved to x = "..self.x.." , y = "..self.y)
end

function Player:findAdjacentTile()
   self.targetTile.x, self.targetTile.y = Grid:findAdjacentTile(self.x, self.y, self.previousTile.x, self.previousTile.y)
end
