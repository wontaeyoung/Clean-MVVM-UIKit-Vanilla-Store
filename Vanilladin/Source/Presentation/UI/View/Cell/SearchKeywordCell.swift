import UIKit

final class SearchKeywordCell: BaseTableViewCell {
    // MARK: - Property
    var keyword: String? {
        didSet {
            self.setAttribute()
        }
    }
    
    var deleteAction: (() -> Void)?
    
    // MARK: - UI
    private let paddingView: UIView = .init()
    
    private let keywordLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: UIConstant.FontSize.description)
        
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button: UIButton = .init(type: .system)
        let buttonImage = UIImage(systemName: UIConstant.SFSymbol.xMark)?
            .withTintColor(.gray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium))
        
        button.setImage(buttonImage, for: .normal)
        button.addTarget(
            self,
            action: #selector(deleteButtonDidTap),
            for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Method
    override func setAttribute() {
        keywordLabel.text = keyword
    }
    
    override func setHierarchy() {
        contentView.addSubview(paddingView)
        paddingView.addSubviews(keywordLabel, deleteButton)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(paddingView, keywordLabel, deleteButton)

        paddingView.setPaddingAutoLayout(to: contentView, horizontal: 20)
        
        NSLayoutConstraint.activate([
            keywordLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            keywordLabel.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 44),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc private func deleteButtonDidTap() {
        deleteAction?()
    }
}
