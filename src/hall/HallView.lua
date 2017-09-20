local HallView = class("HallView", cc.load("mvc").ViewBase)

function HallView:onCreate(...)
    self.scaleX_,self.scaleY_,self.scaleMin_  = FishGF.getCurScale()

    self.hallUI = require("hall/HallLayer").create();
	self:addChild(self.hallUI,1)

    self.loadingLayer = require("Loading/LoadingLayer").new()
    self:addChild(self.loadingLayer,FishCD.ORDER_LOADING)

    --大厅公告
    self.uiHallNotice = require("hall/HallNotice/HallNotice").create()
    self.uiHallNotice:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,612.14*self.scaleY_))
    self:addChild(self.uiHallNotice,FishCD.ORDER_SCENE_UI)
    self.uiHallNotice:setVisible(false)  
    
    --大厅房间图标
    self.uiAllRoomView = require("hall/Room/AllRoomView").create()
    self.uiAllRoomView:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,366.05*self.scaleY_))
    self:addChild(self.uiAllRoomView,2)
    --self.uiAllRoomView:setVisible(false)  
    self.uiAllRoomView:setScale(self.scaleMin_)

    --背包
    self.uiBagLayer = require("hall/Bag/Bag").create()
    self.uiBagLayer:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiBagLayer,FishCD.ORDER_LAYER_TRUE)
    self.uiBagLayer:setVisible(false)   
    self.uiBagLayer:setScale(self.scaleMin_)

    --兑换
    self.uiExchange = require("hall/Exchange/Exchange").create()
    self.uiExchange:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiExchange,FishCD.ORDER_LAYER_TRUE)
    self.uiExchange:setVisible(false)   
    self.uiExchange:setScale(self.scaleMin_)

    --商店
    self.uiShopLayer = require("Shop/Shop").create()
    self.uiShopLayer:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiShopLayer,FishCD.ORDER_LAYER_TRUE)
    self.uiShopLayer:setVisible(false)   
    self.uiShopLayer:setScale(self.scaleMin_)

    --月卡
    self.uiMonthcard = require("hall/Monthcard/Monthcard").create()
    self.uiMonthcard:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,330*self.scaleY_))
    self:addChild(self.uiMonthcard,FishCD.ORDER_LAYER_TRUE)
    self.uiMonthcard:setVisible(false)   
    self.uiMonthcard:setScale(self.scaleMin_)

    --VIP特权
    self.uiVipRight = require("VipRight/VipRight").create()
    self.uiVipRight:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiVipRight,FishCD.ORDER_LAYER_TRUE)
    self.uiVipRight:setVisible(false)
    self.uiVipRight:setScale(self.scaleMin_)

    --签到
    self.uiCheck = require("hall/Check/Check").create()
    self.uiCheck:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiCheck,FishCD.ORDER_LAYER_TRUE)
    self.uiCheck:setVisible(false)
    self.uiCheck:setScale(self.scaleMin_)

    --微信分享
    self.uiWeChatShare = require("hall/WeChatShare/WeChatShare").create()
    self.uiWeChatShare:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiWeChatShare,FishCD.ORDER_LAYER_TRUE)
    self.uiWeChatShare:setVisible(false)
    self.uiWeChatShare:setScale(self.scaleMin_)

    --邀请码邀请
    self.uiInviteFriend = require("hall/WeChatShare/InviteFriend").create()
    self.uiInviteFriend:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiInviteFriend,FishCD.ORDER_LAYER_TRUE)
    self.uiInviteFriend:setVisible(false)
    self.uiInviteFriend:setScale(self.scaleMin_)

    --邮箱
    self.uiMail = require("hall/Mail/Mail").create()
    self.uiMail:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiMail,FishCD.ORDER_LAYER_TRUE)
    self.uiMail:setVisible(false)
    self.uiMail:setScale(self.scaleMin_)

    --邮件正文
    self.uiMailBody = require("hall/Mail/MailBody").create()
    self.uiMailBody:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiMailBody,FishCD.ORDER_LAYER_TRUE)
    self.uiMailBody:setVisible(false)
    self.uiMailBody:setScale(self.scaleMin_)
    
    --锻造
    self.uiForgedLayer = require("hall/Forged/Forged").create()
    self.uiForgedLayer:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiForgedLayer,FishCD.ORDER_LAYER_TRUE)
    self.uiForgedLayer:setVisible(false)   
    self.uiForgedLayer:setScale(self.scaleMin_)

    --每日任务
    self.taskPanel = require("hall/Task/TaskUI/TaskMain").new()
    self.taskPanel:setAnchorPoint(0.5, 0.5)
    self.taskPanel:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.taskPanel, FishCD.ORDER_GAME_task);
    self.taskPanel:setVisible(false)

    self.uiFriendRoom = require("hall/FriendRoom/FriendRoom").create();
	self:addChild(self.uiFriendRoom,1)

    --规则介绍
    self.uiRuleIntroduction = require("hall/FriendRoom/RuleIntroduction").create()
    self.uiRuleIntroduction:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiRuleIntroduction,FishCD.ORDER_LAYER_TRUE)
    self.uiRuleIntroduction:setVisible(false)   
    self.uiRuleIntroduction:setScale(self.scaleMin_)

    --加入房间
    self.uiJoinRoom = require("hall/FriendRoom/JoinRoom").create()
    self.uiJoinRoom:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiJoinRoom,FishCD.ORDER_LAYER_TRUE)
    self.uiJoinRoom:setVisible(false)   
    self.uiJoinRoom:setScale(self.scaleMin_)

    --历史记录
    self.uiRecord = require("hall/Record/Record").create()
    self.uiRecord:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiRecord,FishCD.ORDER_LAYER_TRUE)
    self.uiRecord:setVisible(false)   
    self.uiRecord:setScale(self.scaleMin_)

    --详细历史记录
    self.uiRecordBody = require("hall/Record/RecordBody").create()
    self.uiRecordBody:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiRecordBody,FishCD.ORDER_LAYER_TRUE)
    self.uiRecordBody:setVisible(false)   
    self.uiRecordBody:setScale(self.scaleMin_)

    --创建成功
    self.uiCreateSuceed = require("hall/FriendRoom/CreateSuceed").create()
    self.uiCreateSuceed:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiCreateSuceed,FishCD.ORDER_LAYER_TRUE)
    self.uiCreateSuceed:setVisible(false)   
    self.uiCreateSuceed:setScale(self.scaleMin_)

    --账号设置
    self.uiPlayerInfo = require("PlayerInfo/PlayerInfo").create()
    self.uiPlayerInfo:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiPlayerInfo,FishCD.ORDER_LAYER_TRUE)
    self.uiPlayerInfo:setVisible(false)
    self.uiPlayerInfo:setScale(self.scaleMin_)

    --解绑手机
    self.uiPhoneUnbind = require("PlayerInfo/PhoneUnbind").create()
    self.uiPhoneUnbind:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiPhoneUnbind,FishCD.ORDER_LAYER_TRUE)
    self.uiPhoneUnbind:setVisible(false)
    self.uiPhoneUnbind:setScale(self.scaleMin_)

    --修改密码
    self.uiChangePassword = require("PlayerInfo/ChangePassword").create()
    self.uiChangePassword:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiChangePassword,FishCD.ORDER_LAYER_TRUE)
    self.uiChangePassword:setVisible(false)
    self.uiChangePassword:setScale(self.scaleMin_)

    --普通激活
    self.uiComAct = require("PlayerInfo/ComAct").create()
    self.uiComAct:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiComAct,FishCD.ORDER_LAYER_TRUE)
    self.uiComAct:setVisible(false)
    self.uiComAct:setScale(self.scaleMin_)

    --手机激活
    self.uiPhoneAct = require("PlayerInfo/PhoneAct").create()
    self.uiPhoneAct:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiPhoneAct,FishCD.ORDER_LAYER_TRUE)
    self.uiPhoneAct:setVisible(false)
    self.uiPhoneAct:setScale(self.scaleMin_)

    --手机绑定
    self.uiPhoneBind = require("PlayerInfo/PhoneBind").create()
    self.uiPhoneBind:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiPhoneBind,FishCD.ORDER_LAYER_TRUE)
    self.uiPhoneBind:setVisible(false)
    self.uiPhoneBind:setScale(self.scaleMin_)

    --修改昵称
    self.uiChangeNickName = require("PlayerInfo/ChangeNickName").create()
    self.uiChangeNickName:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(self.uiChangeNickName,FishCD.ORDER_LAYER_TRUE)
    self.uiChangeNickName:setVisible(false)
    self.uiChangeNickName:setScale(self.scaleMin_)
end

function HallView:loadRes(func)
    self.loadingLayer:preloadRes(handler(self, self.getGameNetData))
end

function HallView:closeLoading()
    self.loadingLayer:setVisible(false)
    self.loadingLayer:closeAllSchedule()
end

function HallView:quickStartGame()
    self.uiAllRoomView:faseStartGame();
end

function HallView:notifyEnterHall()
    self.taskPanel:onEnterHall()
end

return HallView;