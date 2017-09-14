
local funCallBackSMSGS2C = {}

local GameManagerBase = class("GameManagerBase", SmallGamesGI.GameClient)

function GameManagerBase:ctor()
    SmallGamesGI.GameClient.ctor(self)
    funCallBackSMSGS2C = {}
    if SmallGamesGI.MessageDefine then
        self.msgProto = jmsg.create(SmallGamesGI.MessageDefine)
    end
    self:RegisterMsgProcess(SmallGamesGI.MsgHead.MSG_S2C_JMSG, self.OnMsg, "OnMsg")
end

function GameManagerBase:OnCreateScene()
    local scene = require(SmallGamesGF.getCommonSrcPath("game.GameScene")).create()
    self:sendClientReadyMessage()
    SmallGamesGI.RoomScene = SmallGamesGI.curScene
    SmallGamesGI.curScene = scene
    SmallGamesGI.keyBoardViewsRoomSceneBak = SmallGamesGF.copyTable(SmallGamesGI.keyBoardViews)
    SmallGamesGI.GameManager = self
    return scene
end

function GameManagerBase:OnInitialize()
  return true;
end

function GameManagerBase:setCallBackSMSGS2C( callBackSMSGS2C )
    for k,v in pairs(callBackSMSGS2C) do
        funCallBackSMSGS2C[k] = v
    end
end

function GameManagerBase:sendMsg( name, data )
    if self.msgProto then
        local encoded, len = jmsg.encodeBinary(self.msgProto, name, data)
        local msg = CLuaMsgHeader.New()
        msg.id = SmallGamesGI.MsgHead.MSG_C2S_JMSG
        msg:WriteData(encoded, len)
        self:SendData(msg)
        jmsg.freeBinary(encoded)
    else
        local tDdata = {}
        tDdata.type = name
        tDdata.data = data
        local jsonData = json.encode(tDdata)
        local strJsonData = tostring(jsonData)
        local len = string.len( strJsonData )
        local msg = CLuaMsgHeader.New()
        msg.id = SmallGamesGI.MsgHead.MSG_C2S_JMSG
        for i=1,len do
            msg:WriteByte(string.byte( strJsonData, i ))
        end
        self:SendData(msg)
    end
end

function GameManagerBase:sendClientReadyMessage()
    -- 基类不实现
end

---------------------------------------recv----------

function GameManagerBase:OnMsg(msg)
    local data, typename
    if self.msgProto then
        local dataTmp, typeTmp = jmsg.decodeBinary(self.msgProto, msg:ReadData(0))
        data = dataTmp
        typename = typeTmp
    else
        local len = msg.len
        local dataTmp = ""
        for i=1,len do
            dataTmp = dataTmp .. string.char( msg:ReadByte() )
        end
        local tData = json.decode(dataTmp)
        data = tData.data
        typename = tData.type
    end
    if funCallBackSMSGS2C and funCallBackSMSGS2C[typename] then
        funCallBackSMSGS2C[typename](self, data)
    else
        self:OnRecvMsg(typename, data)
    end
end

function GameManagerBase:OnRecvMsg(type, data)
    assert(false, "请在自己游戏的GameManager里定义OnRecvMsg接口")
end

return GameManagerBase