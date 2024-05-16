import UIKit

final class SearchGuideView: BaseView {
    // MARK: - UI
    private let searchGuideImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: UIConstant.SFSymbol.booksVerticalCircle)?
            .colored(with: .black)
        
        return imageView
    }()
    
    private lazy var searchGuideText: UILabel = {
        let label: UILabel = .init()
        label.text = "찾고싶은 책의 이름을 검색해주세요!"
        label.textColor = .black
        
        return label
    }()
    
    // MARK: - Method
    override func setHierarchy() {
        addSubviews(searchGuideImageView, searchGuideText)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(
            searchGuideImageView,
            searchGuideText)
        
        NSLayoutConstraint.activate([
            searchGuideImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchGuideImageView.centerYAnchor.constraint(
                equalTo: centerYAnchor,
                constant: -50),
            searchGuideImageView.widthAnchor.constraint(equalToConstant: 200),
            searchGuideImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            searchGuideText.topAnchor.constraint(
                equalTo: searchGuideImageView.bottomAnchor,
                constant: 50),
            searchGuideText.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
