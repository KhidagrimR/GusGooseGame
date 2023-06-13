-- HERE WE MAKE A CLASS
Bullet = {}
Bullet.__index = Bullet

function Bullet.new(bulletIndex, startingX, startingY, direction, angle)
    local instance = setmetatable({}, Bullet)
    instance.nameIndex = bulletIndex
    instance.lifeSpan = BulletManager.bulletLifeSpan
    instance.lifeSpanTimer = instance.lifeSpan
    instance.sprite = love.graphics.newImage("assets/player/bullet.png")

    instance.speed = BulletManager.bulletSpeed
    instance.x = startingX
    instance.y = startingY
    instance.width = 14
    instance.height = 6
    instance.direction = direction

    instance.angle = angle

    print("Name : " .. bulletIndex)
    print("Direction = " .. instance.direction)

    return instance
end

function Bullet:update(dt)
    self:move(dt)
    self:reduceLifeSpan(dt)
end

function Bullet:reduceLifeSpan(dt)
    self.lifeSpanTimer = self.lifeSpanTimer - dt

    if self.lifeSpanTimer <= 0 then
        --self.speed = 0
        BulletManager:removeBullet(self.nameIndex)
    end
end

function Bullet:move(dt)
    self.x = self.x + math.cos(self.angle) * self.speed * self.direction * dt
    self.y = self.y + math.sin(self.angle) * self.speed * self.direction * dt
end

function Bullet:draw()
    --love.graphics.rectangle("fill", self.x, self.y, self.direction * self.width / 2, self.height / 2)
    love.graphics.draw(self.sprite, self.x - (self.width / 2) * self.direction, self.y - self.height / 2, self.angle,
        self.direction, 1)
end
