local Unlock = class("Unlock", SmallGamesGMF.LoadPackages("mvc").ViewBase)

Unlock.AUTO_RESOLUTION   = true
Unlock.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("main.uiUnlockanimal")
Unlock.RESOURCE_BINDING  = {
    panel         = { parent = nil, varname = "panel" },          
        race_pic_photo_2            = { parent = "panel", varname = "race_pic_photo_2" },       
            spr_animal            = { parent = "race_pic_photo_2", varname = "spr_animal" },        
            fnt_rate            = { parent = "race_pic_photo_2", varname = "fnt_rate" },        
        btn_ok            = { parent = "panel", varname = "btn_ok", events={event=SmallGamesGI.bindingEvents.ClickScale, method="onClickOK"}  },      
}

function Unlock:onCreate()
    self:runAction(self.resourceNode_.animation)
    self.resourceNode_.animation:play("star_", false)
    local remove = {}
    remove[#remove + 1] = cc.DelayTime:create(7)
    remove[#remove + 1] = cc.CallFunc:create(function ( ... )
        self:removeFromParent()
    end)

    self:runAction(transition.sequence(remove))
end

function Unlock:setRate(rate)
    self.fnt_rate:setString(rate)
end

function Unlock:loadImage(img)
    self.spr_animal:initWithFile(img)
end

function Unlock:onClickOK()
    self.resourceNode_.animation:play("end_", false)
    local callDelay = {}
    callDelay[#callDelay + 1] = cc.DelayTime:create(0.165)
    callDelay[#callDelay + 1] = cc.CallFunc:create(function ( ... )
        self:removeFromParent()
    end)

    self:runAction(transition.sequence(callDelay))
    
end

return Unlock
