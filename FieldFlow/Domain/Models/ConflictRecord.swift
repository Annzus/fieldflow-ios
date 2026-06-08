import Foundation

struct ConflictRecord: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let entityID: UUID
    let localPayload: Data
    let serverPayload: Data
    let localBaseVersion: Int
    let serverVersion: Int
    let detectedAt: Date
}
