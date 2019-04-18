
require 'autobatch'
require 'sbss'

local Player = require 'Player'
local Ground = require 'Ground'
local Background = require 'Background'
local Obstacle = require 'Obstacle'
local Scene = require 'Scene'

local scene

function love.load()
    -- スプライトの読み込み
    local sprite = sbss:new('assets/sprites.xml')

    -- サウンドの読み込み
    local sounds = {
        bgm = love.audio.newSource('assets/Retro Comedy.ogg', 'stream'),
        start = love.audio.newSource('assets/coin2.ogg', 'static'),
        score = love.audio.newSource('assets/coin5.ogg', 'static'),
        jump = love.audio.newSource('assets/jump3.ogg', 'static'),
        gameover = love.audio.newSource('assets/gameover3.ogg', 'static')
    }
    sounds.bgm:setLooping(true)

    -- スクリーンサイズ
    local width, height = love.graphics.getDimensions()

    -- プレイヤー
    local player = Player(sprite, width * 0.2, height * 0.8, 50, 50, sounds)
    player:gotoState 'run'

    -- 地面
    local ground = Ground(sprite, 500, player.y, width, height)

    -- 背景
    local image = love.graphics.newImage('assets/blue_desert.png')
    local background = Background(image, 100, 0, 0, width, height, height / image:getHeight())

    -- 障害物
    local obstacle = Obstacle(sprite, 'cactus.png', 500, width + 100, height * 0.8, 50, 80)

    -- シーン
    scene = Scene(
        player, obstacle, ground, background, sounds
    )
    scene:gotoState 'title'
end

function love.update(dt)
    scene:update(dt)
end

function love.draw()
    love.graphics.reset()
    scene:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f5' then
        love.event.quit('restart')
    else
        scene:keypressed(key, scancode, isrepeat)
    end
end

function love.mousepressed(...)
    scene:mousepressed(...)
end
