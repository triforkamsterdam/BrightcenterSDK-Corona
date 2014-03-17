module(..., package.seeall)

local mime = require("mime")
local json = require("json")
local widget = require( "widget" )

local connector = require("brightcenterSDK")
local username = ""
local password = ""
local loaded = false
local assessmentId = "123-456-789"
local questionId = "1"
local selectedGroup = 0

local halfW = display.contentCenterX
local halfH = display.contentCenterY

local widgetGroupLogin = display.newGroup();
local usernameText = ""
local usernameField = {}
local passwordText = ""
local passwordField = {}

local studentList
local groupList
local listWidget = display.newGroup()
local titleBarWidget = display.newGroup()

--
--
--STUDENT RENDER LIST 
--
--
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

-- Hande row touch events
local function onRowTouchStudent( event )
	local phase = event.phase
	local row = event.target
	if "release" == phase then
		connector.selectedStudent = connector.groups[selectedGroup].students[row.index].id
		cleanUp()
	end
end

local widgetGroupSelectStudent = display.newGroup()



--
--
--GROUP RENDER LIST 
--
--

local function onRowRenderGroup( event )
	local phase = event.phase
	local row = event.row
	local groupContentHeight = row.contentHeight
	print(groupContentHeight)
	local rowTitle = display.newText( row, connector.groups[row.index].name, 0, 0, native.systemFontBold, 30 )
	rowTitle.x = 20
	rowTitle.anchorX = 0
	rowTitle.y = groupContentHeight * 0.5
	rowTitle:setFillColor(175/255)
end

-- Hande row touch events
local function onRowTouchGroup( event )
	local phase = event.phase
	local row = event.target
	if "release" == phase then
		print( connector.groups[row.index].name)
		studentList:deleteAllRows()
		studentList.isVisible = true
		selectedGroup = row.index
		for i = 1, #connector.groups[row.index].students do
			studentList:insertRow{
				rowHeight = 60,
			}
		end
	end
end

function groupCallbackFunction()
	initTitlebar()
	titleBarWidget.isVisible = true
	listWidget.isVisible = true
	widgetGroupLogin.isVisible = false;
	usernameField.isVisible = false;
	passwordField.isVisible = false;
	for i = 1, #connector.groups do
		groupList:insertRow{
			rowHeight = 60,
			rowColor = { default={ 80/255 }, over={ 1, 113/255, 0 } },
			lineColor = { 80/255 }
		}
	end
	transition.to( groupList, { x = groupList.contentWidth * 0.5, time = 0, transition = easing.outExpo } )
	transition.to( studentList, { x = studentList.contentWidth, time = 0, transition = easing.outExpo } )
	studentList.isVisible = true;
	groupList.isVisible = true;
end

local groupCallback = groupCallbackFunction;

local login = function( event )
	username = usernameField.text
	password = passwordField.text
	connector.setCredentials(username, password)
	connector.loadGroups(groupCallback)
end


function initLists()

	studentList = widget.newTableView
	{
		top = 160,
		left = (halfW * 2) * 2/3,
		width = (halfW * 2) * 2/3, 
		height = halfH * 2,
		onRowRender = onRowRenderStudent,
		onRowTouch = onRowTouchStudent,
	}
	studentList.isVisible = false;
	listWidget:insert(studentList)

	groupList = widget.newTableView
	{
		top = 160,
		left = (halfW * 2) / 3,
		width = (halfW * 2) / 3, 
		height = halfH * 2,
		backgroundColor = {80/255},
		isBounceEnabled = false,
		onRowRender = onRowRenderGroup,
		onRowTouch = onRowTouchGroup,
	}
	groupList.isVisible = false;
	listWidget:insert(groupList)
	listWidget.isVisible = false;
end

function initLoginForm()
	print("init login form")
	usernameText = display.newText("Username", halfW - 100, 300, native.systemFont, 16)
	usernameField = native.newTextField( halfW, 330, 300, 30)
	usernameField.inputFontSize = 20
	widgetGroupLogin:insert(usernameText)
	widgetGroupLogin:insert(usernameField)

	passwordText = display.newText("Password", halfW - 100, 370, native.systemFont, 16)
	passwordField = native.newTextField( halfW, 400, 300, 30)
	passwordField.isSecure = "true"
	passwordField.inputFontSize = 20
	widgetGroupLogin:insert(passwordText)
	widgetGroupLogin:insert(passwordField)

	local loginButton = widget.newButton
	{
		label = "Login",
		emboss = true,
		onRelease = login,
		fontSize = 20,
		x = halfW,
		y = halfH
	}

	widgetGroupLogin:insert(loginButton)
	widgetGroupLogin.isVisible = true
end


function initTitlebar()
	local titleBar = display.newRect(halfW, 80 * 0.5, display.contentWidth, 80 )
	titleBar:setFillColor(1)
	titleBarWidget:insert(titleBar)

	local bcLogo = display.newImage("brightcenter-logo.png")
	bcLogo.x = 150
	bcLogo.y = 40
	titleBarWidget:insert(bcLogo)

	local groupBar = display.newRect(halfW / 3, 80 * 1.5, display.contentWidth * 1/3, 80 )
	groupBar:setFillColor(136/255)
	local groupText = display.newText{
		text = "Groups",
		x = (display.contentWidth / 6) ,	
		y = 120,
		fontSize = 36,
		parentGroup = groupBar
	}
	groupText:setFillColor(217/255)
	titleBarWidget:insert(groupBar)
	titleBarWidget:insert(groupText)

	local studentBar = display.newRect((halfW * 2) * 2/3, 80 * 1.5, (display.contentWidth * 2/3), 80 )
	studentBar:setFillColor(214/255)
	local studentText = display.newText{
		text = "Students",
		x = (display.contentWidth / 2) ,	
		y = 120,
		fontSize = 36,
		parentGroup = groupBar
	}
	studentText:setFillColor(67/255)
	titleBarWidget:insert(studentBar)
	titleBarWidget:insert(studentText)
	titleBarWidget.isVisible = true;
end


function cleanUp()
	connector.functionAfterSequence()
	listWidget.isVisible = false;
	titleBarWidget.isVisible = false;
	widgetGroupLogin.isVisible = false;
	connector.groups = {}
	connector.results = {}
	connector.username = {}
	connector.password = {}
end

function initScreens()
	display.setDefault( "background", 79/255);
	initLoginForm()
	initLists()
	display.setStatusBar( display.HiddenStatusBar );
end
