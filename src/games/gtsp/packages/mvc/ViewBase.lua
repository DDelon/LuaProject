
local ViewBase = class("ViewBase", cc.Node)

-- 释放设备返回键时间
local releaseKeyboardTime = os.clock()

function ViewBase:ctor(app, name, parent, node, ...)
    self:enableNodeEvents()
    self.app_ = app
    if name == nil or name == "" then
        name = self.class.__cname
    end
    self.name_ = name
    self.parent_ = parent
    self.node_ = node
    self.tag_ = SmallGamesGF.getViewTag(self.name_)

    -- 同一个按钮点击时间间隔，当且仅当>0时控制生效
    self.multiTouchTime = 0.2
    local multiTouchTime = rawget(self.class, "MULTI_TOUCH_TIME")
    if multiTouchTime then
        self.multiTouchTime = multiTouchTime
    end
    -- 两个按钮点击时间间隔，当且仅当>0时控制生效
    self.multiBtnTouchTime = 0.2
    local multiBtnTouchTime = rawget(self.class, "MULTI_BTN_TOUCH_TIME")
    if multiBtnTouchTime then
        self.multiBtnTouchTime = multiBtnTouchTime
    end
    self.lastClickBtnData = {
        nodeBtn = nil,
        curClickTime = os.clock(),
        multiTouchTime = 0,
        multiBtnTouchTime = 0,
    }

    -- 开启触摸事件
    self.openTouchEventListener = true
    local openTouchEventListener = rawget(self.class, "TOUCH_EVENT_LISTENER")
    if openTouchEventListener then
        self.openTouchEventListener = openTouchEventListener
    end

    -- check lua resource file

    local res = rawget(self.class, "RESOURCE_FILENAME")
    if node == nil then 
        if res then
            self:createResourceNode(res)
        end

        local binding = rawget(self.class, "RESOURCE_BINDING")
        if res and binding then
            self:createResourceBinding(binding, self.resourceNode_.root)
        end
    else 
        self.resourceNode_ = node
        local binding = rawget(self.class, "RESOURCE_BINDING")
        if res and binding then
            self:createResourceBinding(binding, self.resourceNode_)
        end

        local parentNode = node:getParent()
        local localZOrder = node:getLocalZOrder()
        local anchorPoint = node:getAnchorPoint()
        local posX = node:getPositionX()
        local posY = node:getPositionY()
        local scaleX = node:getScaleX()
        local scaleY = node:getScaleY()
        node:removeFromParent()
        self:addChild(node)
        parentNode:addChild(self, localZOrder)
        node:setPosition(cc.p(0, 0))
        node:setScaleX(1)
        node:setScaleY(1)
        self:setAnchorPoint(cc.p(anchorPoint))
        self:setPosition(cc.p(posX, posY))
        self:setScaleX(scaleX)
        self:setScaleY(scaleY)
    end

    if self.tag_ then
        self:setTag(self.tag_)
    end

    printf("%s:onCreate", self.name_)
    self:onCreate(...)

    printf("%s:onInit", self.name_)
    self:onInit()

    if self.openTouchEventListener then
        local function onTouchBegan(touch,event)
            printf("%s:onTouchBegan", self.name_)
            return self:onTouchBegan(touch,event)
        end
        local function onTouchMoved(touch,event)
            printf("%s:onTouchMoved", self.name_)
            self:onTouchMoved(touch,event)
        end
        local function onTouchEnded(touch,event)
            printf("%s:onTouchEnded", self.name_)
            self:onTouchEnded(touch,event)
        end
        local function onTouchCancelled(touch,event)
            printf("%s:onTouchCancelled", self.name_)
            self:onTouchCancelled(touch,event)
        end
        local listenerTouch = cc.EventListenerTouchOneByOne:create()
        listenerTouch:setSwallowTouches(self:isSwallowTouches())
        listenerTouch:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
        listenerTouch:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
        listenerTouch:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
        listenerTouch:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
        self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listenerTouch, self)
    end

end

