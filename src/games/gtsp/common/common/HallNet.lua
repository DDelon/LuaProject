
local evt = {}
--创建大厅管理器类
local HallNet = SmallGamesGF.ClassEx("HallNet", function() 
    local  obj = CHallManager.New();
    obj.event= evt;
    return obj ;
end );

function HallNet.create()
    local net = HallNet.new();
    if net:Initialize() then
        return net;
    else
        return nil;
    end
end

function HallNet:initRoomConfig(msgTab, roomId)
    self.netMsgTab = msgTab
    self.roomId = roomId
end

function HallNet:dealloc()
    print("hall net dealloc");
    self:Shutdown();
end

--创建LUA游戏客户端
function HallNet:CreateLuaGameClient(shortname)
    local gameclient= CLuaGameClient.New()
	if gameclient then
        local hotUpdatePath = cc.FileUtils:getInstance():getWritablePath().."src/"..SmallGamesGF.getCurAppSrcPath("common/GameManager.lua", '/')
        --hotUpdatePath = cc.FileUtils:getInstance():getWritablePath().."src/"..SmallGamesGF.getCommonSrcPath("common/GameManagerBase.lua", '/')
		gameclient:SetClientInfo(SmallGamesGI.RoomManager, hotUpdatePath)
    else
        print("create lua gameclient fail")
	end
	return gameclient
end

function HallNet:enterGame(roomID)
    self.roomLv = roomID;
    if SmallGamesGI.RoomManager ~= nil then
        SmallGamesGI.RoomManager:sendDataGetDesk(roomID);
    else
        print("roommanager is nil");
    end
end

function HallNet:getSession()
    return self.session;
end

--------------------------------------------------网络协议事件回调
--管理器初始化，返回true成功，否则失败
function evt.Initialize(hallobj)
    print("hall Initialize");
    return true;
end

function evt.Shutdown(hall)
    print("hall Shutdown");
end

function evt.OnConnect( obj,bConnected )
    print("hall OnConnect");
    if bConnected then 
        print("success")   
    end
end

function evt.OnExitRoom(obj)
    print("hall OnExitRoom");
end

function evt.OnMsgLogout(obj)
    print("hall OnMsgLogout");
end

function evt.OnSystemMessage(obj,msg,msgtype)
    print("hall OnSystemMessage");
end

--与大厅服务器连接断开
function evt.OnSocketClose( obj,nErr ) 
    if SmallGamesGI.isEnterBg then
        return;
    end

    if not SmallGamesGI.isNoticeClose then
        return;
    end

    print("hall OnSocketClose error code:"..nErr);
    print("与大厅服务器连接断开，请重新登录0")

    SmallGamesGI.eventDispatcher:dispatch("OnSocketClose", nil)
end

--[[
* @brief 登陆到大厅成功
* @param hall 大厅对象
* @param lastroomid 最后断线房间ID，如果为0，则非断线重连状态
--]]
function evt.OnJoinHall( hall,lastroomid )
    print("hall OnJoinHall vlastroomid :"..lastroomid);
    SmallGamesGF.removeWaittingBox("startConnect")
    SmallGamesGI.eventDispatcher:dispatch("OnJoinHall")
end

--[[
* @brief 登陆到大厅失败
]]
function evt.OnJoinHallFailed( hall,result )
    print("hall OnJoinHallFailed");
    SmallGamesGF.removeWaittingBox("startConnect")

    SmallGamesGI.eventDispatcher:dispatch("OnJoinHallFailed", nil, result)
end

