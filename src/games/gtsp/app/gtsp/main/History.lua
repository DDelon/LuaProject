local History = class("History", SmallGamesGMF.LoadPackages("mvc").ViewBase)

History.AUTO_RESOLUTION   = true
History.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiGameHistory.lua")
History.RESOURCE_BINDING  = {    
    panel         = { parent = nil, varname = "panel" },
    bg         = { parent = "panel", varname = "bg" },
    btn_close     = { parent = "bg", varname = "btn_close", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickClose"} },
    sv_result_container     = { parent = "bg", varname = "sv_result_container"},
    column_1     = { parent = "bg", varname = "column_1"},
}
History.RESOURCE_UNLOCK_ANIMAL = SmallGamesGF.getCurAppResPath("animal/")

function History:onCreate()
    self.column_1:setVisible(false)
end

function History:onClickClose( ... )
    DogGI.ui_manager:resume()
    self:onQuit()
    --self:removeFromParent()
end

function History:init( datas )

    local baseX, baseY = self.column_1:getPosition()
    local data = datas.items
    if #data == 0 then
        return
    end

    self.sv_result_container:setSwallowTouches(false)
    self.sv_result_container:setScrollBarEnabled(false)
    self.sv_result_container:setInnerContainerSize(cc.size(100* #data, 100 ))

    local posSeq = {}
    for i = #data, 1, -1 do
        local column = self.sv_result_container:getChildByName("column_" .. i)
        if not column then
            column = self.column_1:clone()
            column:setName("column_" .. i)
            column:setPosition(baseX + 100 * (#data - i), baseY)
            column:setVisible(true)
            --for i = 1, 6 do
            --    column:getChildByName("head_" .. i):getChildByName("headx"):removeFromParent()
            --end
            
            self.sv_result_container:addChild(column)
        end

        local winIndex = -1
        local resId = data[i].resultAnimal
        local betInfo = data[i].bets

        local px, py = column:getPosition()

        for i,v in ipairs(betInfo) do
            if v.animalId == resId then
                winIndex = i
            end

            local config = DogGI.dog_config.dogs[tonumber(v.animalId)]
            local item = column:getChildByName("head_" .. i)
            item:getChildByName("fnt_rate"):setString("x".. config.score)
            item:getChildByName("fnt_rate"):setLocalZOrder(1)
            item:getChildByName("img_bg"):setVisible(true)
            item:getChildByName("img_bg_2"):setVisible(false)

            local size = item:getContentSize()
            local img = ccui.ImageView:create(History.RESOURCE_UNLOCK_ANIMAL .. config.res .. ".png")
            img:setName("headx")
            img:setScale(0.5)
            img:setPosition(size.width/2, size.height/2)
            item:addChild(img)
        end

        local winItem = column:getChildByName("head_" .. winIndex)
        winItem:getChildByName("img_bg"):setVisible(false)
        winItem:getChildByName("img_bg_2"):setVisible(true)

        local rect = winItem:getContentSize()
        local x, y = winItem:getPosition()
        posSeq[#posSeq + 1] = cc.p(px + x - rect.width/4, py + y - rect.height/4)
    end

    self:doDrawLine(posSeq)

   -- dump(posSeq)
    
end

function History:onEnterAni()
    DogGI.ui_manager:pause()
    self:enterAni(self.panel)
end

function History:onExitAni()
    self:exitAni(self.panel)
end

function History:onTouchBegan( ... )
    if not self:isVisible() then
        return false
    end
    
    return true
end

function History:doShow()
    self:setVisible(true)
end

function History:doDrawLine( poses )
    local spr = cc.Sprite:create(SmallGamesGF.getCurAppResPath("race/race_record_bg_1.png"))
    spr:setPosition(poses[1])
    self.sv_result_container:addChild(spr, 11)

    if #poses == 1 then
        return
    end

    --local angle = self:getAngelBetweenPos(poses[1], poses[2])
    
    local dn = cc.DrawNode:create()
    dn:drawSegment(poses[1], poses[2], 2, cc.c4f(1, 0, 0, 1))
    dn:setPosition(0, 0)
    self.sv_result_container:addChild(dn, 10)

    table.remove( poses, 1 )

    self:doDrawLine( poses )
end

-----------------------------------------------------------------------------------
function History:getAngelBetweenPos(posFrom, posTo)

	local scalePosFrom 	= 	cc.p(posFrom.x , posFrom.y)
	local scalePosTo 	= 	cc.p(posTo.x , posTo.y )

	-- 去掉偏移影响
	local posDst = cc.p(scalePosTo.x - scalePosFrom.x, scalePosTo.y - scalePosFrom.y)

	return (cc.pGetAngle(cc.p(0, 0), posDst)/math.pi) * 180
end


function History:getLine()
    local spr = cc.Sprite:create(SmallGamesGF.getCurAppResPath("race/race_bg_line.png"))

    return spr
end

function History:calDistanceBtwPoses( pos1, pos2 )
    local deltX = pos1.x - pos2.x
    local deltY = pos1.y - pos2.y

    return math.sqrt( deltX * deltX + deltY * deltY )
end

return History
