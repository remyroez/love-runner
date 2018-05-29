
local class = require 'middleclass'
local stateful = require 'stateful'

-- プレイヤー
local Player = class 'Player'
Player:include(stateful)

function Player:initialize(sprite, x, y)
    self.sprite = sprite
    self.x = x or 0
    self.y = y or 0
end

function Player:update(dt)
end

function Player:draw()
    self:drawSprite('alienGreen_front.png', self.x, self.y)
end

function Player:drawSprite(name, x, y)
    local quad = self.sprite.quad[name]
    local _, __, w, h = quad:getViewport()
    self.sprite:draw(name, x - w / 2, y - h)
end

function Player:keypressed(...)
end

function Player:mousepressed(...)
end

-- プレイヤー：走る
local Run = Player:addState 'run'

local names = {
    'alienGreen_walk1.png',
    'alienGreen_walk2.png',
}

local duration = 0.1

function Run:enteredState()
    self.index = 1
    self.time = duration
end

function Run:update(dt)
    -- タイマーを減らす
    self.time = self.time - dt
    if self.time < 0 then
        -- ０未満になったらリセット
        self.time = self.time + duration

        -- インデックスをインクリメント
        self.index = self.index + 1

        -- インデックスをループ
        if self.index > #names then
            self.index = 1
        end
    end
end

function Run:draw()
    -- 走るアニメーションの描画
    self:drawSprite(names[self.index], self.x, self.y)
end

function Run:keypressed(...)
    -- 何かキーを押したらジャンプ
    self:gotoState 'jump'
end

function Run:mousepressed(...)
    -- 何かクリックしたらジャンプ
    self:gotoState 'jump'
end

-- プレイヤー：ジャンプ
local Jump = Player:addState 'jump'

local gravity = 3000

function Jump:enteredState()
    self.offset = 0
    self.power = 1000
end

function Jump:update(dt)
    -- Ｙ座標オフセットの計算
    self.offset = self.offset + self.power * dt
    self.power = self.power - gravity * dt
    
    -- オフセット位置が０未満になったら走る
    if self.offset < 0 then
        self:gotoState 'run'
    end
end

function Jump:draw()
    -- ジャンプアニメーションをオフセット位置に描画
    self:drawSprite('alienGreen_jump.png', self.x, self.y - self.offset)
end

return Player
