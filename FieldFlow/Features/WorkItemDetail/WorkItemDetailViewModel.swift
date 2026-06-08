import Combine
import Foundation

@MainActor
final class WorkItemDetailViewModel: ObservableObject {
    @Published private(set) var item: WorkItem?
    @Published private(set) var histories: [ActivityHistory] = []
    @Published private(set) var errorMessage: String?

    private let itemID: UUID
    private let repository: any WorkItemRepository

    init(itemID: UUID, repository: any WorkItemRepository) {
        self.itemID = itemID
        self.repository = repository
    }

    func load() async {
        do {
            item = try await repository.workItem(id: itemID)
            histories = try await repository.activityHistory(for: itemID)
        } catch let error as AppError {
            errorMessage = error.displayMessage
        } catch {
            errorMessage = AppError.unknown(message: String(describing: error)).displayMessage
        }
    }
}
