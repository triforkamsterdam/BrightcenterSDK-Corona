module(..., package.seeall)

local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true
local widget = require( "widget" )
local scene = storyboard.newScene()


local brightcenterbutton


function test()
	brightcenterbutton.isVisible = false
	storyboard.gotoScene("BCLoginScene", {effect = "slideUp"})
end

local brightcenterBeforeSequence = test

function scene:createScene( event )
   local group = self.view
   if connector.username ~= nil then
   		print( "create screen!" .. connector.username )
   end

end
scene:addEventListener( "createScene", scene )

function scene:willEnterScene( event )
  	local group = self.view
  	display.setDefault( "background", 1);
   	brightcenterbutton = widget.newButton{
		label = "Brightcenter!",
		emboss = true,
		fontSize = 20,
		onRelease = brightcenterBeforeSequence,
		x = 300,
		y = 300
	}
 	print("will enter!")
end
scene:addEventListener( "willEnterScene", scene )

function scene:didExitScene( event )

end
scene:addEventListener( "didExitScene", scene )

return scene
