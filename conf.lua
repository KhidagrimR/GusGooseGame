CONS = {}
CONS.layersName = {}
CONS.layersName.start = "Start"
CONS.scale = 1

function love.conf(t)
    t.title = "Gus goose game"
    t.version = "11.3"
    t.console = true
    t.window.width = 640 * CONS.scale
    t.window.height = 368 * CONS.scale
end
