Player = {}

function Player:load()
    self.sprite = love.graphics.newImage("assets/player/goose.png")

    self.x = 150
    self.y = 130
    self.width = 32
    self.height = 32

    self.hp = 3

    self.direction = "left"
    self.state = "idle"
    self.isShooting = false

    self.weapon = {}
    self.weapon.startingCoolDownDuration = 0.5
    self.weapon.coolDownDuration = self.weapon.startingCoolDownDuration
    self.weapon.coolDownDurationTimer = 0
    self.weapon.amountOfBulletPerShot = 2

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
    if self.state == "death" then
        return
    end

    self:setState()

    if self.isShooting == true then
        self:coolDownShoot(dt)
    end
end

function Player:getHit()
    self.hp = self.hp - 1

    if self.hp <= 0 then
        self.isShooting = true
        self.state = "death"
        UIManager:endGame()
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
    --love.graphics.rectangle("fill", self.x, self.y, scaleX * self.animation.width / 2, self.animation.height / 2)
    love.graphics.draw(self.animation.draw, self.x + 12, self.y, 0, scaleX, 1, self.animation.width / 2,
        self.animation.height / 2)
end
