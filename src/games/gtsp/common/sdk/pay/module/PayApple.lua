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

function PayApple:doPay(payInfo, extendData)
	self.super.doPay(self, payInfo, extendData)
end

return PayApple