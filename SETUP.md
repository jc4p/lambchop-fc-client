# LambchopCast API Key Setup

This document provides instructions for setting up the Neynar API key securely in the LambchopCast app.

## Option 1: Environment Variables (Recommended for Development)

1. In Xcode, select the LambchopCast scheme
2. Go to Product > Scheme > Edit Scheme (or press ⌘<)
3. Select the "Run" action from the sidebar
4. Go to the "Arguments" tab
5. Under "Environment Variables", click the "+" button
6. Add a new environment variable:
   - Name: `NEYNAR_API_KEY`
   - Value: Your Neynar API key

This approach keeps your API key out of the source code, making it safer when sharing or publishing your code.

## Option 2: Config.swift (Less Secure, But Simpler)

If you're just testing locally and won't be sharing your code, you can modify `Config.swift`:

```swift
struct Config {
    // Replace this with your own Neynar API key
    static let apiKey = "YOUR_API_KEY_HERE"
}
```

⚠️ **WARNING**: Never commit your API key to a public repository if using this approach.

## Getting a Neynar API Key

1. Sign up at [neynar.com](https://neynar.com/)
2. Navigate to the API keys section in your dashboard
3. Create a new API key for use with this app

## Testing Without an API Key

The app includes a fallback API key for demonstration purposes, but it may be rate-limited or disabled in the future. It's recommended to obtain your own API key for regular use.