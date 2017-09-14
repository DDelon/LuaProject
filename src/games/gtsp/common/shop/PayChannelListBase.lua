
local PayChannelListBase = class("PayChannelListBase", SmallGamesGMF.LoadPackages("mvc").ViewBase)

function PayChannelListBase:onCreate()
    self.super:onCreate()
end

function PayChannelListBase:onInit()
    self.super:onInit()
    self.channelInfoList = {
        Wechat = {type=SmallGamesGI.PaySDKType.Wechat, relation="wechat", icon="pay_ico_wx.png", 	name="微信支付",  visible=(bit.band(PAY_SWITCH, 1) == 1 and true or false)},
        Alipay = {type=SmallGamesGI.PaySDKType.Alipay, relation="alipay_client", icon="pay_ico_alipay.png", name="支付宝支付",visible=(bit.band(PAY_SWITCH, 2) == 2 and true or false) },
        Unionpay = {type=SmallGamesGI.PaySDKType.Unionpay, relation="unionpay_client", icon="pay_ico_union.png",  name="银联支付",  visible=(bit.band(PAY_SWITCH, 4) == 4 and true or false) },
        Apple = {type=SmallGamesGI.PaySDKType.Apple, relation="appstore", icon="pay_ico_apple.png",  name="苹果支付",  visible=(bit.band(PAY_SWITCH, 8) == 8 and true or false) },
    }
end

function PayChannelListBase:onEnter()
    self.super:onEnter()
end

function PayChannelListBase:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function PayChannelListBase:onEnterAni()
    self:enterAni(self.panel)
end

function PayChannelListBase:onExit()
    self.super:onExit()
end

function PayChannelListBase:onExitAni()
    self:exitAni(self.panel)
end

function PayChannelListBase:onKeyback()
    self.super:onKeyback()
end

function PayChannelListBase:onTouchBegan(touch, event)
    return true
end

function PayChannelListBase:setPayInfo(payInfo)
    self.payInfo = payInfo
end

return PayChannelListBase
