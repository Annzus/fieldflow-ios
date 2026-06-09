# FieldFlow

FieldFlow is an iOS portfolio app for field operations workflows. It focuses on a practical mobile client architecture for task-like business records called WorkItems.

The current app runs with local SwiftData storage and demonstrates demo login, WorkItem browsing, local create/edit flows, activity history, repository abstraction, dependency injection, and unit tests.

## Concept

Mobile business apps often need to keep working when network conditions are unstable. FieldFlow is designed around that problem space: clear local state, readable sync status, and an architecture that can grow into offline-first data handling.

## Features

- Demo account login
- WorkItem list backed by SwiftData
- WorkItem detail screen
- Local WorkItem creation and editing
- Activity history for local changes
- Search by title or detail
- Status filter
- Assignee filter
- Priority, assignee, and sync status display
- Local data retained after app restart
- SwiftUI preview support
- Unit tests for repository and view model behavior

## Tech Stack

- Swift 6
- SwiftUI
- Swift Concurrency
- SwiftData
- Keychain
- XCTest
- Xcode project
- iOS 17+
- Java 21 / Spring Boot backend
- PostgreSQL / Flyway
- OpenAPI / Swagger UI

## Architecture

Current structure:

```text
App
→ DependencyContainer
→ AppRouter
→ LoginView / WorkItemListView
→ WorkItemListViewModel
→ WorkItemRepository
→ SwiftDataWorkItemRepository
→ SwiftData Models
```

Planned direction:

```text
View
→ ViewModel
→ UseCase
→ Repository
→ SwiftData LocalStore / APIClient
→ Spring Boot API
→ PostgreSQL
```

The domain layer does not depend on SwiftUI, URLSession, or SwiftData. This keeps the core models and repository contracts easy to test and replace.

## Setup

### iOS

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

### Backend

Backend source is under `Backend/`.

Requirements:

- Java 21
- Maven
- Docker, for PostgreSQL

Start PostgreSQL:

```bash
cd Backend
docker compose up -d
```

Run backend tests:

```bash
cd Backend
mvn test
```

Run API:

```bash
cd Backend
mvn spring-boot:run
```

Swagger UI:

```text
http://localhost:8080/swagger-ui.html
```

## Roadmap

- Offline operation queue
- iOS REST API integration
- Conflict handling and retry policy
- UIKit bridge example
- CI workflow
