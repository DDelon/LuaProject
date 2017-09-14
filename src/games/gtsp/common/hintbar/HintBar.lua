
local HintBar = class("HintBar", SmallGamesGMF.LoadPackages("mvc").ViewBase)

HintBar.AUTO_RESOLUTION   = true
HintBar.RESOURCE_FILENAME = SmallGamesGI.uiHintBar
HintBar.RESOURCE_BINDING  = {
    panel               = { parent = nil, varname = "panel" },
    img_bg              = { parent = "panel", varname = "img_bg" },
    txt_content         = { parent = "panel", varname = "txt_content" },
}

function HintBar:onCreate()
    self.super:onCreate()
end

function HintBar:onInit()
    self.super:onInit()
    self.txt_content:setString("")
end

function HintBar:onEnter()
    self.super:onEnter()
    SmallGamesGI.HintBar = self
end

function HintBar:onEnterAni()
    self:enterAni(self.panel)
end

function HintBar:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
    local function callbackFun()
        self:onQuit()
    end
    self.panel:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.FadeOut:create(1), cc.CallFunc:create(callbackFun)))
end

function HintBar:onExit()
    self.super:onExit()
    SmallGamesGI.HintBar = nil
end

function HintBar:setContent( strContent )
    self.txt_content:setString(strContent)
    self.img_bg:setContentSize(cc.size(self.txt_content:getContentSize().width+100, self.img_bg:getContentSize().height))
end

return HintBar
