import UIKit

class BaseTableViewCell: UITableViewCell {
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setHierarchy()
        setConstraint()
        setAttribute()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) BaseTableViewCell")
    }
    
    // MARK: - Method
    @MainActor func setHierarchy() { }
    @MainActor func setConstraint() { }
    @MainActor func setAttribute() { }
}
