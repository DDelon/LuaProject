
local GameScene = class("GameScene", function()
	return cc.Scene:create();
end)

function GameScene.create(client)
	local scene = GameScene.new()
	scene:onInit()
	return scene
end

function GameScene:onInit()
    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "enterTransitionFinish" then

        elseif event == "exit" then
            self:onExit()
        elseif event == "exitTransitionStart" then

        elseif event == "cleanup" then

        end

    end
    self:registerScriptHandler(onNodeEvent)
end

function GameScene:onEnter()
    self.layerGame = SmallGamesGF.createView(SmallGameApp.GameLayer)
    self:addChild(self.layerGame)
    SmallGamesGI.GameManager.layerGame = self.layerGame
end

function GameScene:onEnterTransitionFinish()
    
end

function GameScene:onExit()
    
end

return GameScene
