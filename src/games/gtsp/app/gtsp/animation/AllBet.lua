local AllBet = class("Unlock", SmallGamesGMF.LoadPackages("mvc").ViewBase)

AllBet.AUTO_RESOLUTION   = true
AllBet.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("effect.uiAllstake")
AllBet.RESOURCE_BINDING  = {
}

function AllBet:onCreate()
    self:runAction(self.resourceNode_.animation)
end

function AllBet:play(img)
    self.resourceNode_.animation:play("playlo", false)
end

function AllBet:onTouchBegan( ... )
    return false
end

return AllBet
