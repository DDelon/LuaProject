--[[
* 网站接口
* 回调函数事件原型
	err:错误原因，如果为nil，则没有错误
	data:数据，只有err为nil，才有效
function(err,data);
--]]
-- http://userapi.{domain}/{接口版本号}/{接口语言}/{品牌标识}/{接口名称}/app_id/{app_id}/channel_id/{channel_id}

-- local URL_HEADER = "http://userapi."
-- local DAPI_DOMAIN = URL_HEADER..WEB_DOMAIN;
-- local API_DOMAIN = "http://api.test."..WEB_DOMAIN;

-- 返回状态码
cc.exports.ApiStatus=
{
    Ok = 0,
    ShowMsg = 100,
    Success = 200,
    WXAuthFailed=351
}

local StateMsg = {
    [0] = "成功",
    [100] = "错误提示, 当状态为此值时请将错误信息显示给用户",
    [101] = "请求接口时必须使用https协议访问",
    [111] = "接口版本参数错误",
    [112] = "接口语言参数错误",
    [113] = "接口品牌参数错误",
    [119] = "缺少参数,具体缺少哪个参数请在msg中查看",
    [120] = "参数错误,具体哪个参数错误请在msg中查看",
    [121] = "请求的app_id参数错误",
    [122] = "请求的channel_id参数错误",
    [123] = "应用配置不存在",
    [124] = "用户API请求中的data参解密错误",
    [131] = "用户API请求中的token参数为空",
    [132] = "用户API请求中的token无效",
    [301] = "短信验证码发送太快(即:两次的间隔时间太短)",
    [302] = "单位时间内发送的短信验证码数量超限",
    [303] = "手机号码处于黑名单中,无法获取短信验证码",
    [351] = "微信授权过期",
    [500] = "服务器内部错误"
}

local dapi_ = "://dapi." .. WEB_DOMAIN
local userapi_ = "://userapi"..PREFIX_DOMAIN.."." .. WEB_DOMAIN
local payapi_ = "://payapi"..PREFIX_DOMAIN.."." .. WEB_DOMAIN
local payback_ = "://payback"..PREFIX_DOMAIN.."." .. WEB_DOMAIN
local thirdapi_ = "://third."..WEB_DOMAIN

-- local api_ver_="/v1"
-- local language_="/cn"
-- 平台 全局变量 BRAND 索引方式 获取 

--实现接口 url
local Dapi = {}
local Http = SmallGamesGI.Http

local function getPayApi_(name, channelId)
    if channelId == nil then
        channelId = CHANNEL_ID
    end
    local ver_str = SmallGamesGF.getHallVerison()
    return string.format("%s%s/%s/%d/%s/%s", payapi_, name,  APP_ID, channelId, ver_str, REGION_CODE)
end

local function getVerifyApi_(name, channelId)
    if channelId == nil then
        channelId = CHANNEL_ID
    end
    local ver_str = SmallGamesGF.getHallVerison()
    return string.format("%s%s/%s/%d/%s/%s", payback_, name,  APP_ID, channelId, ver_str, REGION_CODE)
end

local function getUserApi_(name, channelId)
    if channelId == nil then
        channelId = CHANNEL_ID
    end
    local ver_str = SmallGamesGF.getHallVerison()
    return string.format("%s%s/%s/%d/%s/%s", userapi_, name, APP_ID, channelId, ver_str, REGION_CODE)
end

--第三方登陆
local function getThirdApi_(name, channelId)
    if channelId == nil then
        channelId = CHANNEL_ID
    end
	local ver_str = SmallGamesGF.getHallVerison()
    return string.format("%s%s/%s/%d/%s/%s", thirdapi_, name, APP_ID, channelId, ver_str, REGION_CODE)
end

local function getToken_()
    if SmallGamesGI.hallNet then
        return { token = SmallGamesGI.hallNet:getSession() }
    else
        return { token = "0123456789abcdef0123456789abcdef" }
    end
end

local function checkvalues_(...)
    local values = { ... }
    for _, v in ipairs(values) do
        if not v or (type(v) == "string" and string.len(v) < 1) then
            printf("[error]参数校验失败，请检查参数。")
            return false
        end
    end
    return true
end

local function errorhandler_(callback)
    return function(state, data)
        if state then
            local ms = StateMsg[tonumber(state)] or data
            callback({ msg = ms or "解析错误！" , status = tostring(state) })
        else
            printf("errorhandler_ %s", tostring(data))
            local ok, datatable = pcall(function() return loadstring(data)(); end)
			if ok == false and data ~= nil then
				datatable = json.decode(data);
			end
            datatable = checktable(datatable)
            if ok and datatable.status == ApiStatus.ShowMsg then
                --GameApp:dispatchEvent(gg.Event.SHOW_MESSAGE_DIALOG, datatable.msg)
            end
            callback(datatable)
        end
    end
end


-- 获取错误代码提示
function Dapi:GetErrorMsg(err_code)
    return StateMsg[err_code]
end

-- 所属子域-- payapi
-- 接口名称-- order/new
-- 功能描述-- 充值下单
-- 请求方式-- POST
-- 所需的额外参数
-- type (string)-- 充值方式
-- wechat : 微信支付
-- alipay_client : 支付宝
-- unionpay_client : 银联支付
-- appstore : 苹果AppStore
-- roomid (integer)-- 充值时玩家所在的房间ID, 没有或大厅为0
-- money (integer)-- 充值金额，单位为：分
-- virtual (integer)-- 是否充值为虚拟货币，1:表示充值为吉祥/微乐币,0或不传:表示直接充值为豆
-- autobuy (integer)-- 是否自动使用本次充值的吉祥/微乐币购买等价道具(并赠送豆) 1.自动够买 0.
-- ingame (integer)-- 是否为游戏中充值，0:否，1:是
-- udid (string)-- 唯一标识符
-- debug (integer)-- 是否为调试模式，0否，1是
-- 额外返回参数
-- orderid (string)-- 16位商户订单号
-- ext (array)-- 扩展数据结构
function Dapi:OrderNew(args, callback, debug)
    args["debug"] = checkint(args.debug or debug);
    args.ingame = args.ingame or 0;
    args.roomid = args.roomid or 0;
    args.virtual = args.virtual or 0;
    args.autobuy = args.autobuy or 0;
    local deviceid = Helper.GetDeviceCode();
    args.udid = args.udid or deviceid;
    args.type = args.type or ""
    if checkvalues_(args.type, args.money, args.autobuy) then
        local url = getPayApi_("/order/new", CHANNEL_ID)
        print("pay url:"..url)
        table.merge(args, getToken_())
        Http:Post(url, errorhandler_(callback), args, true)
    end
end

function Dapi:thirdLogin(channel, data, callback)
    data.type = channel

	local url = getThirdApi_("/login");
	Http:Post(url, callback, data, true)
end

return Dapi;