function ViewBase:enableNodeEvents()
    if self.isNodeEventEnabled_ then
        return self
    end

    self:registerScriptHandler(function(state)
        if state == "enter" then
            printf("%s:onEnter", self.name_)
            self:onEnter_()
            self:onCallbackEnter()
            self:onEnterAni()
        elseif state == "exit" then
            printf("%s:onExit", self.name_)
            self:removeKeyboard()
            SmallGamesGI.eventDispatcher:removeListenerByView(self)
            self:onExit_()
            self:onCallbackExit()
        elseif state == "enterTransitionFinish" then
            printf("%s:onEnterTransitionFinish", self.name_)
            self:onEnterTransitionFinish_()
        elseif state == "exitTransitionStart" then
            printf("%s:onExitTransitionStart", self.name_)
            self:onExitTransitionStart_()
        elseif state == "cleanup" then
            printf("%s:onCleanup", self.name_)
            self:onCleanup_()
        end
    end)
    self.isNodeEventEnabled_ = true

    return self
end

function ViewBase:createResourceNode(resourceFilename)
    if self.resourceNode_ then
        self.resourceNode_.root:removeSelf()
        self.resourceNode_ = nil
    end
    
   local lua_ui = require(resourceFilename).create()
   if lua_ui then   
        self:addChild(lua_ui.root)
        self.resourceNode_ = lua_ui
        local resolution = rawget(self.class, "AUTO_RESOLUTION") 
        local com =  lua_ui.root:getComponent("__ui_layout")
        if com and resolution then
             --com:setSize(display.size)
             com:refreshLayout()
        end
        -- 分标率自适应
        self:makeResolutionAdaptation(self.resourceNode_.root)
   end
end

function ViewBase:createResourceBinding(binding, res_node)
    for nodeName, nodeBinding in pairs(binding) do
        local function getNode( nodeChildName )
            if binding[nodeChildName] then
                local varname = binding[nodeChildName].varname
                if binding[nodeChildName].parent ~= nil and binding[nodeChildName].parent ~= "" then
                    local nodeParent = self[binding[nodeChildName].parent]
                    if not nodeParent then
                        nodeParent = getNode(binding[nodeChildName].parent)
                    end
                    self[nodeChildName] = nodeParent:getChildByName(varname)
                else
                    self[nodeChildName] = res_node:getChildByName(varname)
                end
            end
            return self[nodeChildName]
        end
        local node = getNode(nodeName)
        if node then
            self[nodeName] = node
            if nodeBinding.events ~= nil then
                if nodeBinding.events.event >= SmallGamesGI.bindingEvents.Touch and nodeBinding.events.event <= SmallGamesGI.bindingEvents.ClickColor then
                    local multiTouchTime = 0
                    local multiBtnTouchTime = 0
                    if nodeBinding.events.multiTouchTime and nodeBinding.events.multiTouchTime > 0 then
                        multiTouchTime = nodeBinding.events.multiTouchTime
                    elseif self.multiTouchTime > 0 then
                        multiTouchTime = self.multiTouchTime
                    end
                    if nodeBinding.events.multiBtnTouchTime and nodeBinding.events.multiBtnTouchTime > 0 then
                        multiBtnTouchTime = nodeBinding.events.multiBtnTouchTime
                    elseif self.multiBtnTouchTime > 0 then
                        multiBtnTouchTime = self.multiBtnTouchTime
                    end
                    if nodeBinding.events.event == SmallGamesGI.bindingEvents.Touch then
                        self:addTouchEvent(node, self:handler(self,self[nodeBinding.events.methodTouchBegin]), self:handler(self,self[nodeBinding.events.methodTouchMove]),
                            self:handler(self,self[nodeBinding.events.methodTouchEnd]), self:handler(self,self[nodeBinding.events.methodTouchCancel]), nil, multiTouchTime, multiBtnTouchTime)
                    elseif nodeBinding.events.event == SmallGamesGI.bindingEvents.Click then
                        self:addClickEvent(node, self:handler(self,self[nodeBinding.events.method]), nil, multiTouchTime, multiBtnTouchTime)
                    elseif nodeBinding.events.event == SmallGamesGI.bindingEvents.ClickScale then
                        self:addClickEvent(node, self:handler(self,self[nodeBinding.events.method]), 2, multiTouchTime, multiBtnTouchTime, nodeBinding.events.soundEffectPath)
                    elseif nodeBinding.events.event == SmallGamesGI.bindingEvents.ClickColor then
                        self:addClickEvent(node, self:handler(self,self[nodeBinding.events.method]), 1, multiTouchTime, multiBtnTouchTime)
                    end
                elseif nodeBinding.events.event == SmallGamesGI.bindingEvents.EditBox then
                    self[nodeName] = self:initWinEditBox(node, nodeBinding.events.isPassword, nodeBinding.events.isMediate)
                elseif nodeBinding.events.event == SmallGamesGI.bindingEvents.FileNode then
                    if nodeBinding.events.isParent then
                        local binding = rawget(self.class.super, "RESOURCE_BINDING")
                        if binding then
                            self:createResourceBinding(binding, node)
                        end
                    elseif nodeBinding.events.luaFile then
                        self[nodeName] = require(nodeBinding.events.luaFile).new(SmallGamesGI.myApp, nodeBinding.events.viewName, self, node)
                    end
                end
            end
        else
            if nodeBinding.allowNull then
                -- allow null
            else
                assert(node, "ViewBase:createResourceBinding():error"..nodeName)
            end
        end
    end
