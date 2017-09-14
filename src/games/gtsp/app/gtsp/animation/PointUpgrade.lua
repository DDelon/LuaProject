local PointUpgrade = class("PointUpgrade", SmallGamesGMF.LoadPackages("mvc").ViewBase)

PointUpgrade.AUTO_RESOLUTION   = true
PointUpgrade.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiPointUpgrade")
PointUpgrade.RESOURCE_BINDING  = {
    txt_upg_level         = { parent = nil, varname = "txt_upg_level" },    
    bg            = { parent = nil, varname = "bg" },        
        txt_reward            = { parent = "bg", varname = "txt_reward" },        
}

function PointUpgrade:onCreate()
    self:runAction(self.resourceNode_.animation)
    self.resourceNode_.animation:play("play_upg", false)
    local path = SmallGamesGF.getCurAppResPath("sound/lvup_02.mp3")
    AudioEngine.playEffect(path)
end

function PointUpgrade:setLevel( level )
    self.txt_upg_level:setString(level)
end

function PointUpgrade:setReward(reward)
    self.txt_reward:setString(reward)
end

return PointUpgrade
