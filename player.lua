Player = {}

function Player:load()
    self.x = 0
    self.y = 0
    self.width = Grid.info.playerWidth
    self.height = Grid.info.playerHeight

    self.state = "idle"

    self.targetTile = {}
    self.targetTile.x = 0
    self.targetTile.y = 0

    self.previousTile = {}
    self.previousTile.x = 0
    self.previousTile.y = 0

    self.currentTile = {}
    self.currentTile.x = 0
    self.currentTile.y = 0

    Grid:movePlayerToPosition(Grid.info.playerStartX,Grid.info.playerStartY)
end

function Player:update(dt)
   --print("player X and Y = "..self.x.." , "..self.y)
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

   Grid:movePlayerToPosition(self.targetTile.x, self.targetTile.y)
   --print("Player moved to x = "..self.x.." , y = "..self.y)
end

function Player:findAdjacentTile()
   self.targetTile.x, self.targetTile.y = Grid:findAdjacentTile(self.currentTile.x, self.currentTile.y, self.previousTile.x, self.previousTile.y)
   print("Target tile position are : "..self.targetTile.x.." , "..self.targetTile.y)
end

function Player:draw()
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end