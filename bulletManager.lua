
BulletManager = {}

function BulletManager:load()
	self.bulletLifeSpan = 2
    self.bulletSpeed = 1
    self.bullets = {}
    self.index = 1
end

function BulletManager:spawnBullet(direction)
    local dir = 1

    if direction == "left" then dir = 1
    else dir = -1
    end

    self.bullets[self.index] = Bullet.new(self.index, Player.x, Player.y, dir)
    self.index = self.index + 1
end


function BulletManager:update(dt)
	BulletManager:updateBullets(dt)
end

function BulletManager:updateBullets(dt)
    for i = 1, self.bullets.getn(), 1 do
        self.bullets[i].update(dt)
    end
end



function BulletManager:removeBullet(index)

end


function BulletManager:draw()
    -- for each bullet, call bullet draw
end