end 

-- 触摸事件  effect：1变暗 2 缩放 0 or nil 无效果
function ViewBase:addTouchEvent(sender, callbackBegin, callbackMove, callbackEnd, callbackCancel, effect, multiTouchTime, multiBtnTouchTime, soundEffectPath)
    local allowClick = true
    sender:addTouchEventListener(function(sender, eventType) 
        if eventType == ccui.TouchEventType.began then    --began
            if 1 == effect then
                sender:setColor({r = 200, g = 200, b = 200})
            elseif 2 == effect then
                if sender["curScale"] == nil then
                    sender["curScale"] = sender:getScale() or 1
                end
                sender.scale_=sender["curScale"] or 1
                sender:setScale(sender.scale_*0.95)
            end
            if multiTouchTime and multiBtnTouchTime then
                allowClick = self:ifBtnCanClick(sender, multiTouchTime, multiBtnTouchTime)
            end
            if callbackBegin and allowClick then
                callbackBegin(sender,eventType)
            end
        elseif eventType == ccui.TouchEventType.moved then  --moved
            if 1 == effect then
            elseif 2 == effect then
            end
            if callbackMove and allowClick then
                callbackMove(sender,eventType)
            end
        elseif eventType == ccui.TouchEventType.ended then  --end
            if 1 == effect then
                sender:setColor({r = 255, g = 255, b = 255})
            elseif 2 == effect then
                sender:setScale(sender.scale_*1.0)	
            end
            if callbackEnd and allowClick then
                callbackEnd(sender,eventType)
            end
            -- 播放点击音效
            if soundEffectPath ~= nil then
                AudioEngine.playEffect(soundEffectPath)
            else 
                AudioEngine.playEffect(SmallGamesGI.rootResPath.."/sound/common/com_btn01.mp3")
            end
        elseif eventType == ccui.TouchEventType.canceled then  --cancel
            if 1 == effect then
                sender:setColor({r = 255, g = 255, b = 255})
            elseif 2 == effect then
                sender:setScale(sender.scale_*1.0)
            end
            if callbackCancel and allowClick then
                callbackCancel(sender,eventType)
            end
        end
    end)
end

-- 点击事件  effect：1变暗 2 缩放 0 or nil 无效果
function ViewBase:addClickEvent(sender, callback, effect, multiTouchTime, multiBtnTouchTime, soundEffectPath)
    self:addTouchEvent(sender, nil, nil, nil, nil, effect, nil, nil, soundEffectPath)
    sender:addClickEventListener(function() 
        if self:ifBtnCanClick(sender, multiTouchTime, multiBtnTouchTime) then
            if callback then
                callback(sender)
            end
        end
    end)
