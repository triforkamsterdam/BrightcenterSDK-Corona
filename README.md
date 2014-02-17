BrightcenterSDK-Corona
=======================

Use this SDK to make it easy to communicate with the Brightcenter backend. 

### Download the project
To use this SDK you need to download this project. You could also just download the `brightcenterSDK.lua` file.
You'll need to include that file into your own project by just adding it to your project folder.

### Use the SDK
To use the sdk you need to include the following line of code:

```lua
local connector = require("brightcenterSDK")
```

Now connector is the object which lets you communicate with the Brightcenter backend. However, before you do anything else with the connector you should call:

```lua
connector.setCredentials([username], [password])
```
This method sets the credentials of the user that's using the app. If you don't make this call, the connector won't work.





### Get groups of a user
To get groups of a user you can use the following piece of code:
```lua
connector.loadGroups([callbackfunction])
```
Because Corona makes use of asynchronous network calls, you need to provide a function that serves as a callback. Otherwise your main program will keep executing and the groups will be `nil`. In the callback function you can do whatever you want with the groups that are retrieved from the server. An example:
```lua
-- this method sets a label to the name of the group
function myCallback
    myLabel.text = connector.groups[1].name
end

local callback = myCallback
connector.loadGroups(callback)
```

To retrieve a student from a group you can use the following(also, only use this in a callback function):
```lua
--retrieves the first student of the first group
connector.groups[1].students[1].personId --id of the student
connector.groups[1].students[1].firstName --firstname of the student
connector.groups[1].students[1].lastName --lastname of the student
```

### Get the results of a student
To get the results of a student you can use the following:
```lua
connector.loadResults([assessmentId], [studentId], [callbackfunction])
```

to acces the results you can use the following:
```lua
connector.results[1].score --the score
connector.results[1].questionId -- the id of the question
connector.results[1].attempts --the number of attempts
connector.results[1].duration --the duration in seconds
connector.results[1].completionStatus -- the completion, can either be "COMPLETED" or "INCOMPLETE"
```

Note that also these calls should be made in a callback function.

### Post the result of a student
To post a result of a student you can use the following function:
```lua
connector.postResult([assessmentId], [studentId], [questionId], [score], [duration], [completionStatus])
```
This method returns a string if something went wrong, so you can print the function for error checking.

-`assessmentId` should be a string
-`studentId` should be a string
-`questionId` should be a string
-`score` should be an integer
-`duration` should be the duration in seconds as an integer
-`completionStatus` should be either "COMPLETED" or "INCOMPLETE"

###Get the user details
To get the userdetails you can make the following call:
```lua
connector.loadUserDetails([userCallback])
```

to acces the userdetails you can do something like this:
```lua
connector.userDetails.username --the username of the user
connector.userDetails.firstName --the first name of the user
connector.userDetails.lastName --the last name of the user
```








