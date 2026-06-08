import SwiftUI

struct WorkItemListView: View {
    @StateObject private var viewModel: WorkItemListViewModel
    @ObservedObject private var sessionStore: SessionStore
    @State private var editorMode: WorkItemEditorMode?
    @State private var errorMessage: String?

    private let repository: any WorkItemRepository

    init(
        viewModel: WorkItemListViewModel,
        repository: any WorkItemRepository,
        sessionStore: SessionStore
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.repository = repository
        self.sessionStore = sessionStore
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("FieldFlow")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("ログアウト") {
                            do {
                                try sessionStore.logout()
                            } catch let error as AppError {
                                errorMessage = error.displayMessage
                            } catch {
                                errorMessage = AppError.unknown(message: String(describing: error)).displayMessage
                            }
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            editorMode = .create
                        } label: {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("新規作成")
                    }
                }
                .navigationDestination(for: UUID.self) { itemID in
                    WorkItemDetailView(
                        viewModel: WorkItemDetailViewModel(
                            itemID: itemID,
                            repository: repository
                        ),
                        repository: repository
                    )
                }
        }
        .searchable(text: $viewModel.searchText, prompt: "WorkItemを検索")
        .task {
            await viewModel.loadItems()
        }
        .sheet(item: $editorMode) { mode in
            WorkItemEditorView(mode: mode, repository: repository) {
                await viewModel.reload()
            }
        }
        .alert("エラー", isPresented: Binding(
            get: { errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    errorMessage = nil
                }
            }
        ), presenting: errorMessage) { _ in
            Button("OK", role: .cancel) {
                errorMessage = nil
            }
        } message: {
            Text($0)
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
                    assigneeFilter
                    ForEach(items) { item in
                        NavigationLink(value: item.id) {
                            WorkItemRowView(item: item)
                        }
                    }
                }
                .refreshable {
                    await viewModel.reload()
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

    private var assigneeFilter: some View {
        Picker("担当者", selection: $viewModel.selectedAssigneeID) {
            Text("すべて").tag(nil as UUID?)
            ForEach(PreviewData.members) { member in
                Text(member.name).tag(member.id as UUID?)
            }
        }
        .pickerStyle(.menu)
        .accessibilityLabel("担当者フィルター")
    }
}

#Preview {
    let repository = MockWorkItemRepository(items: PreviewData.workItems)
    let container = DependencyContainer.preview()
    WorkItemListView(
        viewModel: WorkItemListViewModel(
            repository: repository
        ),
        repository: repository,
        sessionStore: container.sessionStore
    )
}
