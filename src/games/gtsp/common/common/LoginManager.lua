
local evt = {}

local function handleLoginError( strMsg )
	SmallGamesGI.isLogin = false
    local function callback(msgbox, btnType)
        if btnType == SmallGamesGI.MsgBoxBtns.FirstBtn then
			if SmallGamesGI.appName then
				SmallGamesGF.exitApp(2)
			else
				SmallGamesGF.enterScene("LoginScene")
			end
        end
    end
	SmallGamesGF.createMsgBox(SmallGamesGI.MsgBoxTYPE.OneBtn, strMsg, callback)
end

local LoginManager = SmallGamesGF.ClassEx("LoginManager", function()
	local obj =  CLoginManager.New()
	obj.event = evt
	return obj
end)

function LoginManager.create()
	local LoginManager = LoginManager.new()
	if LoginManager:Initialize() then
		return LoginManager
	else
		return nil
	end
end

function LoginManager:init( )
	self.serverIndex = 1
	self.autoLogin = false
	self.loginType = SmallGamesGI.LoginType.None
	self.visitorName = ""
	self.userName = ""
	self.password = ""
end

function LoginManager:initLoginData( loginType, visitorName, userName, password )
	self.loginType = loginType
	self.visitorName = visitorName
	self.userName = userName
	self.password = password
end

function LoginManager:getServerConfig()
	return self.serverConfig
end

function LoginManager:setServerConfig(serverConfig)
	self.serverConfig = serverConfig
end

function LoginManager:updateAccountPass(account, password)
	self.loginType = SmallGamesGI.LoginType.Name
	self.userName = account
    self.password = password
end

function LoginManager:DoAutoLogin()
	print("-------------DoAutoLogin-------------")
	self.autoLogin = true
	if self.loginType == SmallGamesGI.LoginType.ThridLodin then
		--第三方登陆
		self:loginByThird(self.thirdLoginInfo)
	else
		self:startConnect()
	end
	self.autoLogin = false
end

function LoginManager:startConnect()
	if table.getn(self.serverConfig) < self.serverIndex then
		print("服务器配置表为空")
		return
	end
	local serverData = self.serverConfig[self.serverIndex]
	if serverData.url == nil or serverData.port == nil then
		print("服务器配置表为空")
	else
		print("--------------------------startConnect")
		--弹出等待服务器返回的屏蔽层
		if not SmallGamesGI.isLogin then
			SmallGamesGF.createWaittingBox(self.autoLogin and "正在获取服务器信息，请稍候~" or nil, "startConnect")
			SmallGamesGI.isLogin = true
		end
        print("server ip:"..serverData.url.." port:"..serverData.port)
		self:Reconnect(serverData.url, serverData.port)
	end
end

--登录失败提示
function LoginManager:OnLoginError(strMsg)
	print("---OnLoginError---strMsg="..strMsg)
	SmallGamesGF.removeWaittingBox("startConnect")
	SmallGamesGI.isLogin = false
	handleLoginError(strMsg)
end

--第三方登陆接口
function LoginManager:loginByThird(info)
	self.loginType = SmallGamesGI.LoginType.ThridLodin
	self.thirdLoginInfo = info
	SmallGamesGF.createHallManager(info)
end

-----------------------------------------------evt事件表-------------------------
function evt.Initialize(login)
	print("login initialize")
	login:init()
	return true
end

function evt.OnConnect(login, connected)
	print("login OnConnect");
	if connected then
		print("连接到服务器 index:"..login.serverIndex.."成功");

	else
		if login.serverIndex < table.getn(login.serverConfig) then
			print("尝试连接下一组服务器");
			login.serverIndex = login.serverIndex+1;
			login:startConnect();
		else
			SmallGamesGF.removeWaittingBox("startConnect")
			if  SmallGamesGI.isLogin then
				SmallGamesGI.isLogin = false
				handleLoginError("服务器全部连接失败")
			end
		end
	end
end

--登录服务器连接断开
function evt.OnSocketClose(obj,nErrorCode)
	print("login OnSocketClose")
	SmallGamesGF.removeWaittingBox("startConnect")
	handleLoginError("登录服务器连接断开")
end

--登录服务器检测版本应答 发送登录请求
function evt.OnCheckVersion(obj,result)
	print("login OnCheckVersion")
	if not result then
		return;
	end
	print("obj.loginType:"..obj.loginType)
	if obj.loginType == SmallGamesGI.LoginType.Name then  
		obj:DispatchLoginByName(true,obj.userName,obj.password);
	elseif obj.loginType == SmallGamesGI.LoginType.UnName then
		printf(obj.visitorName);
		obj:DispatchLoginByUnName(IS_WEILE,obj.visitorName);
	elseif obj.loginType == SmallGamesGI.LoginType.AllocUser then
		print("OnCheckVersion:LOGIN_TYPE_ALLOC_USER")
		obj:DispatchAllocUser(Helper.GetDeviceUserName(),1,IS_WEILE,APP_ID,CHANNEL_ID);
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
	print("login OnMsgLoginReply")
	local valTab = {}
	valTab.session = session
	valTab.userid = userid
	valTab.serverip = serverip;
	
	valTab.serverport = serverport
	SmallGamesGF.createHallManager(valTab)
end

--[[
* @brief 登录失败
* @param [in] obj 产生事件的对象，这里是CLoginManager的对象
* @param [in] result 登录失败原因
]]
function evt.OnMsgLoginFailed( obj,result)
    print("login OnMsgLoginFailed")
    local msgs= {"登录失败，账号或者密码错误",
	"登录失败，账号或者密码错误",
	"登录失败，帐号已经登录！",
	"登录失败，该帐号已经绑定其它机器！",
	"登录失败，该帐号被锁，请与管理员联系",
	"登录失败，服务器忙，请稍后尝试！",
	"登录失败，您尝试的错误次数太多，暂时无法登录",
	"登录失败，您需要输入验证码!",
	"登录失败，验证码已过期或者不存在",
	"登录失败，验证码不正确"};
	print("login failed result:"..result);
    print(msgs[result] or "登录失败，未知错误,请与管理员联系");
	
    SmallGamesGF.removeWaittingBox("startConnect")
	SmallGamesGI.isLogin = false
	handleLoginError(msgs[result] or "登录失败，请与管理员联系，错误码:"..result)
end

--[[
* @brief 请求分配游客帐号应答
* @param [in] obj 产生事件的对象，这里是CLoginManager的对象
* @param [in] result 分配结果，为０为成功
* @param [in] session 游客会话id
]]
function evt.OnMsgAllocRoleReply( obj,result,session )

    if result and result>0 then
        --GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG,"游客登录失败，请稍后重试!")
    else
        obj:AddRoleInfo(session);
        obj:LoginByUnname(session);
    end   
end


--[[
* @breif 登录服务器附带消息
* @param [in] obj 产生事件的对象，这里是CLoginManager的对象
* @param [in] bUrl 消息内容是否是url
* @param [in] msg 如果bUrl是true,则msg为网址，应该用浏览器打开，否则是消息内容
]]
function evt.OnMsgLoginMessage(obj,bUrl,msg)
    print("login OnMsgLoginMessage")
end

return LoginManager;