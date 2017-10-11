cc.exports.SmallGameApp = {}

SmallGameApp.RoomLayer = "MainLayer"
SmallGameApp.ShopLayer = "ShopLayer"
SmallGameApp.ShopItem = "ShopItem"
SmallGameApp.PayChannelList = "PayChannelList"

SmallGameApp.appPathConfigs = {
    main = "main",
    shop = "shop."..SmallGamesGI.lobbyNameLower,
    shop_common = "shop.common",
}

SmallGameApp.appConfigs = {
    MainLayer = {
        SmallGameApp.appPathConfigs.main,
    },
    ShopLayer = {
        SmallGameApp.appPathConfigs.shop,
        SmallGameApp.appPathConfigs.shop_common,
    },
    ShopItem = {
        SmallGameApp.appPathConfigs.shop,
        SmallGameApp.appPathConfigs.shop_common,
    },
    PayChannelList = {
        SmallGameApp.appPathConfigs.shop,
        SmallGameApp.appPathConfigs.shop_common,
    },
}

SmallGameApp.AppId = "368"
SmallGameApp.AppKey = "633E848B26EfD1bcD05d48D8AE5f21f2"
SmallGameApp.GameId = 366

SmallGamesGI.uiMsgBoxBase = SmallGamesGF.getCurAppResUIPath("common.uiMsgBoxBase.lua")
SmallGamesGI.uiMsgBox = SmallGamesGF.getCurAppResUIPath("common.uiMsgBox.lua")
SmallGamesGI.uiWaittingBox = SmallGamesGF.getCurAppResUIPath("common.uiWaittingBox.lua")
SmallGamesGI.uiHintBar = SmallGamesGF.getCurAppResUIPath("common.uiHintBar.lua")
SmallGamesGI.uiSoundBox = SmallGamesGF.getCurAppResUIPath("common.uiSoundBox.lua")

SmallGameApp.curRoomId = 2310

function SmallGameApp.getRoomData( tRoomDataList )
    local roomData = tRoomDataList[SmallGameApp.curRoomId]
    if roomData == nil then
        for k,v in pairs(tRoomDataList) do
            if SmallGamesGI.SYSTEM_STATE == 0 then
                roomData = v
                break
            else
                if v.gameid == 1140 then
                    roomData = v
                    break
                end
            end
        end
    end
    dump(tRoomDataList)
    dump(roomData)
    return roomData
end

SmallGamesGI.RoomManager = require(SmallGamesGF.getCurAppSrcPath("common.RoomManager"))

SmallGamesGI.dataBinPath = SmallGamesGF.getCurAppSrcPath("databin")

SmallGamesGI.DataBinList = {}