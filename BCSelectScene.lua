module(..., package.seeall)

local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true
local widget = require( "widget" )
local scene = storyboard.newScene()

local halfW = display.contentCenterX
local halfH = display.contentCenterY

local logout = function ( event )
	connector.username = nil
	connector.password = nil
	connector.userDetails = nil
	storyboard.gotoScene(connector.returnScreen)
end

function initTitlebar(viewGroup)
	local titleBar = display.newRect(halfW, 80 * 0.5, display.contentWidth, 80 )
	titleBar:setFillColor(1)

	local bcLogo = display.newImage("brightcenter-logo.png")
		bcLogo.x = halfW * 0.5
		bcLogo.y = 40
		bcLogo.xScale = 0.5;
		bcLogo.yScale = 0.5;

	local logoutButton = widget.newButton{
			emboss = true,
			onRelease = logout,
			fontSize = 20,
			defaultFile = "closeButton.png",
			x = halfW * 1.75,
			y = 40
	}

	local groupBar = display.newRect(halfW / 3, 80 * 1.5, display.contentWidth * 1/3, 80 )
	groupBar:setFillColor(136/255)
	local groupText
	if system.getPreference("locale", "language") == "en" then
   		groupText = "Groups"
   	else
   		groupText = "Groepen"
   	end	
	local groupLabel = display.newText{
		text = groupText,
		x = (display.contentWidth / 6) ,	
		y = 120,
		fontSize = 36,
		parentGroup = groupBar
	}
	groupLabel:setFillColor(217/255)

	local studentBar = display.newRect((halfW * 2) * 2/3, 80 * 1.5, (display.contentWidth * 2/3), 80 )
	studentBar:setFillColor(214/255)


	local studentText
	if system.getPreference("locale", "language") == "en" then
   		studentText = "Students"
   	else
   		studentText = "Leerlingen"
   	end	
	local studentLabel = display.newText{
		text = studentText,
		x = (display.contentWidth / 2) ,	
		y = 120,
		fontSize = 36,
		parentGroup = groupBar
	}
	studentLabel:setFillColor(67/255)

	viewGroup:insert(titleBar)
	viewGroup:insert(bcLogo)
	viewGroup:insert(logoutButton)
	viewGroup:insert(groupBar)
	viewGroup:insert(groupLabel)
	viewGroup:insert(studentBar)
	viewGroup:insert(studentLabel)

end

local function onRowRenderStudent( event )
	local phase = event.phase
	local row = event.row
	local groupContentHeight = row.contentHeight
	local firstName = connector.groups[selectedGroup].students[row.index].firstName
	local lastName = connector.groups[selectedGroup].students[row.index].lastName
	local rowTitle = display.newText( row, firstName .. " " .. lastName, 0, 0, native.systemFontBold, 30 )
	rowTitle.x = 20
	rowTitle.anchorX = 0
	rowTitle.y = groupContentHeight * 0.5
	rowTitle:setFillColor(125/255)
end

local function onRowTouchStudent( event )
	local phase = event.phase
	local row = event.target
	if "release" == phase then
		connector.selectedStudent = connector.groups[selectedGroup].students[row.index].id
		storyboard.gotoScene(connector.returnScreen)
	end
end

local function onRowRenderGroup( event )
	local phase = event.phase
	local row = event.row
	local groupContentHeight = row.contentHeight
	local rowTitle = display.newText( row, connector.groups[row.index].name, 0, 0, native.systemFontBold, 30 )
	rowTitle.x = 20
	rowTitle.anchorX = 0
	rowTitle.y = groupContentHeight * 0.5
	rowTitle:setFillColor(175/255)
end

local function onRowTouchGroup( event )
	local phase = event.phase
	local row = event.target

	if "release" == phase then
		for i = 1, groupList:getNumRows() do
	        local tmpRow = groupList:getRowAtIndex(i)
	       	tmpRow:setRowColor{
	       		default = { 80/255 },
	    		over = { 1, 113/255, 0 }
	       	}
		end
    	row:setRowColor{
		   	default = { 1, 113/255, 0 },
		   	over = { 1, 113/255, 0 }
	    }
		studentList:deleteAllRows()
		selectedGroup = row.index
		for i = 1, #connector.groups[row.index].students do
			studentList:insertRow{
				rowHeight = 60,
			}
		end
	end
end

function initLists(viewGroup)
	studentList = widget.newTableView
	{
		top = 160,
		left = (halfW * 2) * 1/3,
		width = (halfW * 2) * 2/3, 
		height = (halfH * 2) - 160,
		onRowRender = onRowRenderStudent,
		onRowTouch = onRowTouchStudent,
	}

	groupList = widget.newTableView
	{
		top = 160,
		left = 0,
		width = (halfW * 2) / 3, 
		height = (halfH * 2) - 160,
		backgroundColor = {80/255},
		onRowRender = onRowRenderGroup,
		onRowTouch = onRowTouchGroup,
	}
	viewGroup:insert( studentList )
	viewGroup:insert( groupList )
end

function groupCallbackFunction()
	for i = 1, #connector.groups do
		groupList:insertRow{
			rowHeight = 60,
			rowColor = { default={ 80/255 }, over={ 1, 113/255, 0 }},
			lineColor = { 80/255 }
		}
	end
	studentList.isVisible = true;
	groupList.isVisible = true;
	native.setActivityIndicator( false )
end

local groupCallback = groupCallbackFunction;


function scene:createScene( event )
	local group = self.view
	native.setActivityIndicator( true )
	initTitlebar(group)
	initLists(group)
	connector.loadGroups(groupCallback)
end
scene:addEventListener( "createScene", scene )

return scene