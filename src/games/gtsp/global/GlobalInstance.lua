
-- 平台大厅列表
SmallGamesGI.lobbyList = {
    Xyx = "Xyx",
    Buyu = "Buyu",
    Qipai = "Qipai",
}

-- 获取当前平台大厅名
SmallGamesGI.lobbyName = nil

-- 平台大厅数据
SmallGamesGI.lobbyData = {
    AppId = "",
    AppKey = "",
    GameId = 0,
    ChannelId = 0,
    WechatAppId = "",
}

-- 商城数据
SmallGamesGI.storeData = {
    productConfig = {},
    unit = "",
    pointOfMoney = 1,
}

-- 游戏列表
SmallGamesGI.appList = {
    Gtsp = "gtsp",
    Buyu = "buyu",
}

-- 获取当前游戏名
SmallGamesGI.appName = nil

-- 全局app
SmallGamesGI.myApp = nil
SmallGamesGI.myAppLast = nil

-- 当前场景
SmallGamesGI.curScene = nil
SmallGamesGI.lastScene = nil

-- 资源目录
SmallGamesGI.packagesPath = SmallGamesGI.rootSrcPath..".packages"
SmallGamesGI.appSrcPath = SmallGamesGI.rootSrcPath..".app"
SmallGamesGI.commonSrcPath = SmallGamesGI.rootSrcPath..".common"
SmallGamesGI.globalSrcPath = SmallGamesGI.rootSrcPath..".global"
SmallGamesGI.appResPath = SmallGamesGI.rootResPath.."/res/app"
SmallGamesGI.commonResPath = SmallGamesGI.rootResPath.."/res/common"
SmallGamesGI.appResUIPath = SmallGamesGI.rootResUIPath..".ui.app"
SmallGamesGI.commonResUIPath = SmallGamesGI.rootResUIPath..".ui.common"

-- 界面路径配置
SmallGamesGI.appPathConfigs = {
    room = "room",
    game = "game",
    MsgBox = "msgbox",
    WaittingBox = "waittingbox",
    HintBar = "hintbar",
    SoundBox = "soundbox",
}

-- 界面配置索引
SmallGamesGI.appConfigsIndex = {
    FilePath = 1, -- 资源src/res文件路径
}
-- 界面配置
SmallGamesGI.appConfigs = {
    RoomScene = {
        SmallGamesGI.appPathConfigs.room,
    },
    GameScene = {
        SmallGamesGI.appPathConfigs.game,
    },
    MsgBox = {
        SmallGamesGI.appPathConfigs.MsgBox,
    },
    WaittingBox = {
        SmallGamesGI.appPathConfigs.WaittingBox,
    },
    HintBar = {
        SmallGamesGI.appPathConfigs.HintBar,
    },
    SoundBox = {
        SmallGamesGI.appPathConfigs.SoundBox,
    },
}

SmallGamesGI.defaultScene = "RoomScene"

-- 界面tag列表
SmallGamesGI.appViewListTag = {}

-- 开启设备返回键的界面
SmallGamesGI.keyBoardViewsBak = {}
SmallGamesGI.keyBoardViews = {}
SmallGamesGI.keyBoardViews.list = {}
SmallGamesGI.keyBoardViews.views = {}

-- 设备返回键是否只触发一个窗口
SmallGamesGI.bOpenKeyBackSingle = true

-- 绑定控件事件类型
SmallGamesGI.bindingEvents = {
    Touch = 1,
    Click = 2,
    ClickScale = 3,
    ClickColor = 4,
    EditBox = 5,
    FileNode = 6,
}

SmallGamesGI.MsgBoxTYPE = {
    NoneBtn = 1,
    OneBtn = 2,
    TwoBtn = 3,
}

SmallGamesGI.MsgBoxBtns = {
    CloseBtn = 1,
    FirstBtn = 2,
    SecondBtn = 3,
}

SmallGamesGI.msgBox = nil

SmallGamesGI.waittingBox = nil

SmallGamesGI.hintBar = nil

SmallGamesGI.LoginType = {
    None = 0, -- 无任何操作
    Name = 1, -- 根据用户名登陆
    UnName = 2, -- 匿名登陆
    GetRoleList = 3, -- 拉取用户列表
    AllocUser = 4, -- 分配新帐号
    ThridLodin = 5, -- 第三方登陆
}

SmallGamesGI.isLogin = false

SmallGamesGI.RoomManager = nil

