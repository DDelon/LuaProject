local ShareWechat = class("ShareWechat", SmallGamesGF.getShareBase())

function ShareWechat.create()
	local obj = ShareWechat.new()
	obj:init(payInfo)
	return obj
end

function ShareWechat:init()
	self.super.init(self)
	self.type = SmallGamesGI.ShareSDKType.Wechat
end

function ShareWechat:doShare(shareInfo)
	self.super.doShare(self, shareInfo)
end

function ShareWechat:onShareResult(luastr)
	self.super.onShareResult(self, luastr)
end

function ShareWechat:onShareResultBuyu(luastr)
	local ok,argtable = pcall(function()
        return loadstring(luastr)();
    end)
	if ok then
        if argtable.status == 0 then
            print("share success request server")
        end
    else
        if luastr == 0 then
            --ios平台
            print("share success request server")
        else
            print("share result analysis failure")
        end
    end
	self:onShareResult(luastr)
end

function ShareWechat:onShareResultQipai(luastr)
	self:onShareResult(luastr)
end

function ShareWechat:onShareResultAndroidBuyu(luastr)
	self:onShareResultBuyu(luastr)
end

function ShareWechat:onShareResultAndroidQipai(luastr)
	self:onShareResultQipai(luastr)
end

function ShareWechat:onShareResultIosBuyu(luastr)
	self:onShareResultBuyu(luastr)
end

function ShareWechat:onShareResultIosQipai(luastr)
	self:onShareResultQipai(luastr)
end

function ShareWechat:getAndroidBuyuShareInfo(shareInfo)
	local luaBridge = require(SmallGamesGI.luaj)
    luaBridge.callStaticMethod(self.luaBottomCallData.className, self.luaBottomCallData.methonCallbackResult, { handler(self, self.funOnShareResult) })
	shareInfo.appid = SmallGamesGI.lobbyData.WechatAppId
	local jsonArgs = json.encode(shareInfo)
	local javaParams = {
        jsonArgs
    }
    local javaMethodSig = "(Ljava/lang/String;)V"
	return javaParams, javaMethodSig
end

function ShareWechat:getAndroidQipaiShareInfo(shareInfo)
end

function ShareWechat:getIosBuyuShareInfo(shareInfo)
	shareInfo.appid = SmallGamesGI.lobbyData.WechatAppId
	shareInfo.listener = handler(self, self.funOnShareResult)
	return shareInfo
end

function ShareWechat:getIosQipaiShareInfo(shareInfo)
	return shareInfo
end

return ShareWechat