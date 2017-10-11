local ShareHelper = class("ShareHelper")

function ShareHelper.create()
	local obj = ShareHelper.new()
	obj:init()
	return obj
end

function ShareHelper:init()
end

function ShareHelper:initBottomCallData()
	local extendShareData = SmallGamesGI.ExtendGameConf:getShareData()
	self.luaBottomCallData = {}
	if extendShareData.wechat[device.platform] then
		self.luaBottomCallData.wechat = extendShareData.wechat[device.platform]
	end
end

function ShareHelper:createShare(type)
	print("ShareHelper:createShare "..type)
	self.curShareSdk = require(SmallGamesGI.commonSrcPath..".sdk.share.module.Share"..type).create()
	if type == SmallGamesGI.ShareSDKType.Wechat then
		if self.luaBottomCallData.wechat then
			self.curShareSdk:setLuaBottomCallData(self.luaBottomCallData.wechat)
		end
	end
	SmallGamesGI.ExtendGameConf.share_type = string.lower( type )
end

function ShareHelper:doShare(type, shareInfo)
	if SmallGamesGI.lobbyName == SmallGamesGI.lobbyList.Xyx then
		return
	end
	if device.platform ~= "android" and device.platform ~= "ios" then
		return
	end

    self:createShare(type)
    self.curShareSdk:doShare(shareInfo)
end

return ShareHelper