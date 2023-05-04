-- module pour utiliser les maps faites sur tiled
local STI = require("sti")
require("player")
require("grid")

--for pixel art
love.graphics.setDefaultFilter("nearest","nearest")


function love.load()
	-- get map
	Map = STI("map/map.lua", {"box2d"})

	background = love.graphics.newImage("assets/background.png")
	loadAll()
end

function loadAll()
	Grid:load()
	Player:load()
end

function love.update(dt)
	Player:update(dt)
end

function love.draw()
	love.graphics.draw(background)
	Map:draw(0, 0, CONS.scale, CONS.scale)
	Player:draw()
end

function love.keypressed(key)
	Player:move(1)
end