end

function ViewBase:ifBtnCanClick( sender,  multiTouchTime, multiBtnTouchTime)
    local allowClick = true
    local curClickTime = os.clock()
    if self.lastClickBtnData.nodeBtn then
        if self.lastClickBtnData.nodeBtn == sender then
            if self.lastClickBtnData.multiTouchTime > 0 and curClickTime - self.lastClickBtnData.curClickTime <= self.lastClickBtnData.multiTouchTime then
                allowClick = false
            end
        else
            if self.lastClickBtnData.multiBtnTouchTime > 0 and curClickTime - self.lastClickBtnData.curClickTime <= self.lastClickBtnData.multiBtnTouchTime then
                allowClick = false
            end
        end
    end
    if allowClick then
        self.lastClickBtnData.nodeBtn = sender
        self.lastClickBtnData.curClickTime = curClickTime
        self.lastClickBtnData.multiTouchTime = multiTouchTime
        self.lastClickBtnData.multiBtnTouchTime = multiBtnTouchTime
    end
    return allowClick
end

function ViewBase:buttonClicked(nodeView, sender)
    printf("ViewBase:buttonClicked %s %s", nodeView.name_, sender:getName())
end

function ViewBase:initWinEditBox(box,isPassword,isMediate)
    local parent = box:getParent()
    isPassword = isPassword or false
    local editBoxSize = box:getContentSize()
    local grayColor = cc.c3b(172,181,186)
    local nodeBox = ccui.EditBox:create(cc.size(editBoxSize.width , editBoxSize.height+20), cc.Scale9Sprite:create())--editBoxSize.height
    nodeBox:setAnchorPoint(cc.p(box:getAnchorPoint()))
    nodeBox:setPosition(cc.p(box:getPositionX() , box:getPositionY()))
    nodeBox:setPlaceHolder(box:getPlaceHolder())
    nodeBox:setPlaceholderFontColor(grayColor)
    nodeBox:setFontColor(box:getColor())
    nodeBox.mFontColor = box:getColor()
    --nodeBox:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)
    nodeBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    nodeBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DEFAULT)
    nodeBox:setFontSize( box:getFontSize() )
    nodeBox.mFontSize = box:getFontSize()
    nodeBox:setPlaceholderFontSize(box:getFontSize())
    --nodeBox:setPosition(cc.p(node:getPositionX()*self.scaleMin_,node:getPositionY()*self.scaleMin_))
    
    local issetMaxLengthEnabled = box:isMaxLengthEnabled()
    if issetMaxLengthEnabled then
        nodeBox:setMaxLength(box:getMaxLength())
    end

    nodeBox.isPassword = isPassword
    if isPassword then 
        nodeBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
      else
        nodeBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    end
    parent:addChild(nodeBox)

    nodeBox.setString = function(self,str)
        self:setText(str)
    end
    nodeBox.getString = function(self)
        return self:getText()
    end

    isMediate = true
    --输入完之后是否居中
    if isMediate then
        nodeBox:setPlaceholderFontColor(cc.c4b(255,255,255,0))
        local text_str = ccui.Text:create()
        text_str:ignoreContentAdaptWithSize(true)
        text_str:setTextAreaSize({width = 0, height = 0})
        text_str:setFontSize(box:getFontSize())
        text_str:setString("")
        text_str:setTextHorizontalAlignment(1)
        text_str:setTextVerticalAlignment(1)
        text_str:setLayoutComponentEnabled(true)
        text_str:setName("text_str")
        text_str:setCascadeColorEnabled(true)
        text_str:setCascadeOpacityEnabled(true)
        text_str:setTextColor(box:getColor())
        text_str.mFontColor = box:getColor()
        parent:addChild(text_str)   
        nodeBox.text_str = text_str
        text_str:setPosition(cc.p(box:getPositionX() , box:getPositionY()))
        text_str:setAnchorPoint(cc.p(box:getAnchorPoint()))
        text_str.isPassword = isPassword
        text_str.setStringData = function(self,str)
            local newStr = ""
            if self.isPassword then
                for i=1,#str do
                    newStr = newStr.."*"
                end
            else
                newStr = str
            end
            text_str:setString(newStr)
        end

        nodeBox.setString = function(self,str)
            self:setFontColor(cc.c4b(self.mFontColor.r,self.mFontColor.g,self.mFontColor.b,0))
            self:setText(str)
            self.text_str:setStringData(str)
            if str == "" then
                self.text_str:setString(self:getPlaceHolder())
                self.text_str:setTextColor(grayColor)
            else
                self.text_str:setTextColor(self.text_str.mFontColor)
            end
        end

        --没有初始化str的要调用这个
        nodeBox.setNewPlaceHolder = function(self,str)
            self:setPlaceHolder(str)
            self.text_str:setString(str)
            self.text_str:setTextColor(grayColor)
        end


        --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
        nodeBox:registerScriptEditBoxHandler(
            function(strEventName,pSender) 
                if strEventName == "began" then --编辑框开始编辑时调用
                    print("----------------began---------")
                    pSender.text_str:setVisible(false)
                    local c3bColor = pSender.mFontColor
                    pSender:setFontColor(cc.c4b(c3bColor.r,c3bColor.g,c3bColor.b,255))
                    self:onEditBoxBagan()
                elseif strEventName == "ended" then -- 当编辑框失去焦点并且键盘消失的时候被调用
                    print("----------------ended---------")
                    local str = pSender:getText()
                    pSender.text_str:setStringData(str)
                    pSender.text_str:setVisible(true) 
                    local c3bColor = pSender.mFontColor
                    pSender:setFontColor(cc.c4b(c3bColor.r,c3bColor.g,c3bColor.b,0))
                    if str == "" then
                        pSender.text_str:setString(pSender:getPlaceHolder())
                        pSender.text_str:setTextColor(grayColor)
                    else
                        pSender.text_str:setTextColor(pSender.text_str.mFontColor)
                    end
                    self:onEditBoxEnded()
                elseif strEventName == "return" then --编辑框return时调用-- 当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用
                    --判断是哪个编辑框，在多个编辑框同时绑定此函数时 需判断时哪个编辑框
                    if edit == EditName then 
                    --当编辑框EditName 按下return 时到此处
                    elseif edit == EditPassword then
                    --当编辑框EditPassword  按下return 时到此处
                    elseif edit == EditEmail then
                    --当编辑框EditEmail   按下return 时到此处
                    end
                    self:onEditBoxBagan()
                elseif strEventName == "changed" then --编辑框内容改变时调用
                    print("---changed--text = "..pSender:getText())
                    --pSender.text_str:setString(pSender:getText())
                    self:onEditBoxReturn()
                end
            end) 


    end

    box:removeFromParent()

    return nodeBox

