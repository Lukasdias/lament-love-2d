--[[
    assets.lua
    OS-independent asset loading.

    Path lookups are case-insensitive, so the same code loads the same files
    on case-sensitive systems (Linux) and case-insensitive ones (Windows,
    macOS). Each path segment is matched against the real directory contents;
    if nothing matches, the original path is returned so LÖVE reports the real
    error instead of failing silently.
]]

local assets = {}

-- Resolve `path` to its real, correctly-cased form.
function assets.resolve(path)
    local resolved = ""
    for segment in path:gmatch("[^/]+") do
        local found
        for _, item in ipairs(love.filesystem.getDirectoryItems(resolved)) do
            if item:lower() == segment:lower() then
                found = item
                break
            end
        end
        if not found then return path end
        resolved = (resolved == "") and found or (resolved .. "/" .. found)
    end
    return resolved
end

function assets.image(path)
    return love.graphics.newImage(assets.resolve(path))
end

function assets.source(path, kind)
    return love.audio.newSource(assets.resolve(path), kind or "static")
end

return assets
