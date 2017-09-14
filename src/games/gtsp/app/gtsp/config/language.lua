local Language = class("Language", nil)

function Language:create( ... )
    local language = Language.new()

    local languageConfig = require(SmallGamesGF.getCurAppSrcPath("databin.language"))

    language.confirm = languageConfig["800000001"].ch
    language.cancel = languageConfig["800000002"].ch
    language.rule = languageConfig["800000003"].ch
    language.point = languageConfig["800000004"].ch
    language.vip = languageConfig["800000005"].ch
    language.money = languageConfig["800000006"].ch
    language.point2 = languageConfig["800000007"].ch
    language.vip2 = languageConfig["800000008"].ch
    language.money2 = languageConfig["800000009"].ch
    language.exit = languageConfig["800000010"].ch
    language.all_top = languageConfig["800000011"].ch
    language.bet_top = languageConfig["800000012"].ch
    language.money_no_enough = languageConfig["800000013"].ch
    language.to_long_no_operate = languageConfig["800000014"].ch
    language.anouncement = languageConfig["800000015"].ch
    language.bet_reset = languageConfig["800000016"].ch
    language.start_hangup = languageConfig["800000017"].ch
    language.stop_hangup = languageConfig["800000018"].ch
    language.consume_success = languageConfig["800000019"].ch
    language.consume_fail = languageConfig["800000020"].ch
    language.lost_connect = languageConfig["800000021"].ch
    language.enter_condition_no_satisfy = languageConfig["800000022"].ch

    return language
end


return Language