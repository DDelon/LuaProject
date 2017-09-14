
local PayChannelList = class("PayChannelList", require(SmallGamesGI.PayChannelListBase))

PayChannelList.AUTO_RESOLUTION   = true
PayChannelList.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("shop."..SmallGamesGI.lobbyNameLower..".uiPayChannelList.lua")
PayChannelList.RESOURCE_BINDING  = {
    panel                   = { parent = nil, varname = "panel" },
    btn_close               = { parent = "panel", varname = "btn_close", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickClose"} },
    text_goods_label        = { parent = "panel", varname = "text_goods_label" },
    text_goods              = { parent = "panel", varname = "text_goods" },
    text_price_label        = { parent = "panel", varname = "text_price_label" },
    text_price              = { parent = "panel", varname = "text_price" },
    node_channel_1          = { parent = "panel", varname = "node_channel_1", events={event=SmallGamesGI.bindingEvents.FileNode, viewName = "PayChannelItem1", luaFile=SmallGamesGF.getCurAppSrcPath("shop."..SmallGamesGI.lobbyNameLower..".PayChannelItem")} },
    node_channel_2          = { parent = "panel", varname = "node_channel_2", events={event=SmallGamesGI.bindingEvents.FileNode, viewName = "PayChannelItem2", luaFile=SmallGamesGF.getCurAppSrcPath("shop."..SmallGamesGI.lobbyNameLower..".PayChannelItem")} },
    node_channel_3          = { parent = "panel", varname = "node_channel_3", events={event=SmallGamesGI.bindingEvents.FileNode, viewName = "PayChannelItem3", luaFile=SmallGamesGF.getCurAppSrcPath("shop."..SmallGamesGI.lobbyNameLower..".PayChannelItem")} },
    node_channel_4          = { parent = "panel", varname = "node_channel_4", events={event=SmallGamesGI.bindingEvents.FileNode, viewName = "PayChannelItem4", luaFile=SmallGamesGF.getCurAppSrcPath("shop."..SmallGamesGI.lobbyNameLower..".PayChannelItem")} },
}

function PayChannelList:onCreate(payInfo)
    self.super:onCreate()
    self:openKeyboard()
end

function PayChannelList:onInit()
    self.super:onInit()
    self.channelList = {
        { id=4, info=self.channelInfoList.Apple },
        { id=1, info=self.channelInfoList.Wechat },
        { id=2, info=self.channelInfoList.Alipay },
        { id=3, info=self.channelInfoList.Unionpay },
    }
    if device.platform~="ios" then
    	self.channelList[1].info.visible=false
    end
end

function PayChannelList:onEnter()
    self.super:onEnter()
end

function PayChannelList:onEnterTransitionFinish()
    self.super:onEnterTransitionFinish()
end

function PayChannelList:onExit()
    self.super:onExit()
end

function PayChannelList:onKeyback()
    self.super:onKeyback()
    self:onQuit()
end

function PayChannelList:onEnterAni()
    self:enterAni(self.panel)
end

function PayChannelList:onExitAni()
    self:exitAni(self.panel)
end

function PayChannelList:onClickClose( sender )
    self:onQuit()
end

function PayChannelList:updateView()
    if self.payInfo == nil then
        return
    end
    self.text_goods:setString(self.payInfo.name)
    self.text_price:setString("￥"..tostring(self.payInfo.price))

    local index = 1
    for i,v in ipairs(self.channelList) do
        local node_channel = self["node_channel_"..v.id]
        local channel_info = v.info
        if channel_info.visible then
            node_channel:setPayInfo(self.payInfo)
            node_channel:updateView(channel_info.icon, channel_info.name)
            node_channel:setPosition(cc.p(self["node_channel_"..index]:getPosition()))
            node_channel:setChannelType(channel_info.type)
            node_channel:setRelation(channel_info.relation)
            index = index + 1
        end
        node_channel:setVisible(channel_info.visible)
    end
end

return PayChannelList
