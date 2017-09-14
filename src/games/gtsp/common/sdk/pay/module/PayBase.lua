local PayBase = class("PayBase")

function PayBase:init()
	self.type = 0
	local funDoPay = {
		Buyu = self.doPayBuyu,
		Qipai = self.doPayQipai,
	}
	local funDoPayPlatform = {
		android = {
			Buyu = self.doPayAndroidBuyu,
			Qipai = self.doPayAndroidQipai,
		},
		ios = {
			Buyu = self.doPayIosBuyu,
			Qipai = self.doPayIosQipai,
		},
	}
	self.funDoPay = funDoPay[SmallGamesGI.lobbyName]
	self.funDoPayPlatform = funDoPayPlatform[device.platform][SmallGamesGI.lobbyName]
	self.callfunc = nil
end

function PayBase:setLuaBottomCallData(luaBottomCallData)
	self.luaBottomCallData = luaBottomCallData
end

function PayBase:doPay(payInfo)
	if self.funDoPay then
		self.funDoPay(self, payInfo)
	end
end

function PayBase:doPayBuyu(payInfo)
	local function callfunc(data)
        if data and data.status == 0 then
            local payArgs = checktable(data)
            print("orderRequest data:"..json.encode(data))
            table.merge(payArgs, payInfo)
            local ext = data.ext;
            if  ext ~= nil then table.merge(payArgs, ext) end

			self:doPayPlatform(payArgs)
        else
            print("下单失败！" .. data.msg)
            --弹出提示框是否重试
        end
    end
	SmallGamesGI.ApiHelper:OrderNew(payInfo, callfunc)
end

function PayBase:doPayQipai(payInfo)
end

function PayBase:doPayPlatform(payInfo)
	if self.funDoPayPlatform then
		self.funDoPayPlatform(self, payInfo)
	end
end

function PayBase:doPayAndroidBuyu(payInfo)
	self:doPayAndroid(self:getAndroidBuyuPayInfo(payInfo))
end

function PayBase:doPayAndroidQipai(payInfo)
end

function PayBase:doPayIosBuyu(payInfo)
	self:doPayIos(self:getPayIosBuyuInfo())
end

function PayBase:doPayIosQipai(payInfo)
end

function PayBase:getAndroidBuyuPayInfo(payInfo)
	if self.luaBottomCallData == nil then
		return
	end

    local luaBridge = require(SmallGamesGI.luaj)
    luaBridge.callStaticMethod(self.luaBottomCallData.className, self.luaBottomCallData.methonCallbackResult, { handler(self, self.onCallback_) })

    local javaMethodName = self.luaBottomCallData.methodName
    payInfo.virtual=checkint( payInfo.virtual) 
    local jsonArgs = json.encode(payInfo)
    local cfgTable = PAY_CONFIG[payInfo.type]
    local jsonCfg = json.encode(cfgTable)

    local javaParams = {
        payInfo.type,
        jsonArgs,
        jsonCfg
    }
    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
	return javaParams, javaMethodSig
end

function PayBase:getIosBuyuPayInfo(payInfo)
	payInfo.listener = handler(self, self.onIosCallback_)
	payInfo.money = tonumber(payInfo.money)/100
	local cfgTable = checktable(PAY_CONFIG[payInfo.type][payInfo.productType])

	if payInfo.type == "appstore" then
		local productids = table.values(cfgTable)
		payInfo.productidarray = json.encode(productids)
		payInfo.productid = cfgTable[payInfo.money]
		if not payInfo.productid then
			print("don't support item price check ios product config")
			return
		end
	else
		table.merge(payInfo, cfgTable)
	end
	return payInfo
end

function PayBase:doPayAndroid(javaParams, javaMethodSig)
	local luaBridge = require(SmallGamesGI.luaj)
	local javaMethodName = self.luaBottomCallData.methodName
    luaBridge.callStaticMethod(self.luaBottomCallData.className, javaMethodName, javaParams, javaMethodSig)
end

function PayBase:doPayIos(payInfo)
	if self.luaBottomCallData == nil then
		return
	end
	local iosClassName = self.luaBottomCallData.className
	local methodName = self.luaBottomCallData.methodName
    local luaoc = require(SmallGamesGI.luaoc)
	local ok, ret = luaoc.callStaticMethod(iosClassName, methodName, payInfo)
	if not ok then
		print("call oc class:"..iosClassName.." method:"..methodName.." failure")
	end
end

function PayBase:verifyIosReceipt_(luastr, paytype)
    print("verify:"..luastr)
    local ok, args = pcall(function()
        return loadstring(luastr)();
    end)
    if ok then
        print("-----------------ok verify")
		cc.UserDefault:getInstance():setStringForKey("verifydata", luastr);
        local scheduleId = 0;
        local oldVal = FishCD.OVER_TIME;
		local isRecv = false;
        FishCD.OVER_TIME = 9999;
        FishGF.waitNetManager(true,nil,"123456")
        local function requestVerify()
			dump(args)
        	FishGI.Dapi:VerifyIosReceipt(args, function(msg)
        		if scheduleId ~= 0 then
        			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId);
        		end
				if isRecv then
					return;
				end
	            FishGF.waitNetManager(false,nil,"123456")
				cc.UserDefault:getInstance():setStringForKey("verifydata", "");
	            FishCD.OVER_TIME = oldVal;
				isRecv = true;
	            if msg.status == 0 then
	                local ret_tab = { status = msg.status, paytype = paytype, msg = "支付成功！" }
	                
	                self:onCallback_(ret_tab)
	            else
	                print("iap order verify failure");
	            end
	 
	        end)
        end
        requestVerify();
        scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(requestVerify, 5, false)
        
    else
        printf("解析ios 参数失败 %s", luastr)
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

function PayBase:onCallback_(luastr) 
	local ok = false;
	local resultInfo = nil;
	if type(luastr) == "string" then
		ok,resultInfo = pcall(function()         
			return loadstring(luastr)();
		end)
	else
		ok = true;
		resultInfo = luastr;
	end

	if ok then
		if resultInfo.status == 0 then
			--成功
			print("------recharge succeed----")

			SmallGamesGI.eventDispatcher:dispatch("OnChargeSucceed", nil)
			-- FishGI.gameScene.net:sendReChargeSucceed()
			-- FishGI.eventDispatcher:dispatch("BuySuccessCall", resultInfo);
		else
			print("------recharge faile----")
		end
	else
		printf("PayBase:onCallback_"..tostring(luastr))
	end 
end

function PayBase:onIosCallback_(status, paytype, msg)
	if paytype == "appstore" and status == 0 then
		self:verifyIosReceipt_(msg, paytype);
	else
		local retTab = {
			status = status,
			paytype = paytype,
			msg = msg,
		}
		self:onCallback_(retTab);
	end
end

function PayBase:verifyIosReceipt_(luastr, paytype)
    print("verify:"..luastr)
    local ok, args = pcall(function()
        return loadstring(luastr)();
    end)
    if ok then
        print("-----------------ok verify")

		FishGF.waitNetManager(true,FishGF.getChByIndex(800000186),"verifyIosReceipt_")
        FishGI.Dapi:VerifyIosReceipt(args, function(msg)
            FishGF.waitNetManager(false,FishGF.getChByIndex(800000186),"verifyIosReceipt_")
            if msg.status == 0 then
                local ret_tab = { status = msg.status, paytype = paytype, msg = "支付成功！" }
                --self:onPayCallback("return "..gg.SerialObject(ret_tab))
                self:onCallback_(ret_tab)
            else
                print("iap order verify failure");
            end
 
        end)
    else
        printf("解析ios 参数失败 %s", luastr)
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