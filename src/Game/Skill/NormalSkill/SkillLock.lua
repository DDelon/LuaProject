local SkillBase = import("Game.Skill.NormalSkill.SkillBase")
local SkillLock = class("SkillLock",SkillBase)

SkillLock.touchDisTime  = 0.5  --手动切换目标间隔
SkillLock.chainCount  = 8  --锁链点个数
function SkillLock:ctor(...)

    self:initListener()
    self:initLock()
    self:openTouchEventListener()

    FishGI.isLock = false
    self.tem_timelineId = 0
    self.tem_fishArrayId = 0

end

--初始化监听器
function SkillLock:initListener()
    FishGI.eventDispatcher:registerCustomListener("startMyLock", self, function(valTab) self:startMyLock(valTab) end);
    FishGI.eventDispatcher:registerCustomListener("startOtherLock", self, function(valTab) self:startOtherLock(valTab) end);
    FishGI.eventDispatcher:registerCustomListener("bulletTargetChange", self, function(valTab) self:bulletTargetChange(valTab) end);

end

--初始化锁定
function SkillLock:initLock()
    self.aimFish = nil
    self.playerSelf = nil
    self.startTime = 0
    self.touchStartTime = 0

    LuaCppAdapter:getInstance():setLuaNode(1,self,{});

end

--结束锁定
function SkillLock:endLock( )
    print("over lock")
    FishGI.isLock = false
    FishGMF.setLockData(FishGI.gameScene.playerManager.selfIndex,2,0,0)

    self.playerSelf = FishGI.gameScene.playerManager:getMyData()
    if self.playerSelf ~= nil then
        self.playerSelf:endShoot();
    end 
    self.touchStartTime = 0
    self.btn.parentClasss:setState(1)

end

function SkillLock:onTouchBegan(touch, event) 
    if FishGI.isLock == true then
        if self.touchStartTime ~= 0 and (os.time() -self.touchStartTime < self.touchDisTime) then
            return
        end
        self.touchStartTime = os.time()

        local isTouchBtn = self:getParent():getParent():isTouchBtn(touch)
        if isTouchBtn then
            return true
        end

        local curPos = touch:getLocation()
        self.playerSelf = FishGI.gameScene.playerManager:getMyData()
        local myPlayerId = FishGI.gameScene.playerManager.selfIndex

        local timelineId,fishArrayId = self:getLockFishByPos(curPos)

        if timelineId == nil or (timelineId == 0 and  fishArrayId == 0)  then
            return true
        end

        FishGMF.setLockData(myPlayerId,3,timelineId,fishArrayId)

        --锁定目标变换
        self:sendChangeAimFish(timelineId,fishArrayId)

        return true
    end

    return false

end

function SkillLock:onTouchCancelled(touch, event) 

end

--按键按下的处理
function SkillLock:clickCallBack( )
    local useType = self:judgeUseType()
    if useType == nil then
        return
    end
    local timelineId = 0
    local fishArrayId = 0
    
    -- if FishGI.isLock == false then
    --     timelineId,fishArrayId = self:getLockFishByScore()
    -- else
    --     timelineId = self.timelineId
    --     fishArrayId = self.fishArrayId
    -- end
    timelineId,fishArrayId = self:getLockFishByScore()
    
    if timelineId == nil then
        return 
    end
    self:pushDataToPool(useType)
    self.useType = useType
    self.tem_timelineId = timelineId
    self.tem_fishArrayId = fishArrayId

    local data = {}
    data.useType = useType
    data.timelineId = timelineId
    data.fishArrayId = fishArrayId
    data.sendType = "start"
    self:sendNetMessage(data)
    self:runTimer()
    self.btn:setTouchEnabled(false)
	
	if FishGI.curGameRoomID == 1 then
		local dataTab = {}
		dataTab.funName = "showLockPointUI"
		LuaCppAdapter:getInstance():luaUseCppFun(dataTab);
	end
end

function SkillLock:getLockFishByScore( )
    local dataTab = {}
    dataTab.funName = "getLockFishByScore"
    local data = LuaCppAdapter:getInstance():luaUseCppFun(dataTab);
    local timelineId = data["timelineId"]
    local fishArrayId = data["fishArrayId"]
    if timelineId == nil then
        return 
    end

    return timelineId,fishArrayId
end

function SkillLock:getLockFishByPos( curPos )
    local locationInNode = FishGI.gameScene:convertToNodeSpace(curPos)
    local dataTab = {}
    dataTab.funName = "getFishByPos"
    dataTab.posX = locationInNode.x
    dataTab.posY = locationInNode.y
    local aimFish = LuaCppAdapter:getInstance():luaUseCppFun(dataTab);
    if aimFish["timelineId"] == 0 and  aimFish["fishArrayId"] == 0  then
        return 
    end
    local timelineId = aimFish["timelineId"]
    local fishArrayId = aimFish["fishArrayId"]

    return timelineId,fishArrayId
end

--得到我的目标鱼坐标
function SkillLock:getMyAimFishPos(  )
    local dataTab = {}
    dataTab.funName = "getAimFishPos"
    dataTab.playerId = FishGI.gameScene.playerManager.selfIndex
    local data = LuaCppAdapter:getInstance():luaUseCppFun(dataTab)
    local aimPosX = 0
    local aimPosY = 0
    local state = 0
    if data ~= nil then
        aimPosX = data["posX"]
        aimPosY = data["posY"]
        state = data["state"]
    end

    return cc.p(aimPosX,aimPosY),state

end

