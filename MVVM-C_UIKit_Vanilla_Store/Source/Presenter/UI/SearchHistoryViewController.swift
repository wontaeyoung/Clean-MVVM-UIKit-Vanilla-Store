import UIKit

final class SearchHistoryViewController: BaseViewController {
    
    // MARK: - Dependency
    private let searchHistoryViewModel: SearchHistoryViewModel
    var delegate: SearchHistoryViewDelegate?
    
    // MARK: - UI
    private(set) lazy var searchHistoryTableView: SearchHistoryTableView = .init()
    
    // MARK: - Initializer
    init(
        searchHistoryViewModel: SearchHistoryViewModel
    ) {
        self.searchHistoryViewModel = searchHistoryViewModel
        
        super.init()
    }
    
    // MARK: - Method
    override func setAttribute() {
        searchHistoryViewModel.setTableViewDataSource(to: searchHistoryTableView)
        searchHistoryTableView.delegate = self
    }
    
    override func setHierarchy() {
        view.addSubview(searchHistoryTableView)
    }
    
    override func setConstraint() {
        view.setTranslatesAutoresizingMaskIntoConstraintsOff(searchHistoryTableView)
        
        searchHistoryTableView.setAutoLayoutAllEqual(to: view)
    }
}

extension SearchHistoryViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let keyword: String = searchHistoryViewModel.getKeyword(at: indexPath.row) else { return }
        delegate?.submitKeyword(keyword)
    }
}

