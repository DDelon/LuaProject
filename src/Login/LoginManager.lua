local LoginManager = class("LoginManager", function()
	return cc.Scene:create();
end)

function LoginManager.create()
	local manager = LoginManager.new();
	manager:init();
	return manager;
end

function LoginManager:init()
    self.sceneName = "login"
	--创建视图 创建网络
	local loginNet = require("Login/LoginNet").create();
	local loginLayer = require("Login/LoginLayer").create();
	if loginNet ~= nil then
		loginLayer:setNet(loginNet)
	end

	self:addChild(loginLayer);
	self.view = loginLayer;
	self.net = loginNet;
    

	self:registerEnterBFgroundEvt();
    self:registerEnterExit();

    local quickStartListener=cc.EventListenerCustom:create("quickStart",handler(self, self.quickStart))  
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(quickStartListener, 1)

    local accountLoginListener = cc.EventListenerCustom:create("accountLogin",handler(self, self.accountLogin))
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(accountLoginListener, 2)

    local exitListener = cc.EventListenerCustom:create("exit",handler(self, self.exit))
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(exitListener, 3)
end

function LoginManager:onEnter()
    FishGI.AudioControl:playLayerBgMusic()
    FishGMF.setGameState(1)
    FishGI.isLogin = false
    FishGI.CIRCLE_COUNT = 0
    FishGI.myData = nil
    FishGI.isEnterBg = false
    FishGI.FRIEND_ROOM_STATUS = 0
    FishGI.FRIEND_ROOMID = nil
    FishGI.IS_RECHARGE = 0

    --判断是否被封号 封号弹提示
    if FishGI.isTestAccount then
        local function callback(sender)
        
        end
        FishGF.showMessageLayer(FishCD.MODE_MIN_OK_ONLY,FishGF.getChByIndex(800000312),callback);
        FishGI.isTestAccount = false;
    end

    --清除遮挡层
    local noDelList = {"doPaySDK"}
    FishGF.clearSwallowLayer(noDelList)

    --解决键盘输入看不到字的bug
    if device.platform == "android" then
        local luaBridge = require("cocos.cocos2d.luaj");
        local javaClassName = "org.cocos2dx.lib.Cocos2dxEditBoxHelper";
        local javaMethodName = "openKeyboard";
        local javaParams = {
            1001
        }
        local javaMethodSig = "(I)V";
        local ok = luaBridge.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);
    end

    --移除监听器
    FishGI.eventDispatcher:removeAllListener();
    --屏幕常亮
	if device.platform == "android" or device.platform == "ios" then
		cc.Device:setKeepScreenOn(true);
	end
end

function LoginManager:onExit()
    cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners("quickStart");
    cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners("accountLogin");
    cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners("exit");
end

function LoginManager:registerEnterBFgroundEvt()
    --进入前台
    local function onAppEnterForeground()
        FishGI.AudioControl:playLayerBgMusic()
        if self.isEnterBg == false then
            return;
        end
    end

    --进入后台
    local function onAppEnterBackground()
        self.isEnterBg = true
    end

    local eventDispatcher = self:getEventDispatcher()
    local forelistener = cc.EventListenerCustom:create("applicationWillEnterForeground", onAppEnterForeground)
    eventDispatcher:addEventListenerWithSceneGraphPriority(forelistener, self)
    local backlistener = cc.EventListenerCustom:create("applicationDidEnterBackground", onAppEnterBackground)
    eventDispatcher:addEventListenerWithSceneGraphPriority(backlistener, self)
	
end

function LoginManager:registerEnterExit()

    local function onNodeEvent(event )
        if event == "enter" then
            self:onEnter()
        elseif event == "enterTransitionFinish" then

        elseif event == "exit" then
            self:onExit()
        elseif event == "exitTransitionStart" then

        elseif event == "cleanup" then

        end
    end
    self:registerScriptHandler(onNodeEvent)
end


---------------listener call--------------
function LoginManager:quickStart()
    local isThirdSDK = FishGF.isThirdSdk();
    local isUseThirdLogin = (isThirdSDK and FishGF.isThirdSdkLogin() or false);
    if isUseThirdLogin then
        self.net:thirdSdkLogin(1);
    else
        local accountTab = FishGI.WritePlayerData:getEndData();
        local isVisitor = ((accountTab == nil or accountTab["isVisitor"] ~= nil) and true or false);
        local password = accountTab["password"];
        local account = accountTab["account"];
        if isVisitor then
            self.net:VisitorLogin();
        else
            if FishGF.checkAccount(account) and FishGF.checkPassword(password) then
                self.net:loginByUserAccount(account, password);
            end
        end
    end
end

function LoginManager:accountLogin()
    local isThirdSDK = FishGF.isThirdSdk();
    local isUseThirdLogin = (isThirdSDK and FishGF.isThirdSdkLogin() or false);
    if isUseThirdLogin then
        self.net:thirdSdkLogin(2);
    else
        self.view:openInputView();
    end
end

function LoginManager:sdkLogin(evt)
    local data = evt._userdata;
    local method = data.method;
    local isThirdSDK = FishGF.isThirdSdk();
    local isUseThirdLogin = FishGF.isThirdSdkLogin();
    if isThirdSdk and isUseThirdLogin then
        self.net:thirdSdkLogin(method);
    end
end

function LoginManager:exit()
    local isThirdSDK = FishGF.isThirdSdk()
    local isUseThirdExit = (isThirdSDK and FishGF.isThirdSdkExit() or false)
    if isUseThirdExit then
        local closeCallback = function (jsons)
            local result = json.decode(jsons)
            if CHANNEL_ID == CHANNEL_ID_LIST.qihu or CHANNEL_ID == CHANNEL_ID_LIST.baidu then
                local tag = tonumber(result.resultMsg)
                if tag == 2 then
                    os.exit(0);
                end
            else
                local code = tonumber(result.resultCode)
                if code == 0 then
                    os.exit(0);
                end
            end
        end
        FishGI.GameCenterSdk:trySDKGameExit({}, closeCallback)
    else
        local function callback(sender)
            local tag = sender:getTag()
            if tag == 2 then
                os.exit(0);
            end
        end   
        FishGF.showExitMessage(FishGF.getChByIndex(800000139),callback)
    end
    

end

return LoginManager;
