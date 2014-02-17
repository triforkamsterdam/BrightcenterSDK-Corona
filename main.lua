studentName = display.newText("StudentName", display.contentCenterX, 120, native.systemFont, 16)
groupName = display.newText("GroupName", display.contentCenterX, 140, native.systemFont, 16)
resultLabel = display.newText("result", display.contentCenterX, 160, native.systemFont, 16)

local mime = require("mime")
local json = require("json")

local connector = require("brightcenterSDK")
local username = "test@test.com"
local password = "test"
local loaded = false
local assessmentId = "123-456-789"
local questionId = "1"

connector.setCredentials("test@test.com", "test")
print(connector.username)
print(connector.password)


function setLabelsCallback() 
	groupName.text =  connector.groups[2].name
	studentName.text = connector.groups[2].students[2].firstName .. " " .. connector.groups[2].students[2].lastName
	loaded = true
	local myFunction2 = setResultsCallback
	local studentId = connector.groups[1].students[1].personId
	studentName.text = studentId
	connector.loadResults("123-456-789", studentId, myFunction2)
end

function setResultsCallback()
	resultLabel.text = connector.results[1].score
	local studentId = connector.groups[1].students[1].personId
	print(connector.postResult("123-456-789", studentId, '1', 4, 10, "COMPLETED"))
end

local myFunction = setLabelsCallback
connector.loadGroups(myFunction)






