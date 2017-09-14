
local SmallGameApp = class("SmallGameApp", SmallGamesGMF.LoadPackages("mvc").AppBase)

function SmallGameApp:onCreate()
    math.randomseed(os.time())
    SmallGamesGI.myApp = self
end

return SmallGameApp
