local assets = require("modules/assets")

function soundLoad()
    main_theme = assets.source("OST/Main_Theme.mp3")
    menu_theme = assets.source("OST/Menu_Theme.mp3")
    death_theme = assets.source("OST/Death_Theme.mp3")
    win_theme = assets.source("OST/Win_theme.mp3")
end

function soundUpdate(dt)
    if gamestate == "menu" then
        menu_theme:play()
    elseif gamestate == "play" then
        love.audio.stop(win_theme)
        death_theme:stop()
        menu_theme:stop()
        main_theme:play()
    elseif gamestate == "death" then
        main_theme:stop()
        death_theme:play()
    elseif gamestate == "end" then 
        main_theme:stop()
        win_theme:play()
    end
end


