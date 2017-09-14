local Preload = class("Preload", nil)


function Preload:create()
    local pl = Preload.new()
    pl:init()
    return pl
end

function Preload:init()
    self:loadCoin()
    self:loadStakeEffect()
    self:preLoadEffect()
    self:preLoadMusic()
end

function Preload:loadCoin()
    cc.SpriteFrameCache:getInstance():addSpriteFrames(SmallGamesGF.getCurAppResPath("effect/effect_game_coin1.plist"))
end

function Preload:loadStakeEffect()
    for i=0, 9 do
        local f_str = string.format(SmallGamesGF.getCurAppResPath("effect/effect_stake_0%d.png"), i)
        local spf = cc.SpriteFrame:create(f_str, cc.rect(0,0,110,110))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(spf, f_str)    
    end
end

function Preload:getCoin()
    local animate = cc.Animation:create()
    for i = 0, 9 do
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("game_coin1_0%d.png", i))
        if frame then
            animate:addSpriteFrame(frame)
        end
    end
    animate:setDelayPerUnit(1.0 / 10.0)
    
    return animate
end

function Preload:getStakeEffect()
    local animate = cc.Animation:create()
    for i = 0, 9 do
        local f_string = string.format(SmallGamesGF.getCurAppResPath("effect/effect_stake_0%d.png"), i)
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(f_string)
        if frame then
            animate:addSpriteFrame(frame)
        end
    end
    animate:setDelayPerUnit(1.0 / 10.0)
    
    return animate
end

function Preload:preLoadEffect()
    self:preLoadEffectImpl(SmallGamesGF.getCurAppResPath("sound/camera_01.mp3"))
    self:preLoadEffectImpl(SmallGamesGF.getCurAppResPath("sound/finish_01.mp3"))
    self:preLoadEffectImpl(SmallGamesGF.getCurAppResPath("sound/lvup_02.mp3"))
    self:preLoadEffectImpl(SmallGamesGF.getCurAppResPath("sound/rolling_01.mp3"))
    self:preLoadEffectImpl(SmallGamesGF.getCurAppResPath("sound/readygo_01.mp3"))
    self:preLoadEffectImpl(SmallGamesGF.getCurAppResPath("sound/readygo_02.mp3"))
end

function Preload:preLoadMusic()
    self:preLoadMusicImpl(SmallGamesGF.getCurAppResPath("music/bgm_run01.mp3"))
    self:preLoadMusicImpl(SmallGamesGF.getCurAppResPath("music/bgm_stay01.mp3"))
end

function Preload:preLoadImage()
    for i = 1, 16 do
        self:preLoadImageImpl(SmallGamesGF.getCurAppResPath("common/com_pic_photo_" .. i ..  ".png"))
    end
end

function Preload:preLoadMusicImpl(path)
    AudioEngine.preloadMusic(path)
end

function Preload:preLoadEffectImpl(path)
    AudioEngine.preloadEffect(path)
end

function Preload:preLoadImageImpl(path)
    cc.Director:getInstance():getTextureCache():addImage(path)
end
return Preload