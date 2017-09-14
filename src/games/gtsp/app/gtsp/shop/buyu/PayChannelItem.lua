
local PayChannelItem = class("PayChannelItem", require(SmallGamesGI.PayChannelItemBase))

PayChannelItem.AUTO_RESOLUTION   = false
PayChannelItem.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("shop."..SmallGamesGI.lobbyNameLower..".uiPayChannelItem.lua")
PayChannelItem.RESOURCE_BINDING  = {
    panel                   = { parent = nil, varname = "panel" },
    btn_pay                 = { parent = "panel", varname = "btn_pay", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickPay"} },
        spr_icon                = { parent = "btn_pay", varname = "spr_icon" },
        text_channel_name       = { parent = "btn_pay", varname = "text_channel_name" },
}

function PayChannelItem:onCreate()
    self.super:onCreate()
end

function PayChannelItem:onInit()
    self.super:onInit()
end

function PayChannelItem:onEnter()
    self.super:onEnter()
end

function PayChannelItem:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function PayChannelItem:onExit()
    self.super:onExit()
end

function PayChannelItem:updateView(icon, name)
    self.spr_icon:setTexture(SmallGamesGF.getCommonResPath(icon))
    self.text_channel_name:setString(name)
end

function PayChannelItem:onClickPay( sender )
    self:onDoPay()
end

return PayChannelItem