
local class = require 'middleclass'
local stateful = require 'stateful'

local lg = love.graphics

-- シーン
local Scene = class 'Scene'
Scene:include(stateful)

function Scene:initialize(player, obstacle, ground, background)
    self.player = player
    self.obstacle = obstacle
    self.ground = ground
    self.background = background

    local width, height = lg.getDimensions()
    self.width = width
    self.height = height
    self.textPos = {
        x = width / 2,
        y = height / 3,
    }
    self.font = lg.newFont(64)
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
    self.obstacle:update(dt)
    self.player:update(dt)
end

function Title:draw()
    self.background:draw()
    self.ground:draw()
    self.obstacle:draw()
    self.player:draw()

    lg.setColor(0, 0, 0, 0.75)
    lg.rectangle("fill", 0, 0, self.width, self.height )

    lg.setColor(love.math.random(), love.math.random(), love.math.random())
    lg.printf("ALIEN RUNNER", self.font, 0, self.textPos.y, self.width, 'center')
    
    lg.setColor(1.0, 0, 0.25)
    lg.printf("PRESS ANY KEY", 0, self.textPos.y * 2, self.width, 'center')
end

function Title:keypressed(key, scancode, isrepeat)
    self:gotoState 'game'
end

function Title:mousepressed(x, y, button, istouch, presses)
    self:gotoState 'game'
end

-- シーン: ゲーム
local Game = Scene:addState 'game'

local function isHit(a, b)
    return (a:right() > b:left()) and (a:bottom() > b:top()) and (a:left() < b:right()) and (a:top() < b:bottom())
end

function Game:enteredState()
    self.background:reset()
    self.ground:reset()
    self.obstacle:reset()
    self.player:reset()
end

function Game:update(dt)
    self.background:update(dt)
    self.ground:update(dt)
    self.obstacle:update(dt)
    self.player:update(dt)
    
    if isHit(self.player, self.obstacle) then
        self.player:gotoState 'die'
        self:gotoState 'gameover'
    end
end

function Game:draw()
    self.background:draw()
    self.ground:draw()
    self.obstacle:draw()
    self.player:draw()
end

function Game:keypressed(key, scancode, isrepeat)
    self.player:keypressed()
end

function Game:mousepressed(x, y, button, istouch, presses)
    self.player:mousepressed()
end

-- シーン: ゲームオーバー
local GameOver = Scene:addState 'gameover'

function GameOver:enteredState()
end

function GameOver:update(dt)
end

function GameOver:draw()
    self.background:draw()
    self.ground:draw()
    self.obstacle:draw()
    self.player:draw()
    
    lg.setColor(1.0, 0, 0)
    lg.printf("GAME OVER", self.font, 0, self.textPos.y, self.width, 'center')
    
    lg.setColor(1.0, 0, 0.25)
    lg.printf("PRESS ANY KEY", 0, self.textPos.y * 2, self.width, 'center')
end

function GameOver:keypressed(key, scancode, isrepeat)
    self:gotoState 'title'
end

function GameOver:mousepressed(x, y, button, istouch, presses)
    self:gotoState 'title'
end

return Scene
