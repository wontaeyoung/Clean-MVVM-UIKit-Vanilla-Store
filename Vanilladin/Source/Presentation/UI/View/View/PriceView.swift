import UIKit

final class PriceView: BaseView {
    // MARK: - Property
    private let price: Int
    
    // MARK: - UI
    private let priceImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: UIConstant.SFSymbol.wonsignSquare)?
            .colored(with: .black)
        
        return imageView
    }()
    
    private let priceTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: UIConstant.FontSize.title)
        label.numberOfLines = .zero
        label.text = "판매가"
        
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: UIConstant.FontSize.title)
        label.numberOfLines = .zero
        
        return label
    }()
    
    // MARK: - Initializer
    init(price: Int) {
        self.price = price
        
        super.init(frame: .zero)
    }
    
    // MARK: - Method
    override func setAttribute() {
        priceValueLabel.text = "₩" + price.asPriceFormat
    }
    
    override func setHierarchy() {
        addSubviews(priceImageView, priceValueLabel)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(priceImageView, priceValueLabel)
        
        NSLayoutConstraint.activate([
            priceImageView.topAnchor.constraint(equalTo: self.topAnchor),
            priceImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            priceImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            priceImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            priceValueLabel.topAnchor.constraint(equalTo: self.topAnchor),
            priceValueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            priceValueLabel.leadingAnchor.constraint(equalTo: priceImageView.trailingAnchor, constant: 10)
        ])
    }
}
