import Foundation
import SwiftData

@MainActor
struct DependencyContainer {
    let workItemRepository: any WorkItemRepository
    let authenticationRepository: any AuthenticationRepository
    let sessionStore: SessionStore

    var router: AppRouter {
        AppRouter(
            workItemRepository: workItemRepository,
            sessionStore: sessionStore
        )
    }

    static func live() throws -> DependencyContainer {
        let modelContainer = try ModelContainer(
            for: WorkItemRecord.self,
            ActivityHistoryRecord.self
        )
        let workItemRepository = SwiftDataWorkItemRepository(container: modelContainer)
        try workItemRepository.prepareDemoDataIfNeeded()

        let authenticationRepository = DemoAuthenticationRepository()

        return DependencyContainer(
            workItemRepository: workItemRepository,
            authenticationRepository: authenticationRepository,
            sessionStore: SessionStore(authenticationRepository: authenticationRepository)
        )
    }

    static func preview() -> DependencyContainer {
        let authenticationRepository = DemoAuthenticationRepository()
        return DependencyContainer(
            workItemRepository: MockWorkItemRepository(items: PreviewData.workItems),
            authenticationRepository: authenticationRepository,
            sessionStore: SessionStore(authenticationRepository: authenticationRepository)
        )
    }
}
