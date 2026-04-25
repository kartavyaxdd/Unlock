# MentalismApp

MentalismApp is a standalone iPhone mentalism product scaffold focused on a single legal routine: `Passcode Peek`.

The experience is designed for private/TestFlight distribution and uses voluntary spectator input inside the app, followed by a discreet performer-only spoken audio reveal.

The scaffold now targets `iOS 16.0+`, which fits an iPhone on iOS 16.7.

## What is included

- SwiftUI iPhone app source for onboarding, trick setup, spectator entry, and neutralized post-entry flow
- Shared Swift package, `MentalismCore`, for trick types, session state, reveal routing, and reset logic
- Unit and UI test scaffolding
- Privacy/compliance documentation
- `project.yml` for XcodeGen plus a workspace file
- a GitHub Actions workflow that can build an unsigned IPA on a macOS runner

## Important constraints

- No network code
- No analytics or third-party SDKs
- No real password interception
- No camera, microphone, location, NFC, or contact permissions
- Spectator secrets are intended to live in memory only during an active routine

## Generate the Xcode project on macOS

This repository was scaffolded from a Windows workspace without Xcode installed, so the checked-in project definition uses XcodeGen.

1. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen)
2. Run:

```bash
cd MentalismApp
xcodegen generate
open MentalismApp.xcworkspace
```

If your local setup prefers opening the project directly, you can open `MentalismApp.xcodeproj` after generation.

For first device testing, follow [Docs/RunOnIPhone.md](Docs/RunOnIPhone.md).
For the no-Mac route, follow [Docs/BuildWithoutMac.md](Docs/BuildWithoutMac.md).

## Structure

- `MentalismApp/`: iOS app code
- `Sources/MentalismCore/`: shared models and trick engine
- `Tests/`: shared package tests
- `MentalismAppTests/`: app unit tests
- `MentalismAppUITests/`: app UI tests
- `Docs/`: privacy policy and TestFlight positioning
- `scripts/`: helper scripts for Mac-based generation

## v1 routine

`Passcode Peek` allows the performer to:

1. choose a 4-digit or 6-digit routine
2. choose audio reveal
3. hand the phone to the spectator
4. let the spectator voluntarily enter a code into the app's own keypad
5. receive the secret discreetly via audio
6. immediately reset the session
