local ResultAnimate = class("ResultAnimate", SmallGamesGMF.LoadPackages("mvc").ViewBase)

ResultAnimate.AUTO_RESOLUTION   = true
ResultAnimate.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiResult3.lua")
ResultAnimate.RESOURCE_BINDING  = {    
    panel         = { parent = nil, varname = "panel" },    
    photo            = { parent = "panel", varname = "photo" },    
        
    fnt_rate            = { parent = "panel", varname = "fnt_rate" },

}


function ResultAnimate:onCreate()
    self:runAction(self.resourceNode_.animation)
    self:play("star_", false)
    
    local frameEventCallFunc = function (frameEventName)
        if frameEventName:getEvent() == "on_end" then
            self:getParent():removeFromParent()
            self.funcEnd()
        end
    end
    self.resourceNode_["animation"]:clearFrameEventCallFunc()
    self.resourceNode_["animation"]:setFrameEventCallFunc(frameEventCallFunc)
end

function ResultAnimate:onClickClose( ... )
    self:setVisible(false)
end

function ResultAnimate:setAnimal( spr , parent)
    local wSrcX, wSrcY = spr:getPosition()

    local x, y = self:getPosition()
    local x1, y1 = self.photo:getPosition()
    local x2, y2 = self.panel:getPosition()
    local dstX, dstY = self:getPosition()
    
    local aMove = {}
    aMove[#aMove + 1] = cc.MoveTo:create(0.66, cc.p(x + x1, y + y1))

    local aRotate = {}
    aRotate[#aRotate + 1] = cc.RotateBy:create(0.66, -365)

    local action =  cc.Spawn:create(transition.sequence(aMove), transition.sequence(aRotate))

    local actions = {}
    actions[#actions + 1] = action
    actions[#actions + 1] = cc.CallFunc:create(function ( ... )
        local path = SmallGamesGF.getCurAppResPath("sound/finish_01.mp3")
        AudioEngine.playEffect(path)
        spr:release()
        spr:removeFromParent()
        local size = self.photo:getContentSize()
        spr:setRotation(0)
        spr:setPosition(size.width/2, size.height/2)
        self.photo:addChild(spr)
    end)

    spr:runAction(transition.sequence(actions))
    DogGI.main.resourceNode_.root:addChild(spr,100)

    
end

function ResultAnimate:setRate(rate)
    self.fnt_rate:setString("x" .. rate)
end

function ResultAnimate:setMoney(money)
    --self.fnt_money:setString(money)
end

function ResultAnimate:play(type, loop)
    self.resourceNode_.animation:play(type, loop)
end

function ResultAnimate:setEndCallFunc(funcEnd)
    self.funcEnd = funcEnd
end

return ResultAnimate
