import UIKit

final class RatingView: BaseView {
    // MARK: - Property
    var ratingScore: Double {
        didSet {
            self.setAttribute()
        }
    }
    
    // MARK: - UI
    private let starStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.spacing = 2
        
        return stackView
    }()
    
    private let ratingLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: UIConstant.FontSize.title)
        
        return label
    }()
    
    // MARK: - Initializer
    init(ratingScore: Double) {
        self.ratingScore = ratingScore
        
        super.init(frame: .zero)
    }
    
    // MARK: - Method
    override func setAttribute() {
        setStars(ratingScore: Int(ratingScore))
        ratingLabel.text = (ratingScore / 2).string(rounded: 1)
    }
    
    override func setHierarchy() {
        addSubviews(starStackView, ratingLabel)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(starStackView, ratingLabel)
        
        NSLayoutConstraint.activate([
            starStackView.topAnchor.constraint(equalTo: self.topAnchor),
            starStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            starStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: self.topAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: starStackView.trailingAnchor, constant: 10),
            ratingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setStars(ratingScore: Int) {
        guard starStackView.arrangedSubviews.count < UIConstant.Rating.maxStarRatingCount else { return }
        
        let fullStarCount: Int = ratingScore / 2
        let hasHalfStar: Bool = ratingScore % 2 == 1
        
        for starNum in 1...UIConstant.Rating.maxStarRatingCount {
            let imageView: UIImageView = {
                let imageView: UIImageView = .init()
                imageView.contentMode = .scaleAspectFit
                
                return imageView
            }()
            
            let symbolName: String = starNum <= fullStarCount
            ? UIConstant.SFSymbol.starFill
            : hasHalfStar
            ? UIConstant.SFSymbol.starLeadinghalfFilled
            : UIConstant.SFSymbol.star
            
            imageView.image = UIImage(systemName: symbolName)?.colored(with: .systemYellow)
            
            starStackView.addArrangedSubview(imageView)
        }
    }
}
