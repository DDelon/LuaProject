local StartAnimate = class("StartAnimate", SmallGamesGMF.LoadPackages("mvc").ViewBase)

StartAnimate.AUTO_RESOLUTION   = true
StartAnimate.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uicountdown.lua")
StartAnimate.RESOURCE_BINDING  = {
}


function StartAnimate:onCreate()
    self:runAction(self.resourceNode_.animation)
    self:play("start", false)
end
function StartAnimate:play(type, loop)
    self.resourceNode_.animation:play(type, loop)
end

return StartAnimate
