
local ShopItem = class("ShopItem", require(SmallGamesGI.ShopItemBase))

ShopItem.AUTO_RESOLUTION   = false
ShopItem.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("shop."..SmallGamesGI.lobbyNameLower..".uishopitem.lua")
ShopItem.RESOURCE_BINDING  = {
    panel                   = { parent = nil, varname = "panel" },
    spr_shop_item           = { parent = "panel", varname = "spr_shop_item" },
    text_name               = { parent = "panel", varname = "text_name" },
    text_word               = { parent = "panel", varname = "text_word" },
    btn_buy                 = { parent = "panel", varname = "btn_buy", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickBuy"} },
        fnt_price               = { parent = "btn_buy", varname = "fnt_price" },
}

function ShopItem:onCreate()
    self.super:onCreate()
end

function ShopItem:onInit()
    self.super:onInit()
end

function ShopItem:onEnter()
    self.super:onEnter()
end

function ShopItem:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function ShopItem:onExit()
    self.super:onExit()
end

function ShopItem:setItemData(valTab)   
    self.id = valTab.id
    self.recharge_name = valTab.name
    local recharge_type = valTab.type
    local recharge = valTab.price
    local recharge_num = valTab.num
    local gift_num = valTab.gift_num
    local frist_change_enable = valTab.frist_charge
    local recharge_res = valTab.image

    self:setType(recharge_type)
    self:setPrice(recharge)
    self:setGoodsNum(recharge_num)
    self:setItemPic( recharge_res )
    self:setIsRecharge(frist_change_enable)
    self:setExtraCharges(gift_num)
    self:setGoodsName(self.recharge_name)
end

function ShopItem:updateItem(frist_change_enable)
    self:setIsRecharge(frist_change_enable);
    self:setExtraCharges(self.gift_num);
end

--类型  鱼币 水晶
function ShopItem:setType( recharge_type )
    self.recharge_type = recharge_type
    if recharge_type == 1 then
        self.unit = FishGF.getChByIndex(800000098)
    elseif recharge_type == 2 then
        self.unit = FishGF.getChByIndex(800000099)
    elseif recharge_type == 3 then
        self.unit = "月卡"
    end
    
end

--商城IOCN资源
function ShopItem:setItemPic( recharge_res )
    self.spr_shop_item:initWithFile("shop/"..recharge_res)
end

--充值额度
function ShopItem:setPrice( recharge )
    self.recharge = recharge
    self.fnt_price:setString((recharge/100).."$")
end

--得到货币数值
function ShopItem:setGoodsNum( recharge_num )
    self.recharge_num = recharge_num
end

--设置物品名称
function ShopItem:setGoodsName( recharge_name )
    self.recharge_name = recharge_name
    self.text_name:setString(recharge_name)
end

--是否首充，或者充值过了
function ShopItem:setIsRecharge( isRecharge )
    self.isRecharge = isRecharge

end

--额外赠送
function ShopItem:setExtraCharges( gift_num )
    self.gift_num = gift_num
    local str = nil
    if self.isRecharge == 1 then
        str = FishGF.getChByIndex(800000100)
    else
        if self.gift_num == 0 then
            str = ""
        else
            str = FishGF.getChByIndex(800000101)..gift_num..self.unit
        end
    end
    if self.recharge_type == 3 then
        str = FishGF.getChByIndex(800000311)
    end
    self.text_word:setString(str)
end

function ShopItem:onClickBuy( sender )
    print("id-----"..self.id)
    local data = {}
    data["id"] = self.id
    data["goods"] = self.id
    data["name"] = self.recharge_name
    data["body"] = self.unit.." "..self.id.." x1"
    data["money"] = self.recharge
    data["price"] = self.recharge/100
    data["type"] = self.recharge_type
    data["autobuy"] = 1
    data["subject"] = self.unit
    data["ingame"] = 1
    data["roomid"] = 0
    data["count"] = 1
    data["debug"] = 0
    data["udid"] = Helper.GetDeviceCode()
    self:onDoPay(data)
end

return ShopItem