--设置我的目标鱼
function SkillLock:setMyAimFish(timelineId,fishArrayId)
    -- if self.timelineId == timelineId and self.fishArrayId == fishArrayId then
    --     return
    -- end

    self.timelineId = timelineId
    self.fishArrayId = fishArrayId

    if FishGI.isLock == true then
        self:playLockChangeAim()
        --锁定目标变换
        self.playerSelf = FishGI.gameScene.playerManager:getMyData()
        self.playerSelf:setMyAimFish(self.timelineId,self.fishArrayId)
    end

end

--设置c++方面的目标鱼
function SkillLock:setCppAimFish(playerId, timelineId,fishArrayId)
    local dataTab = {}
    dataTab.funName = "setAimFish"
    dataTab.playerId = playerId
    dataTab.timelineId = timelineId
    dataTab.fishArrayId = fishArrayId
    LuaCppAdapter:getInstance():luaUseCppFun(dataTab)
end

--开始我的锁定
function SkillLock:startMyLock( valTab)
    self.scaleX_,self.scaleY_,self.scaleMin_  = FishGF.getCurScale()
    self.playerSelf = FishGI.gameScene.playerManager:getMyData()
    local myPlayerId = self.playerSelf.playerInfo.playerId
    local useType = valTab.useType
    local newCrystal = valTab.newCrystal
    local isSuccess = valTab.isSuccess
    local skillPlus = valTab.skillPlus
    self.lock_userTime = self:getSkillData(4,"duration")
    if skillPlus ~= nil then
        self.lock_userTime = self.lock_userTime*skillPlus/100
    end
    if isSuccess == false then
        print("-----startMyLock--isSuccess == false-")
        self:clearDataFromPool(useType)
        self:stopTimer()
        self.tem_timelineId = 0
        self.tem_fishArrayId = 0
        FishGF.showMessageLayer(FishCD.MODE_MIDDLE_OK_ONLY,FishGF.getChByIndex(800000087),nil)
        return
    end

    self.btn.parentClasss:setState(2)

    if useType == 1 then
        --更新水晶
        FishGMF.upDataByPropId(myPlayerId,FishCD.PROP_TAG_02,newCrystal,false)
    elseif useType == 0 then
        FishGMF.addTrueAndFlyProp(myPlayerId,FishCD.PROP_TAG_04,-1,false)
    end
    self:clearDataFromPool(useType,false)

    FishGI.AudioControl:playEffect("sound/lock_01.mp3")

    FishGI.isLock = true
    --继续锁定
    self.startTime = os.time()
    self:runTimer()
    self:stopActionByTag(10006)
    local delayAct = cc.Sequence:create(cc.DelayTime:create(self.lock_userTime),cc.CallFunc:create(function ( ... )
        self:endLock();
    end))
    delayAct:setTag(10006)
    self:runAction(delayAct)

    self.playerSelf.cannon.uiCannonChange:setAutoFire(false)

    local backData = FishGMF.setLockData(myPlayerId,1,self.tem_timelineId,self.tem_fishArrayId)
    if backData.x == nil then
        print("-----aimFish is no exit------")
        return
    end
    --print("get aim posx:"..aimPos.x.." posy:"..aimPos.y);
    if self.playerSelf ~= nil then
        if backData.x > 0 and  backData.y > 0 then
            print("shoot to aim");
            self.playerSelf:shoot(cc.p(backData.x,backData.y));
        end
    else
        print("player self is nil")
    end

    

end

--进入前台刷新时间
function SkillLock:upDateUserTime(disTime )
    if FishGI.isLock == false then
        return
    end
    local curTime =  os.time()
    local curdisTime = curTime - self.startTime
    if curdisTime <=0 then
        return
    end

    self:upDateTimer()

    if curdisTime > self.lock_userTime then
        self:endLock()
    else
        self:stopActionByTag(10006)
        local times = self.lock_userTime -curdisTime
        local delayAct = cc.Sequence:create(cc.DelayTime:create(times),cc.CallFunc:create(function ( ... )
            self:endLock();
        end))
        delayAct:setTag(10006)
        self:runAction(delayAct)
    end

end

function SkillLock:startOtherLock(data )
    local playerId = data.playerId
    local timelineId = data.timelineId
    local fishArrayId = data.fishArrayId
    FishGMF.setLockData(playerId,3,timelineId,fishArrayId)
    --更新水晶
    FishGMF.upDataByPropId(playerId,2,data.newCrystal)
end

--发送自己改变目标鱼消息
function SkillLock:sendChangeAimFish(timelineId, fishArrayId)
    local playerId = FishGI.gameScene.playerManager.selfIndex
    local data = {}
    data.timelineId = timelineId
    data.fishArrayId = fishArrayId
    local bulletCount,bullets = self:getLockBullet(playerId)
    data.bullets = bullets
    data.sendType = "change"
    self:sendNetMessage(data)

end

--得到锁定子弹
function SkillLock:getLockBullet(playerId )
    local bullerCount = 0
    local bulletsTab = {}
    local dataTab = {}
    dataTab.funName = "getLockBullet"
    dataTab.playerId = playerId
    local bullets = LuaCppAdapter:getInstance():luaUseCppFun(dataTab)
    for key,val in pairs(bullets) do
        bullerCount = bullerCount +1
        table.insert(bulletsTab,val)
    end

    return bullerCount,bulletsTab
end

--收到玩家改变目标消息
function SkillLock:bulletTargetChange(data )
    print("-0-OnBulletTargetChange----")
    local selfId = FishGI.gameScene.playerManager.selfIndex;
    if data.playerId ~= selfId then
        FishGMF.setLockData(data.playerId,3,data.timelineId,data.fishArrayId)
    end 
    
end

return SkillLock;