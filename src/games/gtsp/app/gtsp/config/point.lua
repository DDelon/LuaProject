local Point = class("Point", nil)

function Point:create( ... )
    local Point = Point.new()

    local ponit_data = require(SmallGamesGF.getCurAppSrcPath("databin.point"))

    Point.points = {}

    for k,v in pairs(ponit_data) do
        if v.id ~= "" then
        local info = {}
        info.id = v.id + 0
        info.point_lv = v.point_lv + 0
        info.point_demand = v.point_demand + 0
        info.item_id = v.item_id
        info.item_num = v.item_num

        Point.points[#Point.points + 1] = info
        end
    end

    
    local function mysort(data1, data2)
        return tonumber(data1.id) < tonumber(data2.id)
    end

    table.sort(Point.points, mysort)

    return Point
end

function Point:getLvByPoint(level)
    for k,v in pairs(self.points) do
        
        if v.point_lv == level then
            return v.point_demand
        end 
    end

    return 0
end


return Point