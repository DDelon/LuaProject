
local PayChannelItemBase = class("PayChannelItemBase", SmallGamesGMF.LoadPackages("mvc").ViewBase)

function PayChannelItemBase:onCreate()
    self.super:onCreate()
end

function PayChannelItemBase:onInit()
    self.super:onInit()
end

function PayChannelItemBase:onEnter()
    self.super:onEnter()
end

function PayChannelItemBase:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function PayChannelItemBase:onExit()
    self.super:onExit()
end

function PayChannelItemBase:onTouchBegan(touch, event)
    return false
end

function PayChannelItemBase:setPayInfo(payInfo )
    self.payInfo = payInfo
end

function PayChannelItemBase:setRelation(relation)
    self.relation = relation
end

function PayChannelItemBase:setChannelType(channelType)
    self.channelType = channelType
end

function PayChannelItemBase:onDoPay()
    self.payInfo["type"] = self.relation
    SmallGamesGI.PayHelper:doPay(self.channelType, self.payInfo)
end

return PayChannelItemBase;