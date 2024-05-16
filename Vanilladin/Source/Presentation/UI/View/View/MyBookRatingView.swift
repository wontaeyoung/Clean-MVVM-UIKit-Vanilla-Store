import UIKit

final class MyBookRatingView: BaseView {
    // MARK: - Property
    private let starScore: MyBook.StarScore
    
    // MARK: - UI
    private let starStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.spacing = 2
        
        return stackView
    }()
    
    // MARK: - Initializer
    init(starScore: MyBook.StarScore) {
        self.starScore = starScore
        
        super.init(frame: .zero)
    }
    
    // MARK: - Method
    override func setAttribute() {
        setStars()
    }
    
    override func setHierarchy() {
        addSubviews(starStackView)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(starStackView)
        
        NSLayoutConstraint.activate([
            starStackView.topAnchor.constraint(equalTo: self.topAnchor),
            starStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            starStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}

// MARK: - Private
private extension MyBookRatingView {
    func setStars() {
        guard starStackView.arrangedSubviews.count < UIConstant.Rating.maxStarRatingCount else {
            return
        }
        
        for starNum in 1...UIConstant.Rating.maxStarRatingCount {
            let imageView: UIImageView = {
                let imageView: UIImageView = .init()
                imageView.contentMode = .scaleAspectFit
                
                return imageView
            }()
            
            let symbolName: String = starNum <= starScore.rawValue
            ? UIConstant.SFSymbol.starFill
            : UIConstant.SFSymbol.star
            
            imageView.image = UIImage(systemName: symbolName)?.colored(with: .systemYellow)
            
            starStackView.addArrangedSubview(imageView)
        }
    }
}
