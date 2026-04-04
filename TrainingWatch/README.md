# Training Watch App

Apple Watch companion app for Personal Training.

## Setup

1. Open Xcode
2. Create new project: **watchOS → App**
3. Product Name: `TrainingWatch`
4. Team: Your Apple ID (free)
5. Bundle Identifier: `com.yourname.trainingwatch`
6. Interface: **SwiftUI**
7. Language: **Swift**

## After creating the project

Replace the generated files with these source files:

```
TrainingWatch/
├── TrainingWatchApp.swift
├── Models/
│   └── WorkoutProgram.swift
├── Services/
│   ├── SupabaseClient.swift
│   └── AuthManager.swift
├── Helpers/
│   └── KeychainHelper.swift
└── Views/
    ├── LoginView.swift
    ├── ProgramListView.swift
    └── ProgramDetailView.swift
```

## Build & Run

1. Connect Apple Watch via iPhone
2. Select your Watch as target device in Xcode
3. Press ⌘+R (Run)
4. App installs on Watch (~30 seconds)

## Re-install (every 7 days with free account)

1. Open Xcode
2. Press ⌘+R
3. Done (~30 seconds)

## Features

- View active workout programs
- See exercises with sets/reps/weight
- Check off completed exercises (syncs with web app)
- Timer for rest periods
- Haptic feedback on completion
