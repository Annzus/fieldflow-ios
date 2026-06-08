import Foundation

protocol WorkItemRepository: Sendable {
    func fetchWorkItems() async throws -> [WorkItem]
    func observeWorkItems() async -> AsyncStream<[WorkItem]>
    func workItem(id: UUID) async throws -> WorkItem?
    func create(_ input: CreateWorkItemInput) async throws
    func update(_ input: UpdateWorkItemInput) async throws
}
