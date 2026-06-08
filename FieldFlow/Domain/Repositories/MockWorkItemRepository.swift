import Foundation

@MainActor
final class MockWorkItemRepository: WorkItemRepository {
    private var items: [WorkItem]
    private var histories: [ActivityHistory]

    init(
        items: [WorkItem],
        histories: [ActivityHistory] = PreviewData.activityHistories
    ) {
        self.items = items
        self.histories = histories
    }

    func prepareDemoDataIfNeeded() throws {
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

    func create(_ input: CreateWorkItemInput) async throws -> WorkItem {
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
        histories.insert(
            ActivityHistory(
                id: UUID(),
                workItemID: item.id,
                actorID: PreviewData.currentUserID,
                action: .created,
                summary: "WorkItemを作成しました",
                createdAt: now
            ),
            at: 0
        )
        return item
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

    func activityHistory(for workItemID: UUID) async throws -> [ActivityHistory] {
        histories
            .filter { $0.workItemID == workItemID }
            .sorted { $0.createdAt > $1.createdAt }
    }
}
