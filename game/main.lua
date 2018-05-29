
require 'autobatch'
require 'sbss'

local Player = require 'Player'
local Ground = require 'Ground'
local Background = require 'Background'

local sprite
local player
local ground
local background

function love.load()
    sprite = sbss:new('assets/sprites.xml')

    local width, height = love.graphics.getDimensions()
    player = Player(sprite, width * 0.2, height * 0.8)
    player:gotoState 'run'

    ground = Ground(sprite, 500, player.y, width, height)

    local image = love.graphics.newImage('assets/blue_desert.png')
    background = Background(image, 100, 0, 0, width, height, height / image:getHeight())
end

function love.update(dt)
    background:update(dt)
    ground:update(dt)
    player:update(dt)
end

function love.draw()
    background:draw()
    ground:draw()
    player:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f5' then
        love.event.quit('restart')
    else
        player:keypressed()
    end
end

function love.mousepressed(...)
    player:mousepressed()
end
