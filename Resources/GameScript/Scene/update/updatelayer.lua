local PATH = IMG_SCENE.."update/"
local Card = require(SRC.."Scene/common/CardInfo")
local List = require(SRC.."Scene/common/ItemList")
local Pages = require(SRC.."Scene/common/ItemsPage")

local UpdateLayer = {
	layer,
	page
}

function UpdateLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	
	local bg = newSprite(IMG_COMMON.."main.png")
	setAnchPos(bg)
	this.layer:addChild(bg)
	
	local group = RadioGroup:new()
	local upList = {
		{"hero", function()
				this:createHeroUp(params.cid, params.data)
			end},
		{"card", function()
				this:createCardUp(params.kind, params.cid)
			end},
	}
	
	for i = 1, #upList do
		local heroUp = Btn:new(PATH, {upList[i][1].."_up.png", upList[i][1].."_up_select.png"},20 + (i - 1 ) * 160, 750, {
			callback = function(touch)
				if touch then
					params = {}
				end
				upList[i][2]()
			end,
			disableWhenChoose = true,
		},group)
		this.layer:addChild(heroUp:getLayer())		
	end
	
	group:chooseByIndex(params.tab or 1, true)
	
	local line = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(line, 0, 748)
	this.layer:addChild(line)
	
	
	return this
end

function UpdateLayer:createCardUp(kind, cid)
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer, true)
	end
	
	self.contentLayer = newLayer()
	
	local card = Card:new(10, 400, {
		type = kind,
		cid = cid,
	})
	self.contentLayer:addChild(card:getLayer())
	
	local bg = newSprite(PATH.."gold_bg.png")
	setAnchPos(bg, 280, 660)
	self.contentLayer:addChild(bg)
	
	bg = newSprite(PATH.."level_bg.png")
	setAnchPos(bg, 280, 530)
	self.contentLayer:addChild(bg)
	
	bg = newSprite(PATH.."gold_bg.png")
	setAnchPos(bg, 280, 430)
	self.contentLayer:addChild(bg)
	
	local items = {target = {type = kind, cid = cid}}
	local scroll
	
	local function upItems(data)
		if scroll then
			self.contentLayer:removeChild(scroll:getLayer(), true)	
		end
		scroll = ScrollView:new(0, 170, 480, 100, 10, true)
		
		local list = getSortKey(data)
		
		for i = 1, #list do
			local item = Btn:new(IMG_COMMON, {"icon_bg"..getBag(kind, list[i], "star")..".png"}, 0, 0,{
				other = {IMG_COMMON.."icon_border"..getBag(kind, list[i], "star")..".png", 45, 45},
				front = IMG_ICON..kind.."/S_"..getBag(kind, list[i], "look")..".png"
			})
			scroll:addChild(item:getLayer(), item)
		end
		scroll:alignCenter()
		self.contentLayer:addChild(scroll:getLayer())
	end
	
	--选择目标卡牌
	local choose = Btn:new(PATH, {"choose_card.png", "choose_card_pre.png"}, 20, 310, {
		callback = function()
			local list
			list = List:new({
				type = {"hero", "equip"},
				checkBoxOpt = function()
				end,
				okCallback = function()
					self.page = nil
					print(list:getSelectKind())
					self:createCardUp(list:getSelectKind(), list:getSelectId())
				end
				
			})
			self.layer:addChild(list:getLayer())
		end
	})
	self.contentLayer:addChild(choose:getLayer())
	
	--升级按钮
	local update = Btn:new(PATH, {"update.png", "update_pre.png"}, 250, 310, {
		callback = function()
		
		end
	})
	self.contentLayer:addChild(update:getLayer())
	
	--选择销毁卡牌
	local chooseItems = Btn:new(PATH, {"choose_item.png", "choose_item_pre.png"}, 20, 100, {
		callback = function()
--			if items.target then
				local data
				if self.page then
					data = self.page:getItems()
				end
				self:createSplit(items.target.type, {"ok.png", "ok_press.png"}, function()
					upItems(self.page:getItems())
					self.contentLayer:removeChild(self.page:getLayer(), true)
				end,data)
--			else
--				MsgBox.create():flashShow("请选择需要强化的卡牌！~")
--			end
		end
	})
	self.contentLayer:addChild(chooseItems:getLayer())
	
	--返回
	local back = Btn:new(PATH, {"back.png", "back_pre.png"}, 250, 100, {
		callback = function()
			switchScene("home")
		end
	})
	self.contentLayer:addChild(back:getLayer())
	
	
	local line = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(line, 0, 280)
	self.contentLayer:addChild(line)

	
	self.layer:addChild(self.contentLayer)
end


