local Vip = class("Vip", nil)

function Vip:create( ... )
    local Vip = Vip.new()

    local ponit_data = require(SmallGamesGF.getCurAppSrcPath("databin.vip"))

    Vip.vip_infos = {}

    for k,v in pairs(ponit_data) do
        if v.id ~= "" then
            local info = {}
            info.vip_level = v.vip_level + 0
            info.money_need = v.money_need + 0

            Vip.vip_infos[#Vip.vip_infos + 1] = info
        end
    end

    
    local function mysort(data1, data2)
        return tonumber(data1.vip_level) < tonumber(data2.vip_level)
    end

    table.sort(Vip.vip_infos, mysort)

    return Vip
end

function Vip:getLvByExp(exp)
    for k,v in pairs(self.vip_infos) do
        
        if v.money_need == exp then
            return v.vip_level 
        end 
    end

    return 0
end


return Vip