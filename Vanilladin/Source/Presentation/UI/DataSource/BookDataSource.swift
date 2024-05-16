import UIKit

final class BookDataSource: NSObject, DataSourceProtocol {
    typealias Entity = Book
    
    // MARK: - Property
    private let bookRepository: BookRepositoryInterface
    private weak var delegate: DataSourceDelegate?
    private var searchKeyword: String
    private(set) var currentLoadPage: UInt
    private(set) var hasMoreData: Bool
    
    var entities: [Entity] {
        didSet {
            delegate?.entitiesDidUpdate()
        }
    }
    
    // MARK: - Initializer
    init(
        bookRepository: BookRepositoryInterface,
        entities: [Book] = []
    ) {
        self.bookRepository = bookRepository
        self.entities = entities
        
        self.searchKeyword = ""
        self.currentLoadPage = 0
        self.hasMoreData = true
    }
    
    // MARK: - Method
    func searchNewBooks(keyword: String) async throws {
        setNewKeyword(keyword)
        clearEntities()
        resetLoadPage()
        try await requestBooks()
    }
    
    func requestBooks() async throws {
        increaseLoadPage()
        let books: (totalItem: UInt, data: [Book]) = try await fetchBooksData()
        updateEntities(with: books.data)
        checkMoreData(totalItem: books.totalItem)
    }
    
    func requestBookDetail(at index: Int) async throws -> (Book, BookDetail) {
        let book: Book = try getBook(at: index)
        
        guard book.isbn13.isEmpty == false else {
            throw DataSourceError.noISBN13
        }
        
        let bookDetail: BookDetail = try await bookRepository.fetchBookDetail(isbn13: book.isbn13)
        
        return (book, bookDetail)
    }
}

// MARK: - Private
private extension BookDataSource {
    func increaseLoadPage() {
        self.currentLoadPage += 1
    }
    
    func setNewKeyword(_ keyword: String) {
        self.searchKeyword = keyword
    }
    
    func clearEntities() {
        self.entities.removeAll()
    }
    
    func resetLoadPage() {
        self.currentLoadPage = 0
    }
    
    func fetchBooksData() async throws -> (totalItem: UInt, data: [Book]) {
        return try await bookRepository.fetchBooks(
            keyword: searchKeyword,
            page: currentLoadPage)
    }
    
    func updateEntities(with books: [Book]) {
        entities.append(contentsOf: books)
    }
    
    func checkMoreData(totalItem: UInt) {
        guard let itemsPerPage = UInt(AladinAPIConstant.ItemSearch.maxResults) else {
            self.hasMoreData = false
            return
        }
        
        self.hasMoreData = (totalItem > currentLoadPage * itemsPerPage)
    }
    
    func getBook(at index: Int) throws -> Book {
        guard let entity = entities.element(at: index) else {
            throw DataSourceError.findEntityFailed(entityName: "책")
        }
        
        return entity
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
        guard let bookCell = tableView.dequeueCell(
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
        guard let bookCell = collectionView.dequeueCell(
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
