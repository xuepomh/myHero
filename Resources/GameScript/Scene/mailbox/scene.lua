--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local update = require(SRC.."Scene/mailbox/mailboxlayer")



local M = {}

function M:create(data)
	local scene = display.newScene("mailbox")

	---------------插入layer---------------------
	scene:addChild(update:new(data):getLayer())
	--scene:addChild(InfoLayer:create(true):getLayer())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
