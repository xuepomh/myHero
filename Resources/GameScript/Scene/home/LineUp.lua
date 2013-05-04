--阵容

LULayer= {
	LULayer,   --信息头
}
local card = require"GameScript/Scene/common/CardInfo"
function LULayer:create(x,y)
	local this={}
	setmetatable(this,self)
	self.__index = self

	local layer = CCLayer:create()
	--layer:setPosition(ccp(x,y))

	local bg = newSprite("image/scene/home/LineUp.png")
	setAnchPos(bg,x,y)
	layer:addChild(bg)

	local size = DATA_Battle:size()

	local num --阵容的个数
	if size < 3 then
		num = 3
	else
		num  = size + 1
	end

	--local btn = require"GameScript/Common/LuaBtn"
	local group = RadioGroup:new()

	local sv = ScrollView:new(56,530,366,200,0,true)
	for i = 1,num do
		if i <= size then
			if _G.next (DATA_Battle:get(i) )  ~= nil then
				card = CILayer:create(1,DATA_Battle:get(1)["card_id"],56,530,{parent = sv,
																callback = function(card_this,card_x,card_y)
																					print(i)
																end})
				sv:addChild(card:getLayer(),card)
			elseif _G.next (DATA_Battle:get(i) )  == nil  then
				card = CILayer:create(2,DATA_Battle:get(1)["card_id"],56,530,{parent = sv,
																callback = function(card_this,card_x,card_y)
																					print(i)
																end})
				sv:addChild(card:getLayer(),card)
			end
		else
				card = CILayer:create(3,nil,56,530,{parent = sv,
																callback = function(card_this,card_x,card_y)
																					print(i)
																end})
				sv:addChild(card:getLayer(),card)
		end

	end
	layer:addChild(sv:getLayer())


	local lef = newSprite("image/UserAvatar/left_1.png")
	setAnchPos(lef,20,529)
	layer:addChild(lef)

	local rig = newSprite("image/UserAvatar/right_1.png")
	setAnchPos(rig,420,529)
	layer:addChild(rig)

--[[
		xx = 50
		yy = 100
		local temp
		local sv = LuaScrollView:new(0,550,480,200)

	   for i = 1 , 5 do
			temp = btn:new("image/buttonUI/home/button/",{"def.png","pre.png"},xx,yy,
					{
						parent = sv,
						--front = "image/scene/Culture/new_Property.png",
						highLight = true,
						scale = true,

						callback=
							function()
								print(i,"---")
							end
					}, group)
	    if i == 1 then
				group:chooseBtn(temp)
	    end
		sv:addChild(temp:getLayer(),temp)
		y =  y + 100
		end
		layer:addChild(sv:getLayer())


]]


	return layer
end
