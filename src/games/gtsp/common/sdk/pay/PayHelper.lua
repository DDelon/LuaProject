local PayHelper = class("PayHelper")

function PayHelper.create()
	local obj = PayHelper.new();
	obj:init();
	return obj;
end

function PayHelper:init()
end

function PayHelper:setBottomCallData(luaData)
	self.luaBottomCallData = luaData
end

function PayHelper:createPay(channelType, gcsdkType)
	print("PayHelper:createPay "..channelType)
	self.curPaySdk = require(SmallGamesGI.commonSrcPath..".sdk.pay.module.Pay"..channelType).create()
	if channelType ~= SmallGamesGI.PaySDKType.Gcsdk then
		if self.luaBottomCallData[device.platform] then
			if self.luaBottomCallData[device.platform].list[channelType] then
				self.curPaySdk:setLuaBottomCallData(self.luaBottomCallData[device.platform].list[channelType])
			elseif self.luaBottomCallData[device.platform].common then
				self.curPaySdk:setLuaBottomCallData(self.luaBottomCallData[device.platform].common)
			end
		end
	else
		self.curPaySdk.gcsdkType = gcsdkType
		if self.luaBottomCallData.gcsdk.list[gcsdkType] ~= nil then 
			self.curPaySdk:setLuaBottomCallData(self.luaBottomCallData.gcsdk.list[gcsdkType])
		else
			self.curPaySdk:setLuaBottomCallData(self.luaBottomCallData.gcsdk.common)
		end
	end
end

function PayHelper:doPay(channelType, payInfo)
	if SmallGamesGI.lobbyName == SmallGamesGI.lobbyList.Xyx then
		return
	end
	if device.platform ~= "android" and device.platform ~= "ios" then
		return
	end

	self:createPay(channelType)
	self.curPaySdk:doPay(payInfo)
end

return PayHelper