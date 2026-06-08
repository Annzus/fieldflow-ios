import Combine
import Foundation

@MainActor
final class WorkItemListViewModel: ObservableObject {
    @Published private(set) var state: LoadingState<[WorkItem]> = .idle
    @Published var searchText = "" {
        didSet { applyFilters() }
    }
    @Published var selectedStatus: WorkItemStatus? {
        didSet { applyFilters() }
    }
    @Published var selectedAssigneeID: UUID? {
        didSet { applyFilters() }
    }

    private let repository: any WorkItemRepository
    private var allItems: [WorkItem] = []

    init(repository: any WorkItemRepository) {
        self.repository = repository
    }

    func loadItems() async {
        state = .loading

        do {
            allItems = try await repository.fetchWorkItems()
            applyFilters()
        } catch let error as AppError {
            state = .failed(error)
        } catch {
            state = .failed(.unknown(message: String(describing: error)))
        }
    }

    func reload() async {
        await loadItems()
    }

    private func applyFilters() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        let filtered = allItems.filter { item in
            let matchesStatus = selectedStatus.map { item.status == $0 } ?? true
            let matchesAssignee = selectedAssigneeID.map { item.assigneeID == $0 } ?? true
            let matchesSearch = query.isEmpty
                || item.title.localizedCaseInsensitiveContains(query)
                || item.detail.localizedCaseInsensitiveContains(query)
            return matchesStatus && matchesAssignee && matchesSearch
        }

        state = .loaded(filtered)
    }
}
