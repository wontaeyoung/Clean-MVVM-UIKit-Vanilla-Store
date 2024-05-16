import UIKit

final class SearchBookViewController: BaseViewController {
    // MARK: - Property
    private let searchBookPresenter: SearchBookPresenter
    private let searchHistoryPresenter: SearchHistoryPresenter
    private var hasSearchGuideShown: Bool = false
    
    // MARK: - UI
    private var searchGuideView: SearchGuideView = .init()
    
    private(set) var searchResultNavigationController: UINavigationController = {
        let navigationController: UINavigationController = .init()
        navigationController.view.backgroundColor = .white
        
        return navigationController
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar: UISearchBar = .init()
        searchBar.placeholder = "ex) Vanilladin"
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.searchTextField.clearButtonMode = .whileEditing
        
        return searchBar
    }()
    
    private lazy var hideKeyboardToolbar: UIToolbar = {
        let toolbar: UIToolbar = .init()

        let flexibleSpace: UIBarButtonItem = .init(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        
        let hideKeyboardBarButton: UIBarButtonItem = .init(
            image: UIImage(systemName: UIConstant.SFSymbol.keyboardChevronCompactDown)?.colored(with: .black),
            style: .plain,
            target: self,
            action: #selector(hideKeyboardBarButtonTapped))
        
        toolbar.sizeToFit()
        toolbar.setItems([flexibleSpace, hideKeyboardBarButton], animated: false)

        return toolbar
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
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchResultNavigationController.navigationBar.isHidden = true
        searchBar.searchTextField.inputAccessoryView = hideKeyboardToolbar
    }
    
    override func setHierarchy() {
        view.addSubview(searchResultNavigationController.view)
        searchResultNavigationController.view.addSubview(searchGuideView)
    }
    
    override func setConstraint() {
        view.setTranslatesAutoresizingMaskIntoConstraintsOff(
            searchResultNavigationController.view,
            searchGuideView)

        searchResultNavigationController.view.setAutoLayoutAllEqualToSafeArea(to: view)
        
        searchGuideView.setAutoLayoutAllEqual(to: searchResultNavigationController.view)
    }
}

// MARK: - Delegate
extension SearchBookViewController: SearchHistoryViewDelegate {
    func submitKeyword(_ keyword: String) {
        searchBar.text = keyword
        searchBarSearchButtonClicked(searchBar)
    }
}
        
extension SearchBookViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        searchBookAndShowResult(searchText: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if hasSearchGuideShown {
            searchResultNavigationController.popViewController(animated: false)
        } else {
            hideSearchGuide()
            searchBookPresenter.showSearchView(type: .keyword(self))
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBookPresenter.showSearchView(type: .result(searchResultNavigationController))
    }
}

// MARK: - Private
private extension SearchBookViewController {
    func hideSearchGuide() {
        hasSearchGuideShown = true
        searchGuideView.removeFromSuperview()
    }
    
    func searchBookAndShowResult(searchText: String) {
        Task {
            await searchBookPresenter.requestBooks(type: .new(keyword: searchText))
            searchHistoryPresenter.saveKeyword(searchText)
            searchBar.resignFirstResponder()
        }
    }
    
    @objc func hideKeyboardBarButtonTapped() {
        searchBar.endEditing(true)
    }
}
