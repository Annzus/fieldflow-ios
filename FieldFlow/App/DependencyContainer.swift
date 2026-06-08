import Foundation

struct DependencyContainer: Sendable {
    let workItemRepository: any WorkItemRepository

    var router: AppRouter {
        AppRouter(workItemRepository: workItemRepository)
    }

    static func phaseOne() -> DependencyContainer {
        DependencyContainer(
            workItemRepository: MockWorkItemRepository(items: PreviewData.workItems)
        )
    }
}
