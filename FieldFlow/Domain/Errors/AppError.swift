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

    var displayMessage: String {
        switch self {
        case .networkUnavailable:
            "現在オフラインです。"
        case .timeout:
            "通信がタイムアウトしました。"
        case .unauthorized:
            "ログインの有効期限が切れました。"
        case .forbidden:
            "操作権限がありません。"
        case .validation(let message):
            message
        case .conflict:
            "他の端末で更新されています。内容を確認してください。"
        case .decoding:
            "データの読み込みに失敗しました。"
        case .server(let statusCode):
            "サーバーエラーが発生しました: \(statusCode)"
        case .localStorage:
            "端末内データの処理に失敗しました。"
        case .cancelled:
            "処理をキャンセルしました。"
        case .unknown(let message):
            message
        }
    }
}
