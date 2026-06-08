import Foundation

enum ActivityAction: String, Codable, CaseIterable, Sendable {
    case created
    case titleUpdated
    case detailUpdated
    case statusUpdated
    case priorityUpdated
    case assigneeUpdated
    case conflictResolved
}

struct ActivityHistory: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let workItemID: UUID
    let actorID: UUID
    let action: ActivityAction
    let summary: String
    let createdAt: Date
}
