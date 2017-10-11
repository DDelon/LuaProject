local PayBase = class("PayBase")

function PayBase:init()
	self.type = 0
	self.callfunc = nil
end

function PayBase:setLuaBottomCallData(luaBottomCallData)
	self.luaBottomCallData = luaBottomCallData
end

function PayBase:getPayCallBackUrl()
    return string.format("http://thirdpay.%s/callback/%%s/%s/%s/%s/%s", WEB_DOMAIN, 
        SmallGameApp.AppId, SmallGamesGI.lobbyData.ChannelId, SmallGamesGF.getHallVerison(), REGION_CODE)
end

function PayBase:doPay(payData)
	local payInfo = SmallGamesGI.ExtendGameConf:makeOrderData(payData)
	local function callfunc(data)
		local resultData = SmallGamesGI.ExtendGameConf:makeOrderResultData(data, payInfo)
		if resultData then
			local extendData = {}
			if device.platform == "android" then
				extendData.handlerCallback = handler(self, self.onCallback_)
				if SmallGamesGF.isGcsdkChannel() then
					extendData.thirdpayCallbackUrl = self:getPayCallBackUrl()
				end
				local javaParams = SmallGamesGI.ExtendGameConf:makeAndroidPayParams(resultData, extendData)
				if javaParams then
					self:doPayAndroid(javaParams)
				end
			elseif device.platform == "ios" then
				extendData.handlerCallback = handler(self, self.onIosCallback_)
				local objectParams = SmallGamesGI.ExtendGameConf:makeIosPayParams(resultData, extendData)
				if objectParams then
					self:doPayIos(objectParams)
				end
			end
		else
            print("下单失败！" .. data.msg)
        end
    end
	SmallGamesGI.Dapi:OrderNew(payInfo, callfunc)
end

function PayBase:doPayAndroid(javaParams)
	local luaBridge = require("cocos.cocos2d.luaj")
	if self.luaBottomCallData.callbackResult then
    	luaBridge.callStaticMethod(self.luaBottomCallData.className, self.luaBottomCallData.callbackResult, { handler(self, self.onCallback_) })
	end
	local javaMethodName = self.luaBottomCallData.methodName
    luaBridge.callStaticMethod(self.luaBottomCallData.className, javaMethodName, javaParams, self.luaBottomCallData.methodSig)
end

function PayBase:doPayIos(payInfo)
	if self.luaBottomCallData == nil then
		return
	end
	local iosClassName = self.luaBottomCallData.className
	local methodName = self.luaBottomCallData.methodName
    local luaoc = require("cocos.cocos2d.luaoc")
	local ok, ret = luaoc.callStaticMethod(iosClassName, methodName, payInfo)
	if not ok then
		print("call oc class:"..iosClassName.." method:"..methodName.." failure")
	end
end

function PayBase:doPaySDK(payInfo)
	local function payResult(resultInfo)
    print("------------payResult")
	local resultTab = json.decode(resultInfo)
		if FishGI.GAME_STATE == 3 then
			FishGI.gameScene.net:sendBackFromCharge()
		end		
        if resultTab.resultCode == 0 then
            --成功
            FishGF.print("------recharge succeed----")
            if FishGI.GAME_STATE == 2 then
				FishGF.waitNetManager(true,nil,"doPaySDK")
				FishGI.IS_RECHARGE = 5
                --FishGI.hallScene.net.roommanager:sendDataGetInfo();
            elseif FishGI.GAME_STATE == 3 then
				FishGI.WebUserData:initWithUserId(FishGI.WebUserData:GetUserId())
                FishGI.gameScene.net:sendReChargeSucceed()
            end
        else
            FishGF.print("------recharge faile----")
            FishGF.showSystemTip(nil,800000169,1);
        end
        --删除面板
        cc.Director:getInstance():getRunningScene():removeChildByTag(FishCD.TAG.PAY_VIEW_TAG);
    end
    print("----------------do pay sdk")
    FishGI.GameCenterSdk:trySDKPay(payInfo, payResult)
end

function PayBase:onCallback_(...) 
	local resultStatus = SmallGamesGI.ExtendGameConf:makeAndroidPayResultData(...)
	if resultStatus == 0 then
		print("------recharge succeed----")
		SmallGamesGI.eventDispatcher:dispatch("OnChargeSucceed", nil)
	else
		print("------recharge faile----")
	end
end

function PayBase:onIosCallback_(...)
	local resultStatus = SmallGamesGI.ExtendGameConf:makeIosPayResultData(...)
	if resultStatus == 0 then
		print("------recharge succeed----")
		SmallGamesGI.eventDispatcher:dispatch("OnChargeSucceed", nil)
	else
		print("------recharge faile----")
	end
end

function PayBase:doPaySDKResult(resultStr)
	--[[local ok,argtable = pcall(function()         
        return loadstring(resultStr)();
    end)]]--

	local resultTab = json.decode(resultStr);
	if FishGI.GAME_STATE == 3 then
		FishGI.gameScene.net:sendBackFromCharge()
	end		
    if resultTab ~= nil then
    	local payArgs = checktable(resultTab);
		if FishGI.GAME_STATE == 2 then
			FishGI.hallScene.net.roommanager:sendDataGetInfo();
		elseif FishGI.GAME_STATE == 3 then
			print("-------------------------ref------")
			FishGI.gameScene.net:sendReChargeSucceed()
		end
		
    	self.callfunc(payArgs);
    else
    	print("sdk返回的数据出错");
    end
end

return PayBase