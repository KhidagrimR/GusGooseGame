EnemyManager = {}

function EnemyManager:load()
    --self.bulletLifeSpan = 2
    self.spawnTimer = 0
    self.startingSpawnTimerCooldown = 2
    self.spawnTimerCooldown = self.startingSpawnTimerCooldown
    self.name = "EnemyManager"

    self.difficultyTimer = 0
    self.difficultyTimerCooldown = 8
    self.difficultyPercentIncrease = 10 -- in %

    self.enemies = {}
    self.enemyIndex = 1

    self.spawnPoint = {}
    self.spawnPoint.point1X = 10
    self.spawnPoint.point2X = 280

    self.hasSpawnedBoss = false


    self.sound = love.audio.newSource("assets/musics/SlimeDeath.mp3", "static") -- the "static" tells LÖVE to load the file into memory, good for short sound effects
    self.sound:setVolume(0.1)

    --self:spawnBoss()
    print("Enemy Manager Loaded")
end

function EnemyManager:update(dt)
    self:reduceSpawnCoolDown(dt)
    self:handleEnemies(dt)
    self:increaseDifficultyCooldown(dt)
end

function EnemyManager:handleEnemies(dt)
    -- for each enemy, call enemy draw
    for i = 1, #self.enemies, 1 do -- #self.bullets = table.length
        if self.enemies[i] ~= nil then
            self.enemies[i]:update(dt)
        end
    end
end

function EnemyManager:increaseDifficultyCooldown(dt)
    if self.difficultyTimer > 0 then
        self.difficultyTimer = self.difficultyTimer - dt
    else
        self.difficultyTimer = self.difficultyTimerCooldown
        self:increaseDifficulty() 
    end
end

function EnemyManager:increaseDifficulty()
    -- Reduce enemy spawn cooldown by X%
    self.spawnTimerCooldown = self.spawnTimerCooldown - (self.spawnTimerCooldown * self.difficultyPercentIncrease) / 100
end

function EnemyManager:reduceSpawnCoolDown(dt)
    if self.spawnTimer > 0 then
        self.spawnTimer = self.spawnTimer - dt
    else
        self.spawnTimer = self.spawnTimerCooldown
        self:spawnEnemy() 
    end
end

function EnemyManager:spawnEnemy()
    print("Spawn Enemy : " .. self.enemyIndex)
    local enemyArrayIndex = EnemyManager:getNextEnemyArrayIndex()

    -- set enemy on random spawn point
    local randomX = 0
    local direction
    if love.math.random(1, 100) >= 50 then
        randomX = self.spawnPoint.point1X
        direction = 1
    else
        randomX = self.spawnPoint.point2X
        direction = -1
    end

    self.enemies[enemyArrayIndex] = self:createRandomEnemy(randomX, direction)--Enemy.new(self.enemyIndex, randomX, CONS.groundPos - 50, direction, "Pink", "pinky", 2, 70, -150, 1,1)
    self.enemyIndex = self.enemyIndex + 1
end

function EnemyManager:createRandomEnemy(randomX, direction)
    local difficulty = math.floor(UIManager.playerScore/10)--  = modulo

    local rnd = math.random(1,math.min(difficulty, 3))
    print ("######### RND = "..rnd.. " AND difficulty = "..difficulty.."; player score = "..UIManager.playerScore)

    if rnd <= 1 then
        return Enemy.new(self.enemyIndex, randomX, CONS.groundPos - 50, direction, "Green","greeSlime" , 2, 50, -200, 3, 6)
    elseif rnd == 2 then
        return Enemy.new(self.enemyIndex, randomX, CONS.groundPos - 50, direction, "Yellow","sandSlime", 4, 20, -250, 5,6)
    else
        return Enemy.new(self.enemyIndex, randomX, CONS.groundPos - 50, direction, "Pink", "pinky", 2, 70, -150, 1,1)
    end
end

function EnemyManager:getNextEnemyArrayIndex()
    local index = 1
    while self.enemies[index] ~= nil do
        index = index + 1
    end

    return index
end

function EnemyManager:removeEnemy(p_enemyNameIndex)
    print("enemy removed : " .. p_enemyNameIndex)
    self.sound:stop()
    self.sound:play()
    UIManager.playerScore = UIManager.playerScore +1
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
        --self.enemies[enemyToRemoveIndex] = nil
        table.remove(self.enemies, enemyToRemoveIndex)
    end

    print("amount of enemies in table : " .. #self.enemies)
end

function EnemyManager:spawnBoss()
    self.hasSpawnedBoss = true

    print("Spawn BOSS : " .. self.enemyIndex)
    local enemyArrayIndex = EnemyManager:getNextEnemyArrayIndex()

    -- set enemy on random spawn point
    local randomX = 0
    local direction
    if love.math.random(1, 100) >= 50 then
        randomX = self.spawnPoint.point1X
        direction = 1
    else
        randomX = self.spawnPoint.point2X
        direction = -1
    end

    self.enemies[enemyArrayIndex] = Enemy.new(self.enemyIndex, randomX, CONS.groundPos - 50, direction, "boss", "boss", 100, 10, -350, 4,5, function() UIManager:endGame(true) end)
    self.enemies[enemyArrayIndex].groundOffset = -22
    self.enemies[enemyArrayIndex].height = 40
    self.enemies[enemyArrayIndex].width = 40
    self.enemies[enemyArrayIndex].damages = 100
    self.enemies[enemyArrayIndex].onHit = function(self) 
        local enemy = self  
        enemy:goBack()
    end --EnemyManager.enemies[enemyArrayIndex]:goBack()

    self.enemyIndex = self.enemyIndex + 1

end

function EnemyManager:draw()
    -- for each enemy, call enemy draw
    for i = 1, #self.enemies, 1 do -- #self.bullets = table.length
        if self.enemies[i] ~= nil then
            self.enemies[i]:draw()
        end
    end
end
