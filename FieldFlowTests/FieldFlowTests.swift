import SwiftData
import XCTest
@testable import FieldFlow

@MainActor
final class FieldFlowTests: XCTestCase {
    func testMockRepositoryReturnsPreviewItems() async {
        let repository = MockWorkItemRepository(items: PreviewData.workItems)
        let observedItems = try? await repository.fetchWorkItems()

        XCTAssertEqual(observedItems?.count, 3)
        XCTAssertEqual(observedItems?.first?.title, "配送遅延の確認")
    }

    func testWorkItemListViewModelLoadsItems() async {
        let viewModel = WorkItemListViewModel(
            repository: MockWorkItemRepository(items: PreviewData.workItems)
        )

        await viewModel.loadItems()

        guard case .loaded(let items) = viewModel.state else {
            return XCTFail("Expected loaded state")
        }
        XCTAssertEqual(items.count, 3)
    }

    func testWorkItemListViewModelFiltersBySearchText() async {
        let viewModel = WorkItemListViewModel(
            repository: MockWorkItemRepository(items: PreviewData.workItems)
        )

        await viewModel.loadItems()
        viewModel.searchText = "端末"

        guard case .loaded(let items) = viewModel.state else {
            return XCTFail("Expected loaded state")
        }
        XCTAssertEqual(items.map(\.title), ["店舗端末の交換依頼"])
    }

    func testSwiftDataRepositorySeedsDemoData() async throws {
        let repository = try makeSwiftDataRepository()

        try repository.prepareDemoDataIfNeeded()
        try repository.prepareDemoDataIfNeeded()
        let items = try await repository.fetchWorkItems()

        XCTAssertEqual(items.count, 3)
    }

    func testSwiftDataRepositoryCreatesWorkItem() async throws {
        let repository = try makeSwiftDataRepository()

        let item = try await repository.create(
            CreateWorkItemInput(
                title: "現地確認",
                detail: "端末の状態を確認する",
                priority: .high,
                assigneeID: PreviewData.storeMemberID
            )
        )
        let items = try await repository.fetchWorkItems()

        XCTAssertTrue(items.contains { $0.id == item.id })
        XCTAssertEqual(item.syncState, .pending)
    }

    func testSwiftDataRepositoryUpdatesAndRecordsHistory() async throws {
        let repository = try makeSwiftDataRepository()
        try repository.prepareDemoDataIfNeeded()
        let items = try await repository.fetchWorkItems()
        let item = try XCTUnwrap(items.first)

        try await repository.update(
            UpdateWorkItemInput(
                id: item.id,
                title: "\(item.title) 更新",
                detail: item.detail,
                status: .completed,
                priority: item.priority,
                assigneeID: item.assigneeID,
                baseVersion: item.serverVersion
            )
        )

        let fetchedItem = try await repository.workItem(id: item.id)
        let updated = try XCTUnwrap(fetchedItem)
        let histories = try await repository.activityHistory(for: item.id)

        XCTAssertEqual(updated.status, .completed)
        XCTAssertEqual(updated.syncState, .pending)
        XCTAssertTrue(histories.contains { $0.action == .statusUpdated })
    }

    private func makeSwiftDataRepository() throws -> SwiftDataWorkItemRepository {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: WorkItemRecord.self,
            ActivityHistoryRecord.self,
            configurations: configuration
        )
        return SwiftDataWorkItemRepository(container: container)
    }
}
