
local WaittingBox = class("WaittingBox", SmallGamesGMF.LoadPackages("mvc").ViewBase)

WaittingBox.AUTO_RESOLUTION   = true
WaittingBox.RESOURCE_FILENAME = SmallGamesGI.uiWaittingBox
WaittingBox.RESOURCE_BINDING  = {
    panel               = { parent = nil, varname = "panel" },
    txt_content         = { parent = "panel", varname = "txt_content" },
}

function WaittingBox:onCreate()
    self.super:onCreate()
    self:openKeyboard()
    self:runAction(self.resourceNode_["animation"])
    self.resourceNode_["animation"]:play("circle", true)
end

function WaittingBox:onInit()
    self.super:onInit()
    self.bNormal = false
    self.tTagList = {}
    self.iTagCount = 0
    self.txt_content:setString("")
end

function WaittingBox:onEnter()
    self.super:onEnter()
    SmallGamesGI.waittingbox = self
end

function WaittingBox:onEnterAni()
    self:showGrayBg()
    self:enterAni(self.panel)
end

function WaittingBox:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function WaittingBox:onExit()
    self.super:onExit()
    self.bNormal = false
    self.iTagCount = 0
    SmallGamesGI.waittingbox = nil
end

function WaittingBox:onExitAni()
    self:exitAni(self.panel)
end

function WaittingBox:onKeyback()
    self.super:onKeyback()
end

function WaittingBox:setContent( strContent )
    self.txt_content:setString(strContent)
end

return WaittingBox
