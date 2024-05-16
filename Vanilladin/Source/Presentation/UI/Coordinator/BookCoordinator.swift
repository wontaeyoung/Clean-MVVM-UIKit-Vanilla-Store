import UIKit

final class BookCoordinator: CoordinatorProtocol {
    // MARK: - Stored Property
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol]
    
    // MARK: - Initializer
    init(
        _ navigationController: UINavigationController,
        childCoordinators: [CoordinatorProtocol] = []
    ) {
        self.navigationController = navigationController
        self.childCoordinators = childCoordinators
    }
    
    // MARK: - Method
    func start() {
        showSearchBook()
    }
}

// MARK: 네비게이션
extension BookCoordinator {
    @MainActor 
    func showSearchBook() {
        do {
            let container: DependencyContainer = .shared
            
            let searchPresenter: SearchBookPresenter = try container.resolve()
            let historyPresenter: SearchHistoryPresenter = try container.resolve()
            let searchBookViewController: SearchBookViewController = .init(
                searchBookPresenter: searchPresenter,
                searchHistoryPresenter: historyPresenter)
            searchPresenter.coordinator = self
            
            push(searchBookViewController)
        } catch {
            handle(error: error)
        }
    }
    
    func showSearchHistory(to searchViewController: SearchBookViewController) {
        do {
            let container: DependencyContainer = .shared
            
            let searchPresenter: SearchBookPresenter = try container.resolve()
            let historyPresenter: SearchHistoryPresenter = try container.resolve()
            let viewController: SearchHistoryViewController = .init(
                searchBookPresenter: searchPresenter,
                searchHistoryPresenter: historyPresenter)
            viewController.setDelegate(searchViewController)
            
            searchViewController.searchResultNavigationController.viewControllers = [viewController]
        } catch {
            handle(error: error)
        }
    }
    
    func showResult(searchResultNavigationController: UINavigationController) {
        do {
            let container: DependencyContainer = .shared
            
            let searchPresenter: SearchBookPresenter = try container.resolve()
            let bookListPresenter: BookListPresenter = try container.resolve()
            let viewController: BookListViewController = .init(
                searchBookPresenter: searchPresenter,
                bookListPresenter: bookListPresenter)
            bookListPresenter.coordinator = self
            
            searchResultNavigationController.pushViewController(viewController, animated: false)
        } catch {
            handle(error: error)
        }
    }
    
    @MainActor 
    func showBookDetail(
        book: Book,
        bookDetail: BookDetail
    ) {
        do {
            let presenter: BookDetailPresenter = try DependencyContainer.shared.resolve()
            presenter.coordinator = self
            
            let viewController: BookDetailViewController = .init(
                book: book,
                bookDetail: bookDetail,
                bookDetailPresenter: presenter)
            
            push(viewController)
        } catch {
            handle(error: error)
        }
    }
}
