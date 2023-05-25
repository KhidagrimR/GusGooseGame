EnemyManager = {}

function EnemyManager:load()
    --self.bulletLifeSpan = 2
    self.spawnTimer = 0
    self.spawnTimerCooldown = 10

    self.enemies = {}
    self.enemyIndex = 1

    self.spawnPoint = {}
    self.spawnPoint.point1X = 10
    self.spawnPoint.point2X = 280

    print("Enemy Manager Loaded")
end

function EnemyManager:update(dt)
    self:reduceSpawnCoolDown(dt)
    self:handleEnemies(dt)
end

function EnemyManager:handleEnemies(dt)
    -- for each enemy, call enemy draw
    for i = 1, #self.enemies, 1 do -- #self.bullets = table.length
        if self.enemies[i] ~= nil then
            self.enemies[i]:update(dt)
        end
    end
end

function EnemyManager:reduceSpawnCoolDown(dt)
    if self.spawnTimer > 0 then
        self.spawnTimer = self.spawnTimer - dt
    else
        self.spawnTimer = self.spawnTimerCooldown 
        self:spawnEnemy()-- A DE-COMMENTER
    end
end

function EnemyManager:spawnEnemy()
    print("Spawn Enemy : "..self.enemyIndex)
    local enemyArrayIndex = EnemyManager:getNextEnemyArrayIndex()

    -- set enemy on random spawn point
    local randomX = 0
    local direction
    if love.math.random(1,100) >= 50 then
        randomX = self.spawnPoint.point1X
        direction = 1
    else
        randomX = self.spawnPoint.point2X
        direction = -1
    end

    self.enemies[enemyArrayIndex] = Enemy.new(self.enemyIndex, randomX, CONS.groundPos - 50, direction)
    self.enemyIndex = self.enemyIndex + 1
end

function EnemyManager:getNextEnemyArrayIndex()
    local index = 1
    while self.enemies[index] ~= nil do
        index = index + 1
    end

    return index
end

function EnemyManager:removeEnemy(p_enemyNameIndex)
    print("enemy removed : "..p_enemyNameIndex)
    local enemyToRemoveIndex = nil
    for i = 1, #self.enemies, 1 do
        if self.enemies[i] ~= nil then
            if self.enemies[i].nameIndex == p_enemyNameIndex then
                enemyToRemoveIndex = i
                break;
            end
        end
    end

    if self.enemies[enemyToRemoveIndex] ~= nil then
        self.enemies[enemyToRemoveIndex] = nil
    end
    
    print("amount of enemies in table : "..#self.enemies)
end

function EnemyManager:draw()
    -- for each enemy, call enemy draw
    for i = 1, #self.enemies, 1 do -- #self.bullets = table.length
        if self.enemies[i] ~= nil then
            self.enemies[i]:draw()
        end
    end
end
