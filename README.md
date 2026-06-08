# FieldFlow

FieldFlow is an iOS portfolio app for field operations workflows. It focuses on a practical mobile client architecture for task-like business records called WorkItems.

The current app runs with local mock data and demonstrates a SwiftUI WorkItem list, domain modeling, repository abstraction, dependency injection, and basic unit tests.

## Concept

Mobile business apps often need to keep working when network conditions are unstable. FieldFlow is designed around that problem space: clear local state, readable sync status, and an architecture that can grow into offline-first data handling.

## Features

- WorkItem list with mock business data
- Search by title or detail
- Status filter
- Priority, assignee, and sync status display
- SwiftUI preview support
- Unit tests for repository and view model behavior

## Tech Stack

- Swift 6
- SwiftUI
- Swift Concurrency
- XCTest
- Xcode project
- iOS 17+

## Architecture

Current structure:

```text
App
→ DependencyContainer
→ AppRouter
→ WorkItemListView
→ WorkItemListViewModel
→ WorkItemRepository
→ MockWorkItemRepository
```

Planned direction:

```text
View
→ ViewModel
→ UseCase
→ Repository
→ LocalStore / APIClient
```

The domain layer does not depend on SwiftUI, URLSession, or persistence frameworks. This keeps the core models and repository contracts easy to test and replace.

## Setup

Requirements:

- Xcode 26.4.1 or later
- iOS Simulator
- iOS 17.0 or later

Build:

```bash
xcodebuild build \
  -project FieldFlow.xcodeproj \
  -scheme FieldFlow \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator'
```

Test:

```bash
xcodebuild test \
  -project FieldFlow.xcodeproj \
  -scheme FieldFlow \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

If `iPhone 17` is not available locally, replace it with any installed iPhone simulator name.

## Roadmap

- Local persistence with SwiftData
- Create and edit WorkItems
- Offline operation queue
- REST API integration
- Conflict handling and retry policy
- UIKit bridge example