function UpdateLayer:createHeroUp(cid, data)
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer, true)
	end
	self.contentLayer = newLayer()
	local use = {
		{"魂魄白 x", DATA_User:get("soul_w"),data and data["condition"]["exp_w"] or ""},
		{"魂魄蓝 x", DATA_User:get("soul_b"),data and data["condition"]["exp_b"] or ""},
		{"魂魄金 x", DATA_User:get("soul_g"),data and data["condition"]["exp_g"] or ""},
	}
	
	for i = 1, #use do
		local t = newLabel(use[i][1]..use[i][2], 20, {x =  35 + 150 * (i - 1), y = 710}) 
		self.contentLayer:addChild(t)
	end
	
	local card = Card:new(10, 350, {
		type = "hero",
		cid = cid,
		callback = function()
			local list 
			list = List:new({
				type = "hero",
				checkBoxOpt = function()
					print(list:getSelectId())
				end,
				okCallback = function()
					HTTPS:send("Strong", {a = "hero", m = "strong", 
						strong = "hero_get", 
						id = getBag("hero", list:getSelectId(), "id") , 
						cid = list:getSelectId()},{
						success_callback = function(rec)
							self:createHeroUp(list:getSelectId(), rec)
						end}
					)
				end
			})	
			self.layer:addChild(list:getLayer(),2)
		end})
	self.contentLayer:addChild(card:getLayer())
	
	local info = {
		{"星级:", "star"},
		{"等级:", "lev"},
		{"攻击:", "att"},
		{"防御:", "defe"},
		{"血量:", "hp"},
	}
	local bg, text
	for i = 1, 5 do
		bg = newSprite(PATH.."text_bg.png")
		setAnchPos(bg, 280, 630 - 65 * (i - 1))
		self.contentLayer:addChild(bg)
		
		text = newLabel(info[i][1], 18, {x = 285, y = 645 - 65 * (i - 1)})
		self.contentLayer:addChild(text)
		
		if cid then
			text = newLabel(getBag("hero", cid, info[i][2]).." - "..data["strong"]["chan_"..info[i][2]], 18, {x = 395, y = 645 - 65 * (i - 1), ax = 0.5})
			self.contentLayer:addChild(text)
		end
	end
	
	bg = newSprite(PATH.."up_info.png")
	setAnchPos(bg, 240, 170, 0.5)
	self.contentLayer:addChild(bg)
	
	text = newLabel("升级条件", 25, {x = 240, y = 290, ax = 0.5})
	self.contentLayer:addChild(text)
	
	if cid then
		for i = 1, #use do
			text = newLabel(use[i][1]..use[i][3], 20, {x = 20 + (i - 1) * 150, y = 240})
			self.contentLayer:addChild(text)
		end
		
		text = newSprite(IMG_COMMON.."silver.png")
		setAnchPos(text, 190, 190)
		self.contentLayer:addChild(text)
		
		text = newLabel(data["condition"]["money"], 25, {x = 230, y = 185})
		self.contentLayer:addChild(text)
	end
	
	
	
	
	
	local upStar = Btn:new(PATH, {"up_star.png", "up_star_pre.png"}, 20, 95, {
		callback = function()	
			if cid then
				HTTPS:send("Strong", {a = "hero", m = "strong", strong = "upgrade", id = getBag("hero", cid, "id"), cid = cid}, {
					success_callback = function(rec)
						self:createHeroUp(cid, rec)
						MsgBox.create():flashShow("英雄提升星级成功！！！！！！~")
					end
				})
			end
		end
	})
	self.contentLayer:addChild(upStar:getLayer())
	
	--武将的分解方法
	local func 
	func = function()
		local data = {}
		for k, v in pairs(self.page:getItems()) do
			table.insert(data,{cid = k, id = getBag("hero", k, "id")})
		end
		HTTPS:send("Strong", {a = "hero", m="strong", strong = "resolve", data = data}, {
			success_callback = function()
				self:createSplit("hero",{"split.png", "split_press.png"}, func)
				MsgBox.create():flashShow("英雄分解成功，获得魂魄!!")
			end
		})
	end
	
	local split = Btn:new(PATH, {"split.png", "split_pre.png"}, 250, 95, {
		callback = function()
				self:createSplit("hero",{"split.png", "split_press.png"}, func)
		end
	})
	self.contentLayer:addChild(split:getLayer())
	
	self.layer:addChild(self.contentLayer, 1)
end

function UpdateLayer:getLayer()
	return self.layer
end

function UpdateLayer:createSplit(kind, btnImages, func, data)
		if self.page then
			self.contentLayer:removeChild(self.page:getLayer(), true)
		end
		self.page = Pages:new(0,0, {
			data = data,
			type = kind, 
			showOpt = { btnImages, func}}) 			
		self.contentLayer:addChild(self.page:getLayer())
end

return UpdateLayer
