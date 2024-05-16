import UIKit

final class BookCollectionCell: BaseCollectionViewCell {
    // MARK: - Property
    var book: Book? {
        didSet {
            self.setAttribute()
        }
    }
    
    // MARK: - UI
    private let paddingView: UIView = .init()
    
    private let bookImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: UIConstant.FontSize.title)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: UIConstant.FontSize.description)
        
        return label
    }()
    
    private let publisherLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: UIConstant.FontSize.description)
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: UIConstant.FontSize.description)
        
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [
            titleLabel,
            authorLabel,
            publisherLabel,
            priceLabel
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        return stackView
    }()
    
    // MARK: - Method
    override func setAttribute() {
        bookImageView.image = book?.coverImage
        titleLabel.attributedText = book?.title.attributedTitleText
        authorLabel.text = book?.author
        publisherLabel.text = book?.publisher
        priceLabel.text = (book?.priceSales.asPriceFormat ?? "-") + "원"
    }
    
    override func setHierarchy() {
        contentView.addSubview(paddingView)
        paddingView.addSubviews(bookImageView, infoStackView)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(
            paddingView,
            bookImageView,
            infoStackView
        )
        
        paddingView.setPaddingAutoLayout(to: contentView, padding: 10)
        
        NSLayoutConstraint.activate([
            bookImageView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            bookImageView.topAnchor.constraint(equalTo: paddingView.topAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
            infoStackView.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 10),
            infoStackView.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor),
        ])
    }
}
