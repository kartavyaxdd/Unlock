# Build Without a Mac

You do not have a local Mac, so the practical route is:

1. push this repo to GitHub
2. let GitHub Actions use a hosted macOS runner
3. download the generated unsigned IPA on Windows
4. try installing it with Sideloadly using your Apple ID

## What is already prepared

- `.github/workflows/build-unsigned-ipa.yml`
- `scripts/package_unsigned_ipa.sh`
- iOS deployment target lowered to `16.0`

## What you need to do

### 1. Put the repo on GitHub

Create a GitHub repository and upload the contents of `MentalismApp/`.

### 2. Run the workflow

- Open the GitHub repository
- Go to `Actions`
- Open `Build Unsigned IPA`
- Click `Run workflow`

If the build succeeds, GitHub will attach an artifact named `mentalismapp-unsigned-ipa`.

### 3. Download the artifact on Windows

Download:

- `MentalismApp-unsigned.ipa`

### 4. Install with Sideloadly

On Windows:

- connect the iPhone by cable
- unlock it and trust the computer
- open Sideloadly
- drag in `MentalismApp-unsigned.ipa`
- use your Apple ID in Sideloadly to sign/install

## Important note

This workflow intentionally builds an unsigned IPA. Sideloadly's site says it supports Apple ID sideloading and can sign apps during install. Based on that, this IPA is the best no-Mac artifact to try first.

If Sideloadly refuses the unsigned IPA, the next step will be cloud signing with Apple certificates and provisioning profiles, which requires Apple account credentials and signing material.

## Likely first failure points

- XcodeGen project-generation issue
- Swift compile issue on the macOS runner
- unsigned IPA rejected by Sideloadly

If any of those happens, send me the exact GitHub Actions log or Sideloadly error and I'll take the next pass.
