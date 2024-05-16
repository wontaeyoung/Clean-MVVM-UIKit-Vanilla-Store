import UIKit

final class SearchHistoryViewController: BaseViewController {
    // MARK: - Property
    private let searchBookPresenter: SearchBookPresenter
    private let searchHistoryPresenter: SearchHistoryPresenter
    private weak var delegate: SearchHistoryViewDelegate?
    
    // MARK: - UI
    private(set) lazy var searchHistoryTableView: SearchHistoryTableView = .init()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init()
        indicator.style = .large
        indicator.center.x = view.center.x
        indicator.center.y = view.center.y - 100
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    // MARK: - Initializer
    init(
        searchBookPresenter: SearchBookPresenter,
        searchHistoryPresenter: SearchHistoryPresenter
    ) {
        self.searchBookPresenter = searchBookPresenter
        self.searchHistoryPresenter = searchHistoryPresenter
        
        super.init()
    }
    
    // MARK: - Method
    override func setAttribute() {
        searchHistoryPresenter.setDataSourceDelegate(self)
        searchHistoryPresenter.setTableViewDataSource(to: searchHistoryTableView)
        searchBookPresenter.setDelegate(
            self,
            type: .searchLoadingIndicator)
        searchHistoryTableView.delegate = self
    }
    
    override func setHierarchy() {
        view.addSubviews(searchHistoryTableView, loadingIndicator)
    }
    
    override func setConstraint() {
        view.setTranslatesAutoresizingMaskIntoConstraintsOff(searchHistoryTableView)
        
        searchHistoryTableView.setAutoLayoutAllEqual(to: view)
    }
}

// MARK: - Delegate
extension SearchHistoryViewController: DataSourceDelegate {
    func entitiesDidUpdate() {
        DispatchQueue.main.async {
            self.searchHistoryTableView.reloadData()
        }
    }
}

extension SearchHistoryViewController: LoadingIndicatorDelegate {
    func showIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
}

extension SearchHistoryViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let keyword = searchHistoryPresenter.getKeyword(at: indexPath.row) else {
            return
        }
        
        delegate?.submitKeyword(keyword)
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return SearchHistoryHeaderView {
            self.searchHistoryPresenter.removeAllKeywords()
        }
    }
}

// MARK: - Dependency
extension SearchHistoryViewController {
    func setDelegate(_ delegate: SearchHistoryViewDelegate) {
        self.delegate = delegate
    }
}
