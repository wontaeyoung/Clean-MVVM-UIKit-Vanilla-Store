import UIKit

final class BookTableCell: BaseTableViewCell {
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
        label.font = .systemFont(ofSize: UIConstant.FontSize.description)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let publisherLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: UIConstant.FontSize.description)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: UIConstant.FontSize.description)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView: UIStackView = .init(
            arrangedSubviews: [
                titleLabel,
                authorLabel,
                publisherLabel,
                priceLabel
            ]
        )
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
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
        setTranslatesAutoresizingMaskIntoConstraintsOff(paddingView, bookImageView, infoStackView)
        
        paddingView.setAutoLayoutAllEqualToMarginGuide(to: contentView, option: .all)
        paddingView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        NSLayoutConstraint.activate([
            bookImageView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            bookImageView.topAnchor.constraint(equalTo: paddingView.topAnchor),
            bookImageView.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor),
            bookImageView.widthAnchor.constraint(equalTo: paddingView.widthAnchor, multiplier: 0.25),
        ])
        
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 10),
            infoStackView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
            infoStackView.topAnchor.constraint(equalTo: paddingView.topAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor),
        ])
    }
}
