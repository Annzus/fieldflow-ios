import Foundation

enum AppError: Error, Equatable, Sendable {
    case networkUnavailable
    case timeout
    case unauthorized
    case forbidden
    case validation(message: String)
    case conflict(entityID: UUID)
    case decoding
    case server(statusCode: Int)
    case localStorage
    case cancelled
    case unknown(message: String)
}
