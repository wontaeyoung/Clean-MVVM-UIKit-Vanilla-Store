import UIKit

final class SelectListTypeView: BaseView {
    // MARK: - Property
    var toggleAction: (() -> Void)?
    
    // MARK: - UI
    private lazy var selectTypeSegment: UISegmentedControl = {
        let listImage: UIImage? = .init(systemName: UIConstant.SFSymbol.listBullet)
        let gridImage: UIImage? = .init(systemName: UIConstant.SFSymbol.tableCellsFill)
        let items: [Any?] = [listImage, gridImage]
        
        let control: UISegmentedControl = .init(items: items as [Any])
        control.selectedSegmentIndex = .zero
        control.addTarget(
            self,
            action: #selector(segmentedControlChanged),
            for: .valueChanged)
        
        return control
    }()
    
    // MARK: - Method
    override func setHierarchy() {
        addSubview(selectTypeSegment)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(selectTypeSegment)
        
        NSLayoutConstraint.activate([
            selectTypeSegment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            selectTypeSegment.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    @objc func segmentedControlChanged() {
        toggleAction?()
    }
}
