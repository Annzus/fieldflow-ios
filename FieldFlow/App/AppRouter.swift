import SwiftUI

@MainActor
struct AppRouter {
    let workItemRepository: any WorkItemRepository
    let sessionStore: SessionStore

    func rootView() -> some View {
        AppRootView(
            workItemRepository: workItemRepository,
            sessionStore: sessionStore
        )
    }
}

private struct AppRootView: View {
    let workItemRepository: any WorkItemRepository
    @ObservedObject var sessionStore: SessionStore

    var body: some View {
        if sessionStore.isAuthenticated {
            WorkItemListView(
                viewModel: WorkItemListViewModel(repository: workItemRepository),
                repository: workItemRepository,
                sessionStore: sessionStore
            )
        } else {
            LoginView(
                viewModel: LoginViewModel(sessionStore: sessionStore)
            )
        }
    }
}
