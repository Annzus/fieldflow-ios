import SwiftUI

@main
struct FieldFlowApp: App {
    private let container: DependencyContainer

    init() {
        do {
            container = try DependencyContainer.live()
        } catch {
            fatalError("Failed to initialize FieldFlow: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            container.router.rootView()
        }
    }
}
