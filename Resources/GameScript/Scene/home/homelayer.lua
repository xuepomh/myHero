
HomeLayer= {
}
function HomeLayer:create(x,y)
	local this={}
	setmetatable(this,self)
	self.__index = self

	local layer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.png")
	layer:addChild(bg)
	layer:setPosition(ccp(x,y))

--
--	--[[其他功能按钮，阵容，行囊，融合，强化，英雄，历练]]
--
--	local main_bt = {{IMG_TEXT.."lineup.png","lineup",20,400,
--						function()
--							HTTPS:send("Battle" , 
--							 {
--							 	m="Battle",
--							 	a="Battle",
--							 	Battle = "select_up",
--							 } ,{success_callback = 
--								function()
--									switchScene("lineup")
--								end})
--						end},
--					  {IMG_TEXT.."luggage.png","Luggage",20,300,
--					  function()
--						  switchScene("bag")
--					  end},
--					  {IMG_TEXT.."merge.png","Merge",20,200},
--					  {IMG_TEXT.."strengthen.png","Strengthen",255,400},
--					  {IMG_TEXT.."hero.png","Hero",255,300},
--					  {IMG_TEXT.."experience.png","Experience",255,200,
--					  	function()
--                           HTTPS:send("Fighting",
--                           	{
--                           		m = "Fighting",
--                           		a = "fight",
--                           		Fighting = "start",
--                           		bHurdle = 530001,
--                           		sHurdle = 540001,
--                           	},{success_callback = 
--                           	function()
--					  			switchScene("fighting")
--					  			print("战斗开始")
--					  		end})
--					  	end}}
--
--	--local group = RadioGroup:new()
--	local temp
--	for i ,v in pairs(main_bt) do
--	    temp = Btn:new(IMG_BTN,{"btn_bg.png","btn_bg_press.png"},v[3],v[4],
--	    		{
--	    			front = v[1],
--	    			highLight = true,
--	    			scale = true,
--					--selectable = true,
--	    			callback= v[5]
--	    		 }, group)
--	    if i == 1 then
--	    	--group:chooseBtn(temp)
--	    end
--		layer:addChild(temp:getLayer())
--	end

	local main_small = {
	 	{"luggage",20,
		 	function()
			 	switchScene("bag")
		 	end
	 	},
    	{"exp",110},
	    {"travel",200},
	    {"conquer",290},
	    {"strengthen",380}
	}

	--local group = RadioGroup:new()

	for i ,v in pairs(main_small) do
	    local temps = Btn:new(IMG_BTN,{v[1].."_normal.png", v[1].."_press.png"},v[2],100, {
		   	callback = v[3]})
    	layer:addChild(temps:getLayer())
	end

    return layer
end