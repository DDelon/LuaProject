
local RoomManager = SmallGamesGF.ClassEx("RoomManager", function() 
	return SmallGamesGI.RoomManagerBase.new()
end );

function RoomManager.create(hallManager, roomid)
    local obj = RoomManager.new()
    obj:init(hallManager, roomid)
    local callBackSMSGS2C = {
        SMSGS2CReady = obj.OnReady,
        SMSGS2CStart = obj.onBegin,
        SMSGS2CGetHistory = obj.onHistory,
        SMSGS2CUnlock = obj.onUnlock,
        SMSGS2CSetProp = obj.onSetProp,
        SMSGS2CHeartbeat = obj.onHeartBeat,
        SMSGS2CGameOver = obj.onGameOver,
        SMSGS2CGameAnnounce = obj.onGameAnnounce,
        SMSGS2CGetPlayerInfo = obj.OnGetPlayerInfo
    }
    obj:setCallBackSMSGS2C(callBackSMSGS2C)
    return obj
end

function RoomManager:sendReady()
    SmallGamesGF.delayShowWaittingBox(nil, nil, "SMSGC2SReady")
    self:sendMsg("SMSGC2SReady", {})
end

function RoomManager:sendBegin(startInfo)
    SmallGamesGF.delayShowWaittingBox(nil, nil, "SMSGC2SStart")
    self:sendMsg("SMSGC2SStart", startInfo)
end

function RoomManager:sendHistory()
    SmallGamesGF.delayShowWaittingBox(nil, nil, "SMSGC2SGetHistory")
    self:sendMsg("SMSGC2SGetHistory", {})
end

function RoomManager:sendUnlock(animalId, type)
    SmallGamesGF.delayShowWaittingBox(nil, nil, "SMSGC2SUnlock")
    local val  = {}
    val.animalId = animalId
    val.unlockType = type
    self:sendMsg("SMSGC2SUnlock", val)
end

function RoomManager:sendSetPorp(itemId, value)
    SmallGamesGF.delayShowWaittingBox(nil, nil, "SMSGC2SSetProp")
    local val  = {}
    val.itemId = itemId
    val.value = value
    self:sendMsg("SMSGC2SSetProp", val)
end

function RoomManager:sendHeartBeat()
    if self then
        print("send HeartBeat")
        self:sendMsg("SMSGC2SHeartbeat", {})
    end
end

function RoomManager:sendGameOver()
    print("send Game Over")
    self:sendMsg("SMSGC2SGameOver", {})
end

function RoomManager:sendGetPlayerInfo()
    print("send GetPlayerInfo")
    SmallGamesGF.delayShowWaittingBox(nil, nil, "SMSGC2SGetPlayerInfo")
    self:sendMsg("SMSGC2SGetPlayerInfo", {})
end

function RoomManager:onHeartBeat()
    print("on HeartBeart")
end

function RoomManager:onSetProp(data)
    SmallGamesGF.removeWaittingBox("SMSGC2SSetProp")

    DogGI.main:onMessage("onSetProp", data)
end

function RoomManager:OnRecvMsg(typeName, data)
end

function RoomManager:OnGetPlayerInfo(data)
    SmallGamesGF.removeWaittingBox("SMSGC2SGetPlayerInfo")

    DogGI.main:onMessage("refresh_finfo", data)
end

function RoomManager:OnReady(data)
    SmallGamesGF.removeWaittingBox("SMSGC2SReady")

    DogGI.main:onMessage("ready", data)
end

function RoomManager:onBegin(data)
    SmallGamesGF.removeWaittingBox("SMSGC2SStart")
    DogGI.main:onMessage("onBegin", data)
end

function RoomManager:onHistory(data)
    SmallGamesGF.removeWaittingBox("SMSGC2SGetHistory")
    DogGI.main:onMessage("onHistory", data)
end

function RoomManager:onUnlock(data)
    SmallGamesGF.removeWaittingBox("SMSGC2SUnlock")
    DogGI.main:onMessage("onUnlock", data)
end

function RoomManager:onGameOver(data)    
    DogGI.main:onMessage("onGameOver", data)
end

function RoomManager:onGameAnnounce(data)
    DogGI.main:loadBraodcast(data)
end

return RoomManager