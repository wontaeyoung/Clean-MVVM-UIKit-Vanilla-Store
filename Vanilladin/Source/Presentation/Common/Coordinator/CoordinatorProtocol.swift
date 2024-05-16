import UIKit

protocol CoordinatorProtocol: AnyObject, DependencyContainable {
    // MARK: - Property
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [CoordinatorProtocol] { get set }
    
    // MARK: - Initializer
    init(
        _ navigationController: UINavigationController,
        childCoordinators: [CoordinatorProtocol]
    )
    
    // MARK: - Method
    @MainActor func start()
    @MainActor func end()
    @MainActor func push(_ viewController: BaseViewController)
    @MainActor func pop()
    @MainActor func dismissModal()
    @MainActor func emptyOut()
    @MainActor func handle(error: Error)
}

extension CoordinatorProtocol {
    func end() {
        unregisterAllCoordinators()
        childCoordinators.removeAll()
        delegate?.coordinatorDidEnd(self)
    }
    
    @MainActor 
    func push(_ viewController: BaseViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    @MainActor 
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    @MainActor 
    func dismissModal() {
        navigationController.dismiss(animated: true)
    }
    
    @MainActor 
    func emptyOut() {
        navigationController.viewControllers.removeAll()
    }
    
    func showAlert(
        title: String,
        message: String,
        okTitle: String,
        cancelTitle: String,
        action: @escaping () -> Void
    ) {
        let alertController: UIAlertController = .init(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let okAction: UIAlertAction = .init(
            title: okTitle,
            style: .destructive
        ) { _ in
            action()
        }
        
        let cancelAction: UIAlertAction = .init(
            title: cancelTitle,
            style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.navigationController.present(alertController, animated: true)
        }
    }
    
    func handle(error: Error) {
        guard let appError = error as? AppErrorProtocol else {
            showErrorAlert(error: CoordinatorError.undefiendError)
            return
        }
        
        showErrorAlert(error: appError)
    }
}

private extension CoordinatorProtocol {
    func showErrorAlert(error: AppErrorProtocol) {
        let alertController: UIAlertController = .init(
            title: "오류 발생",
            message: error.errorDescription,
            preferredStyle: .alert)
        
        let okAction: UIAlertAction = .init(
            title: "확인",
            style: .default)
        
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.navigationController.present(alertController, animated: true)
        }
    }
    
    func unregisterAllCoordinators() {
        for coordinator in childCoordinators {
            DependencyContainer.shared.unregister(instance: coordinator)
        }
    }
}
