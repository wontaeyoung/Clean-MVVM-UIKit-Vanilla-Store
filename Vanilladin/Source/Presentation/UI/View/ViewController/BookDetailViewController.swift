import UIKit

final class BookDetailViewController: BaseViewController {
    // MARK: - Property
    private let book: Book
    private let bookDetail: BookDetail
    private let bookDetailPresenter: BookDetailPresenter
    private var descriptionState: DescriptionState
    private var isBookmark: Bool {
        didSet {
            updateBookmarkImage()
        }
    }
    
    // MARK: - UI
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        return scrollView
    }()
    
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
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let authorPublisherLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: UIConstant.FontSize.description)
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let isbnLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: UIConstant.FontSize.description)
        label.numberOfLines = .zero
        label.textColor = .systemGray
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: UIConstant.FontSize.description)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var moreDescriptionButton: UIButton = {
        let button: UIButton = .init()
        button.setTitleColor(.textButtonColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: UIConstant.FontSize.description)
        button.addTarget(
            self,
            action: #selector(didTapMoreButton),
            for: .touchUpInside)
        
        return button
    }()
    
    private lazy var ratingView: RatingView = .init(bookDetail: bookDetail)
    private lazy var commentView: CommentView = .init(bookDetail: bookDetail)
    private lazy var priceView: PriceView = .init(price: book.priceSales)
    private lazy var pageView: PageView = .init(page: bookDetail.itemPage)
    private lazy var dimensionsView: DimensionsView = .init(dimensions: bookDetail.dimensions)
    
    // MARK: - Initializer
    init(
        book: Book,
        bookDetail: BookDetail,
        bookDetailPresenter: BookDetailPresenter
    ) {
        self.book = book
        self.bookDetail = bookDetail
        self.bookDetailPresenter = bookDetailPresenter
        self.descriptionState = .notDetermined
        self.isBookmark = false
        
        super.init()
        setBookmark()
    }
    
    // MARK: - Method
    override func setAttribute() {
        bookImageView.image = book.coverImage
        titleLabel.attributedText = book.title.attributedTitleText
        authorPublisherLabel.text = book.author + " - " + book.publisher
        isbnLabel.text = "ISBN" + book.isbn13
        descriptionLabel.text = book.description
    }
    
    override func setHierarchy() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(paddingView)
        
        paddingView.addSubviews(
            bookImageView,
            titleLabel,
            authorPublisherLabel,
            isbnLabel,
            descriptionLabel,
            moreDescriptionButton,
            ratingView,
            commentView,
            priceView,
            pageView,
            dimensionsView)
    }
    
    override func setConstraint() {
        view.setTranslatesAutoresizingMaskIntoConstraintsOff(
            scrollView,
            paddingView,
            bookImageView,
            titleLabel,
            authorPublisherLabel,
            isbnLabel,
            descriptionLabel,
            moreDescriptionButton,
            ratingView,
            commentView,
            priceView,
            pageView,
            dimensionsView)
        
        scrollView.setAutoLayoutAllEqualToMarginGuide(to: view, option: .vertical)
        
        NSLayoutConstraint.activate([
            paddingView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            paddingView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            paddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            paddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: paddingView.topAnchor),
            bookImageView.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor),
            bookImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            authorPublisherLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            authorPublisherLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            authorPublisherLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            isbnLabel.topAnchor.constraint(equalTo: authorPublisherLabel.bottomAnchor, constant: 10),
            isbnLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            isbnLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: isbnLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            moreDescriptionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            moreDescriptionButton.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: moreDescriptionButton.bottomAnchor, constant: 20),
            ratingView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            ratingView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 10),
            commentView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            commentView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            priceView.topAnchor.constraint(equalTo: commentView.bottomAnchor, constant: 10),
            priceView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            priceView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: priceView.bottomAnchor, constant: 10),
            pageView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            dimensionsView.topAnchor.constraint(equalTo: pageView.bottomAnchor, constant: 10),
            dimensionsView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            dimensionsView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
            dimensionsView.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor)
        ])
    }
    
    override func UIConfigurationDidComplete() {
        updateMoreButtonVisibility()
    }
}

private extension BookDetailViewController {
    enum ViewShowingState {
        case show
        case hide
    }
    
    enum DescriptionState {
        case collapsed
        case expanded
        case noMore
        case notDetermined
    }
    
    func updateMoreButtonVisibility() {
        descriptionState = descriptionLabel.isTruncated ? .collapsed : .noMore
        
        switch descriptionState {
        case .collapsed, .expanded:
            moreDescriptionButton.setTitle("펼치기", for: .normal)
            
        case .noMore, .notDetermined:
            moreDescriptionButton.isHidden = true
        }
    }
    
    @objc func didTapMoreButton() {
        switch descriptionState {
        case .collapsed:
            descriptionState = .expanded
            descriptionLabel.numberOfLines = .zero
            moreDescriptionButton.setTitle("접어두기", for: .normal)
            
        case .expanded:
            descriptionState = .collapsed
            descriptionLabel.numberOfLines = 1
            moreDescriptionButton.setTitle("펼치기", for: .normal)
            
        default:
            moreDescriptionButton.isEnabled = false
        }
    }
    
    func setBookmark() {
        self.isBookmark = bookDetailPresenter.isRegister(isbn13: book.isbn13)
    }
    
    @MainActor
    func updateBookmarkImage() {
        let Symbol = UIConstant.SFSymbol.self
        let image: UIImage? = .init(
            systemName: isBookmark
            ? Symbol.bookVerticalFill
            : Symbol.booksVertical)
        
        let barButtonItem: UIBarButtonItem = .init(
            image: image,
            style: .plain,
            target: self,
            action: #selector(didTapBookmark))
        
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func didTapBookmark() {
        switch isBookmark {
            case true:
                bookDetailPresenter.removeMyBook(book: book) { [weak self] state in
                    guard let self else { return }
                    
                    isBookmark = state
                }
                
            case false:
                bookDetailPresenter.saveMyBook(
                    book: book,
                    isBookmark: &isBookmark)
        }
    }
}
