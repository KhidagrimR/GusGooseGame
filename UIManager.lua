local button = require("button")


UIManager = {}

function UIManager:load()
    self.imageDeath1 = love.graphics.newImage("assets/ui/deathText.png")
    self.imageDeath2 = love.graphics.newImage("assets/ui/deathText2.png")

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
    }                                                                                           -- add flat
    self.buttonValues.costIndex = 1
    self.buttonValues.cost = { 5, 8, 10, 15, 20, 25, 32, 48, 64, 96, 128, 256, 512, 768, 1024 } -- player pay with it s score

    self.button = self:getRandomButton()

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
        (Player.weapon.startingCoolDownDuration * self.buttonValues.atkSpeed.value[self.buttonValues.atkSpeed.index]) /
        100
    self.buttonValues.atkSpeed.index = self.buttonValues.atkSpeed.index + 1
    self.buttonValues.costIndex = self.buttonValues.costIndex + 1
end

-- ############################## END UPGRADE PLAYER ###################################

function UIManager:endGame()
    self.gameState = "end"
end

function UIManager:update(dt)
    self.playerScore = self.playerScore + dt
end

function UIManager:draw()
    love.graphics.setColor(UIManager:getColor())
    love.graphics.print("Money = " .. math.floor(self.playerScore), 10, 65, 0, 4, 4)
    love.graphics.setColor({ 1, 1, 1, 1 })
    love.graphics.print("HP = " .. Player.hp, 10, 10, 0, 4, 4)

    if self.gameState == "end" then
        love.graphics.draw(self.imageDeath1, 250, 250)
        love.graphics.draw(self.imageDeath2, 250, 320)
    end

    self.button:draw(550, 600, 10, 20, 10, 50)
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
