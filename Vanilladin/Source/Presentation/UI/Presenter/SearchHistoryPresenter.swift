final class SearchHistoryPresenter: PresenterProtocol {
    // MARK: - Property
    private let dataSource: SearchHistoryDataSource
    
    // MARK: - Initializer
    init(dataSource: SearchHistoryDataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: - Method
    func setDataSourceDelegate(_ delegate: DataSourceDelegate) {
        dataSource.setDelegate(delegate)
    }
    
    func setTableViewDataSource(to tableView: BaseTableView) {
        dataSource.setTableViewDataSourceAsSelf(to: tableView)
    }
    
    func saveKeyword(_ keyword: String) {
        dataSource.updateKeyword(type: .save(keyword: keyword))
    }
    
    func removeKeyword(_ index: Int) {
        dataSource.updateKeyword(type: .remove(index: index))
    }
    
    func removeAllKeywords() {
        dataSource.updateKeyword(type: .clearAll)
    }
    
    func getKeyword(at index: Int) -> String? {
        return dataSource.getKeyword(at: index)
    }
}
