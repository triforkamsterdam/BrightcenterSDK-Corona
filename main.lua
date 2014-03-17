local bcScreens = require("brightcenterScreens")
local connector = require("brightcenterSDK")

local widget = require("widget")
local brightcenterBeforeSequence
local brightcenterbutton

local brightcenterBeforeSequence = function(event)
	print( "method" )
	brightcenterbutton.isVisible = false
	bcScreens.initScreens()
	display.setDefault( "background", 0);
end

local brightcenterAfterSequence = function()
	print(connector.selectedStudent)
	brightcenterbutton.isVisible = true
end

brightcenterbutton = widget.newButton
{
		label = "Brightcenter!",
		emboss = true,
		fontSize = 20,
		onRelease = brightcenterBeforeSequence,
		x = 300,
		y = 300
}

connector.functionAfterSequence = brightcenterAfterSequence;

