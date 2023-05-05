--for pixel art
require("bullet")
require("bulletManager")
require("player")


love.graphics.setDefaultFilter("nearest", "nearest")


function love.load()
	background = love.graphics.newImage("assets/background.png")
	loadAll()
end

function loadAll()
	Player:load()
end

function love.update(dt)
	Player:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(4, 4)

	love.graphics.draw(background)
	Player:draw()

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
