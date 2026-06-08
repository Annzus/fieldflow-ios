import SwiftUI

struct WorkItemListView: View {
    @StateObject private var viewModel: WorkItemListViewModel

    init(viewModel: WorkItemListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("FieldFlow")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                        } label: {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("新規作成")
                    }
                }
        }
        .searchable(text: $viewModel.searchText, prompt: "WorkItemを検索")
        .task {
            await viewModel.loadItems()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("読み込み中")
        case .failed:
            ContentUnavailableView(
                "読み込みに失敗しました",
                systemImage: "exclamationmark.triangle",
                description: Text("時間をおいて再度お試しください。")
            )
        case .loaded(let items):
            if items.isEmpty {
                ContentUnavailableView(
                    "WorkItemはありません",
                    systemImage: "tray",
                    description: Text("検索条件を変更してください。")
                )
            } else {
                List {
                    statusFilter
                    ForEach(items) { item in
                        WorkItemRowView(item: item)
                    }
                }
            }
        }
    }

    private var statusFilter: some View {
        Picker("ステータス", selection: $viewModel.selectedStatus) {
            Text("すべて").tag(nil as WorkItemStatus?)
            ForEach(WorkItemStatus.allCases) { status in
                Text(status.displayName).tag(status as WorkItemStatus?)
            }
        }
        .pickerStyle(.segmented)
        .listRowSeparator(.hidden)
        .accessibilityLabel("ステータスフィルター")
    }
}

#Preview {
    WorkItemListView(
        viewModel: WorkItemListViewModel(
            repository: MockWorkItemRepository(items: PreviewData.workItems)
        )
    )
}
