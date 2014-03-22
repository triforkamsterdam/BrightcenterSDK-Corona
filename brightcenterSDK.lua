module(..., package.seeall)

local mime = require("mime")
local json = require("json")
--local URL = "https://tst-brightcenter.trifork.nl/api/"
local URL = "http://localhost:8080/api/"
userDetails = nil
groups = {}
results = {}
username = nil
password = nil
selectedStudent = {}
returnScreen = {}

--[[
Sets the credentials of the loggedin user
--]]
function setCredentials(newUsername, newPassword)
	username = newUsername
	password = newPassword
end

--[[
Loads the user details of the loggedin user
--]]
function loadUserDetails(customCallback)
	function networkListenerGetUserDetails(event)
		print( "loading user details!" )
		if ( event.status == 401 ) then
			print "something went wrong with fetching the userDetails"
		else
			local string = json.decode(event.response)
			userDetails = string
		end
		customCallback()
	end
	local headers = {}
	print(username)
	print(password)
	headers["Authorization"] = "Basic " .. mime.b64(username .. ":" .. password)
	local params = {}
	params.headers = headers
	network.request( URL .. "userDetails", "GET", networkListenerGetUserDetails, params)
end


--[[
loads the groups and puts them in a global variable called groups
--]]
function loadGroups(customCallbackSucces)
	function networkListenerGetGroups(event)
		if ( event.status == 401 ) then
			print "something went wrong with fetching the groups"
		else
			local string = json.decode(event.response)
			groups = string
			customCallbackSucces()
		end
	end
	local headers = {}
	headers["Authorization"] = "Basic " .. mime.b64(username .. ":" .. password)
	local params = {}
	params.headers = headers
	network.request( URL .. "groups", "GET", networkListenerGetGroups, params)
end

--[[
Loads the results of a student for an assessment and puts them in a global variable called results
--]]
function loadResults(assessmentId, studentId, customCallback)
	--callback: gets the results and puts them in a variable. makes a callback to the given function
	function networkListenerGetResults(event)
		if ( event.isError ) then
			print "something went wrong with fetching the results"
		else
			local string = json.decode(event.response)
			results = string
			customCallback()
		end
	end
	--set the headers
	local headers = {}
	headers["Authorization"] = "Basic " .. mime.b64(username .. ":" .. password)

	--set the params
	local params = {}
	params.headers = headers

	--network call
	local resultUrl = URL .. "assessment/" .. assessmentId .. "/students/" .. studentId .. "/assessmentItemResult"
	network.request( resultUrl, "GET", networkListenerGetResults, params)
end

function postResult(assessmentId, studentId, questionId, score, duration, completionStatus)
	--Check if values are initialised
	if(score == nil) then
		return "error: value score cannot be nil"
	end
	if(duration == nil) then
		return "error: value duration cannot be nil"
	end
	if (completionStatus == nil) then
		return "error: value completionStatus cannot be nil"
	end
	if(assessmentId == nil) then
		return "error: value assessmentId cannot be nil"
	end
	if(studentId == nil) then
		return "error: value studentId cannot be nil"
	end
	if (questionId == nil) then
		return "error: value questionId cannot be nil"
	end

	--callback: print response, only prints when there is a error
	function networkLisenerPostResult(event)
		print(event.response)
	end

	--set the right headers
	local headers = {}
	headers["Authorization"] = "Basic " .. mime.b64(username .. ":" .. password)
	headers["Content-Type"] = "application/json"

	--set the params
	local params = {}
	params.headers = headers

	--encode values to json
	local jsonTable = {}
	jsonTable["score"] = score
	jsonTable["duration"] = duration
	jsonTable["completionStatus"] = completionStatus
	local encodedTable = json.encode(jsonTable)
	params.body = encodedTable

	--network call
	local resultUrl = URL .. "assessment/" .. assessmentId .. "/student/" .. studentId .. "/assessmentItemResult/" .. questionId
	network.request( resultUrl, "POST", networkLisenerPostResult, params)
end



