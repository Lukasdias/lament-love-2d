function love.conf(t)
    -- Save/identity directory
    t.identity = "lament-of-laurence"
    t.version = "11.5"
    t.console = false

    -- Window
    t.window.title = "The Lament of Laurence"
    t.window.width = 770
    t.window.height = 580
    t.window.vsync = 1
    t.window.msaa = 0
    t.window.resizable = false
    t.window.highdpi = true
    t.window.icon = "imagens/Menu/gameTitle.png"

    -- Modules
    t.modules.physics = true
    t.modules.joystick = false
    t.modules.touch = false
    t.modules.video = false
end
