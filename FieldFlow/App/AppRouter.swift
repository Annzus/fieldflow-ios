import SwiftUI

struct AppRouter: Sendable {
    let workItemRepository: any WorkItemRepository

    @MainActor
    func rootView() -> some View {
        WorkItemListView(
            viewModel: WorkItemListViewModel(repository: workItemRepository)
        )
    }
}
