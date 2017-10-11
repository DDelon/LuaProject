local PayHelper = class("PayHelper")

function PayHelper.create()
	local obj = PayHelper.new()
	obj:init()
	return obj
end

function PayHelper:init()
end

function PayHelper:initBottomCallData()
	local isGcsdk = SmallGamesGF.isGcsdkChannel()
	local extendPayData = SmallGamesGI.ExtendGameConf:getPayData()
	if isGcsdk then
		local channelName = SmallGamesGF.getChannelName()
		if channelName and extendPayData[channelName] then
			if extendPayData[channelName][device.platform] then
				self.luaBottomCallData = extendPayData[channelName][device.platform]
			elseif extendPayData.gcsdk[device.platform] then
				self.luaBottomCallData = extendPayData.gcsdk[device.platform]
			end
		end
	else
		self.luaBottomCallData = {}
		if extendPayData.wechat[device.platform] then
			self.luaBottomCallData.wechat = extendPayData.wechat[device.platform]
		else
			self.luaBottomCallData.wechat = extendPayData.common[device.platform]
		end
		if extendPayData.apliay[device.platform] then
			self.luaBottomCallData.alipay = extendPayData.alipay[device.platform]
		else
			self.luaBottomCallData.alipay = extendPayData.common[device.platform]
		end
		if extendPayData.unionpay[device.platform] then
			self.luaBottomCallData.unionpay = extendPayData.unionpay[device.platform]
		else
			self.luaBottomCallData.unionpay = extendPayData.common[device.platform]
		end
		if extendPayData.apple[device.platform] then
			self.luaBottomCallData.apple = extendPayData.apple[device.platform]
		else
			self.luaBottomCallData.apple = extendPayData.common[device.platform]
		end
	end
end

function PayHelper:createPay(channelType)
	print("PayHelper:createPay "..channelType)
	self.curPaySdk = require(SmallGamesGI.commonSrcPath..".sdk.pay.module.Pay"..channelType).create()
	local isGcsdkChannel = SmallGamesGF.isGcsdkChannel()
	if isGcsdkChannel then
		self.curPaySdk.gcsdkType = SmallGamesGF.getChannelName()
		SmallGamesGI.ExtendGameConf.pay_type = self.curPaySdk.gcsdkType
		SmallGamesGI.ExtendGameConf.is_thirdpay_sdk = isGcsdkChannel
		self.curPaySdk:setLuaBottomCallData(self.luaBottomCallData)
	else
		SmallGamesGI.ExtendGameConf.pay_type = string.lower( channelType )
		SmallGamesGI.ExtendGameConf.is_thirdpay_sdk = isGcsdkChannel
		self.curPaySdk:setLuaBottomCallData(self.luaBottomCallData[string.lower( channelType )])
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