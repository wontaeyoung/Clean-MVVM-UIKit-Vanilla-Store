import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setHierarchy()
        setConstraint()
        setAttribute()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) BaseCollectionViewCell")
    }
    
    // MARK: - Method
    @MainActor func setHierarchy() { }
    @MainActor func setConstraint() { }
    @MainActor func setAttribute() { }
}

