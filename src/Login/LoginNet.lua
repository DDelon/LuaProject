local loginType = LOGIN_TYPE_NONE;  --//当前登录类型
local strLoginUserName = "";        --//最后登录的账号
local strNickName = "";             --//最后登录用户的昵称
local strLoginPassword = "";        --//最后登录的密码信息

local evt = {};

local LoginNet = FishGF.ClassEx("LoginNet", function()
	local obj =  CLoginManager.New()
	obj.event = evt;
	return obj;
end)

function LoginNet.create()
	local loginNet = LoginNet.new();
	if loginNet:Initialize() then
		return loginNet;
	else
		return nil
	end
end

function LoginNet:init( )
	self.serverIndex = 1
	self.autoLogin = false
	self.loginType = FishCD.LOGIN_TYPE_NONE
	self.strLoginUserName = ""
	self.userName = ""
	self.password = ""
end

function LoginNet:initServerConfig()
	self.serverIndex = 1;
	self.autoLogin = false;
	self.serverConfig = FishGI.serverConfig;

end

function LoginNet:updateAccountPass(account, password)
	self.loginType = FishCD.LOGIN_TYPE_BY_NAME
	self.userName = account;
    self.password = password;
end

function LoginNet:DoAutoLogin()
	self.autoLogin = true;
	if self.loginType == FishCD.LOGIN_TYPE_BY_NAME then
		--账号密码登录
		self:startConnect();
	elseif self.loginType == FishCD.LOGIN_TYPE_BY_THIRD_LOGIN then
		--第三方登陆
		self:loginByThird(self.thirdLoginInfo);
	else
		--快速登录
		self:VisitorLogin();
	end
	self.autoLogin = false;
end

function LoginNet:startConnect()
	if self.serverConfig ~= nil and table.maxn(self.serverConfig) > 0 then
		--弹出等待服务器返回的屏蔽层
		if not FishGI.isLogin then
			FishGF.waitNetManager(true,self.autoLogin and FishGF.getChByIndex(800000163) or nil,"startConnect")
			FishGI.isLogin = true
		end
		local serverInfo = self.serverConfig[self.serverIndex];
		FishGF.print("connect ip:"..serverInfo.url.." port:"..serverInfo.port)
		self:Reconnect(serverInfo.url, serverInfo.port);
	end
end

--通过账号密码登录
function LoginNet:loginByUserAccount(userName, password)
    --检查用户名密码
    if userName ~= nil and password ~= nil and userName ~= "" and password ~= "" then
		FishGI.PLAYER_STATE = 1
        self.loginType = FishCD.LOGIN_TYPE_BY_NAME;
        self.userName = userName;
        self.password = password;
        FishGF.setAccountAndPassword(userName,password,nil)
        self:startConnect();
    end
end

--使用游客账号登录
function LoginNet:VisitorLogin()
    local accountTab = FishGI.WritePlayerData:getEndData()
    if accountTab ~= nil and accountTab["account"] ~= "" and accountTab["isVisitor"] ~= nil then
        self:LoginByUnname(accountTab["account"])
        return
    end
    self:AllocNewUser()
end

--第三方sdk登录
function LoginNet:thirdSdkLogin(method)
	local function loginResult(state, data)
		FishGF.waitNetManager(false, nil, "thirdStartConnect")
		if state then
			FishGF.showMessageLayer(FishCD.MODE_MIDDLE_OK_ONLY,"解析失败",nil)
		else
			local resultMsg = nil;
			local ok, datatable = pcall(function() return loadstring(data)(); end)
			if ok == false then
				resultMsg = json.decode(data)
			else
				resultMsg = {}
				resultMsg.data = datatable
			end
			local resultData = resultMsg.data
			local valTab = {};
			valTab.session = resultData.code
			valTab.userid = resultData.id
			valTab.serverip = resultData.ip
			valTab.serverport = resultData.port
			self:loginByThird(valTab);
		end
	end

	FishGF.waitNetManager(true, FishGF.getChByIndex(800000163), "thirdStartConnect")
    FishGI.GameCenterSdk:trySDKLogin({type = method},loginResult)
end

--[[
* @brief 使用游客账号登录
* @param [in] session 游客账号会话ID
* @return 成功返回true
]]
function LoginNet:LoginByUnname( session )
    local accountTab = FishGI.WritePlayerData:getEndData()
    if accountTab ~= nil and accountTab["account"] ~= "" and accountTab["isVisitor"] ~= nil then
    	FishGF.setAccountAndPassword("","",accountTab["isVisitor"])
    end

	FishGI.PLAYER_STATE = 0
    self.strLoginUserName = session;
    self.loginType = FishCD.LOGIN_TYPE_BY_UNNAME;
    self:startConnect();
    return true;
end

--[[
* @brief 分配一个新的游客账号
* @param [in] strNickName 昵称
]]
function LoginNet:AllocNewUser( strNickName)
    if strNickName == nil or strNickName =="" then
        if IS_REVIEW_MODE then
            strNickName = "mobile";
        else
            strNickName = Helper.GetDeviceUserName();
        end
    end
    self.loginType = FishCD.LOGIN_TYPE_ALLOC_USER;
    self.userName = strNickName;
    self:startConnect();
end

