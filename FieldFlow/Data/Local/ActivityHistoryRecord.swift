import Foundation
import SwiftData

@Model
final class ActivityHistoryRecord {
    @Attribute(.unique) var id: UUID
    var workItemID: UUID
    var actorID: UUID
    var actionRawValue: String
    var summary: String
    var createdAt: Date

    init(history: ActivityHistory) {
        self.id = history.id
        self.workItemID = history.workItemID
        self.actorID = history.actorID
        self.actionRawValue = history.action.rawValue
        self.summary = history.summary
        self.createdAt = history.createdAt
    }

    func toDomain() throws -> ActivityHistory {
        guard let action = ActivityAction(rawValue: actionRawValue) else {
            throw AppError.localStorage
        }

        return ActivityHistory(
            id: id,
            workItemID: workItemID,
            actorID: actorID,
            action: action,
            summary: summary,
            createdAt: createdAt
        )
    }
}
