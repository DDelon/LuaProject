local HallNotice = class("HallNotice", SmallGamesGMF.LoadPackages("mvc").ViewBase)

HallNotice.AUTO_RESOLUTION   = true
HallNotice.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiHallnotice.lua")
HallNotice.RESOURCE_BINDING  = {
    panel         = { parent = nil, varname = "panel" },
    panel_clip         = { parent = "panel", varname = "panel_clip" },
}


function HallNotice:onCreate()
end
function HallNotice:play(anouncement)
    local clipsize = self.panel_clip:getContentSize()

    self.curAccount = cc.Label:createWithSystemFont("", "Arial", 30)
    self.curAccount:setColor(cc.c3b(146,62,13))
    self.curAccount:setString(anouncement)
    self.curAccount:setAnchorPoint(cc.p(0, 0.5))
    self.curAccount:setPosition(cc.p(clipsize.width,clipsize.height/2))

    local sizeAnnoun = self.curAccount:getContentSize()
    self.panel_clip:addChild(self.curAccount)

    local move = {}
    move[#move + 1] = cc.MoveBy:create(10, cc.p(-(sizeAnnoun.width + clipsize.width), 0))
    move[#move + 1] = cc.CallFunc:create(function ( ... )
        self:removeFromParent()
    end)

    self.curAccount:runAction(transition.sequence(move))
end

function HallNotice:onTouchBegan( ... )
    return false
end

return HallNotice
