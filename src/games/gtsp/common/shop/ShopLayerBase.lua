
local ShopLayerBase = class("ShopLayerBase", SmallGamesGMF.LoadPackages("mvc").ViewBase)

function ShopLayerBase:onCreate()
    self.super:onCreate()
end

function ShopLayerBase:onInit()
    self.super:onInit()
    self.storeProductDatas = SmallGamesGI.storeData.productConfig
end

function ShopLayerBase:onEnter()
    self.super:onEnter()
end

function ShopLayerBase:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function ShopLayerBase:onExit()
    self.super:onExit()
end

function ShopLayerBase:onKeyback()
    self.super:onKeyback()
end

function ShopLayerBase:onTouchBegan(touch, event)
    return true 
end

function ShopLayerBase:createShopItem()
    return SmallGamesGF.createView(SmallGameApp.ShopItem)
end

return ShopLayerBase
