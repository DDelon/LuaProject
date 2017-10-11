
local AnimalMap = class("AnimalMap", SmallGamesGMF.LoadPackages("mvc").ViewBase)

AnimalMap.AUTO_RESOLUTION   = true
AnimalMap.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiAnimalMap.lua")
AnimalMap.RESOURCE_UNLOCK_ANIMAL = SmallGamesGF.getCurAppResPath("animal/")
AnimalMap.RESOURCE_BINDING  = {    
    panel         = { parent = nil, varname = "panel" },    
    bg            = { parent = "panel", varname = "bg" },        
    btn_close     = { parent = "bg", varname = "btn_close", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickClose"} },
}


function AnimalMap:onCreate()
    DogGI.ui_manager:pause()
    
end

function AnimalMap:init()
    local dogs = DogGI.dog_config.dogs

    local unlcoks = DogGI.config.unlockAnimals
    
    for i,dog in ipairs(dogs) do
        local item = self.panel:getChildByName("animal_" .. i)

        local btnItem = item:getChildByName("animal_1")
        
        btnItem:getChildByName("img_rate"):getChildByName("fnt_rate"):setString("x" .. dog.score)
        btnItem:getChildByName("img_head"):loadTexture(SmallGamesGF.getCurAppResPath("animal/") .. dog.res .. ".png")
        local isUnlock = false
        for k,v in pairs(unlcoks) do
            if i == (v + 0) then
                isUnlock = true
                btnItem:getChildByName("img_grey"):setVisible(false)
                btnItem:getChildByName("race_bg_lock_0"):setVisible(false)
                btnItem:getChildByName("race_bg_lock_1_3"):setVisible(false)
            end
        end
        --[[
        
    DogGI.cur_point = data.point
    DogGI.historyBet = data.historyBet
    DogGI.vipExp = data.vipExp
        ]]
        btnItem:addClickEventListener(function()
                local dog_config = DogGI.dog_config.dogs[i]
                local toast 
                local toast2
                local unlockdata
                if dog_config.unlock_type == 0 or isUnlock then
                    return
                elseif dog_config.unlock_type == 1 then
                    toast = DogGI.language_config.point
                    toast2 = DogGI.language_config.point2
                    unlockdata = dog_config.unlock_data
                    if DogGI.cur_point > DogGI.point_config:getLvByPoint(dog_config.unlock_data) then
                        SmallGamesGI.RoomManager:sendUnlock(i,dog_config.unlock_type)

                        return
                    end

                elseif dog_config.unlock_type == 2 then
                    toast = DogGI.language_config.vip
                    toast2 = DogGI.language_config.vip2
                    unlockdata = DogGI.vip_config:getLvByExp(dog_config.unlock_data)
                    if DogGI.vipExp > dog_config.unlock_data then
                        SmallGamesGI.RoomManager:sendUnlock(i,dog_config.unlock_type)

                        return
                    end

                elseif dog_config.unlock_type == 3 then
                    toast = DogGI.language_config.money
                    toast2 = DogGI.language_config.money2
                    unlockdata = dog_config.unlock_data
                    if DogGI.historyBet > dog_config.unlock_data then
                        SmallGamesGI.RoomManager:sendUnlock(i,dog_config.unlock_type)

                        return
                    end

                end

                if dog_config.unlock_gold == -1 then
                    local size = self:getContentSize()
                    local s_format = string.format( toast, unlockdata )
                    SmallGamesGF.createMsgBox(SmallGamesGI.MsgBoxTYPE.oneBtn, s_format)
                    return
                end

                local s_format = string.format( toast2, unlockdata, dog_config.unlock_gold)

                SmallGamesGF.createMsgBox(SmallGamesGI.MsgBoxTYPE.TwoBtn, s_format, function (obj, btnType)
                if btnType == SmallGamesGI.MsgBoxBtns.CloseBtn then
                elseif btnType == SmallGamesGI.MsgBoxBtns.FirstBtn then
                    if DogGI.cur_money < dog_config.unlock_gold then
                        SmallGamesGF.createMsgBox(SmallGamesGI.MsgBoxTYPE.TwoBtn, DogGI.language_config.money_no_enough, function ( ... )
                        end)

                        return
                    end
                    SmallGamesGI.RoomManager:sendUnlock(i, 4)
                    DogGI.pre_consume = dog_config.unlock_gold
                    DogGI.cur_money = DogGI.cur_money - dog_config.unlock_gold
                    DogGI.main.node_title_bar:setGoldCount(DogGI.cur_money)

                    --obj:removeFromParent()
                elseif btnType == SmallGamesGI.MsgBoxBtns.SecondBtn then

                    return 
                end

                end)

                print("unlock failed")
                return
        end)
    end

    self:checkUnlockable()
end

function AnimalMap:onUnlock(data)
    if data.success == 0 then
        DogGI.cur_money = DogGI.cur_money + DogGI.pre_consume
        DogGI.main.node_title_bar:setGoldCount(DogGI.cur_money)
        DogGI.pre_consume = 0
        return
    end

    local animalId = data.animalId
    local unlcoks = DogGI.config.unlockAnimals
    unlcoks[#unlcoks + 1] = animalId

    DogGI.main.node_title_bar:checkUnlockable()
    DogGI.pre_consume = 0

    local item = self.panel:getChildByName("animal_" .. animalId)
    item:getChildByName("animal_1"):getChildByName("spr_tip"):setVisible(false)
    item.animation:play("unlock", false)
    local config = DogGI.dog_config.dogs[animalId]

    local delayRun = {}
    delayRun[#delayRun + 1] = cc.DelayTime:create(1.25)
    delayRun[#delayRun + 1] = cc.CallFunc:create(function ( ... )
        local result = require(SmallGamesGF.getCurAppSrcPath("animation.Unlock")).create()
        result:setRate(config.score)
        result:loadImage(AnimalMap.RESOURCE_UNLOCK_ANIMAL .. config.res.. ".png")
        self:addChild(result)
    end)

    self:runAction(transition.sequence(delayRun))
end

function AnimalMap:onClickClose( ... )
    self:onQuit()
    --self:removeFromParent()
    self:release()
    DogGI.ui_manager:resume()
    DogGI.main.animal_map = nil
end

function AnimalMap:onEnterAni()
    self:enterAni(self.panel)
end

function AnimalMap:onExitAni()
    self:exitAni(self.panel)
end

function AnimalMap:checkUnlockable()
    local dogs = DogGI.dog_config.dogs
    local unlcoks = DogGI.config.unlockAnimals
    self.unlockable = false
    for i,dog in ipairs(dogs) do
        local dog_config = DogGI.dog_config.dogs[i]
        local unlockdata
        local item = self.panel:getChildByName("animal_" .. i)
        local btnItem = item:getChildByName("animal_1")
        btnItem:getChildByName("spr_tip"):setVisible(false)

        local isUnlock = false
        for k,v in pairs(unlcoks) do
            if i == (v + 0) then
                isUnlock = true
            end
        end

        if not isUnlock then
            if dog_config.unlock_type == 0 or isUnlock then
                return
            elseif dog_config.unlock_type == 1 then
                unlockdata = dog_config.unlock_data
                if DogGI.cur_point > DogGI.point_config:getLvByPoint(dog_config.unlock_data) then
                    btnItem:getChildByName("spr_tip"):setVisible(true)
                    self.unlockable = true
                end

            elseif dog_config.unlock_type == 2 then
                unlockdata = DogGI.vip_config:getLvByExp(dog_config.unlock_data)
                if DogGI.vipExp > dog_config.unlock_data then
                    btnItem:getChildByName("spr_tip"):setVisible(true)
                    self.unlockable = true
                end

            elseif dog_config.unlock_type == 3 then
                unlockdata = dog_config.unlock_data
                if DogGI.historyBet > dog_config.unlock_data then
                    btnItem:getChildByName("spr_tip"):setVisible(true)
                    self.unlockable = true
                end
            end
        end
    end

    return self.unlockable
end

return AnimalMap
