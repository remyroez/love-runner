
local class = require 'middleclass'

-- 地面
local Ground = class 'Ground'

Ground.static.names =  {
    top = 'sandMid.png',
    center = 'sandCenter.png'
}

function Ground:initialize(sprite, speed, y, w, h)
    self.sprite = sprite
    self.speed = speed or 100
    self.x = 0
    self.y = y or 0

    local dw, dh = love.graphics.getDimensions()
    self.w = w or dw
    self.h = h or dh

    self.top = self.sprite.quad[Ground.names.top]
    self.center = self.sprite.quad[Ground.names.center]

    local _, __, width, height = self.top:getViewport()
    self.width = width
    self.height = height
    self.offset = 0
end

function Ground:update(dt)
    -- スクロール処理
    self.offset = self.offset - self.speed * dt

    -- スプライトの幅の分までスクロールしたらリセット
    if self.offset < 0 then
        self.offset = self.offset + self.width
    end
end

function Ground:draw()
    -- 横方向にいっぱいまで描画
    local x = self.x + self.offset - self.width
    while x < self.w do
        self:drawTop(x, self.y)

        -- 縦方向に画面いっぱいまで描画
        local y = self.y + self.height
        while y < self.h do
            self:drawCenter(x, y)
            y = y + self.height
        end

        x = x + self.width
    end
end

function Ground:drawTop(x, y)
    -- 地表を描画
    self.sprite:draw(Ground.names.top, x, y)
end

function Ground:drawCenter(x, y)
    -- 地下を描画
    self.sprite:draw(Ground.names.center, x, y)
end

return Ground
