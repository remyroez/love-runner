
require 'autobatch'
require 'sbss'

local Player = require 'Player'
local Ground = require 'Ground'
local Background = require 'Background'
local Obstacle = require 'Obstacle'
local Scene = require 'Scene'

local player
local ground
local background
local obstacle
local scene

local draw_collision = false

local function isHit(a, b)
    return (a:right() > b:left()) and (a:bottom() > b:top()) and (a:left() < b:right()) and (a:top() < b:bottom())
end

function love.load()
    local sprite = sbss:new('assets/sprites.xml')

    local width, height = love.graphics.getDimensions()
    player = Player(sprite, width * 0.2, height * 0.8, 50, 50)
    player:gotoState 'run'

    ground = Ground(sprite, 500, player.y, width, height)

    local image = love.graphics.newImage('assets/blue_desert.png')
    background = Background(image, 100, 0, 0, width, height, height / image:getHeight())

    obstacle = Obstacle(sprite, 'cactus.png', 500, width + 100, height * 0.8, 50, 80)

    scene = Scene(
        player, obstacle, ground, background
    )
    scene:gotoState 'title'
end

function love.update(dt)
    scene:update(dt)
end

function love.draw()
    love.graphics.reset()

    scene:draw()
    
    if draw_collision then
        obstacle:drawCollision()
        player:drawCollision()
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f5' then
        love.event.quit('restart')
    elseif key == 'f1' then
        draw_collision = not draw_collision
    else
        scene:keypressed(key, scancode, isrepeat)
    end
end

function love.mousepressed(...)
    scene:mousepressed(...)
end
