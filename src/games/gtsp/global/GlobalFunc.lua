cc.exports.SmallGamesGF = {}

function SmallGamesGF.ClassEx(clsname,fncreate)
    local cls;
    local function _create() 
        local obj = fncreate();
        for k,v in pairs(cls) do
            obj[k] = v;
        end
        return obj;
    end
    cls = class(clsname, _create)
    return cls;
end

function SmallGamesGF.copyTable(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = SmallGamesGF.copyTable(v)
        end
    end
    return tab
end

function SmallGamesGF.getChannelName( channelId )
    if channelId == nil then
        channelId = SmallGamesGI.lobbyData.ChannelId
    end
    if SmallGamesGI.ChannelNameList[channelId] then
        return SmallGamesGI.ChannelNameList[channelId]
    end
    return ""
end

function SmallGamesGF.isGcsdkChannel( channelId )
    if channelId == nil then
        channelId = SmallGamesGI.lobbyData.ChannelId
    end
    if channelId ~= SmallGamesGI.ChannelIdList.weile and channelId ~= SmallGamesGI.ChannelIdList.tencent and channelId ~= SmallGamesGI.ChannelIdList.ios then
        return true
    end
    return false
end

function SmallGamesGF.getHallVerison()
    return string.format( "%d.%d.%d", SmallGamesGI.appVersion[1], SmallGamesGI.appVersion[2], SmallGamesGI.appVersion[3] )
end

-- 获取游戏src文件目录
function SmallGamesGF.getAppSrcPath(appName, fileName, separator)
    local appSrcPath = SmallGamesGI.appSrcPath
    if separator == nil then
        separator = '.'
    elseif separator ~= '.' then
        appSrcPath = string.gsub(SmallGamesGI.appSrcPath, '%.', separator)
    end
    if fileName then
        return appSrcPath..separator..appName..separator..fileName
    else
        return appSrcPath..separator..appName
    end
end
function SmallGamesGF.getCurAppSrcPath(fileName, separator)
    return SmallGamesGF.getAppSrcPath(SmallGamesGI.appName, fileName, separator)
end
function SmallGamesGF.getCommonSrcPath(fileName, separator)
    local commonSrcPath = SmallGamesGI.commonSrcPath
    if separator == nil then
        separator = '.'
    elseif separator ~= '.' then
        commonSrcPath = string.gsub(SmallGamesGI.commonSrcPath, '%.', separator)
    end
    if fileName then
        return commonSrcPath..separator..fileName
    else
        return commonSrcPath
    end
end
function SmallGamesGF.getGlobalSrcPath(fileName, separator)
    if fileName then
        return SmallGamesGI.globalSrcPath..separator..fileName
    else
        return SmallGamesGI.globalSrcPath
    end
end

-- 获取游戏res资源文件目录
function SmallGamesGF.getAppResPath(appName, fileName, separator)
    if fileName then
        return SmallGamesGI.appResPath.."/"..appName.."/"..fileName
    else
        return SmallGamesGI.appResPath.."/"..appName
    end
end
function SmallGamesGF.getCurAppResPath(fileName)
    return SmallGamesGF.getAppResPath(SmallGamesGI.appName, fileName)
end
function SmallGamesGF.getCommonResPath(fileName)
    if fileName then
        return SmallGamesGI.commonResPath.."/"..fileName
    else
        return SmallGamesGI.commonResPath
    end
end

-- 获取游戏res界面文件目录
function SmallGamesGF.getAppResUIPath(appName, fileName)
    if fileName then
        return SmallGamesGI.appResUIPath.."."..appName.."."..fileName
    else
        return SmallGamesGI.appResUIPath.."."..appName
    end
end
function SmallGamesGF.getCurAppResUIPath(fileName)
    return SmallGamesGF.getAppResUIPath(SmallGamesGI.appName, fileName)
end
function SmallGamesGF.getCommonResUIPath(fileName)
    if fileName then
        return SmallGamesGI.commonResUIPath.."."..fileName
    else
        return SmallGamesGI.commonResUIPath
    end
end
function SmallGamesGF.getAppOrCommonResUIPath(fileName)
    if SmallGamesGI.appName then
        local strAppPath = SmallGamesGF.getCurAppResUIPath(fileName)
        if cc.FileUtils:getInstance():isFileExist(strAppPath) then
            return strAppPath
        else
            return SmallGamesGF.getCommonResUIPath(fileName)
        end
    else
        return SmallGamesGF.getCommonResUIPath(fileName)
    end
end

-- 获取游戏配置文件目录
function SmallGamesGF.getAppConfigsPath(appName)
    return SmallGamesGF.getAppSrcPath(appName)..".AppConfigs"
end

-- 移除游戏配置
function SmallGamesGF.cleanAppConfigs()
    if SmallGamesGI.appName then
        package.loaded[SmallGamesGF.getAppConfigsPath(SmallGamesGI.appName)] = nil
	    cc.FileUtils:getInstance():purgeCachedEntries()
        SmallGamesGI.appName = nil
        cc.exports.SmallGameApp = nil
    end
end

-- 加载(重载)游戏配置
function SmallGamesGF.loadAppConfigs(appName)
    SmallGamesGF.cleanAppConfigs()
    SmallGamesGI.appName = appName
    require(SmallGamesGF.getAppConfigsPath(appName))
    SmallGamesGF.resetViewTagList()
    package.loaded[SmallGamesGF.getCommonSrcPath("msgbox.MsgBoxBase")] = nil
    package.loaded[SmallGamesGF.getCommonSrcPath("msgbox.MsgBox")] = nil
    package.loaded[SmallGamesGF.getCommonSrcPath("waittingbox.WaittingBox")] = nil
    package.loaded[SmallGamesGF.getCommonSrcPath("hintbar.HintBar")] = nil
    package.loaded[SmallGamesGF.getCommonSrcPath("soundbox.SoundBox")] = nil
    cc.FileUtils:getInstance():purgeCachedEntries();
end

-- 重置界面tag列表
function SmallGamesGF.resetViewTagList( )
    SmallGamesGI.appViewListTag = {}
    local iTag = 0
    for k,v in pairs(SmallGamesGI.appConfigs) do
        if not SmallGamesGI.appViewListTag[k] then
            iTag = iTag + 1
            SmallGamesGI.appViewListTag[k] = iTag
        end
    end
    for k,v in pairs(SmallGameApp.appConfigs) do
        if not SmallGamesGI.appViewListTag[k] then
            iTag = iTag + 1
            SmallGamesGI.appViewListTag[k] = iTag
        end
    end
end

-- 获取界面tag
function SmallGamesGF.getViewTag( viewName )
    return SmallGamesGI.appViewListTag[viewName]
end

-- 创建大厅
function SmallGamesGF.createHallManager(valTab)
    local session = valTab.session;
    local userid = valTab.userid;
    local serverip = valTab.serverip;
    local serverport = valTab.serverport;
	--大厅场景最好等待网络正常连接成功后再转入大厅场景
    if SmallGamesGI.hallNet then
        SmallGamesGI.hallNet:dealloc()
    end
    SmallGamesGI.hallNet = require(SmallGamesGF.getCommonSrcPath("common.HallNet")).create()
    print("连接到大厅1111")
    if SmallGamesGI.hallNet ~= nil then
        if SmallGamesGI.hallNet:ConnectToHall(session,userid,serverip,serverport) then
            SmallGamesGF.setHallLoginData(session,userid,serverip,serverport)
            print("连接到大厅2222");
        else
            print("连接到大厅失败 ConnectToHall");
        end
    else

    end
end

-- 设置大厅登录数据
function SmallGamesGF.setHallLoginData( session,userid,serverip,serverport )
    if SmallGamesGI.hallLoginData == nil then
        SmallGamesGI.hallLoginData = {}
    end
    SmallGamesGI.hallLoginData.session = session
    SmallGamesGI.hallLoginData.userid = userid
    SmallGamesGI.hallLoginData.serverip = serverip
    SmallGamesGI.hallLoginData.serverport = serverport
end

-- 进入房间
function SmallGamesGF.enterRoom()
    SmallGamesGF.removeWaittingBox("startConnect")
    --进入房间
    local room = SmallGameApp.getRoomData(SmallGamesGI.hallNet.rooms)
    if room then
        local roomId = room.id
        if roomId then
            SmallGamesGF.createWaittingBox("正在获取服务器信息，请稍候~","joinGame")
            SmallGamesGI.RoomManager = SmallGamesGI.RoomManager.create(SmallGamesGI.hallNet, roomId)
            SmallGamesGI.hallNet.roommanager = SmallGamesGI.RoomManager
            SmallGamesGI.hallNet:SendJoinRoom(roomId) --发送进入房间消息 
            return true
        end
	end	
    return false
end

-- 进入游戏
function SmallGamesGF.enterGame(roomId)
    if SmallGamesGI.RoomManager ~= nil then
        SmallGamesGI.curDeskId = tonumber(roomId)
        SmallGamesGI.RoomManager:sendDataGetDesk(roomId);
    else
        print("roommanager is nil");
    end
end

-- 设置大厅数据
function SmallGamesGF.setLobbyData( systemStatus, appId, appKey, gameId, channelId, wechatAppId, callbackUpdateLobbyData )
    SmallGamesGI.SYSTEM_STATE = systemStatus
    SmallGamesGI.lobbyData.AppId = appId
    SmallGamesGI.lobbyData.AppKey = appKey
    SmallGamesGI.lobbyData.GameId = gameId
    SmallGamesGI.lobbyData.ChannelId = channelId
    SmallGamesGI.lobbyData.WechatAppId = wechatAppId
    SmallGamesGI.callbackUpdateLobbyData = callbackUpdateLobbyData
end

-- 设置大厅登录数据
function SmallGamesGF.setLobbyLoginData( serverConfig, loginType, visitorName, userName, password, thirdLoginInfo )
    SmallGamesGI.LoginManager:setServerConfig(serverConfig)
    SmallGamesGI.LoginManager:initLoginData(loginType, visitorName, userName, password)
    SmallGamesGI.LoginManager.thirdLoginInfo = thirdLoginInfo
end

-- 设置底层调用数据
function SmallGamesGF.setBottomCallData( luaj, luaoc, luaPayData, luaShareData )
    SmallGamesGI.luaj = luaj
    SmallGamesGI.luaoc = luaoc
    SmallGamesGI.PayHelper:setBottomCallData(luaPayData)
    SmallGamesGI.ShareHelper:setBottomCallData(luaShareData)
end

-- 设置商品数据
function SmallGamesGF.setStoreProductData( storeProductDatas )
    SmallGamesGI.storeProductDatas = storeProductDatas
end

-- 开始游戏
function SmallGamesGF.start(lobbyName, appName)
    SmallGamesGI.appVersion = require(SmallGamesCD.rootSrcPath..".version")
    SmallGamesGI.lobbyName = lobbyName
    SmallGamesGI.lobbyNameLower = string.lower( lobbyName )
    if appName == nil then
        if SmallGamesGI.appName then
            appName = SmallGamesGI.appName
        else
            return
        end
    end
    SmallGamesGI.isExitGame = false
    SmallGamesGF.loadAppConfigs(appName)
    if SmallGamesGI.callbackUpdateLobbyData then
        SmallGamesGI.callbackUpdateLobbyData(SmallGameApp.AppId, SmallGameApp.AppKey, SmallGameApp.GameId)
    end
    local appConfigs = {}
    for k, v in pairs(SmallGameApp.appConfigs) do
        if appConfigs[k] == nil then
            appConfigs[k] = {}
        end
        for i,j in ipairs(v) do
            table.insert( appConfigs[k], string.format("%s.%s.%s", SmallGamesGI.appSrcPath, SmallGamesGI.appName, j) )
        end
    end
    for k, v in pairs(SmallGamesGI.appConfigs) do
        if appConfigs[k] == nil then
            appConfigs[k] = {}
        end
        for i,j in ipairs(v) do
            table.insert( appConfigs[k], string.format("%s.%s", SmallGamesGI.commonSrcPath, j) )
        end
    end
    SmallGamesGI.myAppLast = SmallGamesGI.myApp
    SmallGamesGI.lastScene = SmallGamesGI.curScene
    SmallGamesGI.keyBoardViewsBak = SmallGamesGF.copyTable(SmallGamesGI.keyBoardViews)
    cc.FileUtils:getInstance():addSearchPath(SmallGamesGF.getCommonResPath())
    require(SmallGamesGI.appSrcPath..".SmallGameApp"):create(appConfigs, SmallGamesGI.defaultScene):run(nil, true)
end

-- 切换场景
function SmallGamesGF.enterScene( sceneName )
    return SmallGamesGI.myApp:enterScene(sceneName)
end

function SmallGamesGF.exitGame()
    SmallGamesGI.curScene = SmallGamesGI.RoomScene
    SmallGamesGI.keyBoardViews = SmallGamesGF.copyTable(SmallGamesGI.keyBoardViewsRoomSceneBak)
    SmallGamesGI.GameManager:StandUP()
end

-- 场景出栈, isExitType:1退出到大厅，2退出到登录，3退出游戏app
function SmallGamesGF.exitApp(isExitType)
    if isExitType == nil then
        isExitType = 1
    end
    if isExitType == 3 then
        SmallGamesGI.myApp:exit()
        return
    end
    SmallGamesGI.isExitGame = true
    if SmallGamesGI.isEnterRoom then
        SmallGamesGI.RoomManager:ExitRoom()
    end
    SmallGamesGI.hallNet:dealloc()
    if SmallGamesGI.myAppLast then
        SmallGamesGI.myApp = SmallGamesGI.myAppLast
        SmallGamesGI.myAppLast = nil
    end
    if SmallGamesGI.lastScene then
        SmallGamesGI.curScene = SmallGamesGI.lastScene
        SmallGamesGI.lastScene = nil
    end
    SmallGamesGI.MessageDefine = nil
    SmallGamesGI.keyBoardViews = SmallGamesGF.copyTable(SmallGamesGI.keyBoardViewsBak)
    SmallGamesGI.uiMsgBoxBase = "app.ui.msgbox.MsgBoxBaseNode.lua"
    SmallGamesGI.uiMsgBox = "app.ui.msgbox.MsgBoxNode.lua"
    SmallGamesGI.uiWaittingBox = "app.ui.waittingbox.WaittingBoxNode.lua"
    SmallGamesGI.uiHintBar = "app.ui.hintbar.HintBarNode.lua"
    package.loaded[SmallGamesGF.getCommonSrcPath("msgbox.MsgBoxBase")] = nil
    package.loaded[SmallGamesGF.getCommonSrcPath("msgbox.MsgBox")] = nil
    package.loaded[SmallGamesGF.getCommonSrcPath("waittingbox.WaittingBox")] = nil
    package.loaded[SmallGamesGF.getCommonSrcPath("hintbar.HintBar")] = nil
    cc.FileUtils:getInstance():purgeCachedEntries()
    if SmallGamesGI.callbackUpdateLobbyData then
        SmallGamesGI.callbackUpdateLobbyData(SmallGamesGI.lobbyData.AppId, SmallGamesGI.lobbyData.AppKey, SmallGamesGI.lobbyData.GameId)
    end
    SmallGamesGI.myApp:popScene()
    if isExitType == 2 then
        SmallGamesGI.myApp:enterScene("LoginScene")
    end
end

-- 创建界面
function SmallGamesGF.createView( viewName, parent, node, ... )
    return SmallGamesGI.myApp:createView(viewName, parent, node, ...)
end

function SmallGamesGF.getRoomSceneBase()
    return require(SmallGamesGF.getCommonSrcPath("main.RoomScene"))
end

function SmallGamesGF.getPayBase()
    return require(SmallGamesGF.getCommonSrcPath("sdk.pay.module.PayBase"))
end

function SmallGamesGF.getShareBase()
    return require(SmallGamesGF.getCommonSrcPath("sdk.share.module.ShareBase"))
end

-- 清空开启设备返回键的界面
function SmallGamesGF.removeKeyboardAll()
    SmallGamesGI.keyBoardViews.list = {}
    SmallGamesGI.keyBoardViews.views = {}
end

function SmallGamesGF.showGrayBgByLayer(layer,opacity)
    if opacity ~= nil and opacity == 0 then
        return
    end

    local gray_bg = layer:getChildByName("gray_bg")
    if gray_bg ~= nil  then
        gray_bg:setVisible(true)
        gray_bg:setScale(2)
    else
        gray_bg = cc.Scale9Sprite:create(SmallGamesGF.getCommonResPath("com_pic_graybg.png"))
        gray_bg:setScale9Enabled(true)
        local size = cc.Director:getInstance():getWinSize()
        gray_bg:setContentSize(size)
        gray_bg:setPosition(cc.p(0,0))
        gray_bg:setScale(2)
        gray_bg:setName("gray_bg")
        layer:addChild(gray_bg)
    end

    gray_bg:setOpacity(opacity)

    return gray_bg
end

function SmallGamesGF.hideGrayBgByLayer(layer)
    local gray_bg = layer:getChildByName("gray_bg")
    if gray_bg ~= nil  then
        gray_bg:setVisible(false)
    end
end

function SmallGamesGF.onViewEnterAni(node, callback)
    local curScale = node:getScale()
    node:setScale(0.2*curScale)
    if callback then
        node:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15,1.1*curScale),cc.ScaleTo:create(0.05,0.95*curScale),cc.ScaleTo:create(0.05,1*curScale), cc.CallFunc:create(callback)))
    else
        node:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15,1.1*curScale),cc.ScaleTo:create(0.05,0.95*curScale),cc.ScaleTo:create(0.05,1*curScale)))
    end
