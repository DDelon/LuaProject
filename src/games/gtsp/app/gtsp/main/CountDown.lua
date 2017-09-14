
local CountDown = class("CountDown", SmallGamesGMF.LoadPackages("mvc").ViewBase)

CountDown.AUTO_RESOLUTION   = true
CountDown.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiStartbetting.lua")
CountDown.RESOURCE_BINDING  = {
    panel         = { parent = nil, varname = "panel" },
        spr_bet         = { parent = "panel", varname = "spr_bet" },
            txt_counting         = { parent = "spr_bet", varname = "txt_counting" },
}


function CountDown:onCreate()
    self:runAction(self.resourceNode_.animation)
end

function CountDown:setString(num)
    self.txt_counting:setString(num)
end

function CountDown:start()
    self:play("star", false)
end

function CountDown:stop()
    self:play("close", false)
    self:stopActionByTag("999")
end

function CountDown:play(type, loop)
    self.resourceNode_.animation:play(type, loop)
end

function CountDown:onTouchBegan( ... )
    return false
end


return CountDown
