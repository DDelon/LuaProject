local evt = {}

local funCallBackSMSGS2C = {}

--创建房间管理类 防作弊模式
local AllocSitRoomManager = SmallGamesGF.ClassEx("AllocSitRoomManager", function() 
    local obj =  CAllocSitRoomManager.New()
	obj.event = evt;
	return obj;
end );

function AllocSitRoomManager:init(hallManager, roomid)
    funCallBackSMSGS2C = {
        MSGS2CGetHallInfo = self.onHallInfo,
    }
    if SmallGamesGI.MessageDefine then
        self.msgProto = jmsg.create(SmallGamesGI.MessageDefine)
    end
    self:SetRoomInfo(hallManager, roomid)
    if self:Initialize() then
        self:RegisterMsgProcess(SmallGamesGI.MsgHead.MSG_S2C_HALL_JMSG, self.OnMsg, "OnMsg")
        return true
    else
        return false
    end
end

function AllocSitRoomManager:RegisterMsgProcess(msg, func, name)
    print("BaseClient RegisterMsgProcess");
    evt[msg] = function(client, ...)
--        print("[API] Enter MSG = " .. tostring(msg) .. ", " .. tostring(name));
        return func(self, ...);
    end;
end

function AllocSitRoomManager:setCallBackSMSGS2C( callBackSMSGS2C )
    for k,v in pairs(callBackSMSGS2C) do
        funCallBackSMSGS2C[k] = v
    end
end

function AllocSitRoomManager:sendMsg( name, data )
    if self.msgProto then
        local encoded, len = jmsg.encodeBinary(self.msgProto, name, data)
        local msg = CLuaMsgHeader.New()
        msg.id = SmallGamesGI.MsgHead.MSG_C2S_HALL_JMSG;
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
        msg.id = SmallGamesGI.MsgHead.MSG_C2S_HALL_JMSG
        for i=1,len do
            msg:WriteByte(string.byte( strJsonData, i ))
        end
        self:SendData(msg)
    end
end

--发送刷新大厅数据
function AllocSitRoomManager:sendDataGetInfo()
    SmallGamesGF.createWaittingBox("", "sendDataGetInfo")
    local data = {
        channelId = CHANNEL_ID,
        version = table.concat(HALL_WEB_VERSION, "."),
    }
    self:sendMsg("MSGC2SGetHallInfo", data)
end

function AllocSitRoomManager:sendDataGetDesk(roomId)
    SmallGamesGF.createWaittingBox("", "sendDataGetDesk")
    local msg = SmallGamesGI.WebTool.codingData({
            {"BYTE", tonumber(roomId)}
        },SmallGamesGI.MsgHead.MSG_C2S_GET_DESK)
    self:SendData(msg)
end

---------------------------------------recv----------

function AllocSitRoomManager:OnMsg(msg)
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

function AllocSitRoomManager:OnRecvMsg(type, data)
    assert(false, "请在自己游戏的RoomManager里定义OnRecvMsg接口")
end

function AllocSitRoomManager:onHallInfo(data)
    SmallGamesGF.removeWaittingBox("sendDataGetInfo")
end

function AllocSitRoomManager.getDeskID()
end

function evt.Initialize(room)
	return true
end

--进入房间成功
function evt.OnMsgJoinRoom(room)
    print("RoomManager OnMsgJoinRoom")
    SmallGamesGF.removeWaittingBox("sendDataGetDesk")
	if not room:StartGame() then
		printf("RoomManager 启动游戏失败");
		room:ExitRoom();
    else
	end
    
end

function evt.OnProcessMessage(obj, msg)
    local temp = msg:ReadInt();
    local temp1 = msg:ReadWord();
    print("msg:"..temp1);
end

--玩家离开房间
function evt.OnMsgPlayerLeave( room,player )
    print("player leave hall");
end

function evt.Shutdown(obj)
    print("hall roommamanger shutdown");
    if not SmallGamesGI.isNoticeClose then
        return;
    end
end


function evt.OnMsgSitDown(room,player)
end

function evt.OnStopGame(obj, gameclient)
    print("hallmanager ");
end


--以下函数可选择实现
--[[系统消息
function e.OnSystemMessage( room,msgtype,msg )
	
end
]]

return AllocSitRoomManager;

--endregion