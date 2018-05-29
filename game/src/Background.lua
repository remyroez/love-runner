
local class = require 'middleclass'

-- 地面
local Background = class 'Background'

function Background:initialize(image, speed, x, y, w, h, s)
    self.image = image
    self.speed = speed or 100

    self.x = x or 0
    self.y = y or 0

    local dw, dh = love.graphics.getDimensions()
    self.w = w or dw
    self.h = h or dh

    self.scale = s or 1

    self.offset = 0
end

function Background:update(dt)
    -- スクロール処理
    self.offset = self.offset - self.speed * dt

    -- 画像の幅の分までスクロールしたらリセット
    if self.offset < 0 then
        self.offset = self.offset + self.image:getWidth() * self.scale
    end
end

function Background:draw()
    -- 横方向にいっぱいまで描画
    local x = self.x + self.offset - self.image:getWidth() * self.scale
    while x < self.w do
        love.graphics.draw(self.image, x, self.y, 0, self.scale, self.scale)
        x = x + self.image:getWidth() * self.scale
    end
end

return Background
