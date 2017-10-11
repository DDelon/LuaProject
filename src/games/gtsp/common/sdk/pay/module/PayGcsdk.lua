local PayGcsdk = class("PayGcsdk", SmallGamesGF.getPayBase())

function PayGcsdk.create()
	local obj = PayGcsdk.new()
	obj:init(payInfo)
	return obj
end

function PayGcsdk:init()
	self.super.init(self)
	self.type = SmallGamesGI.PaySDKType.Gcsdk
	self.funDoPayGcsdk = {
        Buyu = {
            baidu = self.doPayBuyuBaidu,
            huawei = self.doPayBuyuHuawei,
            jinli = self.doPayBuyuJinli,
            lenovo = self.doPayBuyuLenovo,
            mi = self.doPayBuyuMi,
            oppo = self.doPayBuyuOppo,
            qihu = self.doPayBuyuQihu,
            vivo = self.doPayBuyuVivo,
            yyb = self.doPayBuyuYyb,
        },
	}
    self.orderData = {
        baidu = {
            typeName = "baidu",
        },
        huawei = {
            typeName = "huawei",
        },
        jinli = {
            typeName = "jinli",
        },
        lenovo = {
            typeName = "lenovo",
        },
        mi = {
            typeName = "mi",
        },
        oppo = {
            typeName = "oppo",
        },
        qihu = {
            typeName = "360",
        },
        vivo = {
            typeName = "vivo",
        },
        yyb = {
            typeName = "midas",
        },
    }
end

function PayGcsdk:getPayCallBackUrl()
    return string.format("http://thirdpay.%s/callback/%s/%s/%s/%s/%s", WEB_DOMAIN, 
        self.orderData[self.gcsdkType].typeName, SmallGameApp.AppId, SmallGamesGI.lobbyData.ChannelId, SmallGamesGF.getHallVerison(), REGION_CODE)
end

function PayGcsdk:doPay(payInfo, extendData)
	payInfo.type = self.orderData[self.gcsdkType].typeName
    self.super.doPay(self, payInfo, extendData)
end

function PayGcsdk:doPayAndroidBuyu(payInfo)
	if self.luaBottomCallData == nil then
		return
	end
    if self.funDoPayGcsdk[SmallGamesGI.lobbyName][self.gcsdkType] then
		payInfo = self.funDoPayGcsdk[SmallGamesGI.lobbyName][self.gcsdkType](self, payInfo)
	else
		print("暂未开放此平台的支付功能")
        return
	end
	local jsonStr = json.encode(payInfo)
	local javaParams = {
        jsonStr,
        handler(self, self.onCallback_)
	}
	self:doPayAndroid(javaParams, self.luaBottomCallData.methodSig)
end

function PayGcsdk:doPayBuyuBaidu(payArgs)
	local pointArr = {
        ["830000001"] = "28035",
        ["830000002"] = "28036",
        ["830000003"] = "28037",
        ["830000004"] = "28038",
        ["830000005"] = "28039",
        ["830000006"] = "28040",
        ["830000007"] = "28041",
        ["830000008"] = "28042",
        ["830000009"] = "28043",
        ["830000010"] = "28044",
        ["830000011"] = "28045",
        ["830000012"] = "28046",
        ["830000013"] = "28047",
        ["830000014"] = "28048",
        ["830000015"] = "28049",
    }
	local payInfo = {}
    payInfo.order = payArgs.orderid
    payInfo.mPropsId = pointArr[tostring(payArgs.id)]
    payInfo.productName = payArgs.name
    payInfo.price = payArgs.money/100
	return payInfo
end

function PayGcsdk:doPayBuyuHuawei(payArgs)
	local payInfo = {}
    payInfo.orderid = payArgs.orderid
    payInfo.money = payArgs.money
    payInfo.callbackurl = self:getPayCallBackUrl()
    payInfo.productname = payArgs.subject
    payInfo.productid   = payArgs.goods
    payInfo.username    = SmallGamesGI.hallNet.userinfo.nick
    payInfo.userid      = SmallGamesGI.hallNet.userinfo.id
	return payInfo
end

function PayGcsdk:doPayBuyuJinli(payArgs)
	local payInfo = {}
    payInfo.orderid     = payArgs.orderid
    --payInfo.money       = payTab.money/100
    payInfo.money       = tonumber(payArgs.money)/100
    payInfo.callbackurl = self:getPayCallBackUrl()
    payInfo.productname = payArgs.subject
    payInfo.productid   = payArgs.goods
    payInfo.username    = SmallGamesGI.hallNet.userinfo.nick
    payInfo.userid      = SmallGamesGI.hallNet.userinfo.id
	return payInfo
end

function PayGcsdk:doPayBuyuLenovo(payArgs)
	local tWaresidList = {}
    tWaresidList["830000001"] = 148920
    tWaresidList["830000002"] = 148198
    tWaresidList["830000003"] = 148199
    tWaresidList["830000004"] = 148200
    tWaresidList["830000005"] = 148201
    tWaresidList["830000006"] = 148202
    tWaresidList["830000007"] = 148203
    tWaresidList["830000008"] = 148204
    tWaresidList["830000009"] = 148205
    tWaresidList["830000010"] = 148206
    tWaresidList["830000011"] = 148207
    tWaresidList["830000012"] = 148208
    tWaresidList["830000013"] = 148209
    tWaresidList["830000014"] = 148210
    tWaresidList["830000015"] = 148211
    local payInfo = {}
    payInfo.waresid = tWaresidList[tostring(payArgs.goods)]
    payInfo.exorderno = payArgs.orderid
    payInfo.price = payArgs.money/100
    payInfo.notifyurl = ""
	return payInfo
end

function PayGcsdk:doPayBuyuMi(payArgs)
	 local payInfo = {}
    payInfo.order = payArgs.orderid
    payInfo.amount = payArgs.money;
    payInfo.productName = payArgs.subject
    payInfo.productDesc = payArgs.body
    payInfo.callbackurl = self:getPayCallBackUrl()
	return payInfo
end

function PayGcsdk:doPayBuyuOppo(payArgs)
	local payInfo = {}
    payInfo.order = payArgs.orderid
    payInfo.amount = payArgs.money
    payInfo.productName = payArgs.subject
    payInfo.productDesc = payArgs.body
    payInfo.callbackurl = self:getPayCallBackUrl()
	return payInfo
end

function PayGcsdk:doPayBuyuQihu(payArgs)
	local payInfo = {}
    payInfo.orderid = payArgs.orderid
    payInfo.money = payArgs.money
    payInfo.callbackurl = self:getPayCallBackUrl()
    payInfo.productname = payArgs.subject
    payInfo.productid   = payArgs.goods
	payInfo.username    = SmallGamesGI.hallNet.userinfo.nick
    payInfo.userid      = SmallGamesGI.hallNet.userinfo.id
	return payInfo
end

function PayGcsdk:doPayBuyuVivo(payArgs)
	local payInfo = {}
    payInfo.order = payArgs.ext.vivoOrder
    payInfo.amount = payArgs.ext.orderAmount
    payInfo.signature = payArgs.ext.vivoSignature
    payInfo.productName = payArgs.subject
    payInfo.productDesc = payArgs.body
	return payInfo
end

function PayGcsdk:doPayBuyuYyb(payArgs)
	local payInfo = {}
    payInfo.orderid = payArgs.orderid
    payInfo.money = payArgs.money
    payInfo.name = payArgs.subject
    payInfo.productDesc = payArgs.body
    payInfo.goods = payArgs.goods
    payInfo.callbackurl = self:getPayCallBackUrl()
	return payInfo
end

return PayGcsdk