end

function SmallGamesGF.onViewExitAni(node, callback)
    local curScale = node:getScale()
    if callback then
        node:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15,0.3*curScale), cc.FadeOut:create(0.01), cc.CallFunc:create(callback)))
    else
        node:runAction(cc.Sequencecreate(cc.ScaleTo:create(0.15,0.3*curScale), cc.FadeOut:create(0.01)))
    end
end

-- 创建弹框界面
function SmallGamesGF.createMsgBox( type, strMsg, callback, openCloseBtn )
    if strMsg == nil then
        strMsg = ""
    end
    if openCloseBtn == nil then
        openCloseBtn = false
    end
    --[[
    local function callback( msgbox, btnType )
        if msgbox and btnType then
            if btnType == SmallGamesGI.MsgBoxBtns.CloseBtn then
            elseif btnType == SmallGamesGI.MsgBoxBtns.FirstBtn then
                msgbox:removeFromParent()
            elseif btnType == SmallGamesGI.MsgBoxBtns.SecondBtn then
            end
        end
    end
    ]]
    
    local function newMsgBox( )
        local msgBox = SmallGamesGF.createView("MsgBox")
        msgBox:setAnchorPoint(cc.p(0.5, 0.5))
        msgBox:setPosition(cc.p(display.width/2, display.height/2))
        SmallGamesGI.curScene:addChild(msgBox)

        msgBox:setType(type)
        msgBox:setContent(strMsg)
        msgBox:setCallBackFun(callback)
        msgBox:isShowCloseBtn(openCloseBtn)
        return msgBox
    end
    if SmallGamesGI.msgBox then
        local function callbackExit( )
            SmallGamesGI.msgBox = newMsgBox()
        end
        SmallGamesGI.msgBox:setCallbackExit(callbackExit)
        SmallGamesGI.msgBox:onQuit()
    else
        SmallGamesGI.msgBox = newMsgBox()
    end
