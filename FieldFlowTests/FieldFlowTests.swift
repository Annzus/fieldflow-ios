import XCTest
@testable import FieldFlow

final class FieldFlowTests: XCTestCase {
    func testMockRepositoryReturnsPreviewItems() async {
        let repository = MockWorkItemRepository(items: PreviewData.workItems)
        let observedItems = try? await repository.fetchWorkItems()

        XCTAssertEqual(observedItems?.count, 3)
        XCTAssertEqual(observedItems?.first?.title, "配送遅延の確認")
    }

    @MainActor
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

    @MainActor
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
}
