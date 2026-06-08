import Foundation

@MainActor
protocol WorkItemRepository {
    func prepareDemoDataIfNeeded() throws
    func fetchWorkItems() async throws -> [WorkItem]
    func observeWorkItems() async -> AsyncStream<[WorkItem]>
    func workItem(id: UUID) async throws -> WorkItem?
    func create(_ input: CreateWorkItemInput) async throws -> WorkItem
    func update(_ input: UpdateWorkItemInput) async throws
    func activityHistory(for workItemID: UUID) async throws -> [ActivityHistory]
}
