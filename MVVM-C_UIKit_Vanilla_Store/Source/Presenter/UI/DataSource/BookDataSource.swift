import UIKit

final class BookDataSource: NSObject, DataSourceProtocol {
    typealias Entity = Book
    
    // MARK: - Property
    private weak var delegate: DataSourceDelegate?
    private(set) var currentLoadPage: UInt
    private var searchKeyword: String
    private(set) var hasMoreData: Bool
    
    var entities: [Entity] {
        didSet {
            delegate?.entitiesDidUpdate()
        }
    }
    
    // MARK: - Initializer
    init(entities: [Book] = []) {
        self.entities = entities
        
        self.currentLoadPage = 1
        self.searchKeyword = ""
        self.hasMoreData = true
    }
    
    // MARK: - Method
    func searchNewBooks(keyword: String) async {
        self.searchKeyword = keyword
        clearEntities()
        resetLoadPage()
    }
    
    func getBook(at index: Int) throws -> Book {
        guard let entity = entities.element(at: index) else {
            throw DataSourceError.findEntityFailed(entityName: "책")
        }
        
        return entity
    }
}

// MARK: - Private
private extension BookDataSource {
    func increaseLoadPage() {
        self.currentLoadPage += 1
    }
    
    func clearEntities() {
        self.entities.removeAll()
    }
    
    func resetLoadPage() {
        self.currentLoadPage = 1
    }
}

// MARK: Set Dependency
extension BookDataSource {
    func setDelegate(_ delegate: DataSourceDelegate) {
        self.delegate = delegate
    }
    
    func setTableViewDataSourceAsSelf(to tableView: BaseTableView) {
        tableView.dataSource = self
    }
    
    func setCollectionViewDataSourceAsSelf(to collectionView: BaseCollectionView) {
        collectionView.dataSource = self
    }
}

// MARK: - DataSource
extension BookDataSource: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return entities.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let bookCell = tableView.dequeueCell(
                BookTableCell.self,
                for: indexPath) as? BookTableCell
        else {
            return tableView.dequeueCell(UITableViewCell.self, for: indexPath)
        }
        
        guard let book = entity(at: indexPath.row) else {
            return bookCell
        }
        
        bookCell.book = book
        
        return bookCell
    }
}

extension BookDataSource: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return entities.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let bookCell = collectionView.dequeueCell(
                BookCollectionCell.self,
                for: indexPath) as? BookCollectionCell
        else {
            return collectionView.dequeueCell(UICollectionViewCell.self, for: indexPath)
        }
        
        guard let book = entity(at: indexPath.row) else {
            return bookCell
        }
        
        bookCell.book = book
        
        return bookCell
    }
}
