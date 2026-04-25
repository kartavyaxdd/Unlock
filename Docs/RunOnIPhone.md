# Run On iPhone

Use this checklist once you move the repo onto a Mac with Xcode installed.

## 1. Open the project

```bash
cd MentalismApp
xcodegen generate
open MentalismApp.xcworkspace
```

## 2. Connect your iPhone

- Plug the iPhone into the Mac with a cable
- Unlock the iPhone and tap `Trust This Computer` if prompted
- In Xcode, wait for the device to appear in the run destination list
- If Developer Mode is required on the iPhone, enable it and reconnect

## 3. Set signing

- Select the `MentalismApp` target
- Open `Signing & Capabilities`
- Choose your Apple Team
- Replace the default bundle identifier with your own unique value

## 4. First build target

- Pick your connected iPhone as the run destination
- Build once with `Product > Build`
- Then run with `Product > Run`

## 5. First things to verify

- Onboarding appears on first launch
- `Start Spectator Mode` opens the keypad screen
- Entering 4 digits or 6 digits transitions to the neutralized screen
- `Reset for Next Performance` clears the routine
- Backgrounding the app during an active routine hides sensitive state

## 6. Audio testing

- Connect wired headphones or AirPods before testing reveals
- Confirm the spoken digits are understandable and discreet
- If audio routes incorrectly, check iPhone Control Center and the active playback output
