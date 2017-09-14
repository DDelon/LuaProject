
local OptionTitle = class("OptionTitle", SmallGamesGMF.LoadPackages("mvc").ViewBase)

OptionTitle.AUTO_RESOLUTION   = true
OptionTitle.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiOptionTitle.lua")
OptionTitle.RESOURCE_BINDING  = {
    panel         = { parent = nil, varname = "panel" },
        pp         = { parent = "panel", varname = "pp" },
        btn_back          = { parent = "pp", varname = "btn_back", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickBack"} },
        btn_his           = { parent = "pp", varname = "btn_his", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickHis"} },
        btn_rule          = { parent = "pp", varname = "btn_rule", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickRule"} },
        btn_setting       = { parent = "pp", varname = "btn_setting", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickSetting"} },
        btn_pic           = { parent = "pp", varname = "btn_pic", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickAnimalMap"} },
            spr_tip           = { parent = "btn_pic", varname = "spr_tip" },

        img_gold_bg         = { parent = "panel", varname = "img_gold_bg" },
            btn_buy           = { parent = "img_gold_bg", varname = "btn_buy", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickBuyGold"} },
            txt_gold           = { parent = "img_gold_bg", varname = "txt_gold"},

            

        ldb_ex         = { parent = "panel", varname = "ldb_ex" },
            txt_point         = { parent = "ldb_ex", varname = "txt_point" },  
            spr_topLevel         = { parent = "ldb_ex", varname = "spr_topLevel" },
            img_ex         = { parent = "ldb_ex", varname = "img_ex" },
                txt_level         = { parent = "img_ex", varname = "txt_level" },  
            
            
--img_sub_title           = { parent = nil, varname = "img_sub_title" },    
}


function OptionTitle:onCreate()
    self.spr_tip:setVisible(false)
end

function OptionTitle:setGoldCount(count)
    self.txt_gold:setString(count)
end

function OptionTitle:setPointCount(count)
    local last = 0
    local vip_lv = 0
    local demand = 0
    for i,v in ipairs(DogGI.point_config.points) do
        if v.point_demand > count then
            demand = v.point_demand
            break
        end
        vip_lv = v.point_lv
        last = v.point_demand
    end
    local res = (count - last) .. "&" .. (demand - last)
    local float = (count - last)/(demand - last)
    self.txt_level:setString(vip_lv)
    self.ldb_ex:setPercent(float*100)
    self.txt_point:setString(res)
    if vip_lv == 9 then
        self.spr_topLevel:setVisible(true)
        self.txt_point:setVisible(false)
    end
end

function OptionTitle:onClickBack()
    print("onClickBack")
    if DogGI.main.start_animate_playing then
        return 
    end

    DogGI.main:onGameExit(SmallGamesGI.MsgBoxTYPE.TwoBtn, DogGI.language_config.exit)
end

function OptionTitle:onClickHis()
    if DogGI.main.start_animate_playing then
        return 
    end

    DogGI.main:showHistory()
end

function OptionTitle:onClickAnimalMap()
    if DogGI.main.start_animate_playing then
        return 
    end
    print("onClickPic")
    
    DogGI.main:showAnimalMap()
end

function OptionTitle:onClickRule()
    if DogGI.main.start_animate_playing then
        return 
    end

    print("onClickRule")
    DogGI.main:showRuleScene()
end

function OptionTitle:onClickSetting()
    if DogGI.main.start_animate_playing then
        return 
    end

    print("onClickSetting")
    DogGI.main:showSettings()
end

function OptionTitle:onClickBuyGold()
    if DogGI.main.start_animate_playing then
        return 
    end
    
    print("onClickBuyGold")
    DogGI.main:showShopLayer()
end

function OptionTitle:doHide()
    local size = self:getContentSize()
    local x, y = self.pp:getPosition()

    local act = {}
    act[#act + 1] = cc.MoveTo:create(0.5, cc.p(x,  y + 90))

    self.pp:runAction(transition.sequence(act))    
end

function OptionTitle:doShow()
    local size = self:getContentSize()
    local x, y = self.pp:getPosition()

    local act = {}
    act[#act + 1] = cc.MoveTo:create(0.5, cc.p(x,  y - 90))

    self.pp:runAction(transition.sequence(act))
end

    -- body
function OptionTitle:onTouchBegan( ... )
    return false
end

function OptionTitle:checkUnlockable()
    local isUnlockable = false
    local dogs = DogGI.dog_config.dogs
    local unlcoks = DogGI.config.unlockAnimals
    self.unlockable = false
    for i,dog in ipairs(dogs) do
        local dog_config = dogs[i]
        local isUnlock = false
        local unlockdata
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
                    isUnlockable = true
                end

            elseif dog_config.unlock_type == 2 then
                unlockdata = DogGI.vip_config:getLvByExp(dog_config.unlock_data)
                if DogGI.vipExp > dog_config.unlock_data then
                    isUnlockable = true
                end

            elseif dog_config.unlock_type == 3 then
                unlockdata = dog_config.unlock_data
                if DogGI.historyBet > dog_config.unlock_data then
                    isUnlockable = true
                end
            end
        end
    end

    if isUnlockable then
        self.spr_tip:setVisible(true)
    else
        self.spr_tip:setVisible(false)
    end
end

return OptionTitle
