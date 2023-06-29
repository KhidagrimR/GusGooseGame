-- HERE WE MAKE A CLASS
Enemy = {}
Enemy.__index = Enemy

function Enemy.new(enemyIndex, startingX, startingY, direction, spriteFolder, spriteName, hp, speed, jumpStr,
                   jumpTimerMin, jumpTimerMax, funcOnDeath)
    local instance = setmetatable({}, Enemy)
    instance.nameIndex = enemyIndex
    instance.sprite = love.graphics.newImage("assets/slimes/" .. spriteFolder .. "/" .. spriteName .. ".png")

    instance.x = startingX
    instance.y = startingY
    instance.width = 16
    instance.height = 16
    instance.speed = speed --50
    instance.hp = hp       --4

    instance.damages = 1

    instance.spriteFolder = spriteFolder
    instance.spriteName = spriteName

    instance.xVel = 0
    instance.yVel = 0
    instance.gravity = 500
    instance.jumpStr = jumpStr                                                -- -200
    instance.jumpTimerCooldown = love.math.random(jumpTimerMin, jumpTimerMax) -- 3 and 6
    instance.jumpTimer = instance.jumpTimerCooldown

    instance.isGrounded = false
    instance.groundOffset = 0
    instance.state = "idle"

    instance.onHitFuntion = nil

    instance.direction = direction

    instance.onDeath = funcOnDeath or function() print("this button has no function attached") end

    print("New enemy added on position : " .. instance.x .. " and " .. instance.y)
    instance:loadAssets()
    return instance
end

function Enemy:loadAssets()
    self.animation = { timer = 0, rate = 0.1 }

    -- IDLE
    self.animation.idle = { total = 4, current = 1, img = {} }
    for i = 1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("assets/slimes/" ..
            self.spriteFolder .. "/" .. self.spriteName .. "_walk" .. i .. ".png")
    end

    -- JUMP
    self.animation.jump = { total = 2, current = 1, img = {} }
    for i = 1, self.animation.jump.total do
        self.animation.jump.img[i] = love.graphics.newImage("assets/slimes/" ..
            self.spriteFolder .. "/" .. self.spriteName .. "_jump" .. i .. ".png")
    end

    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end

function Enemy:update(dt)
    self:applyGravity(dt)
    self:checkIfAlive()
    self:jumpTimerUpdate(dt)
    self:animate(dt)
    self:move(dt)
    self:detectGround()
end

function Enemy:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Enemy:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Enemy:move(dt)
    if self.isGrounded then -- move faster while in the air
        local groundFriction = 0.05
        self.x = self.x + self.speed * self.direction * dt * groundFriction
    else
        self.x = self.x + self.speed * self.direction * dt
    end
    self.y = self.y + self.yVel * dt
end

function Enemy:draw()
    --love.graphics.rectangle("fill", self.x, self.y, self.direction * self.width / 2, self.height / 2)
    --love.graphics.draw(self.sprite, self.x - (self.width / 2) * self.direction , self.y - self.height / 2, 0, self.direction, 1)
    love.graphics.draw(self.animation.draw, self.x - (self.animation.width / 2) * self.direction,
        self.y - self.animation.height / 2, 0, self.direction, 1)
end

function Enemy:applyGravity(dt)
    if not self.isGrounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end

function Enemy:jumpTimerUpdate(dt)
    if self.jumpTimer >= 0 then
        self.jumpTimer = self.jumpTimer - dt
    else
        self.jumpTimer = self.jumpTimerCooldown
        self:jump()
    end
end

function Enemy:jump()
    if self.isGrounded then
        --print("jump applied")
        self.yVel = self.yVel + self.jumpStr
        self.isGrounded = false;
    end
end

function Enemy:detectGround()
    if self.y >= CONS.groundPos + self.groundOffset then
        self.isGrounded = true
        self.yVel = 0
        self.state = "idle"
    else
        self.isGrounded = false
        self.state = "jump"
    end
end

function Enemy:loseLife(amount)
    self:onHit()
    self.hp = self.hp - amount
end

function Enemy:checkIfAlive()
    if self.hp <= 0 then
        Enemy.die(self)
        EnemyManager:removeEnemy(self.nameIndex)
    end
end

function Enemy:die()
    local position = {x = self.x, y = self.y}
    print("selfx ="..self.hp )

    self:onDeath();

    BulletManager:spawnParticles(position, self.direction, 1)
end

function Enemy:onHit()
    if self.onHitFuntion then
        self.onHitFuntion()
    end
end

function Enemy:goBack()
    self.x = self.x - self.direction * 1
end
