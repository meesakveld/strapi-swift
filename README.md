# StrapiSwift

StrapiSwift is a Swift package that provides a simple and easy way to interact with Strapi APIs. It is built on top of the `URLRequest` and `Codable` protocols to provide a seamless experience for developers. StrapiSwift is designed to work with Strapi APIs that are built with the default REST API plugin.

## Table of Contents
- [StrapiSwift](#strapiswift)
  - [Table of Contents](#table-of-contents)
  - [Configuration](#configuration)
    - [Setup](#setup)
    - [Use a replacing token once](#use-a-replacing-token-once)
  - [Content Manager](#content-manager)
  - [Authentication Local Provider](#authentication-local-provider)
  - [Media Library](#media-library)

## Configuration
To configure StrapiSwift, you need to provide the base URL of your Strapi API and the authentication token (if needed).

### Setup

```swift
import SwiftUI
import StrapiSwift

@main
struct SomeNameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // —— Configure StrapiSwift ——
        Strapi.configure(
            baseURL: "https://your-strapi-url.com",
            token: "some-api-token"
        )
        
        return true
    }

}
```

The configuration can always be overwritten, to for example use a jwt token after logging in.

### Use a replacing token once

After making an request with the token, the one time use token will be replaced with the original configured token.

```swift
Strapi.useTokenOnce(token: login.jwt)
```

<br>

## Content Manager
*Filter, sort, populate, fields, pagination, locale and status parameters are supported.*
- ### GET requests

    ```swift
    // Get all documents
    try await Strapi.contentManager.collection("gifts").getDocuments(as: [Gift].self)

    // Get a single document
    try await Strapi.contentManager.collection("gifts").withDocumentId("a4fsdnjsdf42dsfd").getDocument(as: Gift.self)
    ```

- ### POST requests

    ```swift
    let data = StrapiRequestBody([
        "invitedUserEmail": .string(email),
        "event": .string(eventDocumentId)
    ])

    try await Strapi.contentManager.collection("event-invites").postData(data, as: EventInvite.self)
    ```

- ### PUT requests

    ```swift
    let data = StrapiRequestBody([
        "status": .string("accepted")
    ])

    try await Strapi.contentManager.collection("event-invites").withDocumentId("a4fsdnjsdf42dsfd").putData(data, as: EventInvite.self)
    ```


- ### DELETE requests

    ```swift
    try await Strapi.contentManager.collection("event-invites").withDocumentId("a4fsdnjsdf42dsfd").delete()
    ```

<br>

## Authentication Local Provider
- ### Register: a new user

    ```swift
    try await Strapi.authentication.local.register(username: "michaelscott", email: "michaelscott@dundermifflin.com", password: "password", as: User.self)
    ```

- ### Login: an existing user

    ```swift
    try await Strapi.authentication.local.login(identifier: "michaelscott", password: "password", as: User.self)
    ```

- ### Update Profile: for a user

    ```swift
    let data: StrapiRequestBody = StrapiRequestBody([
        "firstname": .string("Michael"),
        "lastname": .string("Scott"),
    ])
    
    try await Strapi.authentication.local.updateProfile(data, userId: 1, as: User.self)
    ```

- ### Me: to get the current user (with option add an extended url)

    ```swift
    // Get the current user
    try await Strapi.authentication.local.me(as: User.self)

    // Me with an extended url for custom endpoints
    let data: StrapiRequestBody = StrapiRequestBody([
        "deviceToken": .string("dfsdg53gdfg532GFD6fgds")
    ])

    try await Strapi.authentication.local.me(extendUrl: "/device-token", requestType: .PUT, data: data, as: User.self)
    ```

- ### Change Password: for a user

    ```swift
    try await Strapi.authentication.local.changePassword(currentPassword: "currentPassword", newPassword: "newPassword", as: User.self)
    ```

<br>

## Media Library
- ### Get All Files: in the media library

    ```swift
    try await Strapi.mediaLibrary.files.getFiles(as: [StrapiImage].self)
    ```

- ### Get File: by ID

    ```swift
    try await Strapi.mediaLibrary.files.withId(1).getFile(as: StrapiImage.self)
    ```

- ### Upload Image: to the media library (via `UIImage` or `URL`)

    ```swift
    // Upload image from UIImage
    try await Strapi.mediaLibrary.files.uploadImage(image: image)

    // Upload image from URL
    try await Strapi.mediaLibrary.files.uploadImage(from: "https://picsum.photos/200/300")
    ```

- ### Delete File: by ID

    ```swift
    try await Strapi.mediaLibrary.files.withId(1).delete(as: StrapiImage.self)
    ```