SmallGamesGI.MsgHead = {
	MSG_C2S_GET_DESK = 6,	--房间内获取桌子
	MSG_C2S_HALL_JMSG = 8,
	MSG_S2C_HALL_JMSG = 4296,
	--MSG_S2C_GET_DATA = 4296, --房间内获取数据

	MSG_C2S_CLIENT_READY = 11, -- 客户端就绪
    MSG_C2S_JMSG = 30, -- 客户端就绪
    MSG_S2C_JMSG = 31, -- 客户端就绪
    EVENT_RECV_FISH_DATA = "RECV_FISH_DATA"
}

-- 公共功能界面文件
SmallGamesGI.uiMsgBoxBase = nil
SmallGamesGI.uiMsgBox = nil
SmallGamesGI.uiWaittingBox = nil
SmallGamesGI.uiHintBar = nil
SmallGamesGI.uiSoundBox = nil

-- 加载全局配置
require(SmallGamesGI.globalSrcPath..".GameFunc")

-- 界面消息推送
SmallGamesGI.eventDispatcher = require(SmallGamesGI.commonSrcPath..".common.EventDispatcher").create()

SmallGamesGI.WebTool = require(SmallGamesGI.commonSrcPath..".common.WebTool")

SmallGamesGI.Http = require(SmallGamesGI.commonSrcPath..".common.HttpHelper")
SmallGamesGI.Dapi = require(SmallGamesGI.commonSrcPath..".common.ApiHelper")

-- 登录管理
SmallGamesGI.LoginManagerBase = require(SmallGamesGI.commonSrcPath..".common.LoginManager")
SmallGamesGI.LoginManager = require(SmallGamesGI.commonSrcPath..".common.LoginManager"):create()

-- 房间管理
SmallGamesGI.RoomManagerBase = require(SmallGamesGI.commonSrcPath..".common.AllocSitRoomManager")

-- 游戏管理
SmallGamesGI.GameClient = require(SmallGamesGI.commonSrcPath..".common.BaseClient")
SmallGamesGI.GameManagerBase = require(SmallGamesGI.commonSrcPath..".common.GameManagerBase")

SmallGamesGI.PayHelper = require(SmallGamesGI.commonSrcPath..".sdk.pay.PayHelper").create()
SmallGamesGI.ShareHelper = require(SmallGamesGI.commonSrcPath..".sdk.share.ShareHelper").create()

SmallGamesGI.ShopLayerBase = SmallGamesGI.commonSrcPath..".shop.ShopLayerBase"
SmallGamesGI.ShopItemBase = SmallGamesGI.commonSrcPath..".shop.ShopItemBase"
SmallGamesGI.PayChannelListBase = SmallGamesGI.commonSrcPath..".shop.PayChannelListBase"
SmallGamesGI.PayChannelItemBase = SmallGamesGI.commonSrcPath..".shop.PayChannelItemBase"

--0外网   1，内网无秘籍   2，内网有秘籍  3.外网225测试房间
SmallGamesGI.SYSTEM_STATE = 0

--是否提示断线
SmallGamesGI.isNoticeClose = true

SmallGamesGI.isEnterBg = false

SmallGamesGI.ChannelIdList = {
    -- 官网
    weile = 200,
    -- 自运营
    tencent = 225,
    --ios
    ios = 11,
    -- 百度
    baidu = 202,
    -- 小米
    mi = 205,
    -- oppo
    oppo = 207,
    -- 360
    qihu = 201,
    -- vivo
    vivo = 206,
    -- 华为
    huawei = 224,
    -- 金立
    jinli = 204,
    -- 联想
    lenovo = 208,
    -- 应用宝
    yyb = 210,
    --今日头条
    jrtt = 723,
    --广点通
    gdt = 209,
}

SmallGamesGI.ChannelNameList = {}
for k,v in pairs(SmallGamesGI.ChannelIdList) do
    SmallGamesGI.ChannelNameList[v] = k
end

SmallGamesGI.PaySDKType = {
    Wechat = "Wechat",
    Alipay = "Alipay",
    Unionpay = "Unionpay",
    Apple = "Apple",
    Gcsdk = "Gcsdk",
}

SmallGamesGI.GcsdkType = {
    baidu = "baidu",
    huawei = "huawei",
    jinli = "jinli",
    lenovo = "lenovo",
    mi = "mi",
    oppo = "oppo",
    qihu = "qihu",
    vivo = "vivo",
    yyb = "yyb",
}

SmallGamesGI.ShareSDKType = {
    Wechat = "Wechat",
}

SmallGamesGI.ShareWechatModel = {
    Session = 0,    --聊天界面
    Timeline = 1,   --朋友圈
    Favorite = 2,   --收藏
}

SmallGamesGI.ShareType = {
    Image = 1,      --分享图片
}