end

-- 创建弹框界面
function SmallGamesGF.createMsgBox2(path1,path2, type, strMsg, callback, openCloseBtn)
    SmallGamesGF.createMsgBox( type, strMsg, callback, openCloseBtn )
    SmallGamesGI.msgBox:setBtnTextImg(path1,path2)
end

-- 移除弹框界面
function SmallGamesGF.removeMsgBox( )
    if SmallGamesGI.msgBox then
        SmallGamesGI.msgBox:onQuit()
    end
end

-- 创建等待界面
function SmallGamesGF.createWaittingBox( strMsg, tag, isNew )
    if strMsg == nil then
        strMsg = "网络连接中，请耐心等待"
    end
    local function newWaittingBox( )
        local waittingBox = SmallGamesGF.createView("WaittingBox")
        waittingBox:setPosition(cc.p(display.width/2, display.height/2))
        SmallGamesGI.curScene:addChild(waittingBox)
        waittingBox:setContent(strMsg)
        return waittingBox
    end
    if SmallGamesGI.waittingbox then
        SmallGamesGI.waittingbox:setContent(strMsg)
    else
        SmallGamesGI.waittingbox = newWaittingBox()
    end
    if tag then
        if SmallGamesGI.waittingbox.tTagList[tag] == nil then
            SmallGamesGI.waittingbox.iTagCount = SmallGamesGI.waittingbox.iTagCount + 1
            SmallGamesGI.waittingbox.tTagList[tag] = 1
        else
            if isNew then
                SmallGamesGI.waittingbox.tTagList[tag] = SmallGamesGI.waittingbox.tTagList[tag] + 1
            end
        end
        table.insert( SmallGamesGI.waittingbox.tTagList, tag )
    else
        SmallGamesGI.waittingbox.bNormal = true
    end
