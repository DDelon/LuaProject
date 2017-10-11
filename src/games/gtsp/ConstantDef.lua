local function initGame(rootSrcPath, rootResPath, lobbyName, appName, lobbyData)
    -- 加载全局配置
    require(rootSrcPath..".global.GlobalFunc")(rootSrcPath, rootResPath)
    SmallGamesGF.start(lobbyName, appName, lobbyData)
end

return initGame