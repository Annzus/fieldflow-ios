import Combine
import Foundation

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var isAuthenticated: Bool

    private let authenticationRepository: any AuthenticationRepository

    init(authenticationRepository: any AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
        self.isAuthenticated = authenticationRepository.isAuthenticated
    }

    func login(email: String, password: String) async throws {
        try await authenticationRepository.login(email: email, password: password)
        isAuthenticated = true
    }

    func logout() throws {
        try authenticationRepository.logout()
        isAuthenticated = false
    }
}
