local PayWechat = class("PayWechat", SmallGamesGF.getPayBase())

function PayWechat.create()
	local obj = PayWechat.new()
	obj:init(payInfo)
	return obj
end

function PayWechat:init()
	self.super.init(self)
	self.type = SmallGamesGI.PaySDKType.Wechat
end

function PayWechat:doPay(payInfo, extendData)
	self.super.doPay(self, payInfo, extendData)
end

return PayWechat