local ShareBase = class("ShareBase")

function ShareBase:init()
	self.type = 0
	local funDoShare = {
		android = {
			Buyu = self.doShareAndroidBuyu,
			Qipai = self.doShareAndroidQipai,
		},
		ios = {
			Buyu = self.doShareIosBuyu,
			Qipai = self.doShareIosQipai,
		},
	}
	local funOnShareResult = {
		android = {
			Buyu = self.onShareResultAndroidBuyu,
			Qipai = self.onShareResultAndroidQipai,
		},
		ios = {
			Buyu = self.onShareResultIosBuyu,
			Qipai = self.onShareResultIosQipai,
		},
	}
	self.funDoShare = funDoShare[device.platform][SmallGamesGI.lobbyName]
	self.funOnShareResult = funOnShareResult[device.platform][SmallGamesGI.lobbyName]
end

function ShareBase:setLuaBottomCallData(luaBottomCallData)
	self.luaBottomCallData = luaBottomCallData
end

function ShareBase:doShare(shareInfo)
	if self.funDoShare then
		self.funDoShare(self, shareInfo)
	end
end

function ShareBase:doShareAndroidBuyu(shareInfo)
	self:doShareAndroid(self:getAndroidBuyuShareInfo(shareInfo))
end

function ShareBase:doShareAndroidQipai(shareInfo)
	self:doShareAndroid(self:getAndroidQipaiShareInfo(shareInfo))
end

function ShareBase:doShareIosBuyu(shareInfo)
	self:doShareIos(self:getIosBuyuShareInfo(shareInfo))
end

function ShareBase:doShareIosQipai(shareInfo)
	self:doShareIos(self:getIosBuyuShareInfo(shareInfo))
end

function ShareBase:doShareAndroid(javaParams, javaMethodSig)
	local luaBridge = require(SmallGamesGI.luaj)
	local javaMethodName = self.luaBottomCallData.methodName
    luaBridge.callStaticMethod(self.luaBottomCallData.className, javaMethodName, javaParams, javaMethodSig)
end

function ShareBase:doShareIos(shareInfo)
	if self.luaBottomCallData == nil then
		return
	end
	local iosClassName = self.luaBottomCallData.className
	local methodName = self.luaBottomCallData.methodName
    local luaoc = require(SmallGamesGI.luaoc)
	local ok, ret = luaoc.callStaticMethod(iosClassName, methodName, shareInfo)
	if not ok then
		print("call oc class:"..iosClassName.." method:"..methodName.." failure")
	end
end

function ShareBase:onShareResult(luastr)
end

return ShareBase