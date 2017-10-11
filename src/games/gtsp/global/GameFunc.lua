cc.exports.SmallGamesGMF = {}

function SmallGamesGMF.LoadPackages(...)
    local names = {...}
    assert(#names > 0, "SmallGamesGMF.LoadPackages - invalid package names")
    
    if not cc.loaded_packages.module_packages then
        cc.loaded_packages.module_packages = {}
    end
    local loaded_packages = cc.loaded_packages.module_packages
    local packages = {}
    for _, name in ipairs(names) do
        assert(type(name) == "string", string.format("SmallGamesGMF.LoadPackages - invalid package name \"%s\"", tostring(name)))
        if not loaded_packages[name] then
            local packageName = string.format(SmallGamesGI.rootSrcPath..".packages.%s.init", name)
            local cls = require(packageName)
            assert(cls, string.format("SmallGamesGMF.LoadPackages - package class \"%s\" load failed", packageName))
            loaded_packages[name] = cls

            if DEBUG > 1 then
                printInfo("SmallGamesGMF.LoadPackages - load module \"%s\"", packageName)
            end
        end
        packages[#packages + 1] = loaded_packages[name]
    end
    return unpack(packages)
end

--------------------------------------------------------------------------
-----------------------------c++发送消息到lua--------------------------------
--------------------------------------------------------------------------
function SmallGamesGMF.CppToLua(valTab)
    
end