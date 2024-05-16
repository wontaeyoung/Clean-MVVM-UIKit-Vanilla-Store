import UIKit

final class DimensionsView: BaseView {
    // MARK: - Property
    private let dimensions: BookDetail.Dimensions
    
    // MARK: - UI
    private let rulerImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: UIConstant.SFSymbol.ruler)?
            .colored(with: .black)
        
        return imageView
    }()
    
    private let dimensionsValueLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: UIConstant.FontSize.title)
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let scalemassImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: UIConstant.SFSymbol.scalemass)?
            .colored(with: .black)
        
        return imageView
    }()
    
    private let weightValueLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: UIConstant.FontSize.title)
        label.numberOfLines = .zero
        
        return label
    }()
    
    // MARK: - Initializer
    init(dimensions: BookDetail.Dimensions) {
        self.dimensions = dimensions
        
        super.init(frame: .zero)
    }
    
    // MARK: - Method
    override func setAttribute() {
        dimensionsValueLabel.text = "W(\(dimensions.width)) x H(\(dimensions.height)) x D(\(dimensions.depth))mm"
        weightValueLabel.text = "\(dimensions.weight)g"
    }
    
    override func setHierarchy() {
        addSubviews(
            rulerImageView,
            dimensionsValueLabel,
            scalemassImageView,
            weightValueLabel)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(
            rulerImageView,
            dimensionsValueLabel,
            scalemassImageView,
            weightValueLabel)
        
        NSLayoutConstraint.activate([
            rulerImageView.topAnchor.constraint(equalTo: self.topAnchor),
            rulerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            rulerImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            dimensionsValueLabel.topAnchor.constraint(equalTo: self.topAnchor),
            dimensionsValueLabel.leadingAnchor.constraint(equalTo: self.rulerImageView.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            scalemassImageView.topAnchor.constraint(equalTo: rulerImageView.bottomAnchor, constant: 10),
            scalemassImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scalemassImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scalemassImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            weightValueLabel.topAnchor.constraint(equalTo: scalemassImageView.topAnchor),
            weightValueLabel.leadingAnchor.constraint(equalTo: self.scalemassImageView.trailingAnchor, constant: 10)
        ])
    }
}
