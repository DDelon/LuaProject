
local MainLayer = class("MainLayer", SmallGamesGMF.LoadPackages("mvc").ViewBase)

-- 同一个按钮点击时间间隔，当且仅当>0时控制生效
MainLayer.MULTI_TOUCH_TIME = 0
-- 两个按钮点击时间间隔，当且仅当>0时控制生效
MainLayer.MULTI_BTN_TOUCH_TIME = 0

MainLayer.AUTO_RESOLUTION   = true
MainLayer.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiMain.lua")
MainLayer.RESOURCE_BINDING  = {
    img_sub_title           = { parent = nil, varname = "img_sub_title" },
        img_cover           = { parent = "img_sub_title", varname = "img_cover" },
        img_bat_ratio_sub       = { parent = "img_sub_title", varname = "img_bat_ratio_sub" },
            fnt_rate            = { parent = "img_bat_ratio_sub", varname = "fnt_rate" },
        btn_start               = { parent = "img_sub_title", varname = "btn_start", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickStart"} },
        btn_reset               = { parent = "img_sub_title", varname = "btn_reset", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickReset"} },
        btn_hungup              = { parent = "img_sub_title", varname = "btn_hungup", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickHungup"} },
            spr_hungeffect      = { parent = "btn_hungup", varname = "spr_hungeffect" },
        bet_all                 = { parent = "img_sub_title", varname = "bet_all", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickBetall"} },
        btn_dog_head_1          = { parent = "img_sub_title", varname = "btn_dog_head_1", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickDogRate"} },
            fnt_rate_1          = { parent = "btn_dog_head_1", varname = "fnt_rate_1" },

        btn_dog_head_2          = { parent = "img_sub_title", varname = "btn_dog_head_2", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickDogRate"} },
            fnt_rate_2          = { parent = "btn_dog_head_2", varname = "fnt_rate_2" },

        btn_dog_head_3          = { parent = "img_sub_title", varname = "btn_dog_head_3", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickDogRate"} },
            fnt_rate_3          = { parent = "btn_dog_head_3", varname = "fnt_rate_3" },

        btn_dog_head_4          = { parent = "img_sub_title", varname = "btn_dog_head_4", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickDogRate"} },
            fnt_rate_4          = { parent = "btn_dog_head_4", varname = "fnt_rate_4" },

        btn_dog_head_5          = { parent = "img_sub_title", varname = "btn_dog_head_5", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickDogRate"} },
            fnt_rate_5          = { parent = "btn_dog_head_5", varname = "fnt_rate_5" },

        btn_dog_head_6          = { parent = "img_sub_title", varname = "btn_dog_head_6", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickDogRate"} },
            fnt_rate_6          = { parent = "btn_dog_head_6", varname = "fnt_rate_6" },

        img_ratio_text_1        = { parent = "img_sub_title", varname = "img_ratio_text_1" },
            fnt_count_1        = { parent = "img_ratio_text_1", varname = "fnt_count_1" },

        img_ratio_text_2        = { parent = "img_sub_title", varname = "img_ratio_text_2" },
            fnt_count_2        = { parent = "img_ratio_text_2", varname = "fnt_count_2" },

        img_ratio_text_3        = { parent = "img_sub_title", varname = "img_ratio_text_3" },
            fnt_count_3        = { parent = "img_ratio_text_3", varname = "fnt_count_3" },
            
        img_ratio_text_4        = { parent = "img_sub_title", varname = "img_ratio_text_4" },
            fnt_count_4        = { parent = "img_ratio_text_4", varname = "fnt_count_4" },

        img_ratio_text_5        = { parent = "img_sub_title", varname = "img_ratio_text_5" },
            fnt_count_5        = { parent = "img_ratio_text_5", varname = "fnt_count_5" },

        img_ratio_text_6        = { parent = "img_sub_title", varname = "img_ratio_text_6" },
            fnt_count_6        = { parent = "img_ratio_text_6", varname = "fnt_count_6" },

    panel_racetrack         = { parent = nil, varname = "panel_racetrack" },
    bg         = { parent = nil, varname = "bg" },
    
    spr_hunging_start         = { parent = nil, varname = "spr_hunging_start" },
    spr_hunging_cancel         = { parent = nil, varname = "spr_hunging_cancel" },

    node_title_bar          = { parent = nil, varname = "node_title", events={event=SmallGamesGI.bindingEvents.FileNode, viewName = "OptionTitle", luaFile=SmallGamesGF.getCurAppSrcPath("main.OptionTitle")} },

    panel_main              = { parent = nil, varname = "panel_main" },
        img_startline           = { parent = "panel_main", varname = "img_startline" },
        img_endline             = { parent = "panel_main", varname = "img_endline" },
        img_bg_counting_down             = { parent = "panel_main", varname = "img_bg_counting_down", events={event=SmallGamesGI.bindingEvents.FileNode, viewName = "CountDown", luaFile=SmallGamesGF.getCurAppSrcPath("main.CountDown")} },
            --txt_counting             = { parent = "img_bg_counting_down", varname = "txt_counting" },

    panel_running              = { parent = nil, varname = "panel_running" },
    img_title_back          = { parent = nil, varname = "img_title_back" },

    img_title_forge         = { parent = nil, varname = "img_title_forge" },

    btn_bat_rattio          = { parent = "img_sub_title", varname = "btn_bat_rattio" },
        fnt_total_rate      = { parent = "btn_bat_rattio", varname = "fnt_total_rate" },
        btn_expand          = { parent = "btn_bat_rattio", varname = "btn_expand", events={event=SmallGamesGI.bindingEvents.Click, method="onClickExpand"} },
        btn_batsub          = { parent = "btn_bat_rattio", varname = "btn_batsub", events={event=SmallGamesGI.bindingEvents.Click, method="onClickExpand"}  },
        ratio_list          = { parent = "btn_bat_rattio", varname = "ratio_list" },
            img_choice          = { parent = "ratio_list", varname = "img_choice"},
            btn_x100          = { parent = "ratio_list", varname = "btn_x100", events={event=SmallGamesGI.bindingEvents.Click, method="onClickRatio"} },
            btn_x200          = { parent = "ratio_list", varname = "btn_x200", events={event=SmallGamesGI.bindingEvents.Click, method="onClickRatio"} },
            btn_x500          = { parent = "ratio_list", varname = "btn_x500", events={event=SmallGamesGI.bindingEvents.Click, method="onClickRatio"} },
            btn_x1000          = { parent = "ratio_list", varname = "btn_x1000", events={event=SmallGamesGI.bindingEvents.Click, method="onClickRatio"} },

    node_test_data          = { parent = nil, varname = "node_test_data" },
        img_input_0           = { parent = "node_test_data", varname = "img_input_0" },
        text_input_0          = { parent = "img_input_0", varname = "text_input_0", events={event=SmallGamesGI.bindingEvents.EditBox, isPassword=false, isMediate=nil} },
        img_input           = { parent = "node_test_data", varname = "img_input" },
        text_input          = { parent = "img_input", varname = "text_input", events={event=SmallGamesGI.bindingEvents.EditBox, isPassword=false, isMediate=nil} },
        btn_setprop          = { parent = "node_test_data", varname = "btn_setprop", events={event=SmallGamesGI.bindingEvents.Click, method="onClickScrectSet"} },
        btn_hide            = { parent = "node_test_data", varname = "btn_hide", events={event=SmallGamesGI.bindingEvents.Click, method="onClickHide"} },
}

cc.exports.DogGI = {}
cc.exports.log = function ( ... )

    local line = tostring(debug.getinfo(2).currentline)
    local funcname = tostring(debug.getinfo(2).name)

    local args = {...}
    local strArgs = funcname .. ":" .. line .. "\t"
    for i = 1, #args do
        local str = "\t" .. tostring(args[i])

        strArgs = strArgs .. str
    end

    print(strArgs)
end

function MainLayer:onMessage(type, data)
    print(type)
    --dump(data)

    if type == "ready" then
        DogGI.ui_manager:onReady(data)
        --SmallGamesGI.RoomManager:sendGetPlayerInfo()
        --self:playDark()
    elseif type == "onBegin" then
        -- local
        
        if not data.success then
            DogGI.ui_manager.betable = true
            DogGI.ui_manager.isRunning = false
            return
        end
        self:hideAll()
        local animates = self:loadStartAnimate()
        self.node_title_bar:doHide()
        self:hideBetRatioList()
        self:disableClick()
        local animate = {}
        animate[#animate + 1] = cc.CallFunc:create(function ( ... )
            self.start_animate_playing = true
            AudioEngine.stopMusic()
            local path = SmallGamesGF.getCurAppResPath("sound/readygo_01.mp3")
            AudioEngine.playEffect(path)
        end)
        animate[#animate + 1] = cc.DelayTime:create(2.0)
        animate[#animate + 1] = cc.CallFunc:create(function ( ... )
            AudioEngine.stopMusic()
            local path = SmallGamesGF.getCurAppResPath("sound/readygo_02.mp3")
            AudioEngine.playEffect(path)
        end)
        animate[#animate + 1] = cc.DelayTime:create(1)
        animate[#animate + 1] = cc.CallFunc:create(function ( ... )

            DogGI.ui_manager:doRun(data, function ( ... )
                SmallGamesGI.RoomManager:sendReady()
                SmallGamesGI.RoomManager:sendHistory()
                self.node_title_bar:doShow()
                
                self:enableClick()
                self:playBright()
            end)

            animates:removeFromParent()
            self.start_animate_playing = false
        end)

        self:runAction(transition.sequence(animate))
    elseif type == "onHistory" then
        self:onHistory(data)
    elseif type == "onUnlock" then
        --dump(data)
        self.animal_map:onUnlock(data)
    elseif type == "onSetProp" then
        if not data.success then
            return
        end
        
        if self.secrect == 1 then
            DogGI.cur_money = self.secrect_count
            self.node_title_bar:setGoldCount(self.secrect_count)
        elseif self.secrect == 2 then
            DogGI.cur_point = self.secrect_count
            self.node_title_bar:setPointCount(self.secrect_count)
        elseif self.secrect == 3 then
        elseif self.secrect == 4 then
        end
    elseif type == "onGameAnnounce" then
        self:loadBraodcast(data)
    elseif type == "refresh_finfo" then
        DogGI.cur_money = data.money
        DogGI.cur_point = data.point
        self.node_title_bar:setGoldCount(DogGI.cur_money)
        self.node_title_bar:setPointCount(DogGI.cur_point)
    end
end

function MainLayer:enableClick()
    self:doEnableClick(true)
end

function MainLayer:disableClick()
    self:doEnableClick(false)
end

function MainLayer:playDark()
    local color = {r = 0, g = 0, b = 0}

    self:playLight(255, 0, 0.8)

end

function MainLayer:playBright()
    local color = {r = 0, g = 0, b = 0}

    self:playLight(0, 255, 0.2)
end


function MainLayer:playLight(from, to, period)
    local total = 0
    local scheduler = cc.Director:getInstance():getScheduler()

    if self.lightschedulerID ~= nil then
        scheduler:unscheduleScriptEntry(self.lightschedulerID)
    end

    self.lightschedulerID = scheduler:scheduleScriptFunc(function(dt)
        total = total + dt
        if total > period then
            self:setBgColor(to)
            scheduler:unscheduleScriptEntry(self.lightschedulerID)
            self.lightschedulerID = nil
            return
        end

        local percent = total/period
        self:setBgColor(to + (from - to) * (1 -  percent))
    end,0,false)
end

function MainLayer:setBgColor(color)
    self.panel_racetrack:setColor({r = color, g = color, b = color})
    self.panel_racetrack_0:setColor({r = color, g = color, b = color})

    self.panel_main:setColor({r = color, g = color, b = color})

    self.img_title_back:setColor({r = color, g = color, b = color})
    self.img_title_back_0:setColor({r = color, g = color, b = color})

    self.panel_running:setColor({r = color, g = color, b = color})
    self.img_title_forge:setColor({r = color, g = color, b = color})
    self.img_title_forge_0:setColor({r = color, g = color, b = color})
    self.bg:setColor({r = color, g = color, b = color})
    
end

function MainLayer:doEnableClick(enable)
    --self.img_cover:setVisible(not enable)
    local color = {r = 255, g = 255, b = 255}
    if not enable then
        color = {r = 175, g = 175, b = 175} 
    end
    for i = 1, 6 do 
        self["btn_dog_head_" .. i]:setEnabled(enable)
        self["btn_dog_head_" .. i]:setColor(color)
    end
    self.btn_start:setEnabled(enable)
    self.btn_start:setColor(color)
    self.btn_reset:setEnabled(enable)
    self.btn_reset:setColor(color)
    self.bet_all:setEnabled(enable)
    self.bet_all:setColor(color)
end

function MainLayer:enableStartClick()
    self:doEnableStartClick(true)
end

function MainLayer:disableStartClick()
    self:doEnableStartClick(false)
end

function MainLayer:doEnableStartClick(enable)
    local color = {r = 255, g = 255, b = 255}
    if not enable then
        color = {r = 175, g = 175, b = 175} 
    end
    
    self.btn_start:setEnabled(enable)
    self.btn_start:setColor(color)

    
    self.btn_hungup:setEnabled(enable)
    self.btn_hungup:setColor(color)
end

function MainLayer:loadStartAnimate()
    local animate = require(SmallGamesGF.getCurAppSrcPath("main.StartAnimate.lua")).create()
    animate:setPosition(DogGI.winSize.width/2, DogGI.winSize.height/2)
    self:addChild(animate)
    animate:play("start", false)

    return animate
end

function MainLayer:loadBraodcast(data)
    local anouncement = string.format(DogGI.language_config.anouncement, data.playerId , 1,  data.nWinGold + 0)
    local animate = require(SmallGamesGF.getCurAppSrcPath("main.HallNotice.lua")).create()
    animate:setPosition(DogGI.winSize.width/2, DogGI.winSize.height*0.85)
    animate:play(anouncement)

    self:addChild(animate)

    return animate
end

function MainLayer:onCreate()
    self.super:onCreate(self)
    self:openKeyboard()
    --self.img_sub_title:setLocalZOrder(9999)

    DogGI = {}
    DogGI.main = self
    DogGI.winSize = cc.Director:getInstance():getWinSize()
    self.ratio = 1000

    self:runAction(self.resourceNode_.animation)
    self:play("close", false)
    self:play("hangup", true)
    self.spr_hungeffect:setVisible(false)
end

function MainLayer:play(type, loop)
    self.resourceNode_.animation:play(type, loop)
end

function MainLayer:onInit()
    self.super:onInit()

    self:initPreload()
    self:initConfig()
    self:initDog()
    self:initLanguage()
    self:initPoint()
    self:initVip()

    self:initDogManager()
    --self:loadBraodcast()
    DogGI.ui_manager:initUI(self)
    self:initUI()
end

function MainLayer:initUI()
    local size = self.bet_all:getContentSize()
    self.all_bet_effect = require(SmallGamesGF.getCurAppSrcPath("animation.AllBet")).create()
    self.all_bet_effect:setPosition(size.width/2, size.height/2)
    self.bet_all:addChild(self.all_bet_effect)

    for i = 1, 6 do 
        size = self.btn_dog_head_1:getContentSize()
        self["bet_effect" .. i] = require(SmallGamesGF.getCurAppSrcPath("animation.AllBet")).create()
        self["bet_effect" .. i]:setPosition(size.width/2, size.height/2)
        self["btn_dog_head_" .. i]:addChild(self["bet_effect" .. i])

        self["bet_stake_effect" .. i] = require(SmallGamesGF.getCurAppSrcPath("animation.StakeEffect")).create()
        self["bet_stake_effect" .. i]:setPosition(size.width/2, size.height/2 + 17)
        self["btn_dog_head_" .. i]:addChild(self["bet_stake_effect" .. i])
    end

    size = self.btn_start:getContentSize()
    self.start_effect = require(SmallGamesGF.getCurAppSrcPath("animation.StartEffect")).create()
    self.start_effect:setPosition(size.width/2, size.height/2)
    self.btn_start:addChild(self.start_effect)
end

function MainLayer:onEnter()
    self.super:onEnter()
end

function MainLayer:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function MainLayer:onExit()
    self.super:onExit()
    self:stopAllActions()
    AudioEngine.stopMusic()
    DogGI.ui_manager.run_count = 0
    if DogGI.ui_manager.schedulerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(DogGI.ui_manager.schedulerID)
    end
end

function MainLayer:onKeyback()
    self.super:onKeyback()
    self:onGameExit(SmallGamesGI.MsgBoxTYPE.TwoBtn, DogGI.language_config.exit)
end

function MainLayer:onGameExit(msgboxType, strContent)
    local function callback( msgbox, btnType )
        if btnType == SmallGamesGI.MsgBoxBtns.FirstBtn then
            SmallGamesGF.exitApp()
        end
    end
    SmallGamesGF.createMsgBox(msgboxType, strContent, callback)
end

function MainLayer:sendHeartBeat()
    SmallGamesGI.RoomManager:sendHeartBeat()
end

function MainLayer:onMsgReady()
    SmallGamesGI.RoomManager:sendReady()
    SmallGamesGI.RoomManager:sendHistory()
end

function MainLayer:onChargeSucceed()
    SmallGamesGI.RoomManager:sendGetPlayerInfo()
end

function MainLayer:onSocketClose()
    self:onGameExit(SmallGamesGI.MsgBoxTYPE.OneBtn, DogGI.language_config.lost_connect)
end

------------------------------------------------------------------------

function MainLayer:initConfig()
    DogGI.config = require(SmallGamesGF.getCurAppSrcPath("config.config.lua")).create()
end

function MainLayer:initDog()
    DogGI.dog_config = require(SmallGamesGF.getCurAppSrcPath("config.dog.lua")).create()
end

function MainLayer:initLanguage()
    DogGI.language_config = require(SmallGamesGF.getCurAppSrcPath("config.language.lua")).create()
end

function MainLayer:initPoint()
    DogGI.point_config = require(SmallGamesGF.getCurAppSrcPath("config.point.lua")).create()
end

function MainLayer:initVip()
    DogGI.vip_config = require(SmallGamesGF.getCurAppSrcPath("config.vip.lua")).create()
end
function MainLayer:initDogManager()
    DogGI.ui_manager = require(SmallGamesGF.getCurAppSrcPath("manager.UIManager.lua")).create()
end

function MainLayer:initPreload()
    DogGI.preload = require(SmallGamesGF.getCurAppSrcPath("preload.Preload.lua")).create()
end

function MainLayer:onClickStart()
    if DogGI.ui_manager.isRunning then
        return
    end

    if DogGI.ui_manager.preparing then
        return
    end
    self.start_effect:play()
    print("click start")
    self.img_bg_counting_down:stop()
    DogGI.ui_manager.betable = false
    DogGI.ui_manager.isRunning = true
    SmallGamesGI.RoomManager:sendBegin(DogGI.ui_manager:getBeginInfo())
end

function MainLayer:onClickReset()
    if not DogGI.ui_manager.betable then
        return
    end

    if DogGI.ui_manager.isPlaying then
        return
    end


    SmallGamesGF.createHintBar(self, DogGI.language_config.bet_reset, cc.p(DogGI.winSize.width/2, DogGI.winSize.height/2))
    DogGI.ui_manager:resetRatio()
end

function MainLayer:onClickHungup()
    self.isHunging = not self.isHunging
    local toast = nil
    if self.isHunging then
        self:showHunging()
        self.img_bg_counting_down:setVisible(false)
        --toast = SmallGamesGF.createHintBar(nil, DogGI.language_config.start_hangup, nil)
        self:play("hangup", true)
        self.spr_hungeffect:setVisible(true)
    else
        self:showUnhunging()
        self.img_bg_counting_down:setVisible(true)
        --toast = SmallGamesGF.createHintBar(nil, DogGI.language_config.stop_hangup, nil)
        self:play("hangup", true)
        self.spr_hungeffect:setVisible(false)
    end

    --toast:setPosition(DogGI.winSize.width/2, DogGI.winSize.height/2)
    --self:addChild(toast, 9999)

    if self.isHunging then
        self:onClickStart()
    end
end

function MainLayer:showHunging()
    local actions = {}
    self.spr_hunging_start:stopActionByTag("808")
    self.spr_hunging_start:setVisible(true)
    self.spr_hunging_cancel:setVisible(false)
    SmallGamesGF.onViewEnterAni(self.spr_hunging_start)

   -- actions[#actions + 1]  = cc.FadeIn:create(2)
    actions[#actions + 1]  = cc.DelayTime:create(2)
    actions[#actions + 1]  = cc.FadeOut:create(0.2)
    actions[#actions + 1]  = cc.CallFunc:create(function ( ... )
        self.spr_hunging_start:setVisible(false)
    end)
    actions[#actions + 1]  = cc.FadeIn:create(0.2)
    local fa = transition.sequence(actions)
    fa:setTag("808")
    self.spr_hunging_start:runAction(fa)
end

function MainLayer:showUnhunging()
    local actions = {}
    self.spr_hunging_cancel:stopActionByTag("808")
    self.spr_hunging_cancel:setVisible(true)
    self.spr_hunging_start:setVisible(false)
    SmallGamesGF.onViewEnterAni(self.spr_hunging_cancel)
    --actions[#actions + 1]  = cc.FadeIn:create(2)
    actions[#actions + 1]  = cc.DelayTime:create(2)
    actions[#actions + 1]  = cc.FadeOut:create(0.2)
    actions[#actions + 1]  = cc.CallFunc:create(function ( ... )
        self.spr_hunging_cancel:setVisible(false)
    end)
    actions[#actions + 1]  = cc.FadeIn:create(0.2)

    local fa = transition.sequence(actions)
    fa:setTag("808")
    self.spr_hunging_cancel:runAction(fa)
end

function MainLayer:onClickBetall()
    if not DogGI.ui_manager.betable then
        return
    end
    
    if DogGI.ui_manager.isPlaying then
        return
    end
    --self.all_bet_effect:play()
    for i = 1, 6 do
        DogGI.ui_manager:onClickDogRate(i)
        
    end
end

function MainLayer:onClickDogRate(obj)
    if not DogGI.ui_manager.betable then
        return
    end
    
    if DogGI.ui_manager.isPlaying then
        return
    end

    local i = tonumber(obj:getTag())

    
    DogGI.ui_manager:onClickDogRate(i)
end

function MainLayer:hideAll()
    SmallGamesGF.removeMsgBox()
    self:checkAndRemove(self.his)
    self:checkAndRemove(self.rule)
    self:checkAndRemove(self.animal_map)
    self:checkAndRemove(self.soundBox)
    self:checkAndRemove(DogGI.ui_manager.hangupDlg)
    DogGI.ui_manager:resume()
end

function MainLayer:checkAndRemove(obj)
    if obj ==nil then
        return
    end
    
    if obj:getParent() then
        obj:removeFromParent()
        obj = nil
    end
end

function MainLayer:onHistory(data)
    self.his_data = data
end

function MainLayer:showHistory()
    if not self.his_data then
        return
    end

    self.his = require(SmallGamesGF.getCurAppSrcPath("main.History.lua")).create()
    self.his:init(self.his_data)
    self.his:setPosition(DogGI.winSize.width/2, DogGI.winSize.height/2)
    self.his:retain()
    self:addChild(self.his)
end

function MainLayer:showRuleScene()
    self.rule = require(SmallGamesGF.getCurAppSrcPath("main.GameRule.lua")).create()
    self.rule:setPosition(DogGI.winSize.width/2, DogGI.winSize.height/2)
    self.rule:retain()
    self:addChild(self.rule)
end

function MainLayer:showSettings()
    self.soundBox = SmallGamesGF.createSoundBox()
    self.soundBox:setPosition(DogGI.winSize.width/2, DogGI.winSize.height/2)
    self.soundBox:retain()
    self.soundBox:setCallbackEnter(function ( ... )
        DogGI.ui_manager:pause()
    end)
    self.soundBox:setCallbackExit(function ( ... )
        DogGI.ui_manager:resume()
    end)
    self:addChild(self.soundBox)
end

function MainLayer:showAnimalMap()
    self.animal_map = require(SmallGamesGF.getCurAppSrcPath("main.AnimalMap.lua")).create()
    self.animal_map:setPosition(DogGI.winSize.width/2, DogGI.winSize.height/2)
    self.animal_map:init()
    self.animal_map:retain()
    self:addChild(self.animal_map)
end

function MainLayer:showShopLayer()
    if SmallGamesGI.lobbyName == nil then
        return
    end
    self.shop = SmallGamesGF.createShopLayer()
    self.shop:setPosition(DogGI.winSize.width/2, DogGI.winSize.height/2)
    self.shop:retain()
    self.shop:setCallbackEnter(function ( ... )
        DogGI.ui_manager:pause()
    end)
    self.shop:setCallbackExit(function ( ... )
        DogGI.ui_manager:resume()
        DogGI.ui_manager:PreCheckBeforePlay(DogGI.cur_money)
    end)
    self:addChild(self.shop)
end

local isOpen = false
function MainLayer:onClickExpand()
    if not DogGI.ui_manager.betable then
        return
    end

    if DogGI.ui_manager.isPlaying then
        return
    end
    self.ratio_list:setVisible(true)

    if isOpen then
        isOpen = false
        self:play("close", false)
        self.btn_expand:setRotation(180)
       -- self:play("hangup", true)
    else
        isOpen = true
        self:play("open", false)
        self.btn_expand:setRotation(0)
      --  self:play("hangup", true)
    end
end

function MainLayer:onClickRatio(obj)
    if not DogGI.ui_manager.betable then
        return
    end

    if DogGI.ui_manager.isPlaying then
        return
    end

    local name = obj:getName()
    local ratio
    if name == "btn_x100" then
        ratio = 100

    elseif name == "btn_x200" then
        ratio = 200

    elseif name == "btn_x500" then
        ratio = 500

    elseif name == "btn_x1000" then
        ratio = 1000
    end


    self:hideBetRatioList()
    if ratio == self:getRatio() then
        return
    end

    self:setRatio(ratio)
    DogGI.ui_manager:resetRatio()
end

function MainLayer:getRatio()
    return self.ratio
end

function MainLayer:setRatio(ratio)
    self.ratio = ratio
    self.fnt_total_rate:setString("x"..ratio)
    local x, y = self["btn_x" .. ratio]:getPosition()
    self.img_choice:setPosition(x, y)
end

function MainLayer:setTotalRate(ratio)
    self.fnt_rate:setString(ratio)
end

function MainLayer:onClickScrectSet()
    local aa = self.text_input:getString()
    local count = tonumber(aa)
    if count == nil then
        return
    end

    
    aa = self.text_input_0:getString()
    local secType = tonumber(aa)
    if secType == nil then
        return
    end

    self.secrect_count = count
    self.secrect = secType
    
    SmallGamesGI.RoomManager:sendSetPorp(self.secrect, self.secrect_count)
end

function MainLayer:onClickHide()
    self.node_test_data:removeFromParent()
end

function MainLayer:onTouchBegan(touch,event)
    self:hideBetRatioList()

    return true
end

function MainLayer:hideBetRatioList( ... )
    if isOpen then
        self:play("close", false)
        isOpen = false
        self.btn_expand:setRotation(180)
    end
end

return MainLayer
