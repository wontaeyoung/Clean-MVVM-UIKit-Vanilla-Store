final class DependencyContainer: DependencyContainerProtocol {
    // MARK: - Property
    static let shared: DependencyContainer = .init()
    private var registry: [ObjectIdentifier: DependencyContainable] = [:]
    
    // MARK: - Initializer
    private init() { }
    
    // MARK: - Method
    func register<T: DependencyContainable>(instance: T) {
        let key: ObjectIdentifier = .init(T.self)
        
        registry.updateValue(instance, forKey: key)
    }
    
    func resolve<T: DependencyContainable>() throws -> T {
        let key: ObjectIdentifier = .init(T.self)
        
        guard let instance: T = registry[key] as? T else {
            throw DependencyContainerError.instanceNotRegistered
        }
        
        return instance
    }
    
    func unregister<T: DependencyContainable>(instance: T) {
        let key: ObjectIdentifier = .init(T.self)
        
        registry.removeValue(forKey: key)
    }
    /**
     App 내에서 사용하는 Module이 추가되면 함수 내에서 인스턴스 생성 + modules 배열에 추가가 필요합니다.
     
     DependencyModules 열거형 케이스를 전달받아서 자동으로 추가하는 방법을 구현 시도했으나, 인스턴스 초기화 의존성을 추상화하지 못해서 폐기되었습니다.
     */
    func setDependency() {
        // MARK: - InfraStructure
        let httpClient: HTTPClient = .init()
        let aladinService: AladinService = .init(httpClient: httpClient)
        let coreDataService: CoreDataService = .init()
        
        // MARK: - Repository
        let bookRepository: BookRepository = .init(aladinService: aladinService)
        let searchKeywordRepository: SearchKeywordRepository = .init(userDefault: .standard)
        let myBookRepository: MyBookRepository = .init(
            aladinService: aladinService,
            coreDataService: coreDataService)
        
        // MARK: - DataSource
        let bookDataSource: BookDataSource = .init(bookRepository: bookRepository)
        let searchHistoryDataSource: SearchHistoryDataSource = .init(searchKeywordRepository: searchKeywordRepository)
        let myBookDataSource: MyBookDataSource = .init(myBookRepository: myBookRepository)
        
        // MARK: - Presenter
        let bookListPresenter: BookListPresenter = .init(bookDataSource: bookDataSource)
        let searchHistoryPresenter: SearchHistoryPresenter = .init(dataSource: searchHistoryDataSource)
        let searchBookPresenter: SearchBookPresenter = .init(dataSource: bookDataSource)
        let bookDetailPresenter: BookDetailPresenter = .init(dataSource: myBookDataSource)
        
        let modules: [DependencyContainable] = [
            // MARK: - InfraStructure
            httpClient,
            aladinService,
            coreDataService,
            
            // MARK: - Repository
            bookRepository,
            searchKeywordRepository,
            myBookRepository,
            
            // MARK: - DataSource
            bookDataSource,
            searchHistoryDataSource,
            
            // MARK: - Presenter
            bookListPresenter,
            searchHistoryPresenter,
            searchBookPresenter,
            bookDetailPresenter
        ]
        
        modules.forEach { module in
            register(instance: module)
        }
    }
}