end

-- type : 1 normal 2 push 3 pop
function ViewBase:showWithScene(bPush)
    self:setVisible(true)
    local scene = display.newScene(self.name_)
    scene:addChild(self)
    local director = cc.Director:getInstance()
    if director:getRunningScene() and bPush then
        director:pushScene(scene)
    else
        display.runScene(scene)
    end
    return self
end

function ViewBase:onCreate()
end

function ViewBase:onInit()
end

function ViewBase:onEnter()
    cc.Node:onEnter()
end

function ViewBase:onEnterAni()
end

function ViewBase:onExit()
    cc.Node:onExit()
end

function ViewBase:onExitAni()
    self:removeFromParent()
end

function ViewBase:onExitTransitionStart()
    cc.Node:onExitTransitionStart()
end

function ViewBase:onEnterTransitionFinish()
    cc.Node:onEnterTransitionFinish()
end

function ViewBase:onCleanup()
    cc.Node:onCleanup()
end

function ViewBase:onQuit()
    self:onExitAni()
end

function ViewBase:onCallbackEnter()
    if self.callbackEnter then
        self.callbackEnter()
    end
end

function ViewBase:setCallbackEnter( callbackEnter )
    self.callbackEnter = callbackEnter
end

function ViewBase:onCallbackExit()
    if self.callbackExit then
        self.callbackExit()
    end
