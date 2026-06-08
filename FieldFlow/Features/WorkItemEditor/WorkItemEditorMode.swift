import Foundation

enum WorkItemEditorMode: Identifiable {
    case create
    case edit(WorkItem)

    var id: String {
        switch self {
        case .create:
            "create"
        case .edit(let item):
            item.id.uuidString
        }
    }

    var title: String {
        switch self {
        case .create:
            "新規WorkItem"
        case .edit:
            "WorkItem編集"
        }
    }
}
