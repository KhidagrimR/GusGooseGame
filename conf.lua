CONS = {}
CONS.gameWidth = 1280
CONS.gameHeight = 720
CONS.groundPos = 138


function love.conf(t)
    t.title = "Gus goose game"
    t.version = "11.3"
    t.console = true
    t.window.width = CONS.gameWidth
    t.window.height = CONS.gameHeight
end
