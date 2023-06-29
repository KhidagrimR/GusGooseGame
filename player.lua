Player = {}

function Player:load()
    self.sprite = love.graphics.newImage("assets/player/goose.png")

    self.x = 150
    self.y = 130
    self.width = 16--32
    self.height = 32

    self.xVel = 0
    self.yVel = 0
    self.acceleration = 100
    self.maxSpeed = 1
    self.friction = 1500


    self.hp = 3

    self.direction = "left"
    self.state = "idle"
    self.isShooting = false

    self.weapon = {}
    self.weapon.startingCoolDownDuration = 0.5
    self.weapon.coolDownDuration = self.weapon.startingCoolDownDuration
    self.weapon.coolDownDurationTimer = 0
    self.weapon.amountOfBulletPerShot = 2

    self.hurtSound = love.audio.newSource("assets/musics/hurt.mp3", "static") -- the "static" tells LÖVE to load the file into memory, good for short sound effects
    self.hurtSound:setVolume(0.4)

    self:loadAssets()
    print("Player Manager Loaded")
end

function Player:loadAssets()
    self.animation = { timer = 0, rate = 0.1 }

    -- IDLE
    self.animation.idle = { total = 4, current = 1, img = {} }
    for i = 1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("assets/player/idle/" .. i .. ".png")
    end

    -- SHOOT
    self.animation.shoot = { total = 4, current = 1, img = {} }
    for i = 1, self.animation.shoot.total do
        self.animation.shoot.img[i] = love.graphics.newImage("assets/player/shoot/" .. i .. ".png")
    end

    -- DEATH
    self.animation.death = {total = 2, current = 1, img = {} }
    for i = 1, self.animation.death.total do
        self.animation.death.img[i] = love.graphics.newImage("assets/player/death/" .. i .. ".png")
    end

    -- RELOAD
    --self.animation.reload = {total = 2, current = 1, img = {}}
    --for i=1, self.animation.reload.total do
    --self.animation.reload.img[i] = love.graphics.newImage("assets/player/reload/"..i..".png")
    --end

    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end

function Player:update(dt)
    self:animate(dt)
    if self.state == "death" or UIManager.gameState == "end" then
        return
    end

    self:setState()
    self:move(dt)
    self:clampPositionOnScreen()

    if self.isShooting == true then
        self:coolDownShoot(dt)
    end
end

function Player:getHit(damages)
    local dmg = damages or 1

    self.hp = self.hp - dmg
    self.hurtSound:play()

    if self.hp <= 0 then
        self.isShooting = true
        self.state = "death"
        UIManager:endGame(false)
    end
end

function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
       self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("q", "left") then
       self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
    else
       self:applyFriction(dt)
    end

    self.x = self.x + self.xVel 
 end

 function Player:clampPositionOnScreen()
    if self.x < 15 then
        self.x = 15
        
    end

    if self.x > CONS.gameWidth/4 - 15 then
        self.x = CONS.gameWidth/4 - 15
    end

 end

 function Player:applyFriction(dt)
   if self.xVel > 0 then
      if self.xVel - self.friction * dt > 0 then
         self.xVel = self.xVel - self.friction * dt
      else
         self.xVel = 0
      end
   elseif self.xVel < 0 then
      if self.xVel + self.friction * dt < 0 then
         self.xVel = self.xVel + self.friction * dt
      else
         self.xVel = 0
      end
   end
end

function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Player:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Player:setState()
    if self.isShooting then
        self.state = "shoot"
    else
        self.state = "idle"
    end
end

function Player:coolDownShoot(dt)
    if self.weapon.coolDownDurationTimer > 0 then
        self.weapon.coolDownDurationTimer = self.weapon.coolDownDurationTimer - dt
    else
        self.isShooting = false
        self.weapon.coolDownDurationTimer = self.weapon.coolDownDuration
    end
end

function Player:shootRight()
    if self.isShooting == true then
        return
    end

    self.isShooting = true
    self.direction = "right"
    self.weapon.coolDownDurationTimer = self.weapon.coolDownDuration

    startShake(0.2)

    --add bullets
    for i = 1, self.weapon.amountOfBulletPerShot, 1 do
        BulletManager:spawnBullet(self.direction)
    end
end

function Player:shootLeft()
    if self.isShooting == true then
        return
    end

    self.isShooting = true
    self.direction = "left"
    self.weapon.coolDownDurationTimer = self.weapon.coolDownDuration

    startShake(0.2)

    --add bullets
    for i = 1, self.weapon.amountOfBulletPerShot, 1 do
        BulletManager:spawnBullet(self.direction)
    end
end

function Player:draw()
    local scaleX = 1
    if self.direction == "right" then
        scaleX = -1
    end
    love.graphics.rectangle("fill", self.x, self.y, scaleX * self.width / 2, self.height / 2)
    love.graphics.draw(self.animation.draw, self.x , self.y, 0, scaleX, 1, self.animation.width / 2,
        self.animation.height / 2)
end
