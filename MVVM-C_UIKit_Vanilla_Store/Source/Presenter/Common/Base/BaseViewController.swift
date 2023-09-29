import UIKit

class BaseViewController: UIViewController, DependencyContainable {
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("NSCoding initializer")
    }
    
    // MARK: - Method
    @MainActor func setAttribute() { }
    @MainActor func setHierarchy() { }
    @MainActor func setConstraint() { }
    @MainActor func completeUIConfiguration() { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setAttribute()
        setHierarchy()
        setConstraint()
        completeUIConfiguration()
    }
}