--[[
* @brief 添加一个游客账号
* @param [in] session 游客会话ID，必须为32个16进制字符
]]
function LoginNet:AddRoleInfo(session,userfrom)
    assert(type(session)=="string" and #session==32,"无效的会话ID");
    local AccountTab = {}
    AccountTab["account"] = session
    AccountTab["password"] = nil
    AccountTab["isVisitor"] = FishGF.getChByIndex(800000176)..string.sub(session,1,8)
    FishGI.WritePlayerData:upDataAccount(AccountTab)

end

--第三方登陆接口
function LoginNet:loginByThird(info)
	self.loginType = FishCD.LOGIN_TYPE_BY_THIRD_LOGIN;
	self.thirdLoginInfo = info
	FishGI.mainManagerInstance:createHallManager(info);
end

-----------------------------------------------evt事件表-------------------------
function evt.Initialize(login)
	login:init()
	--读取服务器配置表
	login:initServerConfig();
	return true;
end

function evt.OnConnect(login, connected)
	local serverInfo = login.serverConfig[login.serverIndex];
	if connected then
		local serverInfo = login.serverConfig[login.serverIndex];
		FishGF.print("connect server ip:"..serverInfo.url.." port:"..serverInfo.port.." success");
	else
		FishGF.print("connect server ip:"..serverInfo.url.." port:"..serverInfo.port.." fail");
		local noDelList = {"doPaySDK"}
		FishGF.clearSwallowLayer(noDelList)
		local curScene = cc.Director:getInstance():getRunningScene();
		FishGI.connectCount = FishGI.connectCount +1
		if FishGI.connectCount < 5 then
			--在大厅帮玩家登陆
			FishGF.waitNetManager(true,nil,"startAllConnect")
			local  seq = cc.Sequence:create(cc.DelayTime:create(0.8),cc.CallFunc:create(function ( ... )
				FishGF.waitNetManager(false,nil,"startAllConnect")
				FishGI.loginScene.net:DoAutoLogin()
			end))
			curScene:runAction(seq)
			return 
		end
		if  FishGI.isLogin then
			FishGI.isLogin = false
			FishGI.connectCount = 0
			FishGF.createCloseSocketNotice(FishGF.getChByIndex(800000033),"LoginOnOnConnect")
		end
	end
end

--登录服务器连接断开
function evt.OnSocketClose(obj,nErrorCode)
	FishGF.waitNetManager(false,nil,"startConnect")
	FishGF.createCloseSocketNotice(FishGF.getChByIndex(800000070),"LoginOnSocketClose")
end

--登录服务器检测版本应答 发送登录请求
function evt.OnCheckVersion(obj,result)
	if not result then
		return;
	end
	if obj.loginType == FishCD.LOGIN_TYPE_BY_NAME then  
		obj:DispatchLoginByName(true,obj.userName,obj.password);
	elseif obj.loginType == FishCD.LOGIN_TYPE_BY_UNNAME then
		obj:DispatchLoginByUnName(IS_WEILE,obj.strLoginUserName);
	elseif obj.loginType == FishCD.LOGIN_TYPE_ALLOC_USER then
		strNickName = Helper.GetDeviceUserName();
		obj:DispatchAllocUser(strNickName,1,IS_WEILE,APP_ID,CHANNEL_ID);
	end
end

--[[
* @brief 登录成功应答
* @param [in] obj 产生事件的对象，这里是CLoginManager的对象
* @param [in] session 连接大厅放服务器的会话ID
* @param [in] userid 用户ID
* @param [in] serverip 大厅服务器IP地址（整型）
* @param [in] serverport 大厅服务器端口
]]
function evt.OnMsgLoginReply(obj,session,userid,serverip,serverport)
	local valTab = {}
	valTab.session = session
	valTab.userid = userid
	valTab.serverip = serverip;
	valTab.serverport = serverport
	FishGI.mainManagerInstance:createHallManager(valTab);
end

--[[
* @brief 登录失败
* @param [in] obj 产生事件的对象，这里是CLoginManager的对象
* @param [in] result 登录失败原因
]]
function evt.OnMsgLoginFailed( obj,result)
    FishGF.waitNetManager(false,nil,"startConnect")
	FishGI.isLogin = false
	FishGF.createCloseSocketNotice(FishGF.getChByIndex(800000034)..result,"OnMsgLoginFailed")
end

--[[
* @brief 请求分配游客帐号应答
* @param [in] obj 产生事件的对象，这里是CLoginManager的对象
* @param [in] result 分配结果，为０为成功
* @param [in] session 游客会话id
]]
function evt.OnMsgAllocRoleReply( obj,result,session )
    if result == 0 then
        obj:AddRoleInfo(session);
        obj:LoginByUnname(session);
	else
		FishGF.print("alloc visitor account failure")
    end   
end

--[[
* @breif 登录服务器附带消息
* @param [in] obj 产生事件的对象，这里是CLoginManager的对象
* @param [in] bUrl 消息内容是否是url
* @param [in] msg 如果bUrl是true,则msg为网址，应该用浏览器打开，否则是消息内容
]]
function evt.OnMsgLoginMessage(obj,bUrl,msg)
    FishGF.print("login OnMsgLoginMessage")
end

return LoginNet;