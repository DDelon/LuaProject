local ShareBase = class("ShareBase")

function ShareBase:init()
	self.type = 0
end

function ShareBase:setLuaBottomCallData(luaBottomCallData)
	self.luaBottomCallData = luaBottomCallData
end

function ShareBase:doShare(shareInfo)
	shareInfo.handlerCallback = handler(self, self.onShareResult)
	if device.platform == "android" then
		local shareData = SmallGamesGI.ExtendGameConf:makeAndroidShareParams(shareInfo)
		self:doShareAndroid(shareData)
	elseif device.platform == "ios" then
		local shareData = SmallGamesGI.ExtendGameConf:makeIosShareParams(shareInfo)
		self:doShareIos(shareData)
	end
end

function ShareBase:doShareAndroid(javaParams)
	local luaBridge = require("cocos.cocos2d.luaj")
	if self.luaBottomCallData.callbackResult then
    	luaBridge.callStaticMethod(self.luaBottomCallData.className, self.luaBottomCallData.callbackResult, { handler(self, self.onShareResult) })
	end
	local javaMethodName = self.luaBottomCallData.methodName
    luaBridge.callStaticMethod(self.luaBottomCallData.className, javaMethodName, javaParams, javaMethodSig)
end

function ShareBase:doShareIos(shareInfo)
	if self.luaBottomCallData == nil then
		return
	end
	local iosClassName = self.luaBottomCallData.className
	local methodName = self.luaBottomCallData.methodName
    local luaoc = require("cocos.cocos2d.luaoc")
	local ok, ret = luaoc.callStaticMethod(iosClassName, methodName, shareInfo)
	if not ok then
		print("call oc class:"..iosClassName.." method:"..methodName.." failure")
	end
end

function ShareBase:onShareResult(...)
	local resultStatus = -1
	if device.platform == "android" then
		resultStatus = SmallGamesGI.ExtendGameConf:makeAndroidShareResultData(...)
	elseif device.platform == "ios" then
		resultStatus = SmallGamesGI.ExtendGameConf:makeIosShareResultData(...)
	end
	if resultStatus == 0 then
		print("share success")
	else
		print("share failed")
	end
end

return ShareBase