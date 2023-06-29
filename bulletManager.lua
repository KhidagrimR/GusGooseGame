BulletManager = {}

function BulletManager:load()
    self.bulletLifeSpan = 2
    self.bulletStartingSpeed = 200
    self.bulletSpeed = self.bulletStartingSpeed
    self.bullets = {}
    self.bulletIndex = 1
    self.bulletMaxSpawnAngleDegree = 10 -- in degree

    self.bulletSpawnOffset = {}
    self.bulletSpawnOffset.x = 15
    self.bulletSpawnOffset.y = 0

    --this is us setting our new particle system
    local img = love.graphics.newImage("assets/slimes/blood/1.png")
    self.pSystem = love.graphics.newParticleSystem(img, 32)
    self.pSystem:setParticleLifetime(15, 20)
    self.pSystem:setLinearAcceleration(0, 0.2, 0, 0.2)
    self.pSystem:setSpeed(0)
    self.pSystem:setRotation(0, 20)
    --self.pSystem:setSpin(2, 5)

    self.shotgunSound1 = love.audio.newSource("assets/musics/shotgun1.mp3", "static") -- the "static" tells LÖVE to load the file into memory, good for short sound effects
    self.shotgunSound1:setVolume(0.1)
    self.shotgunSound2 = love.audio.newSource("assets/musics/shotgun2.mp3", "static") -- the "static" tells LÖVE to load the file into memory, good for short sound effects
    self.shotgunSound2:setVolume(1)
    self.shotgunSound3 = love.audio.newSource("assets/musics/shotgun3.mp3", "static") -- the "static" tells LÖVE to load the file into memory, good for short sound effects
    self.shotgunSound3:setVolume(1)

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

    self:playRandomShotgunSound()
end

function BulletManager:playRandomShotgunSound()
    self.shotgunSound1:stop()
    self.shotgunSound2:stop()
    self.shotgunSound3:stop()

    local rnd = math.random(1, 3)
    if rnd == 1 then
        self.shotgunSound1:play()
    elseif rnd == 2 then
        self.shotgunSound2:play()
    else
        self.shotgunSound3:play()
    end
end

function BulletManager:getNextBulletArrayIndex()
    local index = 1
    while self.bullets[index] ~= nil do
        index = index + 1
    end

    return index
end

function BulletManager:spawnParticles(position, direction, amount) -- position = {x = ..., y = ...}
    --print("position = "..position.x)
    self.pSystem:setPosition(position.x - 5, position.y - 5)
    self.pSystem:emit(amount)
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
    love.graphics.draw(self.pSystem, x / 16, y / 16)

    -- for each bullet, call bullet draw
    for i = 1, #self.bullets, 1 do -- #self.bullets = table.length
        if self.bullets[i] ~= nil then
            self.bullets[i]:draw()
        end
    end
end
