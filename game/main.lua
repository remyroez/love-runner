
require 'autobatch'
require 'sbss'

local sprite

function love.load()
    sprite = sbss:new('assets/spritesheet.xml')
end

function love.update(dt)
end

function love.draw()
    sprite:draw('bunny1_ready.png', 0, 0)
end

function love.quit()
end
