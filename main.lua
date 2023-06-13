--for pixel art
require("bulletManager")
require("bullet")
require("enemyManager")
require("enemy")
require("player")
require("UIManager")

love.graphics.setDefaultFilter("nearest", "nearest")

Timers = {}
Timers.collisionTimer = 0
Timers.collisionTimerCooldown = 0.1

function love.load()
	background = love.graphics.newImage("assets/background.png")

	music = love.audio.newSource("assets/musics/music1.mp3", "stream") -- the "stream" tells LÖVE to stream the file from disk, good for longer music tracks

	music:play()
	music:setVolume(0.1)

	Player:load()
	BulletManager:load()
	EnemyManager:load()
	UIManager:load()

	print("ALL Manager Loaded")
end

function love.update(dt)
	Player:update(dt)
	BulletManager:update(dt)
	EnemyManager:update(dt)
	shakeScreenUpdate(dt)
	UIManager:update(dt)


	collisionTimer(dt)
end

function collisionTimer(dt)
	if Timers.collisionTimer <= 0 then
		checkAllCollisions()
		Timers.collisionTimer = Timers.collisionTimerCooldown
	else
		Timers.collisionTimer = Timers.collisionTimer - dt
	end
end

function love.draw()
	shakeScreenDraw()

	love.graphics.push()
	love.graphics.scale(4, 4)

	love.graphics.draw(background)
	Player:draw()
	BulletManager:draw()
	EnemyManager:draw()

	love.graphics.pop()
	UIManager:draw()
end

function love.keypressed(key)
	print("-- Key Pressed --")

	if (key == "q" or key == "left") then
		Player:shootLeft()
	elseif (key == "d" or key == "right") then
		Player:shootRight()
	end
end

function checkCollision(a, b)
	if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
		return true
	else
		return false
	end
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 and UIManager.gameState == "end" then -- Versions prior to 0.10.0 use the MouseConstant 'l'
		music:stop()
		love.load()
	end

	if button == 1 and UIManager.playerScore >= UIManager.buttonValues.cost[UIManager.buttonValues.costIndex] then -- and UIManager.gameState == "end"
		UIManager.playerScore = UIManager.playerScore - UIManager.buttonValues.cost[UIManager.buttonValues.costIndex]
		UIManager.button:checkPressed(x, y, 5)                                                                  -- last param is mouse radius
		UIManager.shopSound:play()
		UIManager.button = UIManager:getRandomButton()
	end
end

function checkAllCollisions()
	for i = 1, #EnemyManager.enemies, 1 do
		if EnemyManager.enemies[i] ~= nil then
			-- Check collision with bullets
			for j = 1, #BulletManager.bullets, 1 do
				if BulletManager.bullets[j] ~= nil then
					if checkCollision(EnemyManager.enemies[i], BulletManager.bullets[j]) then
						EnemyManager.enemies[i]:loseLife(1)
						BulletManager.bullets[j].lifeSpanTimer = 0
					end
				end
			end

			-- check collision with player
			if checkCollision(EnemyManager.enemies[i], Player) then
				Player:getHit()
				EnemyManager.enemies[i]:loseLife(1000)
			end
		end
	end
end

-- ======================== SHAKE THE SCREEN ====================================== --
local t, shakeDuration, shakeMagnitude = 0, -1, 0
function startShake(duration, magnitude)
	t, shakeDuration, shakeMagnitude = 0, duration or 1, magnitude or 5
end

function shakeScreenUpdate(dt)
	if t < shakeDuration then
		t = t + dt
	end
end

function shakeScreenDraw()
	if t < shakeDuration then
		local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
		local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
		love.graphics.translate(dx, dy)
	end
end
