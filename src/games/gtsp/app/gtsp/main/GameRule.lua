local GameRule = class("GameRule", SmallGamesGMF.LoadPackages("mvc").ViewBase)

GameRule.AUTO_RESOLUTION   = true
GameRule.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiRule.lua")
GameRule.RESOURCE_BINDING  = {    
    panel         = { parent = nil, varname = "panel" },    
    bg         = { parent = "panel", varname = "bg" },        
    btn_close     = { parent = "bg", varname = "btn_close", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickClose"} },
    btn_ok     = { parent = "bg", varname = "btn_ok", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickClose"} },
    lst_txt_rule     = { parent = "bg", varname = "lst_txt_rule" },
        txt_rule     = { parent = "lst_txt_rule", varname = "txt_rule" },
}


function GameRule:onCreate()
    self.txt_rule:setString(DogGI.language_config.rule)
    local size = self.txt_rule:getContentSize()

    self.lst_txt_rule:setInnerContainerSize(size)
    DogGI.ui_manager:pause()
end

function GameRule:onClickClose( ... )
    DogGI.ui_manager:resume()
    self:onQuit()
end

function GameRule:onEnterAni()
    self:enterAni(self.panel)
end

function GameRule:onExitAni()
    self:exitAni(self.panel)
end

return GameRule
