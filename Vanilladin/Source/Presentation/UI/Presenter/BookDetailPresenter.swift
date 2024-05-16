final class BookDetailPresenter: PresenterProtocol {
    // MARK: - Property
    private let dataSource: MyBookDataSource
    weak var coordinator: BookCoordinator?
    
    // MARK: - Initializer
    init(dataSource: MyBookDataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: - Method
    func saveMyBook(
        book: Book,
        isBookmark: inout Bool
    ) {
        do {
            try dataSource.saveMyBook(book: book)
            
            isBookmark = true
        } catch {
            coordinator?.handle(error: error)
        }
    }
    
    func removeMyBook(
        book: Book,
        completion: @escaping (Bool) -> Void
    ) {
        coordinator?.showAlert(
            title: UIConstant.Alert.removeMyBookTitle,
            message: UIConstant.Alert.removeMyBookMessage,
            okTitle: "확인",
            cancelTitle: "취소"
        ) { [weak self] in
            guard let self else { return }
            
            do {
                try dataSource.removeMyBook(book: book)
                
                completion(false)
            } catch {
                coordinator?.handle(error: error)
            }
        }
    }
    
    func isRegister(isbn13: String) -> Bool {
        return dataSource.isRegistered(isbn13: isbn13)
    }
}
