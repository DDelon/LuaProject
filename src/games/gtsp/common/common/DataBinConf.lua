local DataBinConf = class("DataBinConf", nil)

function DataBinConf:create( confName )
    local confDataBin = DataBinConf.new()
    confDataBin:init(confName)
    return confDataBin
end

function DataBinConf:init(confName)
    self.confData = require(SmallGamesGI.dataBinPath.."."..confName)
end

function DataBinConf:getDataById( strId )
    return self.confData[strId]
end

return DataBinConf