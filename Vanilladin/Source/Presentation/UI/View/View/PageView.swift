import UIKit

final class PageView: BaseView {
    // MARK: - Property
    private let page: Int
    
    // MARK: - UI
    private let pageImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: UIConstant.SFSymbol.bookPages)?
            .colored(with: .black)
        
        return imageView
    }()
    
    private let pageValueLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: UIConstant.FontSize.title)
        label.numberOfLines = .zero
        
        return label
    }()
    
    // MARK: - Initializer
    init(page: Int) {
        self.page = page
        
        super.init(frame: .zero)
    }
    
    // MARK: - Method
    override func setAttribute() {
        pageValueLabel.text = page.description + "쪽"
    }
    
    override func setHierarchy() {
        addSubviews(pageImageView, pageValueLabel)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(pageImageView, pageValueLabel)
        
        NSLayoutConstraint.activate([
            pageImageView.topAnchor.constraint(equalTo: self.topAnchor),
            pageImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pageImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pageImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            pageValueLabel.topAnchor.constraint(equalTo: self.topAnchor),
            pageValueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pageValueLabel.leadingAnchor.constraint(equalTo: self.pageImageView.trailingAnchor, constant: 10)
        ])
    }
}
