import SwiftUI

struct WorkItemEditorView: View {
    @Environment(\.dismiss) private var dismiss

    let mode: WorkItemEditorMode
    let repository: any WorkItemRepository
    let onSaved: @MainActor () async -> Void

    @State private var title: String
    @State private var detail: String
    @State private var status: WorkItemStatus
    @State private var priority: WorkItemPriority
    @State private var assigneeID: UUID?
    @State private var isSaving = false
    @State private var errorMessage: String?

    init(
        mode: WorkItemEditorMode,
        repository: any WorkItemRepository,
        onSaved: @escaping @MainActor () async -> Void
    ) {
        self.mode = mode
        self.repository = repository
        self.onSaved = onSaved

        switch mode {
        case .create:
            _title = State(initialValue: "")
            _detail = State(initialValue: "")
            _status = State(initialValue: .pending)
            _priority = State(initialValue: .medium)
            _assigneeID = State(initialValue: nil)
        case .edit(let item):
            _title = State(initialValue: item.title)
            _detail = State(initialValue: item.detail)
            _status = State(initialValue: item.status)
            _priority = State(initialValue: item.priority)
            _assigneeID = State(initialValue: item.assigneeID)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    TextField("タイトル", text: $title)
                    TextField("説明", text: $detail, axis: .vertical)
                        .lineLimit(4...8)
                }

                Section("状態") {
                    Picker("ステータス", selection: $status) {
                        ForEach(WorkItemStatus.allCases) { status in
                            Text(status.displayName).tag(status)
                        }
                    }

                    Picker("優先度", selection: $priority) {
                        ForEach(WorkItemPriority.allCases) { priority in
                            Text(priority.displayName).tag(priority)
                        }
                    }

                    Picker("担当者", selection: $assigneeID) {
                        Text("未割当").tag(nil as UUID?)
                        ForEach(PreviewData.members) { member in
                            Text(member.name).tag(member.id as UUID?)
                        }
                    }
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(mode.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        Task {
                            await save()
                        }
                    }
                    .disabled(isSaving)
                }
            }
        }
    }

    private func save() async {
        isSaving = true
        errorMessage = nil

        do {
            switch mode {
            case .create:
                _ = try await repository.create(
                    CreateWorkItemInput(
                        title: title,
                        detail: detail,
                        priority: priority,
                        assigneeID: assigneeID
                    )
                )
            case .edit(let item):
                try await repository.update(
                    UpdateWorkItemInput(
                        id: item.id,
                        title: title,
                        detail: detail,
                        status: status,
                        priority: priority,
                        assigneeID: assigneeID,
                        baseVersion: item.serverVersion
                    )
                )
            }

            await onSaved()
            dismiss()
        } catch let error as AppError {
            errorMessage = error.displayMessage
        } catch {
            errorMessage = AppError.unknown(message: String(describing: error)).displayMessage
        }

        isSaving = false
    }
}

#Preview {
    WorkItemEditorView(
        mode: .edit(PreviewData.workItems[0]),
        repository: MockWorkItemRepository(items: PreviewData.workItems),
        onSaved: {}
    )
}
