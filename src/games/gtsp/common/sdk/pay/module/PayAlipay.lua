local PayAlipay = class("PayAlipay", SmallGamesGF.getPayBase())

function PayAlipay.create()
	local obj = PayAlipay.new()
	obj:init(payInfo)
	return obj
end

function PayAlipay:init()
	self.super.init(self)
	self.type = SmallGamesGI.PaySDKType.Alipay
end

function PayAlipay:doPay(payInfo, extendData)
	self.super.doPay(self, payInfo, extendData)
end

return PayAlipay