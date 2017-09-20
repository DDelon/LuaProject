
local AppBase = class("AppBase")

function AppBase:ctor(configs_, defaultScene)

    assert(type(configs_) == "table", "AppBase:ctor configs_ is not a table")

    self.configs_ = configs_
    self.defaultScene_ = defaultScene

    if DEBUG > 1 then
        dump(self.configs_, "AppBase configs")
    end

    -- event
    self:onCreate()
end

function AppBase:run(initSceneName, bPush)
    initSceneName = initSceneName or self.defaultScene_
    self:enterScene(initSceneName, bPush)
end

function AppBase:enterScene(sceneName, bPush)
    SmallGamesGF.removeKeyboardAll()
    local view = self:createView(sceneName)
    view:showWithScene(bPush)
    SmallGamesGI.curScene = view
    return view
end

function AppBase:popScene()
    cc.Director:getInstance():popScene()
end

function AppBase:exit()
    cc.Director:getInstance():endToLua()
end

function AppBase:createView(name, parent, node, ...)
    local taskParams = {...}
    if self.configs_[name] then
        for k, root in pairs(self.configs_[name]) do
            local packageName = string.format("%s.%s", root, name)
            local status, view = xpcall(function()
                    return require(packageName)
                end, function(msg)
                if not string.find(msg, string.format("'%s' not found:", packageName)) then
                    print("load view error: ", msg)
                end
            end)
            local t = type(view)
            if status and (t == "table" or t == "userdata") then
                return view:create(self, name, parent, node, ...)
            end
        end
    end
    error(string.format("AppBase:createView() - not found view \"%s\" in search paths \"%s\"",
        name, table.concat(self.configs_, ",")), 0)
end

function AppBase:onCreate()
end 

return AppBase
