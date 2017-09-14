
local ShopItemBase = class("ShopItemBase", SmallGamesGMF.LoadPackages("mvc").ViewBase)

function ShopItemBase:onCreate()
    self.super:onCreate()
end

function ShopItemBase:onInit()
    self.super:onInit()
end

function ShopItemBase:onEnter()
    self.super:onEnter()
end

function ShopItemBase:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function ShopItemBase:onExit()
    self.super:onExit()
end

function ShopItemBase:onTouchBegan(touch,event)
    return false
end

function ShopItemBase:onDoPay( payInfo )
    local channelType = 0
    if not SmallGamesGF.isGcsdkChannel() then
        if bit.band(PAY_SWITCH, 8) == 8 and PAY_SWITCH == 8 then
            payInfo.productType = payInfo.type
            local cfgTable = checktable(PAY_CONFIG["appstore"][payInfo.type])
            payInfo.goods = cfgTable[payInfo.price]
			print("goods "..payInfo.goods)
            channelType = SmallGamesGI.PaySDKType.Apple
        else
            local payChannelList = SmallGamesGF.createView(SmallGameApp.PayChannelList, self, nil)
            payChannelList:setPayInfo(payInfo)
            payChannelList:updateView()
            payChannelList:setPosition(cc.p(display.width/2, display.height/2))
            SmallGamesGI.curScene:addChild(payChannelList)
            return
        end
    else
        channelType = SmallGamesGI.PaySDKType.Gcsdk
    end

    SmallGamesGI.PayHelper:doPay(channelType, payInfo)
end

return ShopItemBase;