
local class = require 'middleclass'
local stateful = require 'stateful'

local lg = love.graphics

-- シーン
local Scene = class 'Scene'
Scene:include(stateful)

function Scene:initialize(player, obstacle, ground, background, sounds)
    self.player = player
    self.obstacle = obstacle
    self.ground = ground
    self.background = background
    self.sounds = sounds

    local width, height = lg.getDimensions()
    self.width = width
    self.height = height
    self.font64 = lg.newFont('assets/Kenney Bold.ttf', 64)
    self.font16 = lg.newFont('assets/Kenney Bold.ttf', 16)
end

function Scene:update(dt)
end

function Scene:draw()
end

function Scene:keypressed(key, scancode, isrepeat)
end

function Scene:mousepressed(x, y, button, istouch, presses)
end

-- シーン: タイトル
local Title = Scene:addState 'title'

function Title:enteredState()
    self.background:reset()
    self.ground:reset()
    self.obstacle:reset()
    self.player:reset()
end

function Title:update(dt)
    self.background:update(dt)
    self.ground:update(dt)
    --self.obstacle:update(dt)
    self.player:update(dt)
end

function Title:draw()
    self.background:draw()
    self.ground:draw()
    --self.obstacle:draw()
    self.player:draw()

    -- 画面を暗くする
    lg.setColor(0, 0, 0, 0.75)
    lg.rectangle("fill", 0, 0, self.width, self.height )

    -- タイトル描画
    lg.setColor(love.math.random(), love.math.random(), love.math.random())
    lg.printf("ALIEN RUNNER", self.font64, 0, self.height * 0.3, self.width, 'center')

    -- キー入力待ち描画
    lg.setColor(1.0, 0, 0.25)
    lg.printf("PRESS ANY KEY", self.font16, 0, self.height * 0.6, self.width, 'center')
end

function Title:keypressed(key, scancode, isrepeat)
    self:gotoState 'game'
    self.sounds.start:play()
end

function Title:mousepressed(x, y, button, istouch, presses)
    self:gotoState 'game'
    self.sounds.start:play()
end

-- シーン: ゲーム
local Game = Scene:addState 'game'

-- 衝突判定
local function isHit(a, b)
    return (a:right() > b:left()) and (a:bottom() > b:top()) and (a:left() < b:right()) and (a:top() < b:bottom())
end

-- 得点判定
local function isScored(player, obstacle)
    local scored = false
    if obstacle.scored then
        -- 得点済み
    elseif obstacle:right() < player:left() then
        -- ジャンプで越えた
        scored = true
    end
    return scored
end

function Game:enteredState()
    self.background:reset()
    self.ground:reset()
    self.obstacle:reset()
    self.player:reset()

    self.draw_collision = false
    self.score = 0

    -- ＢＧＭ再生
    self.sounds.bgm:play()
end

function Game:update(dt)
    self.background:update(dt)
    self.ground:update(dt)
    self.obstacle:update(dt)
    self.player:update(dt)

    if isHit(self.player, self.obstacle) then
        -- 衝突したらゲームオーバー
        self.player:gotoState 'die'
        self:gotoState 'gameover'

    elseif isScored(self.player, self.obstacle) then
        -- 得点処理
        self.score = self.score + self.obstacle:score()

        -- 得点ＳＥ
        self.sounds.score:play()
    end
end

function Game:draw()
    self.background:draw()
    self.ground:draw()
    self.obstacle:draw()
    self.player:draw()

    -- 当たり判定描画
    if self.draw_collision then
        self.obstacle:drawCollision()
        self.player:drawCollision()
    end

    -- 得点描画
    lg.setColor(0, 0, 0)
    lg.printf(self.score, self.font64, 0, self.height * 0.1, self.width, 'center')
end

function Game:keypressed(key, scancode, isrepeat)
    if key == 'f1' then
        draw_collision = not draw_collision
    else
        self.player:keypressed()
    end
end

function Game:mousepressed(x, y, button, istouch, presses)
    self.player:mousepressed()
end

-- シーン: ゲームオーバー
local GameOver = Scene:addState 'gameover'

function GameOver:enteredState()
    -- ベスト得点の更新
    self.best = self.best or self.score
    if self.score > self.best then
        self.best = self.score
    end
    
    -- ＢＧＭ停止
    self.sounds.bgm:stop()

    -- ゲームオーバーＳＥ
    self.sounds.gameover:play()
end

function GameOver:update(dt)
end

function GameOver:draw()
    self.background:draw()
    self.ground:draw()
    self.obstacle:draw()
    self.player:draw()
    
    -- ゲームオーバー描画
    lg.setColor(1.0, 0, 0)
    lg.printf("GAME OVER", self.font64, 0, self.height * 0.125, self.width, 'center')
    
    -- 得点描画
    lg.setColor(0, 0, 0)
    lg.printf("SCORE", self.font16, 0, self.height * 0.325, self.width, 'center')
    lg.printf(self.score, self.font64, 0, self.height * 0.375, self.width, 'center')

    -- ベスト得点描画
    lg.printf("BEST", self.font16, 0, self.height * 0.55, self.width, 'center')
    lg.printf(self.best, self.font64, 0, self.height * 0.6, self.width, 'center')
    
    -- キー入力待ち描画
    lg.setColor(1.0, 0, 0.25)
    lg.printf("PRESS ANY KEY TO RETRY", self.font16, 0, self.height * 0.8, self.width, 'center')
end

function GameOver:keypressed(key, scancode, isrepeat)
    self:gotoState 'game'
    self.sounds.start:play()
end

function GameOver:mousepressed(x, y, button, istouch, presses)
    self:gotoState 'game'
    self.sounds.start:play()
end

return Scene
