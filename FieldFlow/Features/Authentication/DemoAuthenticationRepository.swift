import Foundation

@MainActor
final class DemoAuthenticationRepository: AuthenticationRepository {
    private let tokenStore: KeychainTokenStore

    init(tokenStore: KeychainTokenStore = KeychainTokenStore()) {
        self.tokenStore = tokenStore
    }

    var isAuthenticated: Bool {
        (try? tokenStore.loadToken()) != nil
    }

    func login(email: String, password: String) async throws {
        guard email == DemoAccount.email, password == DemoAccount.password else {
            throw AppError.validation(message: "メールアドレスまたはパスワードが正しくありません。")
        }

        try tokenStore.saveToken("demo-token")
    }

    func logout() throws {
        try tokenStore.deleteToken()
    }
}

enum DemoAccount {
    static let email = "demo@fieldflow.app"
    static let password = "password"
}
