import Combine
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = DemoAccount.email
    @Published var password = DemoAccount.password
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let sessionStore: SessionStore

    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
    }

    func login() async {
        isLoading = true
        errorMessage = nil

        do {
            try await sessionStore.login(email: email, password: password)
        } catch let error as AppError {
            errorMessage = error.displayMessage
        } catch {
            errorMessage = AppError.unknown(message: String(describing: error)).displayMessage
        }

        isLoading = false
    }
}
