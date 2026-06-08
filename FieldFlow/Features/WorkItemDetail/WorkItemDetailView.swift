import SwiftUI

struct WorkItemDetailView: View {
    @StateObject private var viewModel: WorkItemDetailViewModel
    @State private var editorMode: WorkItemEditorMode?

    private let repository: any WorkItemRepository

    init(viewModel: WorkItemDetailViewModel, repository: any WorkItemRepository) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.repository = repository
    }

    var body: some View {
        Group {
            if let item = viewModel.item {
                List {
                    Section("概要") {
                        LabeledContent("タイトル", value: item.title)
                        Text(item.detail)
                            .foregroundStyle(.secondary)
                    }

                    Section("状態") {
                        LabeledContent("ステータス", value: item.status.displayName)
                        LabeledContent("優先度", value: item.priority.displayName)
                        LabeledContent("担当者", value: PreviewData.memberName(for: item.assigneeID))
                        LabeledContent("同期状態", value: item.syncState.displayName)
                        LabeledContent("Server Version", value: "\(item.serverVersion)")
                    }

                    Section("日時") {
                        LabeledContent("作成日時", value: item.createdAt.formatted(date: .abbreviated, time: .shortened))
                        LabeledContent("更新日時", value: item.updatedAt.formatted(date: .abbreviated, time: .shortened))
                    }

                    Section("操作履歴") {
                        if viewModel.histories.isEmpty {
                            Text("履歴はありません")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(viewModel.histories) { history in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(history.summary)
                                    Text(history.createdAt.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("編集") {
                            editorMode = .edit(item)
                        }
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "読み込みに失敗しました",
                    systemImage: "exclamationmark.triangle",
                    description: Text(errorMessage)
                )
            } else {
                ProgressView("読み込み中")
            }
        }
        .navigationTitle("詳細")
        .task {
            await viewModel.load()
        }
        .sheet(item: $editorMode) { mode in
            WorkItemEditorView(mode: mode, repository: repository) {
                await viewModel.load()
            }
        }
    }
}

#Preview {
    NavigationStack {
        WorkItemDetailView(
            viewModel: WorkItemDetailViewModel(
                itemID: PreviewData.workItems[0].id,
                repository: MockWorkItemRepository(items: PreviewData.workItems)
            ),
            repository: MockWorkItemRepository(items: PreviewData.workItems)
        )
    }
}
