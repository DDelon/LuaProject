
local ShopLayer = class("ShopLayer", require(SmallGamesGI.ShopLayerBase))

ShopLayer.AUTO_RESOLUTION   = true
ShopLayer.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("shop."..SmallGamesGI.lobbyNameLower..".uishop.lua")
ShopLayer.RESOURCE_BINDING  = {
    panel                   = { parent = nil, varname = "panel" },
    img_bg                  = { parent = "panel", varname = "img_bg" },
        btn_close                 = { parent = "img_bg", varname = "btn_close", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickClose"} },
    scroll_shop_fishcoin    = { parent = "panel", varname = "scroll_shop_fishcoin" },
}

function ShopLayer:onCreate()
    self.super:onCreate()
    self:openKeyboard()
end

function ShopLayer:onInit()
    self.super:onInit()
    self:initView()
end

function ShopLayer:onEnter()
    self.super:onEnter()
end

function ShopLayer:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function ShopLayer:onExit()
    self.super:onExit()
end

function ShopLayer:onKeyback()
    self.super:onKeyback()
    self:onQuit()
end

function ShopLayer:onEnterAni()
    self:enterAni(self.panel)
end

function ShopLayer:onExitAni()
    self:exitAni(self.panel)
end

function ShopLayer:onClickClose( sender )
    self:onQuit()
end

function ShopLayer:initView()
    self.fishcoinListView = {}

    self.cell_h_count = 2      -- 格子横向数
    self.cell_v_count = 3      -- 格子纵向数
    local cellCountSize = self.scroll_shop_fishcoin:getContentSize()
    -- 计算出每个格子的宽高
    self.cellW = cellCountSize.width / self.cell_h_count
    self.cellH = cellCountSize.height / self.cell_v_count

    self:initFishCoinScroll(SmallGamesGI.storeProductDatas["1"]) 
    
    local function scrollviewEvent(sender,eventType)
        if eventType==ccui.ScrollviewEventType.scrollToBottom then
           --print("滚动到底部噢")
        elseif eventType==ccui.ScrollviewEventType.scrollToTop then
            --print("滚动到顶部噢")
        elseif eventType== ccui.ScrollviewEventType.scrolling then
            --print("滚动中噢")
        end
    end
    self.scroll_shop_fishcoin:addEventListener(scrollviewEvent)

end

function ShopLayer:initFishCoinScroll(valTab)
    local count = valTab["count"]
    for i=1,count do
        local data = valTab[i]
        local shopItem = self:createShopItem()
        data.platformId = 287
        shopItem:setItemData(data)
        self.scroll_shop_fishcoin:addChild( shopItem)
        self.fishcoinListView[i] = shopItem
    end
    self:updataScrollView(self.scroll_shop_fishcoin,self.fishcoinListView)
end

function ShopLayer:updataScrollView(listView,itemList)
    local count = #itemList
    local all_h_count = math.floor((count-1) /2)+1
    listView:setInnerContainerSize(cc.size(self.cellW*2, all_h_count*self.cellH + 8))
    for i=1,count do
        local shopItem = itemList[i]
        shopItem:setPosition(cc.p(self.cellW/2 + math.mod(i+1,2) * self.cellW, all_h_count*self.cellH - self.cellH/2 - math.floor((i-1)/2) *self.cellH))
    end
end

return ShopLayer
