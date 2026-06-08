import Foundation

struct CreateWorkItemInput: Equatable, Sendable {
    var title: String
    var detail: String
    var priority: WorkItemPriority
    var assigneeID: UUID?
}

struct UpdateWorkItemInput: Equatable, Sendable {
    let id: UUID
    var title: String
    var detail: String
    var status: WorkItemStatus
    var priority: WorkItemPriority
    var assigneeID: UUID?
    var baseVersion: Int
}
