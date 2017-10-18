# TMDBKit
The Movie Database API v3 wrapper in Swift 4.

I'm just a very beginner to the Swift world. And I decide to take this project as my first step.

All issues and pull requests are welcomed :-)

# Usage
First `import TMDBKit`, and in your `AppDelegate`'s `application(application:, didFinishLaunchingWithOptions launchOptions:)`:
```swift
TMDBManager.shared.setupClient(withApiKey: "Your API Key", keyChainPrefix: "Your bundle identifier")
```

## Get authentication
First create a new request token and forward your user to the authentication URL:
```swift
// Create a new request token
TMDBManager.shared.createRequestToken() { result in
  switch result {
  case .success:
    guard 
      let redirectURL = URL(string: "Your redirect url"),
      let authURL = TMDBManager.shared.authenticationURL(redirectURL: redirectURL) 
    else { return }
    // Forward your user to the authentication URL
    let TMDBAuth = SFSafariViewController(URL: authURL)
    TMDBAuth.delegate = self
    self.presentViewController(TMDBAuth, animated: true, completion: nil)
  case .fail(let error):
    print(error)
  }
}
```
After your user approves your request token, create a seesion ID:
```swift
TMDBManager.shared.createRequestToken() { result
  switch result {
  case .success:
    // Do something...
  case .fail(let error):
    print(error)
  }
}
```

## License
TMDBKit is available under the MIT license. See the LICENSE file for more info.

License for open source projects invoked can be found under `/Common/OpenSource/` folder
