cc.exports.SmallGamesCD = {}

local function initGame(rootSrcPath, rootResPath)
    -- 模块目录结构
    SmallGamesCD.rootSrcPath = string.gsub(rootSrcPath, "/", ".")
    SmallGamesCD.rootResPath = rootResPath
    SmallGamesCD.rootResUIPath = string.gsub(rootResPath, '/', '.')

    -- 加载全局配置
    require(SmallGamesCD.rootSrcPath..".global.GlobalInstance")

    SmallGamesGI.appVersion = "1.1.1"
end

return initGame