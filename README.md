![](https://github.com/SR2k/TMDBKit/blob/master/Supporting/Logo.svg)
# TMDBKit
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/SR2k/TMDBKit/blob/master/LICENSE)
[![codebeat badge](https://codebeat.co/badges/4370eef5-bf1b-4b46-82a6-587278edd73a)](https://codebeat.co/projects/github-com-sr2k-tmdbkit-master)
[![](https://travis-ci.org/SR2k/TMDBKit.svg?branch=master)](https://travis-ci.org/SR2k/TMDBKit/)

**This framework is still under development. DO NOT use it... just yet 😂.**

The Movie Database API wrapper in Swift.

I'm just a very beginner to the Swift world. And I decide to take this project as my first step. So all issues and pull requests are welcomed :-)

## Project progress

### v3 current progress:
|Section        |Build   |Test    |To-dos  |
|---------------|:------:|:------:|--------|
|Shared methods |☑️      |☑️      |        |
|Account        |☑️      |☑️      |        |
|Authentication |☑️      |☑️      |        |
|Certifications |☑️      |👊        |        |
|Changes        |☑️      |        |        |
|Collections    |☑️      |        |        |
|Companies      |☑️      |        |        |
|Configuration  |☑️      |        |        |
|Credits        |☑️      |        |What is credits? <br>I wish I have take English class more seriously😂.|
|Discover       |☑️      |        |        |
|Find           |☑️      |        |        |
|Genres         |☑️      |        |        |
|Guest Sessions |☑️      |        |        |
|Jobs           |☑️      |        |        |
|Keywords       |☑️      |        |        |
|Lists          |☑️      |        |        |
|Movies         |☑️      |        |Cresits model. <br>Append to response support.|
|Networks       |☑️      |        |        |
|People         |☑️      |        |Append to response support.|
|Reviews        |☑️      |        |Append to response support.|
|Search         |☑️      |        |Multi search.|
|Timezones      |☑️      |        |        |
|TV             |☑️      |        |Append to response support. <br>Changes model.|
|TV Seasons     |☑️      |        |Append to response support. <br>Changes model.|
|TV Episodes    |☑️      |        |Append to response support. <br>Changes model.|
|Cleaning job   |☑️      |        |        |

### v4 current progress:
Will begin soon.

## Usage
### Installation
With CocoaPods:
``` ruby
use_frameworks!

target 'TMDBKitDemo' do
    platform :osx, '10.12'
    pod 'TMDBKit'
end
```
Or simply drag all `.swift` files in `Common` folder to your project (please note that TMDBKit needs SwiftyJSON as dependency).

### Setup the TMDBManager
In your AppDelegate's `applicationDidFinishLaunching` method:
``` swift
TMDBManager.shared.setupClient(withApiKey: "Your-API-key",
                               persistencePrefix: "com.yourTeamName.yourAppName")
```

### Get user authentication
First you need to fetch a request token by:
``` swift
TMDBManager.shared.createRequestToken() { result in
    switch result {
    case .success:
        // Forward your user to the authentication page. For macOS:
        let redirectURL = "yourAppURLScheme://auth_done"
        NSWorkspace.shared.open(TMDBManager.shared.authentication.authenticationURL(redirectURL: redirectURL)!)
    case .fail(let error):
        print(error)
    }
}
```
And after the user authorizes the request token, fetch a session ID:
``` swift
TMDBManager.shared.authentication.createSession() { result in
    switch result {
    case .success:
        print(Session ID Fetched: \(TMDBManager.shared.sessionId!))
    case .fail(let error):
        print(error)
    }
}
```
The session ID will be persisted in the keychain.

### Completion hanlders
Almost all TMDBKit methods needs a `completion` parameter. To those methods that returns data, the handler will pass in a enum by which you can check if the request has been fullfied. It works like this:
``` swift
TMDBManager.shared.account.getDetails() { result in
    // Check if the request has been fullfied
    switch result {
    
    // If success, you will recive a model object
    case .success(let accountInfo):
        print(accountInfo)
        
    // Otherwise, you will get an optional error
    case .fail(let error):
        print(error)
    }
}
```

## Need help?
All methods are equiped with full documentation comments. All you  need to do is hold your Option⌥ key and click the method name. Or switch to Quick Help Inspector:
![](https://github.com/SR2k/TMDBKit/blob/master/Supporting/Documentation_Comments.png)

## License
TMDBKit is available under the MIT license. See the LICENSE file for more info.

License for open source projects invoked can be found under [/Common/OpenSource/ folder](https://github.com/SR2k/TMDBKit/tree/master/Common/OpenSource)
