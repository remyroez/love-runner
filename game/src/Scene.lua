
local class = require 'middleclass'
local stateful = require 'stateful'

-- 主要なエンティティクラス
local Player = require 'Player'
local Ground = require 'Ground'
local Background = require 'Background'
local Obstacle = require 'Obstacle'

-- 各モジュールのエイリアス
local lg = love.graphics
local la = love.audio

-- シーン
local Scene = class 'Scene'
Scene:include(stateful)

-- シーン: 初期化
function Scene:initialize()
    -- スクリーンサイズ
    local width, height = lg.getDimensions()
    self.width = width
    self.height = height

    -- 当たり判定描画フラグ
    self.draw_collision = false
end

-- シーン: 読み込み
function Scene:load()
    -- サウンドの読み込み
    self.sounds = {
        bgm = la.newSource('assets/Retro Comedy.ogg', 'stream'),
        start = la.newSource('assets/coin2.ogg', 'static'),
        score = la.newSource('assets/coin5.ogg', 'static'),
        jump = la.newSource('assets/jump3.ogg', 'static'),
        gameover = la.newSource('assets/gameover3.ogg', 'static')
    }
    self.sounds.bgm:setLooping(true)

    -- フォントの読み込み
    self.font64 = lg.newFont('assets/Kenney Bold.ttf', 64)
    self.font16 = lg.newFont('assets/Kenney Bold.ttf', 16)

    -- スプライトの読み込み
    local sprite = sbss:new('assets/sprites.xml')

    -- プレイヤー
    self.player = Player(sprite, self.width * 0.2, self.height * 0.8, 50, 50, self.sounds)
    self.player:gotoState 'run'

    -- 地面
    self.ground = Ground(sprite, 500, self.player.y, self.width, self.height)

    -- 背景
    local image = lg.newImage('assets/blue_desert.png')
    self.background = Background(image, 100, 0, 0, self.width, self.height, self.height / image:getHeight())

    -- 障害物
    self.obstacle = Obstacle(sprite, 'cactus.png', 500, self.width + 100, self.height * 0.8, 50, 80)
    
    -- タイトルへ
    self:gotoState 'title'
end

-- シーン: 更新
function Scene:update(dt)
end

-- シーン: 描画
function Scene:draw()
end

-- シーン: キー入力
function Scene:keypressed(key, scancode, isrepeat)
end

-- シーン: マウス入力
function Scene:mousepressed(x, y, button, istouch, presses)
end

-- タイトル
local Title = Scene:addState 'title'

-- タイトル: 開始処理
function Title:enteredState()
    -- リセット
    self.background:reset()
    self.ground:reset()
    self.obstacle:reset()
    self.player:reset()
end

-- タイトル: 更新
function Title:update(dt)
    -- 更新
    self.background:update(dt)
    self.ground:update(dt)
    --self.obstacle:update(dt)
    self.player:update(dt)
end

-- タイトル: 描画
function Title:draw()
    --描画
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

-- タイトル: キー入力
function Title:keypressed(key, scancode, isrepeat)
    -- ゲームへ
    self:gotoState 'game'
    self.sounds.start:play()
end

-- タイトル: マウス入力
function Title:mousepressed(x, y, button, istouch, presses)
    -- ゲームへ
    self:gotoState 'game'
    self.sounds.start:play()
end

-- ゲーム
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

-- ゲーム: 開始処理
function Game:enteredState()
    -- リセット
    self.background:reset()
    self.ground:reset()
    self.obstacle:reset()
    self.player:reset()

    -- 得点
    self.score = 0

    -- ＢＧＭ再生
    self.sounds.bgm:play()
end

-- ゲーム: 更新
function Game:update(dt)
    -- 更新
    self.background:update(dt)
    self.ground:update(dt)
    self.obstacle:update(dt)
    self.player:update(dt)

    -- プレイヤー VS 障害物の処理
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

-- ゲーム: 描画
function Game:draw()
    -- 描画
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

-- ゲーム: キー入力
function Game:keypressed(key, scancode, isrepeat)
    if key == 'f1' then
        -- 当たり判定の描画切り替え
        self.draw_collision = not self.draw_collision
    else
        -- プレイヤーに処理を渡す
        self.player:keypressed(key, scancode, isrepeat)
    end
end

-- ゲーム: マウス入力
function Game:mousepressed(x, y, button, istouch, presses)
    -- プレイヤーに処理を渡す
    self.player:mousepressed(x, y, button, istouch, presses)
end

-- ゲームオーバー
local GameOver = Scene:addState 'gameover'

-- ゲームオーバー: 開始処理
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

-- ゲームオーバー: 更新
function GameOver:update(dt)
end

-- ゲームオーバー: 描画
function GameOver:draw()
    -- 描画
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

-- ゲームオーバー: キー入力
function GameOver:keypressed(key, scancode, isrepeat)
    -- ゲームへ
    self:gotoState 'game'
    self.sounds.start:play()
end

-- ゲームオーバー: マウス入力
function GameOver:mousepressed(x, y, button, istouch, presses)
    -- ゲームへ
    self:gotoState 'game'
    self.sounds.start:play()
end

return Scene
