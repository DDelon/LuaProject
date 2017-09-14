
local MsgBox = class("MsgBox", require(SmallGamesGF.getCommonSrcPath("msgbox.MsgBoxBase")))

MsgBox.AUTO_RESOLUTION   = true
MsgBox.RESOURCE_FILENAME = SmallGamesGI.uiMsgBox
MsgBox.RESOURCE_BINDING  = {
    panel_main          = { parent = nil, varname = "panel_main" },
    node_msgbox_base    = { parent = "panel_main", varname = "node_msgbox_base", events={event=SmallGamesGI.bindingEvents.FileNode, isParent=true} },
    text_content        = { parent = "panel_main", varname = "text_content" },
    panel_btn_bar_1     = { parent = "panel_main", varname = "panel_btn_bar_1" },
    btn_ok_1            = { parent = "panel_btn_bar_1", varname = "btn_ok", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickOk1"}},
    panel_btn_bar_2     = { parent = "panel_main", varname = "panel_btn_bar_2" },
    btn_ok_2            = { parent = "panel_btn_bar_2", varname = "btn_ok", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickOk2"}},
        spr_title_ok            = { parent = "btn_ok_2", varname = "spr_title"},
    btn_cancel          = { parent = "panel_btn_bar_2", varname = "btn_cancel", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickCancel"}},
        spr_title_cancel        = { parent = "btn_cancel", varname = "spr_title"},
}

function MsgBox:onCreate()
    self.super:onCreate()
    self:openKeyboard()
end

function MsgBox:onInit()
    self.super:onInit()
    self:setType(SmallGamesGI.MsgBoxTYPE.OneBtn)
end

function MsgBox:onEnter()
    self.super:onEnter()
    SmallGamesGI.msgBox = self
end

function MsgBox:onEnterAni()
    self:showGrayBg()
    self:enterAni(self.panel_main)
end

function MsgBox:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function MsgBox:onExit()
    self.super:onExit()
    SmallGamesGI.msgBox = nil
end

function MsgBox:onExitAni()
    self:exitAni(self.panel_main)
end

function MsgBox:onKeyback()
    self.super:onKeyback()
    self:onQuit()
end

function MsgBox:onTouchBegan(touch,event)
    return true
end

function MsgBox:onClickOk1(sender)
    if self.funCallBack then
        self.funCallBack(self, SmallGamesGI.MsgBoxBtns.FirstBtn)
    end
    self:onQuit()
end

function MsgBox:onClickOk2(sender)
    if self.funCallBack then
        self.funCallBack(self, SmallGamesGI.MsgBoxBtns.FirstBtn)
    end
    self:onQuit()
end

function MsgBox:onClickCancel(sender)
    if self.funCallBack then
        self.funCallBack(self, SmallGamesGI.MsgBoxBtns.SecondBtn)
    end
    self:onQuit()
end

function MsgBox:setBtnTextImg(path1, path2)
    if path1 then
        self.spr_title_ok:setTexture(path1)
    end

    if path2 then
        self.spr_title_cancel:setTexture(path2)
    end
end

function MsgBox:setType( type )
    self.type = type
    if self.type == SmallGamesGI.MsgBoxTYPE.NoneBtn then
        self.panel_btn_bar_1:setVisible(false)
        self.panel_btn_bar_2:setVisible(false)
    elseif self.type == SmallGamesGI.MsgBoxTYPE.OneBtn then
        self.panel_btn_bar_1:setVisible(true)
        self.panel_btn_bar_2:setVisible(false)
    elseif self.type == SmallGamesGI.MsgBoxTYPE.TwoBtn then
        self.panel_btn_bar_1:setVisible(false)
        self.panel_btn_bar_2:setVisible(true)
    end
end

function MsgBox:setContent( strContent )
    self.text_content:setString(strContent)
end

return MsgBox
