local ShareHelper = class("ShareHelper")

function ShareHelper.create()
	local obj = ShareHelper.new()
	obj:init()
	return obj
end

function ShareHelper:init()
end

function ShareHelper:setBottomCallData(luaData)
	self.luaBottomCallData = luaData
end

function ShareHelper:createShare(type)
	print("ShareHelper:createShare "..type)
	self.curShareSdk = require(SmallGamesGI.commonSrcPath..".sdk.share.module.Share"..type).create()
	if self.luaBottomCallData[device.platform] then
		if self.luaBottomCallData[device.platform].list[type] then
			self.curShareSdk:setLuaBottomCallData(self.luaBottomCallData[device.platform].list[type])
		elseif self.luaBottomCallData[device.platform].common then
			self.curShareSdk:setLuaBottomCallData(self.luaBottomCallData[device.platform].common)
		end
	end
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