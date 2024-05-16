import UIKit

final class SearchHistoryTableView: BaseTableView {
    // MARK: - Method
    override func registerCells() {
        register(SearchKeywordCell.self)
    }
}
