local Config = class("Config", nil)

function Config:create( ... )
    local config = Config.new()
    config:initConfig()

    return config
end

function Config:initConfig()
    local luaconfig = require(SmallGamesGF.getCurAppSrcPath("databin.config"))

    self.start_x                = luaconfig["990000002"].data + 0
    self.start_y                = luaconfig["990000012"].data

    local runningpartconfig     = string.split(luaconfig["990000003"].data, ";")
    self.running_part_config = {}
    for k,v in pairs(runningpartconfig) do
        local pConfig = {}
        local sc = string.split(v, ",")
        pConfig.time = sc[1] + 0
        pConfig.min = sc[2] + 0
        pConfig.max = sc[3] + 0

        self.running_part_config[#self.running_part_config + 1] = pConfig
    end
    
    self.config_d               = luaconfig["990000004"].data + 0

    self.min_percent            = luaconfig["990000005"].data
    self.max_percent            = luaconfig["990000006"].data

    self.max_radom              = luaconfig["990000007"].data + 0

    self.default_group          = string.split(luaconfig["990000008"].data, ",")
    self.default_unlock         = string.split(luaconfig["990000009"].data, ",")

    self.pre_set_water          = luaconfig["990000010"].data


    local speedframerate        = string.split(luaconfig["990000011"].data, ";")
    self.speed_frame_rate       = {}
    for k,v in pairs(speedframerate) do
        local ptemp = {}
        local st = string.split(v, ",")
        ptemp.min = st[1] + 0
        ptemp.max = st[2] + 0
        ptemp.rate = st[3] + 0
        self.speed_frame_rate[#self.speed_frame_rate + 1] = ptemp
    end

    self.first_end_final_x      = luaconfig["990000013"].data + 0

    self.near_average_time      = luaconfig["990000014"].data + 0
    self.far_average_time       = luaconfig["990000015"].data + 0

    self.max_time_offset        = luaconfig["990000016"].data + 0
    self.min_time_offset        = luaconfig["990000017"].data + 0

    self.decelerate_time        = luaconfig["990000018"].data + 0
    self.accelerate_time        = luaconfig["990000019"].data + 0

    self.total_time             = luaconfig["990000020"].data + 0
    
    self.start_line             = luaconfig["990000021"].data + 0
    self.end_line               = luaconfig["990000022"].data + 0
    self.bet_countdown          = luaconfig["990000024"].data + 0
    self.pause_period           = luaconfig["990000026"].data + 0
    self.enter_condition        = luaconfig["990000029"].data + 0
    self.title_icon             = luaconfig["990000030"].data
end

return Config