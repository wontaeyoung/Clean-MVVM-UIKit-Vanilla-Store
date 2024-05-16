import UIKit

protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidEnd(_ childCoordinator: CoordinatorProtocol)
}
