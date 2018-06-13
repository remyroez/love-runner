
local class = require 'middleclass'

-- 障害物
local Obstacle = class 'Obstacle'

function Obstacle:initialize(sprite, name, speed, x, y, w, h)
    self.sprite = sprite
    self.name = name or ""
    self.speed = speed or 100

    self.x = x or 0
    self.y = y or 0
    self.w = w or 100
    self.h = h or 100

    self.begin_x = self.x
end

function Obstacle:update(dt)
    self.x = self.x - self.speed * dt

    if self.x < -self.w then
        self.x = self.begin_x
    end
end

function Obstacle:draw()
    local quad = self.sprite.quad[self.name]
    local _, __, w, h = quad:getViewport()
    self.sprite:draw(self.name, self.x - w / 2, self.y - h)
end

function Obstacle:drawCollision()
    -- コリジョンの描画
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle('line', self:left(), self:top(), self:right() - self:left(), self:bottom() - self:top())
end

function Obstacle:left()
    return self.x - self.w / 2
end

function Obstacle:top()
    return self.y - self.h
end

function Obstacle:right()
    return self:left() + self.w
end

function Obstacle:bottom()
    return self:top() + self.h
end

return Obstacle
