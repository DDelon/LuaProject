local StakeEffect = class("StakeEffect", SmallGamesGMF.LoadPackages("mvc").ViewBase)

StakeEffect.AUTO_RESOLUTION   = true
StakeEffect.RESOURCE_FILENAME = SmallGamesGF.getCurAppResUIPath("effect.uiStake")
StakeEffect.RESOURCE_BINDING  = {
}

function StakeEffect:onCreate()
    self:runAction(self.resourceNode_.animation)
    local effect = DogGI.preload:getStakeEffect()

    self.coin = cc.Sprite:create(SmallGamesGF.getCurAppResPath("effect/effect_stake01.png"))
    local action = cc.RepeatForever:create(cc.Animate:create(effect))

    self.coin:runAction(action)
    self:setVisible(false)
    self:addChild(self.coin)
    --self:runAction(action)
end

function StakeEffect:play()
    self:setVisible(true)
    self.coin:setVisible(true)
end

function StakeEffect:stop( ... )
    self.resourceNode_.animation:play("start", false)

    self.coin:setVisible(false)
    local actions = {}
    actions[#actions + 1] = cc.DelayTime:create(0.5)
    actions[#actions + 1] = cc.CallFunc:create(function ( ... )
        self:setVisible(false)
    end)

    self:runAction(transition.sequence(actions))
end

function StakeEffect:onTouchBegan( ... )
    return false
end

return StakeEffect