--[[
* @brief 进入房间应答
* param [in] result 进入房间结果,为0则成功
* param [in] lockedroomid 仅玩家已经在房间中时，该参数有意义
]]
function evt.OnMsgJoinRoom(hall,result,lockedroomid)
    if lockedroomid ~= nil then
        print("lockedroomid: "..lockedroomid);
    end
    SmallGamesGF.removeWaittingBox("joinGame")
    if result == 0 then
        SmallGamesGI.eventDispatcher:dispatch("OnJoinRoom", nil)
    else
        local strMsg = "与大厅服务器连接断开，请重新登录"
        if result == 1 then
            local roomData = hall.rooms[lockedroomid]
            if roomData then
                strMsg = "进入房间失败，同一时刻只能进入一个房间!"
            else
                strMsg = "与大厅服务器连接断开，请重新登录"
            end
        elseif result == 2 or result == 3 then
            --房间满人 --另外找其他房间 直到所有房间都找遍 还没有就提示服务器已满
            strMsg = "房间满人"
        elseif result == 4 then
            --房间有权限要求
            strMsg = "没有进入房间的权限"
        elseif result == 5 then 
            --金钱或者积分不够
            strMsg = "金钱或者积分不够"
        elseif result == 6 then 
            strMsg = "金钱或者积分太高 推荐他去更高的房间"
        elseif result == 7 then 
            --房间限制进入（一般是临时维护或者时间没到)
            strMsg = "房间限制进入"
        elseif result == 8 then
            strMsg = "该房间不存在或者已关闭，请尝试进入其他房间"
        elseif result == 9 then
            strMsg = "与大厅服务器连接断开，请重新登录"
        elseif result == 11 then
            strMsg = "报名费不够"
            local roomData = hall.rooms[hall.roommanager:GetID()];
            local nDataType = tonumber(roomData.cmd.bmlx); --期待数据类型
            local strDataValue = roomData.cmd.bmf; --期待数据值
            if nDataType and strDataValue then --有数据要求
                if nDataType == PROP_ID_PK_TICKET then
                    strMsg = "您背包中的参赛券不足"..strDataValue.."个，获取更多参赛券？"
                elseif nDataType == PROP_ID_MONEY then
                    strMsg = "您携带的豆豆不足"..strDataValue.."个，获取更多豆豆？"
                elseif nDataType == PROP_ID_LOTTERY then
                    strMsg = "您的元宝不足"..strDataValue.."个，报名失败!"
                elseif nDataType == PROP_ID_WEEK_PK_CARD then
                    strMsg = "报名失败，您的周赛券不够！"
                elseif nDataType == PROP_ID_MONTH_PK_CARD then
                    strMsg = "您的决赛券不足，报名失败"
                else
                    strMsg = "您的报名费不足，报名失败!"
                end
            else
                strMsg = "您的报名条件不足，报名失败！"
            end
        elseif result == 12 then --当天输赢达到上限
            strMsg = "您今天的豆豆输赢已达上限,无法进入游戏"
        else
            strMsg = "进入房间失败，未知错误，请联系客服 "..HOT_LINE
        end
        SmallGamesGI.eventDispatcher:dispatch("OnJoinRoomFailed", nil, result, strMsg)
    end
end

--[[
* @brief 离开房间通知
* @param [in] 房间对象
]]
function evt.OnMsgLeaveRoom(hall,roommanager)
    print("hall OnMsgLeaveRoom :");
end

function evt.OnMsgRemoveRoom(hall,roomid)
    print("hall OnMsgRemoveRoom :"..roomid);
    if roomid == hall.roomId then
        local function callback(msgbox, btnType)
            if btnType == SmallGamesGI.MsgBoxBtns.FirstBtn then
                SmallGamesGF.exitApp()
            end
        end
        SmallGamesGF.createMsgBox(SmallGamesGI.MsgBoxTYPE.OneBtn, "与大厅服务器连接断开，请重新登录", callback)
    end
end

--[[
* @brief 服务器强制帐号退出
* @brief reason 0 无原因;1用户重复登陆被挤；2：被服务器强行踢掉
* @note 在触发该函数时，网络已经被断开
]]
function evt.OnMsgLogout(hall,reason)
    print("hall OnMsgLogout");
end

return HallNet;