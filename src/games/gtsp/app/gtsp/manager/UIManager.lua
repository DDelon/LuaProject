local UIManager = class("UIManager", nil)

UIManager.RESOURCE_PATH = SmallGamesGF.getCurAppResPath("run/")
UIManager.RESOURCE_COMMON = SmallGamesGF.getCurAppResPath("common/")
UIManager.TRACE_NUM = 6

UIManager.LAYER_INDEX = {
    ["panel_trace"] = 7,
    ["title_back"] = 5,
    ["title_front"] = 9,
    ["title_opotion"] = 10,
    ["panel_main"] = 8,
    ["panel_running"] = 11,
    ["clip"] = 99,
    ["note_tittle"] = 100,
    ["note_test"] = 101,
    
    ["toast"] = 102,
    ["sub_title"] = 9
}

function UIManager:create( ... )
    local dm = UIManager.new()
    
    dm:initConfig()
    dm:initDog()
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))  

    dm.dogs = {}
    dm.run_count = 0
    return dm
end

function UIManager:initUI(mainScene)
    self.mainUI = mainScene
    self.mainUI.panel_running:setLocalZOrder(UIManager.LAYER_INDEX.panel_running)
    self.mainUI.panel_main:setLocalZOrder(UIManager.LAYER_INDEX.panel_main)
    self.mainUI.node_title_bar:setLocalZOrder(UIManager.LAYER_INDEX.title_opotion)
    self.mainUI.panel_racetrack:setLocalZOrder(UIManager.LAYER_INDEX.panel_trace)
    self.mainUI.node_title_bar:setLocalZOrder(UIManager.LAYER_INDEX.note_tittle)
    self.mainUI.node_test_data:setLocalZOrder(UIManager.LAYER_INDEX.note_test)
    self.mainUI.img_sub_title:setLocalZOrder(UIManager.LAYER_INDEX.sub_title)
    self.mainUI.spr_hunging_start:setLocalZOrder(UIManager.LAYER_INDEX.toast)
    self.mainUI.spr_hunging_cancel:setLocalZOrder(UIManager.LAYER_INDEX.toast)
    self:initPos()
    self:setRatio(100)
end

function UIManager:PreCheckBeforePlay( money )
    if money < DogGI.config.enter_condition then
        self:pause()
        local condition_money = string.format(DogGI.language_config.enter_condition_no_satisfy, DogGI.config.enter_condition)
        SmallGamesGF.createMsgBox2(nil, UIManager.RESOURCE_COMMON .. "com_btn_tc.png", SmallGamesGI.MsgBoxTYPE.TwoBtn, condition_money, function (obj, btnType)
            self:resume()
            if btnType == SmallGamesGI.MsgBoxBtns.CloseBtn then
                SmallGamesGF.exitApp()

            elseif btnType == SmallGamesGI.MsgBoxBtns.FirstBtn then
                DogGI.main:showShopLayer()

            elseif btnType == SmallGamesGI.MsgBoxBtns.SecondBtn then
                SmallGamesGF.exitApp()

            end
        end)
    end
end

function UIManager:onReady(data)
    self.dogs = {}
    
    if not self.betInfos then -- 为空或者挂机清空
        self.betInfos = {{}, {}, {}, {}, {}, {}}
    end
    
    if self.run_count >= 10 then
        self.mainUI:onGameExit(SmallGamesGI.MsgBoxTYPE.OneBtn, DogGI.language_config.to_long_no_operate)
        return
    end

    self:PreCheckBeforePlay(data.money)

    local baseY = 0.585
    local baseDeltY = 0.099
    self.dogTab = data.animals
    DogGI.config.unlockAnimals = data.unlockAnimals
    self.preparing = true
    DogGI.cur_money = data.money
    DogGI.cur_point = data.point
    DogGI.historyBet = data.historyBet
    DogGI.vipExp = data.vipExp

    for i = 1, #self.dogTab  do
        local start_y_offset = DogGI.dog_config.dogs[self.dogTab[i]].y_offset
        self.dogs[i] = self.all_dogs[self.dogTab[i]]
        self.dogs[i]:getAnimation():play("run",-1, 1)
        self.dogs[i]:setPosition(0 , baseY*DogGI.winSize.height - i * baseDeltY*DogGI.winSize.height + DogGI.winSize.height*baseDeltY*start_y_offset/100)

        self.betInfos[i].id = self.dogTab[i]
        if not self.mainUI.isHunging then
            self.betInfos[i].count = 0
        end
        self.betInfos[i].score = DogGI.dog_config.dogs[self.dogTab[i]].score

        local ams = self:getStartAnimate(i)
        self.mainUI:runAction(ams)
    end

    local path = SmallGamesGF.getCurAppResPath("music/bgm_stay01.mp3")
    AudioEngine.playMusic(path, false)

    if not self.mainUI.isHunging then
        self:resetRatio()
    end

    --self:refreshCurTotalBet()

    self.mainUI.node_title_bar:setGoldCount(DogGI.cur_money)
    self.mainUI.node_title_bar:setPointCount(DogGI.cur_point)
    self.mainUI.node_title_bar:checkUnlockable()
    self:resetLine()
