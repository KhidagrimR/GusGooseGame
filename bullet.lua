-- HERE WE MAKE A CLASS
Bullet = {}
Bullet.__index = Bullet

function Bullet.new(index, startingX, startingY, direction)
    local instance = setmetatable({}, Bullet)
    instance.nameIndex = index
    instance.lifeSpan = BulletManager.bulletLifeSpan
    instance.lifeSpanTimer = instance.lifeSpan
    instance.sprite = love.graphics.newImage("assets/player/bullet.png")

    instance.speed = BulletManager.bulletSpeed
    instance.x = startingX
    instance.y = startingY
    instance.direction = direction

    return instance
end

function Bullet:update(dt)
    self.x = self.x + self.speed * self.direction * dt
end

function Bullet:reduceLifeSpan(dt)
    self.lifeSpanTimer = self.lifeSpanTimer - dt

    if self.lifeSpanTimer <= 0 then
        BulletManager:removeBullet(self.nameIndex)        
    end
end
--animal1 = Animal.new("doge")
