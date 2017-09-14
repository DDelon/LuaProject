
local LoginLayer = class("LoginLayer", cc.load("mvc").ViewBase)

LoginLayer.AUTO_RESOLUTION   = true
LoginLayer.RESOURCE_FILENAME = "ui/login/uiloginlayer"
LoginLayer.RESOURCE_BINDING  = {  
    ["btn_start"]        = { ["varname"] = "btn_start" ,        ["events"]={["event"]="click",["method"]="onClickStart"}},  
    ["btn_close"]        = { ["varname"] = "btn_close" ,        ["events"]={["event"]="click",["method"]="onClickClose"}},
    ["spr_logo"]         = { ["varname"] = "spr_logo"  },   
    ["spr_login_bg"]     = { ["varname"] = "spr_login_bg"  },
    
    ["btn_accountstart"] = { ["varname"] = "btn_accountstart" , ["events"]={["event"]="click",["method"]="onClickaccountstart"}},
    ["btn_openlist"]     = { ["varname"] = "btn_openlist" ,     ["events"]={["event"]="click",["method"]="onClickopenlist"}},
    
    ["text_account"]     = { ["varname"] = "text_account"  },
    
    ["image_account_bg"] = { ["varname"] = "image_account_bg"  },    
    
    ["text_notice"]      = { ["varname"] = "text_notice"  },    
    ["text_ver"]         = { ["varname"] = "text_ver"  },
    ["btn_qq"]           = { ["varname"] = "btn_qq" ,           ["events"]={["event"]="click",["method"]="onClickqq"}},
    ["btn_wechat"]       = { ["varname"] = "btn_wechat" ,       ["events"]={["event"]="click",["method"]="onClickwechat"}},
    
    ["btn_retrieve"]     = { ["varname"] = "btn_retrieve" ,     ["events"]={["event"]="click",["method"]="onClickretrieve"}},
    
}

function LoginLayer:onCreate(...)
    self.text_notice:setString(FishGF.getChByIndex(800000017))
    self.text_notice:setScale(self.scaleMin_)
    local ver = "Ver"..table.concat(require("version"),".").."("..CHANNEL_ID..")";
    self.text_ver:setString(ver)
    self.text_ver:setScale(self.scaleMin_)

    self.uiChangeAccount = require("Login/ChangeAccount").create()
    self.uiChangeAccount:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiChangeAccount,1000)
    self.uiChangeAccount:setVisible(false)
    self.uiChangeAccount:setScale(self.scaleMin_)

    self.uiLoginNode = require("Login/LoginNode").create()
    self.uiLoginNode:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiLoginNode,1000)
    self.uiLoginNode:setVisible(false)
    self.uiLoginNode:setScale(self.scaleMin_)

    local accountTab = self.uiChangeAccount:getEndAccount()
    local count = FishGI.WritePlayerData:getMaxKeys()
    if accountTab == nil or (count == 1 and accountTab["isVisitor"] ~= nil )then
        self.text_account:setString("")
        self.image_account_bg:setVisible(false)
        self.btn_accountstart:setPositionY(cc.Director:getInstance():getWinSize().height*0.23)
        self.btn_start:setPositionY(cc.Director:getInstance():getWinSize().height*0.23)
    else
        local account = accountTab["account"]
        local isVisitor = accountTab["isVisitor"]
        if isVisitor ~= nil then
             account = isVisitor
        end
        self.text_account:setString(account)
        self.image_account_bg:setVisible(true)
    end
    
    FishGI.myData = nil

    if CHANNEL_ID == CHANNEL_ID_LIST.yyb then
        self.btn_wechat:setVisible(true)
        self.btn_qq:setVisible(true)
        self.btn_start:setVisible(false)
        self.btn_accountstart:setVisible(false)
        self.btn_wechat:setPositionY(cc.Director:getInstance():getWinSize().height*0.23)
        self.btn_qq:setPositionY(cc.Director:getInstance():getWinSize().height*0.23)
    elseif CHANNEL_ID == CHANNEL_ID_LIST.huawei then
        self.btn_accountstart:setVisible(false)
        self.btn_retrieve:setVisible(false)

        self.btn_start:setPosition(cc.Director:getInstance():getWinSize().width*0.5, cc.Director:getInstance():getWinSize().height*0.26)

        self.btn_wechat:setVisible(false)
        self.btn_qq:setVisible(false)
    else
        self.btn_wechat:setVisible(false)
        self.btn_qq:setVisible(false)
        self.btn_start:setVisible(true)
        self.btn_accountstart:setVisible(true)
    end
    if FishGF.isThirdSdk() and FishGF.isThirdSdkLogin() then
        self.btn_retrieve:setVisible(false)
    end

    self:registerKeyboard();
end

function LoginLayer:registerKeyboard()

    local function onKeyboardFunc(code, event)
        if code == cc.KeyCode.KEY_BACK then
            FishGI.AudioControl:playEffect("sound/com_btn01.mp3")
            self:onClickClose();
        end
    end
    local listener = cc.EventListenerKeyboard:create();
    listener:registerScriptHandler(onKeyboardFunc, cc.Handler.EVENT_KEYBOARD_RELEASED);
    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self);
end

function LoginLayer:onEnter( )
    FishGI.isLogin = false
    FishGI.AudioControl:playLayerBgMusic()
    FishGI.CIRCLE_COUNT = 0
    FishGMF.setGameState(1)
    FishGI.myData = nil
    FishGI.isEnterBg = false
    FishGI.FRIEND_ROOM_STATUS = 0
    FishGI.FRIEND_ROOMID = nil
    FishGI.IS_RECHARGE = 0
end

function LoginLayer:setNet(net)
    self.net = net;
end
 
function LoginLayer:onClickStart( sender )
    if (bit.band(FUN_SWITCH, 2) == 2 and true or false) then
        --服务器正在维护
        FishGF.showMessageLayer(FishCD.MODE_MIDDLE_OK_ONLY,"服务器正在维护中!",nil);
        return;
    end
    local event = cc.EventCustom:new("quickStart")
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

function LoginLayer:onClickaccountstart( sender )
    if (bit.band(FUN_SWITCH, 2) == 2 and true or false) then
        --服务器正在维护
        FishGF.showMessageLayer(FishCD.MODE_MIDDLE_OK_ONLY,"服务器正在维护中!",nil);
        return;
    end
    local event = cc.EventCustom:new("accountLogin")
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

function LoginLayer:openInputView()
    --打开输入账号密码弹出框
    local accountTab = FishGI.WritePlayerData:getEndData()
    if accountTab ~= nil then
        self.uiLoginNode:setAccountData(accountTab)
    end
    self.uiLoginNode:showLayer() 
end

function LoginLayer:changeAccount( )
    local accountTab = FishGI.WritePlayerData:getEndData()
    if accountTab ~= nil then
        self.uiLoginNode:setAccountData(accountTab)
    end
    self.uiLoginNode:showLayer() 
end

function LoginLayer:onClickopenlist( sender )
    self.uiChangeAccount:showLayer() 
end

function LoginLayer:onClickClose( sender )
    local event = cc.EventCustom:new("exit")
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

function LoginLayer:onClickqq( sender )
    local event = cc.EventCustom:new("sdkLogin")
    event._userdata = {method = 1}
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

function LoginLayer:onClickwechat( sender )
    local event = cc.EventCustom:new("sdkLogin")
    event._userdata = {method = 2}
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)

end

function LoginLayer:onClickretrieve( sender )
    cc.Application:getInstance():openURL("http://ii.weile.com/forgot/password/");
end


return LoginLayer;
