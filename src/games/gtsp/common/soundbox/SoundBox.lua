local SoundBox = class("SoundBox", require(SmallGamesGF.getCommonSrcPath("msgbox.MsgBoxBase")))

SoundBox.AUTO_RESOLUTION   = true
SoundBox.RESOURCE_FILENAME = SmallGamesGI.uiSoundBox
SoundBox.RESOURCE_BINDING  = {
    panel_main          = { parent = nil, varname = "panel_main" },
    node_msgbox_base    = { parent = "panel_main", varname = "node_msgbox_base", events={event=SmallGamesGI.bindingEvents.FileNode, isParent=true} },
    img_music           = { parent = "panel_main", varname = "img_music" },
    sld_music           = { parent = "panel_main", varname = "sld_music" },
    img_effect          = { parent = "panel_main", varname = "img_effect" },
    sld_effect          = { parent = "panel_main", varname = "sld_effect" },
}

function SoundBox:onCreate()
    self.super:onCreate()
    self:openKeyboard()
end

function SoundBox:onInit()
    self.super:onInit()
    self.music_volume = cc.UserDefault:getInstance():getFloatForKey(SmallGamesGF.getUserDefaultKey("musicVolume"),1.0)
    self.effect_volume = cc.UserDefault:getInstance():getFloatForKey(SmallGamesGF.getUserDefaultKey("effectVolume"),1.0)
    self.sld_music:setMaxPercent(100)
    self.sld_effect:setMaxPercent(100)
    self.sld_music:setPercent(self.music_volume*100)
    self.sld_effect:setPercent(self.effect_volume*100)
    self.sld_music:addEventListener(handler(self,self.sliderCallback))
    self.sld_effect:addEventListener(handler(self,self.sliderCallback))
end

function SoundBox:onEnter()
    self.super:onEnter()
end

function SoundBox:onEnterAni()
    self:enterAni(self.panel_main)
end

function SoundBox:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function SoundBox:onExit()
    self.super:onExit()
end

function SoundBox:onExitAni()
    self:exitAni(self.panel_main)
end

function SoundBox:onKeyback()
    self.super:onKeyback()
    self:onQuit()
end

function SoundBox:onTouchBegan(touch,event)
    return true
end

function SoundBox:sliderCallback(sender,eventType)
    local tag = sender:getTag()
    if eventType == ccui.SliderEventType.slideBallDown then
    elseif eventType == ccui.SliderEventType.percentChanged  then
        local curPer = sender:getPercent()
        sender:setPercent(curPer)
    elseif eventType == ccui.SliderEventType.slideBallUp then
        local curPer = sender:getPercent()
        sender:setPercent(curPer)
        self:setVolumeByPer(sender,curPer)
    elseif eventType == ccui.SliderEventType.slideBallCancel then
        local curPer = sender:getPercent()
        sender:setPercent(curPer)
        self:setVolumeByPer(sender,curPer)
    end
end

function SoundBox:setVolumeByPer(sender, curPer)
    local volume = curPer/100
    if sender == self.sld_music then
        AudioEngine.setMusicVolume(volume)
        cc.UserDefault:getInstance():setFloatForKey(SmallGamesGF.getUserDefaultKey("musicVolume"), volume)
    elseif sender == self.sld_effect then
        AudioEngine.setEffectsVolume(volume)
        cc.UserDefault:getInstance():setFloatForKey(SmallGamesGF.getUserDefaultKey("effectVolume"), volume)
    end
end

return SoundBox
