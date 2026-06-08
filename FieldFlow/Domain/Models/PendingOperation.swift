import Foundation

enum EntityType: String, Codable, CaseIterable, Sendable {
    case workItem
}

enum OperationType: String, Codable, CaseIterable, Sendable {
    case create
    case updateTitle
    case updateDetail
    case updateStatus
    case updatePriority
    case updateAssignee
}

struct PendingOperation: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let operationID: UUID
    let entityID: UUID
    let entityType: EntityType
    let operationType: OperationType
    let baseVersion: Int
    let payload: Data
    let createdAt: Date
    var retryCount: Int
    var lastErrorMessage: String?
}
