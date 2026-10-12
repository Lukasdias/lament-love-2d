--[[
    camera.lua
    Small self-contained 2D camera for LÖVE.

    Replaces the old STALKER-X dependency. Supports translate + zoom and a
    deadzone follow with the same 'PLATFORMER' feel the game used before.

    Usage:
        local cam = require('modules/camera')
        camera = cam()               -- or cam(x, y, w, h, scale)
        camera.scale = 2
        camera:setFollowStyle('PLATFORMER')
        camera:follow(x, y)
        camera:update(dt)
        camera:attach() ... camera:detach()
]]

local Camera = {}
Camera.__index = Camera

local function lerp(a, b, t) return a + (b - a) * t end

local function new(x, y, w, h, scale, rotation)
    w = w or love.graphics.getWidth()
    h = h or love.graphics.getHeight()
    return setmetatable({
        x = x or w / 2, y = y or h / 2,
        w = w, h = h,
        scale = scale or 1,
        rotation = rotation or 0,
        target_x = nil, target_y = nil,
        follow_style = 'PLATFORMER',
        deadzone = nil,
        follow_lerp_x = 1, follow_lerp_y = 1,
        follow_lead_x = 0, follow_lead_y = 0,
        last_target_x = nil, last_target_y = nil,
    }, Camera)
end

function Camera:attach()
    love.graphics.push()
    love.graphics.translate(self.w / 2, self.h / 2)
    love.graphics.scale(self.scale)
    love.graphics.rotate(self.rotation)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:detach()
    love.graphics.pop()
end

function Camera:move(dx, dy)
    self.x, self.y = self.x + dx, self.y + dy
end

function Camera:toWorldCoords(x, y)
    local c, s = math.cos(self.rotation), math.sin(self.rotation)
    x, y = (x - self.w / 2) / self.scale, (y - self.h / 2) / self.scale
    x, y = c * x - s * y, s * x + c * y
    return x + self.x, y + self.y
end

function Camera:toCameraCoords(x, y)
    local c, s = math.cos(self.rotation), math.sin(self.rotation)
    x, y = x - self.x, y - self.y
    x, y = c * x - s * y, s * x + c * y
    return x * self.scale + self.w / 2, y * self.scale + self.h / 2
end

function Camera:getMousePosition()
    return self:toWorldCoords(love.mouse.getPosition())
end

function Camera:follow(x, y)
    self.target_x, self.target_y = x, y
end

function Camera:setDeadzone(x, y, w, h)
    self.deadzone = { x = x, y = y, w = w, h = h }
end

function Camera:setFollowStyle(style)
    self.follow_style = style
end

function Camera:setFollowLerp(x, y)
    self.follow_lerp_x = x
    self.follow_lerp_y = y or x
end

function Camera:setFollowLead(x, y)
    self.follow_lead_x = x
    self.follow_lead_y = y or x
end

-- Pick the deadzone that matches the follow style.
function Camera:applyFollowStyle()
    if self.follow_style == 'LOCKON' then
        local w, h = self.w / 16, self.w / 16
        self:setDeadzone((self.w - w) / 2, (self.h - h) / 2, w, h)
    elseif self.follow_style == 'PLATFORMER' then
        local w, h = self.w / 8, self.h / 3
        self:setDeadzone((self.w - w) / 2, (self.h - h) / 2 - h * 0.25, w, h)
    elseif self.follow_style == 'TOPDOWN' then
        local s = math.max(self.w, self.h) / 4
        self:setDeadzone((self.w - s) / 2, (self.h - s) / 2, s, s)
    elseif self.follow_style == 'TOPDOWN_TIGHT' then
        local s = math.max(self.w, self.h) / 8
        self:setDeadzone((self.w - s) / 2, (self.h - s) / 2, s, s)
    elseif self.follow_style == 'NO_DEADZONE' then
        self.deadzone = nil
    end
end

function Camera:update(dt)
    if not self.target_x and not self.target_y then return end

    self:applyFollowStyle()

    -- No deadzone: track the target directly.
    if not self.deadzone then
        self.x, self.y = self.target_x, self.target_y
        return
    end

    local dz = self.deadzone
    local dx1, dy1 = dz.x, dz.y
    local dx2, dy2 = dz.x + dz.w, dz.y + dz.h

    -- Deadzone lives in screen space, so convert before comparing.
    local tx, ty = self:toCameraCoords(self.target_x, self.target_y)
    local x, y = self:toCameraCoords(self.x, self.y)

    local scroll_x, scroll_y = 0, 0
    if tx < x then
        local d = tx - dx1
        if d < 0 then scroll_x = d end
    end
    if tx > x then
        local d = tx - dx2
        if d > 0 then scroll_x = d end
    end
    if ty < y then
        local d = ty - dy1
        if d < 0 then scroll_y = d end
    end
    if ty > y then
        local d = ty - dy2
        if d > 0 then scroll_y = d end
    end

    -- Lead the camera in the direction the target is moving.
    if not self.last_target_x and not self.last_target_y then
        self.last_target_x, self.last_target_y = self.target_x, self.target_y
    end
    scroll_x = scroll_x + (self.target_x - self.last_target_x) * self.follow_lead_x
    scroll_y = scroll_y + (self.target_y - self.last_target_y) * self.follow_lead_y
    self.last_target_x, self.last_target_y = self.target_x, self.target_y

    self.x = lerp(self.x, self.x + scroll_x, self.follow_lerp_x)
    self.y = lerp(self.y, self.y + scroll_y, self.follow_lerp_y)
end

return setmetatable({ new = new }, { __call = function(_, ...) return new(...) end })
