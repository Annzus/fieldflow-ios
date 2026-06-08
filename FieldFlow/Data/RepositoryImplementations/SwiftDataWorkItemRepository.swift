import Foundation
import SwiftData

@MainActor
final class SwiftDataWorkItemRepository: WorkItemRepository {
    private let container: ModelContainer
    private var context: ModelContext {
        container.mainContext
    }

    init(container: ModelContainer) {
        self.container = container
    }

    func prepareDemoDataIfNeeded() throws {
        let descriptor = FetchDescriptor<WorkItemRecord>()
        let count = try context.fetchCount(descriptor)
        guard count == 0 else {
            return
        }

        for item in PreviewData.workItems {
            context.insert(WorkItemRecord(workItem: item))
        }

        for history in PreviewData.activityHistories {
            context.insert(ActivityHistoryRecord(history: history))
        }

        try context.save()
    }

    func fetchWorkItems() async throws -> [WorkItem] {
        var descriptor = FetchDescriptor<WorkItemRecord>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        descriptor.fetchLimit = 200
        return try context.fetch(descriptor).map { try $0.toDomain() }
    }

    func observeWorkItems() async -> AsyncStream<[WorkItem]> {
        AsyncStream { continuation in
            Task { @MainActor in
                let items = (try? await fetchWorkItems()) ?? []
                continuation.yield(items)
                continuation.finish()
            }
        }
    }

    func workItem(id: UUID) async throws -> WorkItem? {
        try record(id: id)?.toDomain()
    }

    func create(_ input: CreateWorkItemInput) async throws -> WorkItem {
        try validate(title: input.title)

        let now = Date()
        let item = WorkItem(
            id: UUID(),
            title: input.title.trimmingCharacters(in: .whitespacesAndNewlines),
            detail: input.detail.trimmingCharacters(in: .whitespacesAndNewlines),
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

        context.insert(WorkItemRecord(workItem: item))
        context.insert(
            ActivityHistoryRecord(
                history: ActivityHistory(
                    id: UUID(),
                    workItemID: item.id,
                    actorID: PreviewData.currentUserID,
                    action: .created,
                    summary: "WorkItemを作成しました",
                    createdAt: now
                )
            )
        )
        try context.save()

        return item
    }

    func update(_ input: UpdateWorkItemInput) async throws {
        try validate(title: input.title)

        guard let record = try record(id: input.id) else {
            throw AppError.validation(message: "WorkItemが見つかりません。")
        }

        let oldItem = try record.toDomain()
        let now = Date()
        record.update(with: normalized(input), updatedAt: now)
        insertHistories(oldItem: oldItem, input: input, updatedAt: now)
        try context.save()
    }

    func activityHistory(for workItemID: UUID) async throws -> [ActivityHistory] {
        let descriptor = FetchDescriptor<ActivityHistoryRecord>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
            .filter { $0.workItemID == workItemID }
            .map { try $0.toDomain() }
    }

    private func record(id: UUID) throws -> WorkItemRecord? {
        let descriptor = FetchDescriptor<WorkItemRecord>()
        return try context.fetch(descriptor).first { $0.id == id }
    }

    private func validate(title: String) throws {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw AppError.validation(message: "タイトルを入力してください。")
        }
    }

    private func normalized(_ input: UpdateWorkItemInput) -> UpdateWorkItemInput {
        UpdateWorkItemInput(
            id: input.id,
            title: input.title.trimmingCharacters(in: .whitespacesAndNewlines),
            detail: input.detail.trimmingCharacters(in: .whitespacesAndNewlines),
            status: input.status,
            priority: input.priority,
            assigneeID: input.assigneeID,
            baseVersion: input.baseVersion
        )
    }

    private func insertHistories(oldItem: WorkItem, input: UpdateWorkItemInput, updatedAt: Date) {
        if oldItem.title != input.title {
            insertHistory(workItemID: oldItem.id, action: .titleUpdated, summary: "タイトルを更新しました", createdAt: updatedAt)
        }

        if oldItem.detail != input.detail {
            insertHistory(workItemID: oldItem.id, action: .detailUpdated, summary: "説明を更新しました", createdAt: updatedAt)
        }

        if oldItem.status != input.status {
            insertHistory(workItemID: oldItem.id, action: .statusUpdated, summary: "ステータスを更新しました", createdAt: updatedAt)
        }

        if oldItem.priority != input.priority {
            insertHistory(workItemID: oldItem.id, action: .priorityUpdated, summary: "優先度を更新しました", createdAt: updatedAt)
        }

        if oldItem.assigneeID != input.assigneeID {
            insertHistory(workItemID: oldItem.id, action: .assigneeUpdated, summary: "担当者を更新しました", createdAt: updatedAt)
        }
    }

    private func insertHistory(
        workItemID: UUID,
        action: ActivityAction,
        summary: String,
        createdAt: Date
    ) {
        context.insert(
            ActivityHistoryRecord(
                history: ActivityHistory(
                    id: UUID(),
                    workItemID: workItemID,
                    actorID: PreviewData.currentUserID,
                    action: action,
                    summary: summary,
                    createdAt: createdAt
                )
            )
        )
    }
}
