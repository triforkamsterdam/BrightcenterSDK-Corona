module(..., package.seeall)

local storyboard = require "storyboard"
local widget = require( "widget" )
local scene = storyboard.newScene()
storyboard.purgeOnSceneChange = true

local halfW = display.contentCenterX
local halfH = display.contentCenterY

local usernameField
local passwordField
local loginButton
local errorLabel

local userdetailsCallback = function()
	native.setActivityIndicator( false )
	if connector.userDetails ~= nil then
		local scene = storyboard.gotoScene("BCSelectScene", {effect = "slideLeft"})
	else
		errorLabel.isVisible = true
	end
	
end

function createCircles(viewGroup)
	local left = halfW + 100
	local circle1 = display.newCircle( left, halfH, 450 )
	circle1:setFillColor( 71/255, 71/255, 71/255 )

	local circle2 = display.newCircle( left, halfH, 350 )
	circle2:setFillColor( 79/255 )

	local circle3 = display.newCircle( left, halfH, 300 )
	circle3:setFillColor( 71/255, 71/255, 71/255 )

	local circle4 = display.newCircle( left, halfH, 175 )
	circle4:setFillColor( 79/255, 79/255, 79/255)

	viewGroup:insert( circle1 )
	viewGroup:insert( circle2 )
	viewGroup:insert( circle3 )
	viewGroup:insert( circle4 )
end

local login = function( event )
    native.setActivityIndicator( true )
	username = usernameField.text
	password = passwordField.text
	connector.setCredentials(username, password)
	connector.loadUserDetails(userdetailsCallback)
end

local closeScreen = function( event )
	storyboard.gotoScene( storyboard.getPrevious(), {effect = "slideDown"} )
end

function scene:willEnterScene( event )
	if connector.username ~= nil then
		print( storyboard.getPrevious())
		connector.returnScreen = storyboard.getPrevious()
		storyboard.gotoScene("BCSelectScene", {effect = "slideLeft"})
	else
		local group = self.view
	   	createCircles(group)
	   	connector.returnScreen = storyboard.getPrevious()
	   	display.setDefault( "background", 79/255);

	   	local titleBar = display.newRect(halfW, 80 * 0.5, display.contentWidth, 80 )
		titleBar:setFillColor(1)

		local bcLogo = display.newImage("brightcenter-logo.png")
		bcLogo.x = halfW * 0.5
		bcLogo.y = 40
		bcLogo.xScale = 0.5;
		bcLogo.yScale = 0.5;

		local closeButton = widget.newButton{
			emboss = true,
			onRelease = closeScreen,
			fontSize = 20,
			defaultFile = "closeButton.png",
			x = halfW * 1.75,
			y = 40
		}

		local errorText
		if system.getPreference("locale", "language") == "en" then
	   		usernameText = "Something went wrong with logging in, please try again!"
	   	else
	   		usernameText = "Er is iets misgegaan bij het inloggen, probeer opnieuw!"
	   	end	
	   	errorLabel = display.newText(usernameText, halfW, halfH * 0.7 - 40, native.systemFont, 20)
	   	errorLabel:setFillColor( 1,0,0 )
	   	errorLabel.isVisible = false

	   	local usernameText
	   	if system.getPreference("locale", "language") == "en" then
	   		usernameText = "Username"
	   	else
	   		usernameText = "Gebruikersnaam"
	   	end	
		usernameLabel = display.newText(usernameText, halfW - 100, halfH * 0.7, native.systemFont, 16)
		usernameField = native.newTextField( halfW, halfH * 0.7 + 30, 300, 30)
		usernameField.inputFontSize = 20
		usernameField.cornerRadius = 15

	   	local passwordText
	   	if system.getPreference("locale", "language") == "en" then
	   		passwordText = "Password"
	   	else
	   		passwordText = "Wachtwoord"
	   	end	
		passwordLabel = display.newText(passwordText, halfW - 100, halfH * 0.7 + 70, native.systemFont, 16)
		passwordField = native.newTextField( halfW, halfH * 0.7 + 100, 300, 30)
		passwordField.isSecure = "true"
		passwordField.inputFontSize = 20

	   	local buttonText
	   	if system.getPreference("locale", "language") == "en" then
	   		buttonText = "Login"
	   	else
	   		buttonText = "Inloggen"
	   	end	
		loginButton = widget.newButton
		{
			label = buttonText,
			emboss = true,
			labelColor = { default={1, 1, 1}, over={0, 0, 0}},
			onRelease = login,
			fontSize = 20,
			defaultFile = "button_default.png",
			overFile = "button_click.png",
			x = halfW,
			y = halfH * 0.7 + 170
		}

		group:insert( titleBar )
		group:insert( bcLogo )
		group:insert( closeButton )
		group:insert( errorLabel )
		group:insert( usernameLabel )
		group:insert( usernameField )
		group:insert( passwordLabel )
		group:insert( passwordField )
		group:insert( loginButton )
	end
end
scene:addEventListener( "willEnterScene", scene )

function scene:createScene( event )
	print( "in create login!" )
	if connector.username ~= nil then
		print( storyboard.getPrevious())
		connector.returnScreen = storyboard.getPrevious()
		storyboard.gotoScene("BCSelectScene", {effect = "slideLeft"})
	end
	
   	
end
scene:addEventListener( "createScene", scene )


return scene
