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

function PayUnionpay:doPay(payInfo)
	self.super.doPay(self, payInfo)
end

return PayUnionpay