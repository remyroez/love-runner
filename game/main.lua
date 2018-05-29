
require 'autobatch'
require 'sbss'

local sprite

function love.load()
    sprite = sbss:new('assets/sprites.xml')
end

function love.update(dt)
end

function love.draw()
    sprite:draw('alienGreen_walk1.png', 0, 0)
end

function love.quit()
end