end

local enterAnimate = {
    {["time"] = 2, ["count"] = 40},
    {["time"] = 2.5, ["count"] = 50},
    {["time"] = 3, ["count"] = 60},
    {["time"] = 3.5, ["count"] = 70},
    {["time"] = 4, ["count"] = 80},
    {["time"] = 4.5, ["count"] = 90}
}

function UIManager:getUniqueRondom(last)

    local random = math.random(1, 16)
    if last == random then
        return self:getUniqueRondom(last)
    end

    return random
end

function UIManager:getStartAnimate(i)
    local animate = {}
    local baseFrameRate = self:getFrameRateByRace(i)
    local last = 0
    self.mainUI:disableClick()
    animate[#animate + 1] = cc.CallFunc:create(function ( ... )
        DogGI.main["bet_stake_effect" .. i]:play()
    end)
    for a =1 , enterAnimate[i].count do
        animate[#animate + 1] = cc.CallFunc:create(function ( ... )
            local random = self:getUniqueRondom(last)
            self.mainUI["btn_dog_head_" .. i]:getChildByName("img_head"):loadTexture(UIManager.RESOURCE_COMMON .. "com_pic_photo_".. random .. ".png")
            self.mainUI["fnt_rate_"..i]:setString("x" .. DogGI.dog_config.dogs[random].score)
            last = random
            
            if i == UIManager.TRACE_NUM then
                local path = SmallGamesGF.getCurAppResPath("sound/rolling_01.mp3")
                AudioEngine.playEffect(path)
            end
        end)
        animate[#animate + 1] = cc.DelayTime:create(enterAnimate[i].time/enterAnimate[i].count)
    end

    animate[#animate + 1] = cc.CallFunc:create(function ( ... )
    
        local color = {r = 255, g = 255, b = 255}
        self.mainUI["btn_dog_head_" .. i]:setEnabled(enable)
        self.mainUI["btn_dog_head_" .. i]:setColor(color)

        DogGI.main["bet_stake_effect" .. i]:stop()
        self.mainUI["btn_dog_head_" .. i]:getChildByName("img_head"):loadTexture(UIManager.RESOURCE_COMMON .. "com_pic_photo_".. self.dogTab[i] .. ".png")
        self.mainUI["fnt_rate_" .. i]:setString("x" .. self.betInfos[i].score)
    end)

    animate[#animate + 1] = cc.CallFunc:create(function ( ... )
        self.mainUI.panel_running:addChild(self.dogs[i],  i)
        local x, y = self.dogs[i]:getPosition()
        local action_move_to  = {}
        action_move_to[#action_move_to + 1] = cc.CallFunc:create(function ( ... )
            self.dogs[i]:getAnimation():setSpeedScale(baseFrameRate)
            self.dogs[i]:getAnimation():play("running",-1, 1)
        end)
        action_move_to[#action_move_to + 1] = cc.MoveTo:create(0.5,cc.p(DogGI.config.start_x * DogGI.winSize.width/100, y))
        action_move_to[#action_move_to + 1] = cc.CallFunc:create(function ( ... )
            self.dogs[i]:getAnimation():setSpeedScale(baseFrameRate)
            self.dogs[i]:getAnimation():play("loading",-1, 1)
        end)

        if i == UIManager.TRACE_NUM then -- 最后一个
            self.preparing = false
            action_move_to[#action_move_to + 1] = cc.CallFunc:create(function ()
    

                self.mainUI:enableClick()
                self:tryRefreshTotalBetOrClear()
                if self.mainUI.isHunging then
                    self.mainUI:onClickStart()
                    return
                end

                if not self.isRunning then -- 如果已经开始泡了, 就不要播这个动画了
                    self:startBetCountingDown()
                end
            end)
        end
        self.dogs[i]:runAction(transition.sequence(action_move_to))

        self.mainUI["btn_dog_head_" .. i]:getChildByName("img_head"):loadTexture(UIManager.RESOURCE_COMMON .. "com_pic_photo_".. self.dogTab[i] .. ".png")

     end)

    return transition.sequence(animate)
end

function UIManager:tryRefreshTotalBetOrClear() -- 如果刷新失败, 重置倍率, 挂机的情况下, 没钱了, 重置退出挂机状态
    if self:refreshCurTotalBet() then
        return
    end

    self.mainUI:onClickHungup()
    self:resetRatio()
    self:refreshCurTotalBet()
end

function UIManager:setCountDown(number)
    self.mainUI.img_bg_counting_down:setString(number)
end

function UIManager:startBetCountingDown()
    self:resetRatio()
    local start_time = os.clock()
    local times = 1
    local action1 = {}
    action1[#action1 + 1] = cc.CallFunc:create(function ( ... )
        self.betable = true
        self.mainUI.img_bg_counting_down:start()
    end)

    self:setCountDown(DogGI.config.bet_countdown)
    local actions = {}
    actions[#actions + 1] = cc.DelayTime:create(1)
    actions[#actions + 1] = cc.CallFunc:create(function ( ... )
        local current = os.clock()
        --print("current - last_time ".. (current - start_time))
        if (current - start_time) < times then
            return
        end

        self:setCountDown(DogGI.config.bet_countdown - times)
        if times == DogGI.config.bet_countdown then
            self.betable = false
            self.mainUI.img_bg_counting_down:stop()
            self.mainUI.img_bg_counting_down:stopActionByTag("999")
            self.mainUI:onClickStart()
            return 
        else

        end
        times = times + 1
        
    end)

    local repeats = cc.Repeat:create(transition.sequence(actions), 100)
    local action_total = {}
    action_total[#action_total + 1] = transition.sequence(action1)
    action_total[#action_total + 1] = repeats
    local seq = transition.sequence(action_total)
    seq:setTag("999")
    self.mainUI.img_bg_counting_down:runAction(seq)
end

function UIManager:getBeginInfo()
    local startInfo = {}
    local betInfos = {}
    for k,v in pairs(self.betInfos) do
        local betInfo = {}
        betInfo.animalId = v.id
        betInfo.count = v.count

        betInfos[#betInfos + 1] = betInfo
    end
    startInfo.betInfos = betInfos
    startInfo.rate = self:getRatio()

    self.lastRate = startInfo.rate

    return startInfo
end

function UIManager:getRatio()
    return self.mainUI:getRatio()
end

function UIManager:setRatio(ratio)
    return self.mainUI:setRatio(ratio)
end

function UIManager:setBetCount(index, count)
    self.mainUI["fnt_count_" .. index]:setString(count)
end

function UIManager:doRun(data, funAfterRun)
    
    AudioEngine.stopMusic()
    local path = SmallGamesGF.getCurAppResPath("music/bgm_run01.mp3")
    AudioEngine.playMusic(path, false)    
    
    if not self:isBet() then
        self.run_count = self.run_count + 1
    else
        self.run_count = 0
    end

    self.isRunning = true
    self:doRunDog(data.winId + 1, function ( ... )
        self.isRunning = false 
        for i,v in ipairs(self.dogs) do
            v:removeFromParent()
        end
        
        SmallGamesGI.RoomManager:sendGameOver()
        local info = self:getLvConfigByPoint(data.newPoint)
        if info.point_lv > self:getLvConfigByPoint(DogGI.cur_point).point_lv then
            local pu = require(SmallGamesGF.getCurAppSrcPath("animation.PointUpgrade")).create()
            pu:setLevel(info.point_lv)
            pu:setReward(info.item_num)
            pu:setPosition(DogGI.winSize.width/2, DogGI.winSize.height/2)
            self.mainUI:addChild(pu)

            local remove = {}
            remove[#remove + 1] = cc.DelayTime:create(3)
            remove[#remove + 1] = cc.CallFunc:create(function ( ... )
                pu:removeFromParent()
                funAfterRun()
            end)

            self.mainUI:runAction(transition.sequence(remove))
            
            DogGI.cur_money = data.newMoney + info.item_num
            DogGI.cur_point = data.newPoint
            DogGI.main.node_title_bar:setGoldCount(DogGI.cur_money)
            return
        end

        DogGI.cur_money = data.newMoney
        DogGI.cur_point = data.newPoint
        funAfterRun()
    end, data.newMoney, DogGI.cur_point, data.newPoint - DogGI.cur_point)
    self:doRunScene()
end

function UIManager:getLvConfigByPoint(point)
    local vip_lv = nil
    local demand = 0
    for i,v in ipairs(DogGI.point_config.points) do
        if v.point_demand > point then
            demand = v.point_demand
            break
        end
        vip_lv = v
    end
    if vip_lv == nil then
        vip_lv = {}
        vip_lv.point_lv = 0
    end

    return vip_lv
end

function UIManager:doRunDog(winId, functEndPlay, money, point, deltPoint)
    local actionMaps = {{}, {} , {}, {}, {}, {}}

    local run_part_config = DogGI.config.running_part_config

    self.all_round_pos = {}
    self.all_round_time = {}
    self.dograte = {0, 0, 0, 0, 0, 0}
    local last_time = {0, 0, 0, 0, 0, 0}
    for i,v in ipairs(run_part_config) do
        local times =  self:genRandom(DogGI.config.min_time_offset, DogGI.config.max_time_offset, UIManager.TRACE_NUM, 1000, v.time, i == #run_part_config)
        local positions = self:generateRandomArray(v.min, v.max, UIManager.TRACE_NUM)
        
        if i > #run_part_config - 2 then -- winner 最后2次到前三
            self:specialDeal(positions, winId, i == #run_part_config)
        end

        self.all_round_pos[#self.all_round_pos + 1] = positions
        self.all_round_time[#self.all_round_time + 1] = times
        self:decorMove(actionMaps, positions, self.all_round_pos[#self.all_round_pos - 1], times, last_time)
        last_time = times
    end

    for i =1 , 6 do
            --print("---------------------------- index: " .. i)
        for j,poses in ipairs(self.all_round_pos) do
            --print("position: " .. poses[i])
        end
            --print("-----------------------------------------")
    end


    for i = 1, UIManager.TRACE_NUM do
        self:decorStop(actionMaps[i], i, functEndPlay, winId, money, point, deltPoint)
        local baseFrameRate = self:getFrameRateByRace(i)
        self.dogs[i]:getAnimation():setSpeedScale(baseFrameRate)
        self.dogs[i]:getAnimation():play("run", -1, 1)
        self.dogs[i]:runAction(transition.sequence(actionMaps[i]))
    end
end

function UIManager:decorStop(actionMap, dogIndex, functEndPlay, winId, money, point, deltPoint)
    actionMap[#actionMap + 1] = cc.CallFunc:create(function ( ... )
        local baseFrameRate = self:getFrameRateByRace(dogIndex)
        self.dogs[dogIndex]:getAnimation():setSpeedScale(baseFrameRate *0)
        AudioEngine.stopMusic()
        
        if dogIndex == winId then
            
            AudioEngine.stopMusic()
            local path = SmallGamesGF.getCurAppResPath("sound/camera_01.mp3")
            AudioEngine.playEffect(path)

            local scaleW = DogGI.winSize.width / 1280
            local scaleH = DogGI.winSize.height / 720

            local scale = scaleW
            if scale < scaleH then
                scale = scaleH
            end
            
            local baseWidth = 50 * scale-- 凭感觉定的
            local baseHeight = 170 * scaleH --

            local width = 200 * scale
            local height = 150 * scale
            local rect = self.dogs[winId]:getContentSize()

            local x, y = self.dogs[dogIndex]:getPosition()
            self.clip = cc.ClippingNode:create()
            local blackLayer = cc.LayerColor:create(cc.c4b(0,0,0,180))
            self.clip:addChild(blackLayer)

            local stencil = cc.Sprite:create(UIManager.RESOURCE_COMMON .. "com_pic_photo_1.png", cc.rect(0,0,width, height))
            stencil:setAnchorPoint(1,0)
            stencil:setPosition(x + baseWidth, baseHeight + y)
            self.clip:setStencil(stencil)
            self.clip:setInverted(true)


            local rt = cc.RenderTexture:create(DogGI.winSize.width, DogGI.winSize.height)
            rt:beginWithClear(0,0,0,0)
            self.mainUI.resourceNode_.root:visit()
            rt:endToLua()

            self.win_spr = cc.Sprite:createWithTexture(rt:getSprite():getTexture(), cc.rect(x+baseWidth - width, baseHeight+y,width,height))
            self.win_spr:setPosition(x+baseWidth - width/2, baseHeight+y + height/2)
            self.win_spr:setFlippedY(true)
            self.win_spr:retain()
            self.mainUI.resourceNode_.root:addChild(self.clip, 99)
        end
    end)
    actionMap[#actionMap + 1] = cc.DelayTime:create(0.3)
    local result
    actionMap[#actionMap + 1] = cc.CallFunc:create(function ( ... )
            if dogIndex == winId then
                local type = 1
                local info = self.betInfos[winId]
                local total = tonumber(info.score) * info.count* self.lastRate
                local deltY = 0
                if total > 2000 then
                    type = 2
                    deltY = deltY + 30
                elseif total > 0 then
                    type = 1
                else
                    type = 3

                    local delayCallFunc = {}
                    delayCallFunc[#delayCallFunc + 1] = cc.DelayTime:create(0.8)
                    delayCallFunc[#delayCallFunc + 1] = cc.CallFunc:create(function ( ... )
                        self.mainUI:playDark()
                    end)
                    delayCallFunc[#delayCallFunc + 1] = cc.DelayTime:create(1)
                    delayCallFunc[#delayCallFunc + 1] = cc.CallFunc:create(function ( ... )
                        functEndPlay()
                        self.clip:removeFromParent()
                    end)
                    delayCallFunc[#delayCallFunc + 1] = cc.DelayTime:create(0.5)
                    delayCallFunc[#delayCallFunc + 1] = cc.CallFunc:create(function ( ... )
                    end)

                    self.clip:runAction(transition.sequence(delayCallFunc))
                    return
                end
                
                result = require(SmallGamesGF.getCurAppSrcPath("result.Result" .. type)).create()
                result:setPosition(DogGI.winSize.width/2, DogGI.winSize.height/2 + deltY)
                result:setAnimal(self.win_spr, self.clip)
                local delayCallFunc = {}
                delayCallFunc[#delayCallFunc + 1] = cc.DelayTime:create(0.8)
                delayCallFunc[#delayCallFunc + 1] = cc.CallFunc:create(function ( ... )
                    result:setMoney(total, money - total, point, deltPoint)
                end)

                self.clip:runAction(transition.sequence(delayCallFunc))
                
                result:setRate(DogGI.dog_config.dogs[self.dogTab[winId]].score)
                self.clip:addChild(result)

                result:setEndCallFunc(functEndPlay)
                -- 设置title的金钱和积分
            end
    end)
end

function UIManager:getFrameRateByRace(trace) 
    return (DogGI.dog_config.dogs[self.dogTab[trace]].base_frame + 0)/100
end

function UIManager:doRunScene()
    local scheduler = cc.Director:getInstance():getScheduler()
    self.game_time = 0
    self.schedulerID = scheduler:scheduleScriptFunc(function(dt)
        self:updataScenePos(dt)
    end,0,false)
end

function UIManager:initPos()
    self.mainUI.panel_racetrack_0 = self:cloneTraceEle(self.mainUI.panel_racetrack, UIManager.LAYER_INDEX.panel_trace)
    self.panels = {}
    self.panels[1] = self.mainUI.panel_racetrack
    self.panels[2] = self.mainUI.panel_racetrack_0

    self.mainUI.img_title_back_0 = self:cloneTraceEle(self.mainUI.img_title_back, UIManager.LAYER_INDEX["title_back"])
    self.tt_backs = {}
    self.tt_backs[1] = self.mainUI.img_title_back
    self.tt_backs[2] = self.mainUI.img_title_back_0

    self.mainUI.img_title_forge_0 = self:cloneTraceEle(self.mainUI.img_title_forge, UIManager.LAYER_INDEX["title_front"])
    self.tt_fronts = {}
    self.tt_fronts[1] = self.mainUI.img_title_forge
    self.tt_fronts[2] = self.mainUI.img_title_forge_0

    self:resetLine()
end

function UIManager:pause()
    self.mainUI:pause()
    self.mainUI.img_bg_counting_down:pause()
    if self.mainUI.start_animate then
        self.mainUI.start_animate:pause()
    end


    local period = DogGI.config.pause_period
    self.pause_period = 0
    self.timerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(dt)
        self.pause_period = self.pause_period + dt
        if self.pause_period > period then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timerId)
            self.timerId = nil
            self.mainUI:onGameExit(SmallGamesGI.MsgBoxTYPE.OneBtn, DogGI.language_config.to_long_no_operate)
        end
    end,0,false)

    --[[
    for k,v in pairs(self.panels) do
        v:pause()
    end
    
    for k,v in pairs(self.tt_backs) do
        v:pause()
    end
    
    for k,v in pairs(self.tt_fronts) do
        v:pause()
    end

    self.mainUI.panel_main:pause()
    ]]

end

function UIManager:resume()
    self.mainUI:resume()
    self.mainUI.img_bg_counting_down:resume()
    if self.timerId then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timerId)
    end
    -- body
end

function UIManager:cloneTraceEle(node, zOrder)
    node:setLocalZOrder(zOrder)
    local contentSize = node:getContentSize()
    local node_clone
    local px , py = node:getPosition()
    node_clone = node:clone()
    node_clone:setPosition(px + contentSize.width, py)
    node:getParent():addChild(node_clone, node:getLocalZOrder())

    return node_clone
end

function UIManager:resetLine()
    local x, y = self.mainUI.img_startline:getPosition()
    
    self.mainUI.img_startline:setPosition(DogGI.winSize.width / 100 * DogGI.config.start_line, y)

    x, y = self.mainUI.img_endline:getPosition()
    
    self.mainUI.img_endline:setPosition(self.s_total + DogGI.winSize.width / 100 * DogGI.config.end_line, y)
end

function UIManager:updataScenePos(dt)
    self.game_time = self.game_time + dt
    if self.game_time >= DogGI.config.total_time then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
        return
    end

    self.dt = dt

    local ns = self:nearDeltX(dt)
    local fs = self:farDeltX(dt)

    self:updateTraceMove(ns)
    self:updateEndlineMove(ns)
    self:updateStartlineMove(ns)
    self:updateBackgroudMove(fs)
    self:updateForgegroundMove(ns)
end

function UIManager:isLeftOf(node1, node2)
    local x1, y1 = node1:getPosition()
    local x2, y2 = node2:getPosition()

    if x1 < x2 then
        return node1, node2
    else 
        return node2, node1
    end
end

function UIManager:cycleMoveNodeCycle(deltX, nodes)
    local node1, node2 = self:isLeftOf(nodes[1],nodes[2])

    local x2, y2 = node2:getPosition()
    local contentSize = node1:getContentSize()
    
    local x1, y1 = node1:getPosition()
    if x1 - deltX < 0 then
        
        node1:setPosition(x2 - deltX + contentSize.width, y2)
        node2:setPosition(x2 - deltX, y2)
        return
    end
    --local moveAction = cc.MoveBy:create(self.dt, cc.p(-deltX, 0))
    --local moveAction2 = cc.MoveBy:create(self.dt, cc.p(-deltX, 0))
    
    --node1:runAction(moveAction)
    --node2:runAction(moveAction2)
    node1:setPosition(x1 - deltX, y1)
    node2:setPosition(x1 - deltX + contentSize.width, y1)
end

function UIManager:onClickDogRate(index)
    if self.betInfos[index].count >= 99 then
        return
    end
        
    self.betInfos[index].count = self.betInfos[index].count + 1
    local isSuccess = self:refreshCurTotalBet() 
    if not isSuccess then
        self.betInfos[index].count = self.betInfos[index].count - 1
        self:refreshCurTotalBet()
    end

    if isSuccess then
        self.mainUI["bet_effect" .. index]:play(index)
        self.mainUI:enableStartClick(true)
    end
    self:setBetCount(index, self.betInfos[index].count)
end

function UIManager:resetRatio()
    for i = 1, #self.betInfos do
        self.betInfos[i].count = 0
        self:setBetCount(i, self.betInfos[i].count)
    end
    self:refreshCurTotalBet()
    self.mainUI:disableStartClick()
end

function UIManager:isBet()
    for i = 1, #self.betInfos do
        if  self.betInfos[i].count > 0 then
            return true
        end
    end

    return false
end

function UIManager:refreshCurTotalBet()
    local total = self:totalRatio()
    if DogGI.cur_money - total < 0 then
        self.hangupDlg = SmallGamesGF.createMsgBox(SmallGamesGI.MsgBoxTYPE.TwoBtn, DogGI.language_config.money_no_enough, function ( ... )
            -- body
        end)

        return false
    end

    self.mainUI.node_title_bar:setGoldCount(DogGI.cur_money - total)
    self.mainUI:setTotalRate(total)

    return true
end

function UIManager:totalRatio()
    local baseRatio = 0
    for k,v in pairs(self.betInfos) do
        baseRatio = baseRatio + v.count
    end

    return baseRatio * self:getRatio()
end

function UIManager:updateTraceMove(deltX)
    
    self:cycleMoveNodeCycle(deltX, self.panels)
end

function UIManager:updateEndlineMove(deltX)
    local x, y = self.mainUI.img_endline:getPosition()
    self.mainUI.img_endline:setPosition(x - deltX, y)
end

function UIManager:updateStartlineMove(deltX)
    local x, y = self.mainUI.img_startline:getPosition()
    self.mainUI.img_startline:setPosition(x - deltX, y)
end

function UIManager:updateBackgroudMove(deltX)
    self:cycleMoveNodeCycle(deltX, self.tt_backs)
end

function UIManager:updateForgegroundMove(deltX)
    self:cycleMoveNodeCycle(deltX, self.tt_fronts)
end

function UIManager:nearSpeed( dt )
    self:calculateSpeed(dt, false)
end

function UIManager:farSpeed( dt )
    self:calculateSpeed(dt, true)
end

function UIManager:calculateSpeed(dt, isFar)
    local speed = 0
    local accelerate = self.accelerate
    local velocity   = self.velocity
    local decelerate = self.decelerate
    if isFar then
        accelerate = self.accelerate_far
        velocity   = self.velocity_far
        decelerate = self.decelerate_far
    end

    self.game_time = self.game_time + dt

    if self.game_time < DogGI.config.accelerate_time then -- 加速中
        speed = accelerate * self.game_time

    elseif self.game_time >= DogGI.config.accelerate_time 
        and self.game_time <= DogGI.config.decelerate_time then -- 匀速中
        speed = velocity

    elseif self.game_time > DogGI.config.decelerate_time then -- 减速中
        speed = velocity - (self.game_time - DogGI.config.decelerate_time) * decelerate
    end

    return speed
end

function UIManager:nearDeltX(dt)
    return self:calculateDeltX(dt, false)
end

function UIManager:farDeltX(dt)
    return self:calculateDeltX(dt, true)
end

function UIManager:calculateDeltX(dt, isFar)
    local deltX = 0
    local speed = 0
    local accelerate = self.accelerate
    local velocity   = self.velocity
    local decelerate = self.decelerate
    if isFar then
        accelerate = self.accelerate_far
        velocity   = self.velocity_far
        decelerate = self.decelerate_far
    end

    if self.game_time < DogGI.config.accelerate_time then -- 加速中
        speed = accelerate * (self.game_time - dt)
        deltX = speed * dt + 0.5 * accelerate * dt * dt

    elseif self.game_time >= DogGI.config.accelerate_time 
        and self.game_time <= DogGI.config.decelerate_time then -- 匀速中
        speed = velocity
        deltX = speed * dt

    elseif self.game_time > DogGI.config.decelerate_time then -- 减速中
        speed = velocity - (self.game_time - DogGI.config.decelerate_time - dt) * decelerate
        deltX = speed * dt - 0.5 * decelerate * dt * dt
    end

    return deltX , speed
end

function UIManager:decorMove(actionMaps, positions, last_position, times, last_times)
    for i = 1 , UIManager.TRACE_NUM do
        local x, y = self.dogs[i]:getPosition()
        local rate = self:setRunRate(positions, last_position, times, last_times, i)
        self.dograte[i] = rate
        
        local actionmap = actionMaps[i]
        actionmap[#actionmap + 1] = cc.CallFunc:create(function ()
            local baseFrameRate = self:getFrameRateByRace(i)
            self.dogs[i]:getAnimation():setSpeedScale(baseFrameRate * rate)
        end)
        
        actionmap[#actionmap + 1] = cc.EaseInOut:create(cc.MoveTo:create(times[i] - last_times[i], cc.p(positions[i] * DogGI.winSize.width/100, y)), 1)
    end
end

function UIManager:setRunRate(positions, last_position, times, last_time, index)
    local last = 0
    if last_position then
        last = last_position[index]
    end

    local lasttime = 0
    if last_time then
        lasttime = last_time[index]
    end
    
    local deltX = positions[index] - last
    local deltT = times[index] - lasttime
    local v = deltX / deltT

    for k,policy in pairs(DogGI.config.speed_frame_rate) do
        if v >= policy.min and v <= policy.max then
            return policy.rate / 100
        end
    end
end

function UIManager:specialDeal(positions, winId, isLast)
    if isLast then
        positions[winId] = DogGI.config.first_end_final_x

    else
        local topThree = self:getTopThreeIndex(positions)
        local random = math.random(1, 2)
        
        local temp = positions[winId]
        positions[winId] = positions[topThree[random]]
        positions[topThree[random]] = temp
    end
end

function UIManager:getTopThreeIndex(positions)  -- fixme
    local smallest = 1
    for i = 1 , #positions do
        if positions[smallest] > positions[i] then
            smallest = i
        end
    end

    local bigest = smallest
    for i = 1 , #positions do
        if positions[bigest] < positions[i] then
            bigest = i
        end
    end


    local second = smallest
    for i = 1 , #positions do
        if i ~= bigest and positions[second] < positions[i] then
            second = i
        end
    end


    local third = smallest
    for i = 1 , #positions do
        if i ~= bigest and i ~= second and positions[third] < positions[i] then
            third = i
        end
    end

    return {bigest, second, third}
end

function UIManager:generateRandomArray(min, max, count)
    local array = {}
    for i = 1 , count do
        array[#array + 1] = math.random(min * 10000, max * 10000) / 10000
    end
    return array
end

function UIManager:genRandom(min, max, count, param, base, islast)
    local array = {}
    for i = 1 , count do
        local random = math.random(min, max)
        if islast then
            random = 0
        end
        array[#array + 1] = random / param + base
    end

    return array
end

function UIManager:initConfig()
    local t_constant   = DogGI.config.decelerate_time - DogGI.config.accelerate_time
    local t_decelerate = DogGI.config.total_time - DogGI.config.decelerate_time

    self.velocity   = DogGI.winSize.width / DogGI.config.near_average_time
    self.accelerate = self.velocity / DogGI.config.accelerate_time  
    self.decelerate = self.velocity / t_decelerate

    self.velocity_far   = DogGI.winSize.width / DogGI.config.far_average_time
    self.accelerate_far = self.velocity_far / DogGI.config.accelerate_time  
    self.decelerate_far = self.velocity_far / t_decelerate

    self.s_accelerate = 0.5 * self.accelerate * DogGI.config.accelerate_time * DogGI.config.accelerate_time
    self.s_constant   = self.velocity * (t_constant)
    self.s_decelerate = self.velocity * t_decelerate - 0.5 * self.decelerate * t_decelerate * t_decelerate
    self.s_total = self.s_accelerate + self.s_constant + self.s_decelerate
end

function UIManager:initDog()
    local dogs = DogGI.dog_config.dogs

    self.all_dogs = {}
    self.dog_frame_res = {}
    for k, dog in pairs(dogs) do
        --print(k .. " : " .. dog.res)
        self.dog_frame_res[#self.dog_frame_res + 1] = dog.res
        self.all_dogs[#self.all_dogs + 1] = self:loadAnimal(dog.res)
    end
end

function UIManager:loadAnimal(headName)
    local armature = ccs.Armature:create()
    armature:setScaleX(0.4000)
    armature:setScaleY(0.4000)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(UIManager.RESOURCE_PATH .. headName ..".ExportJson")
    armature:init(headName)
    armature:retain()
    
    return armature
end

return UIManager