
local MsgBoxBase = class("MsgBoxBase", SmallGamesGMF.LoadPackages("mvc").ViewBase)

MsgBoxBase.AUTO_RESOLUTION   = true
MsgBoxBase.RESOURCE_FILENAME = SmallGamesGI.uiMsgBoxBase
MsgBoxBase.RESOURCE_BINDING  = {
    img_bg_base         = { parent = nil, varname = "img_bg" },
    btn_close           = { parent = "img_bg_base", varname = "btn_close", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickClose"}},
}

function MsgBoxBase:onCreate()
    self.super:onCreate()
end

function MsgBoxBase:onInit()
    self.super:onInit()
end

function MsgBoxBase:onEnter()
    self.super:onEnter()
end

function MsgBoxBase:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function MsgBoxBase:onExit()
    self.super:onExit()
end

function MsgBoxBase:onKeyback()
    self.super:onKeyback()
end

function MsgBoxBase:onClickClose(sender)
    if self.funCallBack then
        self.funCallBack(self, SmallGamesGI.MsgBoxBtns.CloseBtn)
    end
    self:onQuit()
end

function MsgBoxBase:isShowCloseBtn( bShowCloseBtn )
    self.bShowCloseBtn = bShowCloseBtn
    self.btn_close:setVisible(self.bShowCloseBtn)
end

function MsgBoxBase:setMsgBoxSize(size)
    self:makeResolutionAdaptation(self.img_bg_base, size)
end

function MsgBoxBase:setCallBackFun( callback )
    self.funCallBack = callback
end

return MsgBoxBase
