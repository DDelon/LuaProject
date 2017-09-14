local PayApple = class("PayApple", SmallGamesGF.getPayBase())

function PayApple.create()
	local obj = PayApple.new()
	obj:init(payInfo)
	return obj
end

function PayApple:init()
	self.super.init(self)
	self.type = SmallGamesGI.PaySDKType.Apple
end

function PayApple:doPay(payInfo)
	self.super.doPay(self, payInfo)
end

return PayApple