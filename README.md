![](https://github.com/SR2k/TMDBKit/blob/master/Supporting/Logo.png)
# TMDBKit
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/SR2k/TMDBKit/blob/master/LICENSE)
[![codebeat badge](https://codebeat.co/badges/55e91f84-b824-4985-bf1a-b2f8cbe431b6)](https://codebeat.co/projects/github-com-sr2k-tmdbkit-master)
[![Travis CI](https://travis-ci.org/SR2k/TMDBKit.svg?branch=master)](https://travis-ci.org/SR2k/TMDBKit/)
![CocoaPods](https://img.shields.io/cocoapods/v/TMDBKit.svg)
![Platforms](https://img.shields.io/badge/platforms-iOS%2010+%20%7C%20macOS%2010.12+%20%7C%20tvOS%2010+%20%7C%20watchOS%203+-213b34.svg)

> **IMPORTANT:**<br>This framework is still under development. **DO NOT** use it... just yet 😂.<br>And if you are willing to help, feel free to creat pull requests.

The Movie Database API wrapper in Swift.

I'm just a very beginner to the Swift world. And I decide to take this project as my first step.
So, any issue and pull request are welcomed :-)

## Project progress

### v3 current progress:
|Section        |Build   |Test    |To-dos  |
|---------------|:------:|:------:|--------|
|Shared methods |☑️      |☑️      |        |
|Account        |☑️      |☑️      |        |
|Authentication |☑️      |☑️      |        |
|Certifications |☑️      |☑️      |        |
|Changes        |☑️      |☑️      |        |
|Collections    |☑️      |☑️      |        |
|Companies      |☑️      |☑️      |        |
|Configuration  |☑️      |☑️      |        |
|Credits        |☑️      |        |What are credits? <br>I wish I have take English class more seriously😂.|
|Discover       |☑️      |        |        |
|Find           |☑️      |        |        |
|Genres         |☑️      |☑️      |[Get movies by genre](https://developers.themoviedb.org/3/genres/get-movies-by-genre) API is deprecated.|
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

### Meet TMDBManager
Everything you need with TMDBKit is wrapped in the `TMDBManager` singleton instance, you can get a reference like this:
``` swift
import TMDBKit

let manager = TMDBManager.shared
```

### Setup the manager
In your AppDelegate's `applicationDidFinishLaunching` method:
``` swift
let manager = TMDBManager.shared
manager.setupClient(withApiKey: "Your-API-key", persistencePrefix: "com.yourTeamName.yourAppName")
```

### Get user authentication
First you need to fetch a request token by:
``` swift
let manager = TMDBManager.shared
manager.createRequestToken() { result in
    switch result {
    case .success:
        // Forward your user to the authentication page. For macOS:
        let redirectURL = "someURLScheme://somePath"
        if let authUrl = manager.authentication.authenticationURL(redirectURL: redirectURL) {
            NSWorkspace.shared.open(authUrl)
        }
    case .fail(let error):
        print(error.data?.toString(.utf8))
        print(error.error)
    }
}
```
And after the user authorizes the request token, fetch a session ID:
``` swift
let manager = TMDBManager.shared
manager.authentication.createSession() { result in
    switch result {
    case .success:
        print(Session ID Fetched: \(self.manager.sessionId!))
    case .fail(let error):
        print(error.data?.toString(.utf8))
        print(error.error)
    }
}
```
The session ID will be persisted in the keychain. For those methods that needs  user authentication,
TMDBKit will automatically add the persisted session ID for HTTP headers,
so usually you don't need to use it directly.

### Completion hanlders
Almost all TMDBKit methods needs a `completion` parameter. The handler will pass in a enum
by which you can check if the request has been fullfied. And to those methods that returns data,
the enum will carry a model object. It works like this:
``` swift
let manager = TMDBManager.shared
manager.account.getDetails() { result in
    // Check if the request has been fullfied
    switch result {
    
    // If success, you will recive a model object:
    case .success(let accountInfo):
        print(accountInfo)
        
    // If some error occurs:
    case .fail(let error):
        // You will get the raw data returned from TMDB server (and there's a extended helper method to get the string):
        print(error.data?.toString(.utf8))
        // Also an optional error describing the situation:
        print(error.error)
    }
}
```

## Need help?
All methods are equiped with full documentation comments. All you  need to do is *Option⌥ click* the method name.
Or switch to the *Quick Help Inspector*:
![](https://github.com/SR2k/TMDBKit/blob/master/Supporting/Documentation_Comments.png)

## License
TMDBKit is available under the MIT license. See the LICENSE file for more info.
