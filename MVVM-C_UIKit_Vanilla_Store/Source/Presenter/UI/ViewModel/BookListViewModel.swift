final class BookListViewModel: ViewModelProtocol {
    enum ListType {
        case table
        case collection
    }
    
    // MARK: - Property
    private weak var coordinator: BookCoordinator?
    private let dataSource: BookDataSource
    private(set) var listType: ListType
    
    // MARK: - Initializer
    init(
        coordinator: BookCoordinator? = nil,
        bookDataSource: BookDataSource
    ) {
        self.coordinator = coordinator
        self.dataSource = bookDataSource
        self.listType = .table
    }
    
    // MARK: - Method
    func setDataSourceDelegate(_ delegate: DataSourceDelegate) {
        dataSource.setDelegate(delegate)
    }
    
    func setTableViewDataSource(to tableView: BaseTableView) {
        dataSource.setTableViewDataSourceAsSelf(to: tableView)
    }
    
    func setCollectionViewDataSource(to collectionView: BaseCollectionView) {
        dataSource.setCollectionViewDataSourceAsSelf(to: collectionView)
    }
    
    func toggleListType() -> ListType {
        if listType == .table {
            listType = .collection
        } else {
            listType = .table
        }
        
        return listType
    }
    
    func showBookDetailView(at index: Int) async {
        do {
            let bookInfo: (book: Book, bookDetail: BookDetail) = try await dataSource.requestBookDetail(at: index)
            
            let detailViewController: BookDetailViewController = await .init(
                book: bookInfo.book,
                bookDetail: bookInfo.bookDetail,
                bookDetailViewModel: try DependencyContainer.shared.resolve())
            
            coordinator?.push(detailViewController)
        } catch {
            coordinator?.handle(error: error)
        }
    }
}
