local Dog = class("Dog", nil)

function Dog:create( ... )
    local dog = Dog.new()
    dog:initDog()

    return dog
end

function Dog:initDog()
    self.dogs = {}
    local dogconfig = require(SmallGamesGF.getCurAppSrcPath("databin.dog"))

    
    for k,v in pairs(dogconfig) do
        if k ~= nil and k ~= "nil" then
            local dog = {}
            dog.id = v.id
            dog.name = v.name
            dog.score = v.score
            dog.true_score = v.true_score
            dog.res = v.res
            dog.dog_type = v.dog_type
            dog.unlock_type = v.unlock_type + 0
            dog.unlock_data = v.unlock_data + 0
            dog.unlock_gold = v.unlock_gold + 0
            dog.y_offset = v.y_offset
            dog.base_frame = v.base_frame

            self.dogs[#self.dogs + 1] = dog
        end
    end

    local function mysort(data1, data2)
        return tonumber(data1.id) < tonumber(data2.id)
    end

    table.sort(self.dogs,mysort)
end


return Dog