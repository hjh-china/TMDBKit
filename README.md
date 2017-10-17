# TMDBKit
The Movie Database API v3 wrapper in Swift

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
