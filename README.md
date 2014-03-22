BrightcenterSDK-Corona
=======================

Use this SDK to make it easy to communicate with the Brightcenter backend. 

### Download the project
To use this SDK you need to download this project. You'll need to include the files into your own project by just adding them to your project folder.

### Use the SDK
To use the sdk you need to include the following line of code:
```lua
connector = require("brightcenterSDK")
```
Connector is the part which let's you make calls to the backend. It is global so it can be accesed from all files.

To load the login screen you can call the following piece of code:
```lua
storyboard.gotoScene("BCLoginScene", {effect = "slideUp"})
```
It loads a new scene on the storybaord.
When a student is picked, `connector.selectedStudent` will contain the id of the student. You will need this id to post or retrieve results from the server.

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

to acces the userdetails you can do something like this:
```lua
connector.userDetails.username --the username of the user
connector.userDetails.firstName --the first name of the user
connector.userDetails.lastName --the last name of the user
```
Note that the user needs to be logged in to do this! otherwise userDetails will be `nil`


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





