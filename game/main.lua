
require 'autobatch'
require 'sbss'

local Player = require 'Player'

local sprite
local player

function love.load()
    sprite = sbss:new('assets/sprites.xml')

    local width, height = love.graphics.getDimensions()
    player = Player(sprite, width * 0.2, height * 0.8)
    player:gotoState 'run'
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
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
