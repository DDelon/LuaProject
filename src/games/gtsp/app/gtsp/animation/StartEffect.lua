local StartEffect = class("Unlock", SmallGamesGMF.LoadPackages("mvc").ViewBase)

StartEffect.AUTO_RESOLUTION   = true
StartEffect.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("effect.uiStart")
StartEffect.RESOURCE_BINDING  = {
}

function StartEffect:onCreate()
    self:runAction(self.resourceNode_.animation)
end

function StartEffect:play(img)
    self.resourceNode_.animation:play("playlo", false)
end

function StartEffect:onTouchBegan( ... )
    return false
end

return StartEffect
