BrightcenterSDK-Corona
=======================

Use this SDK to make it easy to communicate with the Brightcenter backend. 

### Download the project
To use this SDK you need to download this project. You could also just download the `brightcenterSDK.lua` file and the `brightcenterScreens.lua` file.
You'll need to include that file into your own project by just adding it to your project folder.

### Use the SDK
To use the sdk you need to include the following line of code:

```lua
local connector = require("brightcenterSDK")
local bcScreens = require("brightcenterScreens")
```

Connector is the part which let's you make calls to the backend. with bcScreens you can show the Brightcenter loginscreens.
To do so you can make a function that calls `bcScreens.initScreens()`. That function should also hide all visible elements.
Before you call bcScreens.initScreens you MUST provide a callback function to the connector. this function is called when a student is selected.
you can make all your elements visible again in this function. Your code should look something like this:

```lua
connector.functionAfterSequence = FUNCTIONTHATYOUWANTTOLOAD;
```

`connector.selectedStudent` will now contain the id of the selected student. You will need this id to post or retrieve results from the server.





### Get groups of a user manually (not recommended)
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


###sidenotes
-To have internet acces on adroid use the following in `build.settings`:
```
settings =
{
   android =
   {
      usesPermissions =
      {
         "android.permission.INTERNET",
      },
   },
}
```

-for questions, create an issue with the issue tracker on https://tst-brightcenter.trifork.nl OR create an issue on github

-You can check main.lua for some examples. YOU SHOULD NOT INCLUDE THIS IN YOUR PROJECT