end

-- 延迟显示等待界面
function SmallGamesGF.delayShowWaittingBox( fDelayTime )
    if SmallGamesGI.waittingbox then
        fDelayTime = fDelayTime ~= nil and fDelayTime or 0.5
        SmallGamesGI.waittingbox:setVisible(false)
        SmallGamesGI.waittingbox:runAction(cc.Sequence:create(cc.DelayTime:create(fDelayTime), cc.CallFunc:create( 
                function() 
                    SmallGamesGI.waittingbox:setVisible(true)
                end)))
    end
end

-- 移除等待界面
function SmallGamesGF.removeWaittingBox( tag )
    if SmallGamesGI.waittingbox then
        if tag then
            if SmallGamesGI.waittingbox.tTagList[tag] then
                SmallGamesGI.waittingbox.tTagList[tag] = SmallGamesGI.waittingbox.tTagList[tag] - 1
                if SmallGamesGI.waittingbox.tTagList[tag] <= 0 then
                    SmallGamesGI.waittingbox.tTagList[tag] = nil
                    SmallGamesGI.waittingbox.iTagCount = SmallGamesGI.waittingbox.iTagCount - 1
                end
            end
        else
            SmallGamesGI.waittingbox.bNormal = false
        end
        if not SmallGamesGI.waittingbox.bNormal and SmallGamesGI.waittingbox.iTagCount <= 0 then
            SmallGamesGI.waittingbox:onQuit()
        end
    end
