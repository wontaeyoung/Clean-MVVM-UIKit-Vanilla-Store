import UIKit

final class CommentView: BaseView {
    // MARK: - Property
    private let bookDetail: BookDetail
    
    // MARK: - UI
    private let commentImage: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: UIConstant.SFSymbol.textBubble)?
            .colored(with: .black)
        
        return imageView
    }()
    
    private let commentCountLabel: UILabel = {
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
        commentCountLabel.text = "(\(bookDetail.commentReviewCount.description))"
    }
    
    override func setHierarchy() {
        addSubviews(commentImage, commentCountLabel)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(commentImage, commentCountLabel)
        
        NSLayoutConstraint.activate([
            commentImage.topAnchor.constraint(equalTo: self.topAnchor),
            commentImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            commentImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            commentImage.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            commentCountLabel.topAnchor.constraint(equalTo: self.topAnchor),
            commentCountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            commentCountLabel.leadingAnchor.constraint(equalTo: commentImage.trailingAnchor, constant: 10),
        ])
    }
}
