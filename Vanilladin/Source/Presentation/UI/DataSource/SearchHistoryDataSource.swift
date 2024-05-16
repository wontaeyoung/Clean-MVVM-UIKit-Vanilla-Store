import UIKit

final class SearchHistoryDataSource: NSObject, DependencyContainable {
    enum KeywordUpdateType {
        case save(keyword: String)
        case remove(index: Int)
        case clearAll
    }
    
    // MARK: - Property
    private let searchKeywordRepository: SearchKeywordRepositoryInterface
    private weak var delegate: DataSourceDelegate?
    private var keywords: [String] {
        return searchKeywordRepository.keywords
    }
    
    // MARK: - Initializer
    init(searchKeywordRepository: SearchKeywordRepository) {
        self.searchKeywordRepository = searchKeywordRepository
    }
    
    // MARK: - Method
    func getKeyword(at index: Int) -> String? {
        return keywords.element(at: index)
    }
    
    func updateKeyword(type: KeywordUpdateType) {
        switch type {
        case let .save(keyword):
            searchKeywordRepository.saveKeyword(keyword)
            
        case let .remove(index):
            searchKeywordRepository.removeKeyword(at: index)
            
        case .clearAll:
            searchKeywordRepository.clearKeywords()
        }
        
        delegate?.entitiesDidUpdate()
    }
}

// MARK: - Private
private extension SearchHistoryDataSource {
    func saveKeyword(_ keyword: String) {
        searchKeywordRepository.saveKeyword(keyword)
    }
    
    func removeKeyword(at index: Int) {
        searchKeywordRepository.removeKeyword(at: index)
    }
    
    func clearKeywords() {
        searchKeywordRepository.clearKeywords()
    }
}

// MARK: - Set Dependency
extension SearchHistoryDataSource {
    func setDelegate(_ delegate: DataSourceDelegate) {
        self.delegate = delegate
    }
    
    func setTableViewDataSourceAsSelf(to tableView: BaseTableView) {
        tableView.dataSource = self
    }
}

// MARK: - Table DataSource
extension SearchHistoryDataSource: UITableViewDataSource {
    // Cell 갯수 설정
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return keywords.count
    }
    
    // Cell 생성 및 재사용
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let keywordCell: SearchKeywordCell = tableView.dequeueCell(
                SearchKeywordCell.self,
                for: indexPath) as? SearchKeywordCell
        else {
            return tableView.dequeueCell(UITableViewCell.self, for: indexPath)
        }
        
        guard let keyword: String = keywords.element(at: indexPath.row) else {
            return keywordCell
        }
        
        keywordCell.keyword = keyword
        
        keywordCell.deleteAction = { [weak self] in
            guard let self else {
                return
            }
            
            updateKeyword(type: .remove(index: indexPath.row))
        }
        
        return keywordCell
    }
}
