import Foundation

enum WorkItemStatus: String, Codable, CaseIterable, Identifiable, Sendable {
    case pending
    case inProgress
    case completed
    case onHold

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .pending:
            "未対応"
        case .inProgress:
            "対応中"
        case .completed:
            "完了"
        case .onHold:
            "保留"
        }
    }
}

enum WorkItemPriority: String, Codable, CaseIterable, Identifiable, Sendable {
    case low
    case medium
    case high
    case urgent

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .low:
            "低"
        case .medium:
            "中"
        case .high:
            "高"
        case .urgent:
            "緊急"
        }
    }
}

enum SyncState: String, Codable, Sendable {
    case synced
    case pending
    case syncing
    case failed
    case conflict

    var displayName: String {
        switch self {
        case .synced:
            "同期済み"
        case .pending:
            "同期待ち"
        case .syncing:
            "同期中"
        case .failed:
            "失敗"
        case .conflict:
            "競合"
        }
    }
}

struct WorkItem: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var title: String
    var detail: String
    var status: WorkItemStatus
    var priority: WorkItemPriority
    var assigneeID: UUID?
    let createdBy: UUID
    let createdAt: Date
    var updatedAt: Date
    var serverVersion: Int
    var localVersion: Int
    var syncState: SyncState
}
