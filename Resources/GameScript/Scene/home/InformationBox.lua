msgLayer= {
	Layer,   --消息推送
}

function msgLayer:create(x,y)
	local this={}
	setmetatable(this,self)
	self.__index = self

	local layer = CCLayer:create()
	local bg = newSprite("image/scene/home/msg_bg.png")
	bg:setAnchorPoint(ccp(0,0))
	layer:addChild(bg)
	layer:setPosition(ccp(x,y))

	return layer
end