end

function ViewBase:setCallbackExit( callbackExit )
    self.callbackExit = callbackExit
end

function ViewBase:showGrayBg()
    local gray_bg = SmallGamesGF.showGrayBgByLayer(self, 255)
    gray_bg:setLocalZOrder(self:getLocalZOrder()-1)
end

function ViewBase:enterAni(node)
    SmallGamesGF.onViewEnterAni(node)
end

function ViewBase:exitAni(node)
    local function callbackFun()
        self:removeFromParent()
    end
    SmallGamesGF.onViewExitAni(node, callbackFun)
end

function ViewBase:onTouchBegan(touch,event)
    return true
end

function ViewBase:onTouchMoved(touch,event)
end

function ViewBase:onTouchEnded(touch,event)
end

function ViewBase:onTouchCancelled(touch,event)
end

function ViewBase:isSwallowTouches()
    return true
end

function ViewBase:onEditBoxBagan( sender )
end

function ViewBase:onEditBoxChanged( sender )
end

function ViewBase:onEditBoxEnded( sender )
end

function ViewBase:onEditBoxReturn( sender )
end

function ViewBase:handler(obj, method)
    if method == nil then
        return
    end
    return handler(obj, method)
end

function ViewBase:getChildNode( nodeParent, childName, tChildListTmp )
    local nodeChild = nil
    if table.getn(nodeParent:getChildren()) == 0 then 
        return nodeChild
    end 
    nodeChild = nodeParent:getChildByName(childName)
    if nodeChild then 
        if tChildListTmp then 
            tChildListTmp[childName] = nodeChild
        end
        return nodeChild
    end
    for i, v in ipairs(nodeParent:getChildren()) do 
        nodeChild = v:getChildByName(childName)
        if nodeChild then 
            if tChildListTmp then 
                tChildListTmp[childName] = nodeChild
            end
            return nodeChild
        else 
            nodeChild = self:getChildNode(v, childName, tChildListTmp)
            if nodeChild then 
                return nodeChild
            end 
        end 
    end 
    return nodeChild
end

-- 根据name获取子节点 包括ui节点 子节点中不可出现重名
function ViewBase:child(name)
    local child=self:getChildByName(name)
    local res_ui= self.resourceNode_.root
    if not child and res_ui then
        if res_ui[name] then 
            return res_ui[name]
        else
            return self:getChildNode(res_ui, name)
        end
    end
    return child
end

function ViewBase:openKeyboard()
    printf("%s:openKeyboard", self.name_)
    table.insert(SmallGamesGI.keyBoardViews.list, table.getn(SmallGamesGI.keyBoardViews.list)+1, self.name_)
    SmallGamesGI.keyBoardViews.views[self.name_] = self
    local function keyboardEventHandle(code, event)
        if code == cc.KeyCode.KEY_BACK then
            if self.onKeyback then
                if SmallGamesGI.bOpenKeyBackSingle then
                    if os.clock() - releaseKeyboardTime > 0.1 then
                        releaseKeyboardTime = os.clock()
                        local viewKeyBack = SmallGamesGI.keyBoardViews.views[SmallGamesGI.keyBoardViews.list[table.getn(SmallGamesGI.keyBoardViews.list)]]
                        printf("%s:onKeyback", viewKeyBack.name_)
                        if viewKeyBack.onKeyback then
                            viewKeyBack:onKeyback()
                        end
                    end
                else
                    printf("%s:onKeyback", self.name_)
                    if self.onKeyback then
                        self:onKeyback()
                    end
                end
            end
        end
    end
    local listenerKeyboard = cc.EventListenerKeyboard:create();
    --listenerKeyboard:registerScriptHandler(keyboardEventHandle, cc.Handler.EVENT_KEYBOARD_PRESSED)
    listenerKeyboard:registerScriptHandler(keyboardEventHandle, cc.Handler.EVENT_KEYBOARD_RELEASED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listenerKeyboard, self)
