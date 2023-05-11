--for pixel art
require("bulletManager")
require("player")
require("bullet")

love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
	background = love.graphics.newImage("assets/background.png")

	Player:load()
	BulletManager:load()

	print("ALL Manager Loaded")
end

function love.update(dt)
	Player:update(dt)
	BulletManager:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(4, 4)

	love.graphics.draw(background)
	Player:draw()
	BulletManager:draw()

	love.graphics.pop()
end

function love.keypressed(key)
	print("-- Key Pressed --")

	if (key == "q" or key == "left") then
		Player:shootLeft()
	elseif (key == "d" or key == "right") then
		Player:shootRight()
	end
end
