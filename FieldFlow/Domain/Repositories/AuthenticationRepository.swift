import Foundation

@MainActor
protocol AuthenticationRepository {
    var isAuthenticated: Bool { get }
    func login(email: String, password: String) async throws
    func logout() throws
}
