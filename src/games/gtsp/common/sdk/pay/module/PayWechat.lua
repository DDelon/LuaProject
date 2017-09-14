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

function PayWechat:doPay(payInfo)
	self.super.doPay(self, payInfo)
end

return PayWechat