end

function ViewBase:removeKeyboard()
    table.removebyvalue(SmallGamesGI.keyBoardViews.list, self.name_)
    SmallGamesGI.keyBoardViews.views[self.name_] = nil
end

function ViewBase:onKeyback()
end

--控件类型
local g_eUIControllType = {
    None = 0,
    Node = 1,
    Sprite = 2,
    Label = 3,
    Button = 4,
    EditBox = 5,
    CheckBox = 6,
    ImageView = 7,
    Layout = 8,
    ScrollView = 9,
    ListView = 10,
}
local g_tUIControllType = {}
for i,v in pairs(g_eUIControllType) do
    g_tUIControllType[v] = i
end

--控件配置
local g_tUIControllInfo = {
    None = {
                false, --分辨率适配时可作为画布拉伸的控件
            },
    Node = {false},
    Sprite = {false},
    Label = {false},
    Button = {false},
    EditBox = {false},
    CheckBox = {false},
    ImageView = {false},
    Layout = {true},
    ScrollView = {true},
    ListView = {true},
}

-- 分辨率适配
function ViewBase:makeResolutionAdaptation(uiControll, sizeUIControll)

    if uiControll == nil then
        return
    end

    --获取控件类型
    local function getControllType(uiControll)
        local strControllName = uiControll:getDescription()
        if string.byte(strControllName, 1) == 60--[['<'--]] then
            local iBlankIndex = string.find(strControllName, ' ')
            if iBlankIndex then
                strControllName = string.sub(strControllName, 2, iBlankIndex-1)
            end
        end
        if g_tUIControllInfo[strControllName] then
            return g_eUIControllType[strControllName]
        else
            return g_eUIControllType.None
        end
    end

    -- 控件可拉伸，用于分辨率适配
    local function getIsControllStretchable(eControllType, uiControll)
        local scale9Enabled = g_tUIControllInfo[g_tUIControllType[eControllType]][1]
        if not scale9Enabled and eControllType == g_eUIControllType.ImageView then
            scale9Enabled = uiControll:isScale9Enabled()
        end
        if scale9Enabled and uiControll.UserData then
            if uiControll.UserData[1] == "scale9_disabled" then
                scale9Enabled = false
            end
        end
        return scale9Enabled
    end

    local function adaptationUIControll(uiControllTmp, fScaleX, fScaleY, fScale1, fScale2)
        local eControllType = getControllType(uiControllTmp)
        local layout = ccui.LayoutComponent:bindLayoutComponent(uiControllTmp)
        if getIsControllStretchable(eControllType, uiControllTmp) then
            -- if not layout:isPercentWidthEnabled() then 
            --     uiControllTmp:setContentSize(cc.size(uiControllTmp:getContentSize().width*fScaleX, uiControllTmp:getContentSize().height))
            -- end 
            -- if not layout:isPercentHeightEnabled() then 
            --     uiControllTmp:setContentSize(cc.size(uiControllTmp:getContentSize().width, uiControllTmp:getContentSize().height*fScaleY))
            -- end 
            if layout:getHorizontalEdge() == 3 then
                local uiParent = uiControllTmp:getParent()
                uiControllTmp:setContentSize(cc.size(uiParent:getContentSize().width-(layout:getLeftMargin()+layout:getRightMargin()), 
                    uiControllTmp:getContentSize().height))
            else
                uiControllTmp:setContentSize(cc.size(uiControllTmp:getContentSize().width*fScaleX, uiControllTmp:getContentSize().height))
            end
            if layout:getVerticalEdge() == 3 then
                local uiParent = uiControllTmp:getParent()
                uiControllTmp:setContentSize(cc.size(uiControllTmp:getContentSize().width, 
                    uiParent:getContentSize().height-(layout:getTopMargin()+layout:getBottomMargin())))
            else 
                uiControllTmp:setContentSize(cc.size(uiControllTmp:getContentSize().width, uiControllTmp:getContentSize().height*fScaleY))
            end
            --uiControllTmp:setContentSize(cc.size(uiControllTmp:getContentSize().width*fScaleX, uiControllTmp:getContentSize().height*fScaleY))
            -- if not layout:isPositionPercentXEnabled() then 
            --     uiControllTmp:setPositionX(uiControllTmp:getPositionX()*uiControllTmp:getScaleX()*fScaleX)
            -- end 
            -- if not layout:isPositionPercentYEnabled() then 
            --     uiControllTmp:setPositionY(uiControllTmp:getPositionY()*uiControllTmp:getScaleY()*fScaleY)
            -- end 
            uiControllTmp:setPosition(cc.p(uiControllTmp:getPositionX()*fScaleX, uiControllTmp:getPositionY()*fScaleY))
            return 1
        elseif eControllType == g_eUIControllType.Node then
            uiControllTmp:setPosition(cc.p(uiControllTmp:getPositionX()*fScaleX, uiControllTmp:getPositionY()*fScaleY))
            return 1
        else
            if layout:getHorizontalEdge() == 3 and layout:getVerticalEdge() == 3 then
                uiControllTmp:setScaleX(uiControllTmp:getScaleX()*fScale2)
                uiControllTmp:setScaleY(uiControllTmp:getScaleY()*fScale2)
            else
                if layout:getHorizontalEdge() == 3 and fScale1 == fScaleY then
                    uiControllTmp:setScaleX(uiControllTmp:getScaleX()*fScale2)
                elseif not layout:isPercentWidthEnabled() then 
                    uiControllTmp:setScaleX(uiControllTmp:getScaleX()*fScale1)
                end
                if layout:getVerticalEdge() == 3 and fScale1 == fScaleX then
                    uiControllTmp:setScaleY(uiControllTmp:getScaleY()*fScale2)
                elseif not layout:isPercentHeightEnabled() then 
                    uiControllTmp:setScaleY(uiControllTmp:getScaleY()*fScale1)
                end
            end
            uiControllTmp:setPosition(cc.p(uiControllTmp:getPositionX()*fScaleX, uiControllTmp:getPositionY()*fScaleY))
        end
    end

    local function adaptationUIControlls(uiControllTmp, fScaleX, fScaleY, fScale1, fScale2)
        local res = adaptationUIControll(uiControllTmp, fScaleX, fScaleY, fScale1, fScale2)
        if res == 1 then
            for j, v in pairs(uiControllTmp:getChildren()) do
                adaptationUIControlls(v, fScaleX, fScaleY, fScale1, fScale2)
            end
        end
    end

    local fScaleX, fScaleY
    if sizeUIControll then
        fScaleX = sizeUIControll.width / uiControll:getContentSize().width
        fScaleY = sizeUIControll.height / uiControll:getContentSize().height
        local sizeParent = uiControll:getParent():getContentSize()
        uiControll:setPosition(cc.p(sizeParent.width*uiControll:getAnchorPoint().x, sizeParent.height*uiControll:getAnchorPoint().y))
    else
        fScaleX = display.width / CC_DESIGN_RESOLUTION.width
        fScaleY = display.height / CC_DESIGN_RESOLUTION.height
    end
    local fScale1, fScale2
    if CC_DESIGN_RESOLUTION.autoscale == "FIXED_HEIGHT" then
        fScale1 = fScaleX
        fScale2 = fScaleY
    elseif CC_DESIGN_RESOLUTION.autoscale == "FIXED_WIDTH" then
        fScale1 = fScaleY
        fScale2 = fScaleX
    else
        print("CC_DESIGN_RESOLUTION.autoscale error .")
        assert(false)
    end
    adaptationUIControlls(uiControll, fScaleX, fScaleY, fScale1, fScale2)
    if sizeUIControll then
        local sizeParent = uiControll:getParent():getContentSize()
        uiControll:setPosition(cc.p(sizeParent.width*uiControll:getAnchorPoint().x, sizeParent.height*uiControll:getAnchorPoint().y))
    end
end

return ViewBase
