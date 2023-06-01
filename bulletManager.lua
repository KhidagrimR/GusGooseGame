BulletManager = {}

function BulletManager:load()
    self.bulletLifeSpan = 2
    self.bulletSpeed = 200
    self.bullets = {}
    self.bulletIndex = 1
    self.bulletMaxSpawnAngleDegree = 10 -- in degree

    self.bulletSpawnOffset = {}
    self.bulletSpawnOffset.x = 15
    self.bulletSpawnOffset.y = 0

    --this is us setting our new particle system
    local img = love.graphics.newImage("assets/player/particle/shoot_4.png")
    self.pSystem = love.graphics.newParticleSystem(img, 32)
    self.pSystem:setParticleLifetime(1, 5)
    self.pSystem:setLinearAcceleration(-20, -20, 20, 20)
    self.pSystem:setSpeed(20)
    self.pSystem:setRotation(10, 20)
    self.pSystem:setSpin(20, 50)

    print("Bullet Manager Loaded")
end

function BulletManager:spawnBullet(direction)
    local dir = 1
    local angle

    if direction == "left" then
        dir = -1
        angle = math.random(-self.bulletMaxSpawnAngleDegree, self.bulletMaxSpawnAngleDegree)
    else
        dir = 1
        angle = math.random(-self.bulletMaxSpawnAngleDegree, self.bulletMaxSpawnAngleDegree)
    end

    angle = angle * (math.pi / 180) -- to convert in radiant

    print("Attempt to create a bullet : " ..
    self.bulletIndex .. " on coordinate (" .. Player.x .. " , " .. Player.y .. ") with direction toward : " .. dir)

    local bulletArrayIndex = BulletManager:getNextBulletArrayIndex()
    self.bullets[bulletArrayIndex] = Bullet.new(self.bulletIndex, Player.x + (self.bulletSpawnOffset.x * dir),
        Player.y + self.bulletSpawnOffset.y, dir, angle)

    self.bulletIndex = self.bulletIndex + 1


    self.pSystem:setPosition(Player.x + (self.bulletSpawnOffset.x * dir), Player.y + self.bulletSpawnOffset.y)
    self.pSystem:emit(32)
end

function BulletManager:getNextBulletArrayIndex()
    local index = 1
    while self.bullets[index] ~= nil do
        index = index + 1
    end

    return index
end

function BulletManager:update(dt)
    self:updateBullets(dt)
    self.pSystem:update(dt)
end

function BulletManager:updateBullets(dt)
    for i = 1, #self.bullets, 1 do -- #self.bullets = table.length
        if self.bullets[i] ~= nil then
            self.bullets[i]:update(dt)
        end
    end
end

function BulletManager:removeBullet(p_bulletNameIndex)
    print("bullet removed : " .. p_bulletNameIndex)
    local bulletToRemoveIndex = nil
    for i = 1, #self.bullets, 1 do
        if self.bullets[i] ~= nil then
            if self.bullets[i].nameIndex == p_bulletNameIndex then
                bulletToRemoveIndex = i
                break;
            end
        end
    end

    if self.bullets[bulletToRemoveIndex] ~= nil then
        --self.bullets[bulletToRemoveIndex] = nil
        table.remove(self.bullets, bulletToRemoveIndex)
    end

    print("amount of bullet in table : " .. #self.bullets)
end

function BulletManager:draw()
    local x, y = self.pSystem:getPosition()
    love.graphics.draw(self.pSystem, Player.x / 4, Player.y / 4)

    -- for each bullet, call bullet draw
    for i = 1, #self.bullets, 1 do -- #self.bullets = table.length
        if self.bullets[i] ~= nil then
            self.bullets[i]:draw()
        end
    end
end
