local button = require("button")


UIManager = {}

function UIManager:load()
    self.imageDeath1 = love.graphics.newImage("assets/ui/deathText.png")
    self.imageWin1 = love.graphics.newImage("assets/ui/winText.png")
    self.imageDeath2 = love.graphics.newImage("assets/ui/deathText2.png")

    self.playerWin = false

    self.buttonValues = {}
    self.buttonValues.atkSpeed = {
        text = "Attack Speed",
        index = 1,
        value = { 15, 20, 35, 50, 75 },
        spritePath = "assets/ui/panels/btn_atkSpeed.png"
    } -- %
    self.buttonValues.bulletAmount = {
        text = "More bullets",
        index = 1,
        value = { 1, 1, 1, 1, 1 },
        spritePath = "assets/ui/panels/btn_bulletAmount.png"
    } -- add flat
    self.buttonValues.projectileSpeed = {
        text = "Bullet speed",
        index = 1,
        value = { 10, 15, 20, 25, 30 },
        spritePath = "assets/ui/panels/btn_bulletspeed.png"
    } -- in %
    self.buttonValues.playerHealth = {
        text = "More HEaLTh",
        index = 1,
        value = { 1, 2, 2, 3, 3 },
        spritePath = "assets/ui/panels/btn_heal.png"
    }                                                                                               -- add flat
    self.buttonValues.costIndex = 1
    self.buttonValues.cost = { 5, 8, 10, 15, 20, 25, 32, 48, 64, 96, 128, 256, 512, 768, 1024 }  -- player pay with it s score
    --self.buttonValues.cost = { 2, 2, 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,22,2,2,2,2,2 } -- player pay with it s score

    self.button = self:getRandomButton()
    self.playerFinalScore = 0

    self.gameState = "play"
    self.playerScore = 0
    self.font = love.graphics.newImageFont("assets/ui/font.png",
        " abcdefghijklmnopqrstuvwxyz" ..
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
        "123456789.,!?-+/():;%&`'*#=[]\"")

    love.graphics.setFont(self.font)

    self.shopSound = love.audio.newSource("assets/musics/cash.mp3", "static") -- the "static" tells LÖVE to load the file into memory, good for short sound effects
    self.shopSound:setVolume(0.75)
end

