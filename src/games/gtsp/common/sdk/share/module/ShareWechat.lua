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

function ShareWechat:doShare(shareInfo, extendData)
	self.super.doShare(self, shareInfo)
end

return ShareWechat