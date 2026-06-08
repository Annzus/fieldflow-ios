import Foundation
import SwiftData

@Model
final class WorkItemRecord {
    @Attribute(.unique) var id: UUID
    var title: String
    var detailText: String
    var statusRawValue: String
    var priorityRawValue: String
    var assigneeID: UUID?
    var createdBy: UUID
    var createdAt: Date
    var updatedAt: Date
    var serverVersion: Int
    var localVersion: Int
    var syncStateRawValue: String

    init(workItem: WorkItem) {
        self.id = workItem.id
        self.title = workItem.title
        self.detailText = workItem.detail
        self.statusRawValue = workItem.status.rawValue
        self.priorityRawValue = workItem.priority.rawValue
        self.assigneeID = workItem.assigneeID
        self.createdBy = workItem.createdBy
        self.createdAt = workItem.createdAt
        self.updatedAt = workItem.updatedAt
        self.serverVersion = workItem.serverVersion
        self.localVersion = workItem.localVersion
        self.syncStateRawValue = workItem.syncState.rawValue
    }

    func update(with input: UpdateWorkItemInput, updatedAt: Date) {
        title = input.title
        detailText = input.detail
        statusRawValue = input.status.rawValue
        priorityRawValue = input.priority.rawValue
        assigneeID = input.assigneeID
        self.updatedAt = updatedAt
        localVersion += 1
        syncStateRawValue = SyncState.pending.rawValue
    }

    func toDomain() throws -> WorkItem {
        guard let status = WorkItemStatus(rawValue: statusRawValue),
              let priority = WorkItemPriority(rawValue: priorityRawValue),
              let syncState = SyncState(rawValue: syncStateRawValue) else {
            throw AppError.localStorage
        }

        return WorkItem(
            id: id,
            title: title,
            detail: detailText,
            status: status,
            priority: priority,
            assigneeID: assigneeID,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverVersion: serverVersion,
            localVersion: localVersion,
            syncState: syncState
        )
    }
}
