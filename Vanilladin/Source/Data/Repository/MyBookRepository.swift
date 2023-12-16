final class MyBookRepository: MyBookRepositoryInterface {
    // MARK: - Property
    private let aladinService: AladinService
    private let coreDataService: CoreDataService
    
    // MARK: - Initializer
    init(
        aladinService: AladinService,
        coreDataService: CoreDataService
    ) {
        self.aladinService = aladinService
        self.coreDataService = coreDataService
    }
    
    // MARK: - Method
    func save(myBookDTO: MyBookDTO) throws {
        try coreDataService.saveMyBook(myBookDTO: myBookDTO)
    }
    
    func fetch(isbn13: String) throws -> MyBookDTO {
        return try coreDataService.fetchMyBook(isbn13: isbn13)
    }
    
    func fetch() throws -> [MyBookDTO] {
        return try coreDataService.fetchMyBooks()
    }
}