-- ############################## UPGRADE PLAYER ###################################
function UIManager:getRandomButton()
    local rnd = math.random(1, 4)

    local test = {}
    if self.buttonValues.playerHealth.index < #self.buttonValues.playerHealth.value then
        test[1] = 1
    end
    if self.buttonValues.bulletAmount.index < #self.buttonValues.bulletAmount.value then
        test[2] = 2
    end
    if self.buttonValues.playerHealth.index < #self.buttonValues.playerHealth.value then
        test[3] = 3
    end
    if self.buttonValues.playerHealth.index < #self.buttonValues.playerHealth.value then
        test[4] = 4
    end

    rnd = math.random(1, #test)
    rnd = test[rnd]

    if rnd == 1 then -- HP BUTTON
        return button(
            self.buttonValues.playerHealth.text,
            "Cost : " .. self.buttonValues.cost[self.buttonValues.costIndex],
            function() self:healPlayerButton() end,
            nil,
            300,
            100,
            self.buttonValues.playerHealth.spritePath
        )
    elseif rnd == 2 then --BULLET AMOUNT
        return button(
            self.buttonValues.bulletAmount.text,
            "Cost : " .. self.buttonValues.cost[self.buttonValues.costIndex],
            function() self:increaseBulletAmount() end,
            nil,
            300,
            100,
            self.buttonValues.bulletAmount.spritePath
        )
    elseif rnd == 3 then --BULLET SPEED
        return button(
            self.buttonValues.projectileSpeed.text,
            "Cost : " .. self.buttonValues.cost[self.buttonValues.costIndex],
            function() self:increaseBulletSpeed() end,
            nil,
            300,
            100,
            self.buttonValues.projectileSpeed.spritePath
        )
    elseif rnd == 4 then --ATK AMOUNT
        return button(
            self.buttonValues.atkSpeed.text,
            "Cost : " .. self.buttonValues.cost[self.buttonValues.costIndex],
            function() self:increaseAttackSpeed() end,
            nil,
            300,
            100,
            self.buttonValues.atkSpeed.spritePath
        )
    end
end

function UIManager:healPlayerButton()
    Player.hp = Player.hp + self.buttonValues.playerHealth.value[self.buttonValues.playerHealth.index]
    self.buttonValues.playerHealth.index = self.buttonValues.playerHealth.index + 1
    self.buttonValues.costIndex = self.buttonValues.costIndex + 1
end

function UIManager:increaseBulletAmount()
    Player.weapon.amountOfBulletPerShot = Player.weapon.amountOfBulletPerShot +
        self.buttonValues.bulletAmount.value[self.buttonValues.bulletAmount.index]
    self.buttonValues.bulletAmount.index = self.buttonValues.bulletAmount.index + 1
    self.buttonValues.costIndex = self.buttonValues.costIndex + 1
end

function UIManager:increaseBulletSpeed()
    BulletManager.bulletSpeed = BulletManager.bulletStartingSpeed +
        (BulletManager.bulletStartingSpeed * self.buttonValues.projectileSpeed.value[self.buttonValues.projectileSpeed.index] / 100)
    self.buttonValues.projectileSpeed.index = self.buttonValues.projectileSpeed.index + 1
    self.buttonValues.costIndex = self.buttonValues.costIndex + 1
end

function UIManager:increaseAttackSpeed()
    Player.weapon.coolDownDuration = Player.weapon.startingCoolDownDuration -
    (Player.weapon.startingCoolDownDuration * self.buttonValues.atkSpeed.value[self.buttonValues.atkSpeed.index]) / 100
    self.buttonValues.atkSpeed.index = self.buttonValues.atkSpeed.index + 1
    self.buttonValues.costIndex = self.buttonValues.costIndex + 1
end

-- ############################## END UPGRADE PLAYER ###################################

function UIManager:endGame(win) -- 0 = loose, 1 = win
    print(win)
    if self.gameState == "end" then
        return
    else
        self.playerWin = win

        self.gameState = "end"
        self.playerFinalScore = math.floor(self.playerScore) .. ""
    end
    if self.playerWin == true then
       print("YOU WON")
    else
        print("YOU LOOSE")
    end
end

function UIManager:update(dt)
    self.playerScore = self.playerScore + dt
    if self.playerScore >= 100 and EnemyManager.hasSpawnedBoss == false then
        -- Make EnemyManager Spawn the boss
        EnemyManager:spawnBoss()

        -- add ui for boss warning : Warning + boss life bar
    end
end

function UIManager:draw()
    if self.gameState ~= "end" then
        love.graphics.setColor(UIManager:getColor())
        love.graphics.print("Score = " .. math.floor(self.playerScore), 10, 65, 0, 4, 4)
        love.graphics.setColor({ 1, 1, 1, 1 })
        love.graphics.print("HP = " .. Player.hp, 10, 10, 0, 4, 4)
    end

    if self.gameState == "end" then
        if self.playerWin == true then
            love.graphics.draw(self.imageWin1, 250, 250)
        else
            love.graphics.draw(self.imageDeath1, 250, 250)
        end

        love.graphics.draw(self.imageDeath2, 250, 320)

        love.graphics.setColor(UIManager:getColor())
        love.graphics.print("Score = " .. self.playerFinalScore, 250, 380, 0, 4, 4)
        love.graphics.setColor({ 1, 1, 1, 1 })
    end

    if self.button then
        self.button:draw(550, 600, 10, 20, 10, 50)
    end
end

function UIManager:getColor()
    if self.playerScore <= 10 then
        return { 1, 1, 1, 1 }
    elseif self.playerScore <= 20 then
        return { 0.1, 1, 0, 1 } -- green
    elseif self.playerScore <= 50 then
        return { 0, 0.4, 0.85, 1 }
    elseif self.playerScore <= 80 then
        return { 0.3, 0.12, 0.55, 1 }
    elseif self.playerScore <= 100 then
        return { 1, 0.5, 0, 1 }
    else
        return { math.random(0, 1), math.random(0, 1), math.random(0, 1), 1 }
    end
end
