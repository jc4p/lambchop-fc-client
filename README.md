# LambchopCast

A SwiftUI app that displays Lambchop's Farcaster channel using the Neynar API.

## Features

- View posts from Lambchop's Farcaster channel
- Infinite scrolling for loading more content
- Display of images, videos, and text posts
- Pull-to-refresh functionality
- Engagement metrics (likes, recasts, replies)

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository
2. Open `LambchopCast.xcodeproj` in Xcode
3. Build and run the app on your simulator or device

## API Key Security

The app is configured to use an environment variable for the Neynar API key. To set it up securely:

1. Edit your scheme in Xcode (Product > Scheme > Edit Scheme)
2. Select "Run" in the sidebar
3. Go to the "Arguments" tab
4. Under "Environment Variables", add a variable named `NEYNAR_API_KEY` with your API key as the value

Alternatively, for development, you can modify `Config.swift` to use your API key directly, but **remember to remove it before committing** to a public repository.

## Architecture

The app uses:
- SwiftUI for the UI
- SwiftData for data modeling
- MVVM architecture with a ViewModel that manages API requests and data processing
- Async/await for network requests

## Credits

This app uses the [Neynar API](https://neynar.com/) to fetch data from Farcaster.

## License

MIT License