end

-- 创建提示条界面
function SmallGamesGF.createHintBar(parent, strMsg, pos)
    local hintBar = SmallGamesGF.createView("HintBar")
    if parent then
        parent:addChild(hintBar)
    end
    if strMsg then
        hintBar:setContent(strMsg)
    end
    if pos then
        hintBar:setPosition(pos)
    end
    return hintBar
end

-- 创建声音设置弹框界面
function SmallGamesGF.createSoundBox()
    return SmallGamesGF.createView("SoundBox")
end

-- 创建商城界面
function SmallGamesGF.createShopLayer()
    if SmallGamesGI.lobbyName == SmallGamesGI.lobbyList.Xyx then
        return
    end
    return SmallGamesGF.createView(SmallGameApp.ShopLayer)
end

-- 获取本地用户数据key名
function SmallGamesGF.getUserDefaultKey(keyName)
    return SmallGamesGI.appName.."_"..keyName
end

-- 创建所有DataBin配置
function SmallGamesGF.initAllDataBinConf()
    if SmallGamesGI.DataBinList == nil then
        return
    end
    SmallGamesGI.DataBinConf = {}
    for k,v in pairs(SmallGamesGI.DataBinList) do
        SmallGamesGI.DataBinConf[k] = require(SmallGamesGI.commonSrcPath..".common.DataBinConf"):create(v)
    end
end

-- 微信图片分享
function SmallGamesGF.onShareWechatImage(imgName, wxscene)
    if imgName == nil then
        imgName = SmallGamesGI.lobbyName.."WechatShare.jpg"
    end
    if wxscene == nil then
        wxscene = SmallGamesGI.ShareWechatType.Timeline
    end
    local imaPath = ""
    if device.platform == "android" then
        imaPath = "/sdcard/"..imgName
    else
        imaPath = cc.FileUtils:getInstance():getWritablePath()..imgName
    end
    --截屏回调方法  
    local function afterCaptured(succeed, outputFile)
        if succeed then
            print("Capture screen success.")
            local shareData = clone(SmallGamesGI.ShareWechatData)
            shareData.wxscene = wxscene
            shareData.imgpath = outputFile
            shareData.sharetype="image"
            SmallGamesGI.ShareHelper:doShare(SmallGamesGI.ShareSDKType.Wechat, shareData)
        else
            print("Capture screen failed.")
        end
    end
    cc.utils:captureScreen(afterCaptured, imaPath)
end