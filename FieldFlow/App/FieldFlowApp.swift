import SwiftUI

@main
struct FieldFlowApp: App {
    private let container = DependencyContainer.phaseOne()

    var body: some Scene {
        WindowGroup {
            container.router.rootView()
        }
    }
}
