import Foundation

enum MemberRole: String, Codable, CaseIterable, Sendable {
    case operatorUser
    case supervisor
    case administrator

    var displayName: String {
        switch self {
        case .operatorUser:
            "担当者"
        case .supervisor:
            "管理者"
        case .administrator:
            "システム管理者"
        }
    }
}

struct Member: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let name: String
    let role: MemberRole
}
