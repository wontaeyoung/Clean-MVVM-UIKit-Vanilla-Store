import UIKit

final class RatingView: BaseView {
    // MARK: - Property
    private let bookDetail: BookDetail 
    
    // MARK: - UI
    private let starStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.spacing = 2
        
        return stackView
    }()
    
    private let ratingCountLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: UIConstant.FontSize.title)
        label.numberOfLines = .zero
        
        return label
    }()
    
    // MARK: - Initializer
    init(bookDetail: BookDetail) {
        self.bookDetail = bookDetail
        
        super.init(frame: .zero)
    }
    
    // MARK: - Method
    override func setAttribute() {
        setStars(ratingScore: Int(bookDetail.ratingScore))
        ratingCountLabel.text = "(\(bookDetail.ratingCount.description))"
    }
    
    override func setHierarchy() {
        addSubviews(starStackView, ratingCountLabel)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(starStackView, ratingCountLabel)
        
        NSLayoutConstraint.activate([
            starStackView.topAnchor.constraint(equalTo: self.topAnchor),
            starStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            starStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ratingCountLabel.topAnchor.constraint(equalTo: self.topAnchor),
            ratingCountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ratingCountLabel.leadingAnchor.constraint(equalTo: starStackView.trailingAnchor, constant: 10)
        ])
    }
}

// MARK: - Private
private extension RatingView {
    func setStars(ratingScore: Int) {
        guard starStackView.arrangedSubviews.count < UIConstant.Rating.maxStarRatingCount else {
            return
        }
        
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
