import Foundation

actor MockWorkItemRepository: WorkItemRepository {
    private var items: [WorkItem]

    init(items: [WorkItem]) {
        self.items = items
    }

    func fetchWorkItems() async throws -> [WorkItem] {
        items
    }

    func observeWorkItems() async -> AsyncStream<[WorkItem]> {
        let snapshot = items
        return AsyncStream { continuation in
            continuation.yield(snapshot)
            continuation.finish()
        }
    }

    func workItem(id: UUID) async throws -> WorkItem? {
        items.first { $0.id == id }
    }

    func create(_ input: CreateWorkItemInput) async throws {
        let now = Date()
        let item = WorkItem(
            id: UUID(),
            title: input.title,
            detail: input.detail,
            status: .pending,
            priority: input.priority,
            assigneeID: input.assigneeID,
            createdBy: PreviewData.currentUserID,
            createdAt: now,
            updatedAt: now,
            serverVersion: 0,
            localVersion: 1,
            syncState: .pending
        )
        items.insert(item, at: 0)
    }

    func update(_ input: UpdateWorkItemInput) async throws {
        guard let index = items.firstIndex(where: { $0.id == input.id }) else {
            throw AppError.validation(message: "WorkItem not found")
        }

        items[index].title = input.title
        items[index].detail = input.detail
        items[index].status = input.status
        items[index].priority = input.priority
        items[index].assigneeID = input.assigneeID
        items[index].updatedAt = Date()
        items[index].localVersion += 1
        items[index].syncState = .pending
    }
}
