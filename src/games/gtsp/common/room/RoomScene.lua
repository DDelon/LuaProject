
local RoomScene = class("RoomScene", SmallGamesGMF.LoadPackages("mvc").ViewBase)

function RoomScene:onCreate()
    self.super:onCreate()
end

function RoomScene:onInit()
    self.super:onInit()
    SmallGamesGF.initAllDataBinConf()
end

function RoomScene:onEnter()
    self.super:onEnter()
    SmallGamesGI.eventDispatcher:registerCustomListener("OnSocketClose", self, self.onCallbackSocketClose)
    SmallGamesGI.eventDispatcher:registerCustomListener("OnJoinHall", self, self.onCallbackJoinHall)
    SmallGamesGI.eventDispatcher:registerCustomListener("OnJoinHallFailed", self, self.onCallbackJoinHallFailed)
    SmallGamesGI.eventDispatcher:registerCustomListener("OnJoinRoom", self, self.onCallbackJoinRoom)
    SmallGamesGI.eventDispatcher:registerCustomListener("OnJoinRoomFailed", self, self.onCallbackJoinRoomFailed)
    SmallGamesGI.eventDispatcher:registerCustomListener("OnChargeSucceed", self, self.onCallbackChargeSucceed)
    SmallGamesGI.LoginManager:DoAutoLogin()

    self.layerRoom = SmallGamesGF.createView(SmallGameApp.RoomLayer)
    self:addChild(self.layerRoom)
end

function RoomScene:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function RoomScene:onExit()
    self.super:onExit()
    if SmallGamesGI.isExitGame then
        SmallGamesGF.cleanAppConfigs()
    end
end

function RoomScene:sendHeartBeat()
    if self.layerRoom then
        self.layerRoom:sendHeartBeat()
    end
end

function RoomScene:onMsgReady()
    if self.layerRoom then
        self.layerRoom:onMsgReady()
    end
end

function RoomScene:onChargeSucceed()
    if self.layerRoom then
        self.layerRoom:onChargeSucceed()
    end
end

function RoomScene:onSocketClose()
    if self.layerRoom then
        self.layerRoom:onSocketClose()
    end
end

function RoomScene:onCallbackSocketClose()
    self:onSocketClose()
end

function RoomScene:onCallbackJoinHall()
    if not SmallGamesGF.enterRoom() then
        self:onCallbackJoinRoomFailed(nil, "查找不到该房间")
    end
end

function RoomScene:onCallbackJoinHallFailed(result)
    local str = nil
    if result == 1 then
        --玩家已经登陆
        print("玩家已经登陆");
        str = "玩家已经登录"
    else
        print("登陆失败，请联系客服 4008-323-777 ,[错误码:"..result.."]!");
        str = "登录失败，请与管理员联系，错误码:"..result
    end
    --跑出对应的弹出框 确定 取消 回调到相应的函数处理

    local function callback(msgbox, btnType)
        if btnType == SmallGamesGI.MsgBoxBtns.FirstBtn then
            SmallGamesGI.RoomManager:ExitRoom()
            SmallGamesGF.exitApp()
        end
    end
    SmallGamesGF.createMsgBox(SmallGamesGI.MsgBoxTYPE.OneBtn, str, callback)
end

function RoomScene:onCallbackJoinRoom()
    SmallGamesGI.isEnterRoom = true
    local eventDispatcher = self:getEventDispatcher()
    local forelistener = cc.EventListenerCustom:create("applicationWillEnterForeground", function ( ... )
        self:sendHeartBeat()
    end)
    eventDispatcher:addEventListenerWithSceneGraphPriority(forelistener, self)
    local backlistener = cc.EventListenerCustom:create("applicationDidEnterBackground", function ( ... )
        self:sendHeartBeat()
    end)
    eventDispatcher:addEventListenerWithSceneGraphPriority(backlistener, self)
    self:onMsgReady()
end

function RoomScene:onCallbackJoinRoomFailed(result, strMsg)
    SmallGamesGI.isEnterRoom = false
    local function callback(msgbox, btnType)
        if btnType == SmallGamesGI.MsgBoxBtns.FirstBtn then
            SmallGamesGF.exitApp()
        end
    end
    SmallGamesGF.createMsgBox(SmallGamesGI.MsgBoxTYPE.OneBtn, strMsg, callback)
end

function RoomScene:onCallbackChargeSucceed()
    print("RoomScene:onCallbackChargeSucceed")
    self:onChargeSucceed()
end

return RoomScene
