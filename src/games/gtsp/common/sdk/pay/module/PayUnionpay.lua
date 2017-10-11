local PayUnionpay = class("PayUnionpay", SmallGamesGF.getPayBase())

function PayUnionpay.create()
	local obj = PayUnionpay.new()
	obj:init(payInfo)
	return obj
end

function PayUnionpay:init()
	self.super.init(self)
	self.type = SmallGamesGI.PaySDKType.Unionpay
end

function PayUnionpay:doPay(payInfo, extendData)
	self.super.doPay(self, payInfo, extendData)
end

return PayUnionpay