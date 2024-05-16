import UIKit

final class MyBookTableCell: BaseTableViewCell {
    // MARK: - Property
    var myBook: MyBook? {
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
    
    private lazy var starRatingView: MyBookRatingView = .init(starScore: myBook?.score ?? .noScore)
    
    private lazy var infoStackView: UIStackView = {
        let stackView: UIStackView = .init(
            arrangedSubviews: [
                titleLabel,
                authorLabel,
                starRatingView
            ]
        )
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    // MARK: - Method
    override func setAttribute() {
        bookImageView.image = myBook?.cover
        titleLabel.attributedText = myBook?.title.attributedTitleText
        authorLabel.text = myBook?.author
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
