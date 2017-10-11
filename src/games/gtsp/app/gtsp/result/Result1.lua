local ResultAnimate = class("ResultAnimate", SmallGamesGMF.LoadPackages("mvc").ViewBase)

ResultAnimate.AUTO_RESOLUTION   = true
ResultAnimate.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiResult1.lua")
ResultAnimate.RESOURCE_BINDING  = {    
    panel         = { parent = nil, varname = "panel" },    
    photo            = { parent = "panel", varname = "photo" },    
    img_gold            = { parent = "panel", varname = "img_gold" },
        fnt_money            = { parent = "img_gold", varname = "fnt_money" },
            prop_001            = { parent = "fnt_money", varname = "prop_001" },
        fnt_point            = { parent = "img_gold", varname = "fnt_point" },
        
    fnt_rate            = { parent = "panel", varname = "fnt_rate" },

}


function ResultAnimate:onCreate()
    self:runAction(self.resourceNode_.animation)
    self.prop_001:initWithFile(SmallGamesGI.extend_res_path.."/"..SmallGamesGI.extend_money_prop_res)
    self:play("star_", false)
    local frameEventCallFunc = function (frameEventName)
        if frameEventName:getEvent() == "on_end" then
            DogGI.main:playDark()
            
            local actions = {}
            actions[#actions + 1] = cc.DelayTime:create(1)
            actions[#actions + 1] = cc.CallFunc:create(function ( ... )
                self:getParent():removeFromParent()
                self.funcEnd()
            end)
            self:getParent():runAction(transition.sequence(actions))
        end
    end
    self.resourceNode_["animation"]:clearFrameEventCallFunc()
    self.resourceNode_["animation"]:setFrameEventCallFunc(frameEventCallFunc)
end

function ResultAnimate:onClickClose( ... )
    self:setVisible(false)
end

function ResultAnimate:setAnimal( spr , parent)
    local wSrcX, wSrcY = spr:getPosition()

    local x, y = self:getPosition()
    local x1, y1 = self.photo:getPosition()
    
    local aMove = {}
    aMove[#aMove + 1] = cc.MoveTo:create(0.66, cc.p(x + x1, y + y1))

    local aRotate = {}
    aRotate[#aRotate + 1] = cc.RotateBy:create(0.66, -365)

    local action =  cc.Spawn:create(transition.sequence(aMove), transition.sequence(aRotate))

    local actions = {}
    actions[#actions + 1] = action
    actions[#actions + 1] = cc.CallFunc:create(function ( ... )
        local path = SmallGamesGF.getCurAppResPath("sound/finish_01.mp3")
        AudioEngine.playEffect(path)
        spr:release()
        spr:removeFromParent()
        local size = self.photo:getContentSize()
        spr:setRotation(0)
        spr:setPosition(size.width/2, size.height/2)
        self.photo:addChild(spr)
    end)

    spr:runAction(transition.sequence(actions))
    DogGI.main.resourceNode_.root:addChild(spr,100)
end

function ResultAnimate:setRate(rate)
    self.fnt_rate:setString("x" .. rate)
end

function ResultAnimate:setMoney(money, origin, point, deltPoint)
    local period = 1
    local total = 0
    local scheduler = cc.Director:getInstance():getScheduler()
    self.schedulerID = scheduler:scheduleScriptFunc(function(dt)
        total = total + dt

        if total > period then
            self.fnt_money:setString(money)
            self.fnt_point:setString(deltPoint)
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            self.schedulerID = nil

            local px, py = self:getPosition()
            local baseX, baseY = self.img_gold:getPosition()
            
            local pTargetX, pTargetY = DogGI.main.node_title_bar:getPosition()
            local size = DogGI.main.node_title_bar.panel:getContentSize()
            local targetX, targetY = DogGI.main.node_title_bar.img_gold_bg:getPosition()

            for i = 1, 5 do
                local coin = self:generateCoinAnimate(baseX + px, baseY + py, 0.12 * i, i, 1, pTargetX - size.width/2 + targetX, pTargetY - size.height/2 + targetY)
                DogGI.main:addChild(coin)
            end

            self:runTitle(origin, point, money, deltPoint)

            return 
        end

        local percentage = (total)/period
        local count = math.floor(money*percentage)
        self.fnt_money:setString(count)
        count = math.floor(deltPoint*percentage)
        self.fnt_point:setString(count)
    end,0,false)
end

ResultAnimate.SchedulerId = nil
function ResultAnimate:runTitle(o_money, o_point, del_money, del_point)
    local delay = 0.6 + 0.83
    local sub_period = 1
    local sub_total = 0
    local action = {}
    action[#action + 1] = cc.DelayTime:create(delay)
    action[#action + 1] = cc.CallFunc:create(function ( ... )
        ResultAnimate.SchedulerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (dt)
            sub_total = sub_total + dt
            if sub_total > sub_period then
                DogGI.main.node_title_bar:setGoldCount(o_money + del_money)
                DogGI.main.node_title_bar:setPointCount(o_point + del_point)
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(ResultAnimate.SchedulerId)
                self.sub_schId = -1
                return 
            end

            local sub_per = (sub_total)/sub_period
            local count = math.floor(del_money*sub_per)
            DogGI.main.node_title_bar:setGoldCount(o_money + count)
            count = math.floor(del_point*sub_per)
            DogGI.main.node_title_bar:setPointCount(o_point + count)
        end, 0, false)
    end)
    self:runAction(transition.sequence(action))

    return
end

function ResultAnimate:generateCoinAnimate(baseX, baseY, baseDelay, rx, ry, dstX, dstY)
    local coin = self:getCoinImg()
            
    coin:setPosition(baseX + (rx - 1)*60 , baseY)

    coin:runAction(self:CoinAnimate_1stAction(baseDelay))
    coin:runAction(self:CoinAnimate_2ndAction(baseDelay))
    coin:runAction(self:CoinAnimate_3rdAction(baseDelay + 0.21))
    coin:runAction(self:CoinAnimate_4thAction(baseDelay + 0.41))
    coin:runAction(self:CoinAnimate_5thAction(baseDelay + 0.83))

    local moveAcion = cc.EaseExponentialIn:create(cc.MoveTo:create(0.75, cc.p(dstX, dstY)))

    local actions = {}
    actions[#actions + 1] = cc.DelayTime:create(baseDelay + 0.83) 
    actions[#actions + 1] = moveAcion
    actions[#actions + 1] = cc.RemoveSelf:create()
    
    coin:runAction(transition.sequence(actions))
    return coin
end

function ResultAnimate:CoinAnimate_1stAction(delayTime)
    local action = {}
    action[#action + 1] = cc.Show:create()
    action[#action + 1] = cc.DelayTime:create(delayTime)
    action[#action + 1] = cc.ScaleTo:create(0.54, 1)

    return transition.sequence(action)
end

function ResultAnimate:CoinAnimate_2ndAction(delayTime)
    local action = {}
    action[#action + 1] = cc.DelayTime:create(delayTime)
    action[#action + 1] = cc.MoveBy:create(0.21, cc.p(0, 88))

    return transition.sequence(action)
end

function ResultAnimate:CoinAnimate_3rdAction(delayTime)
    local action = {}
    action[#action + 1] = cc.DelayTime:create(delayTime)
    action[#action + 1] = cc.MoveBy:create(0.20, cc.p(0, -103))

    return transition.sequence(action)
end

function ResultAnimate:CoinAnimate_4thAction(delayTime)
    local action = {}
    action[#action + 1] = cc.DelayTime:create(delayTime)
    action[#action + 1] = cc.MoveBy:create(0.13, cc.p(0, 27))

    return transition.sequence(action)
end

function ResultAnimate:CoinAnimate_5thAction(delayTime)
    local action = {}
    action[#action + 1] = cc.DelayTime:create(delayTime)
    action[#action + 1] = cc.ScaleTo:create(0.75, 0.7)

    return transition.sequence(action)
end

function ResultAnimate:getCoinImg()
    local coin = cc.Sprite:create(SmallGamesGI.extend_res_path.."/"..SmallGamesGI.extend_money_prop_res)
    local action = cc.RepeatForever:create(cc.Animate:create(DogGI.preload:getCoin()))
    coin:setVisible(false)
    coin:runAction(action)
    
    return coin
end

function ResultAnimate:play(type, loop)
    self.resourceNode_.animation:play(type, loop)
end

function ResultAnimate:setEndCallFunc(funcEnd)
    self.funcEnd = funcEnd
end

return ResultAnimate
