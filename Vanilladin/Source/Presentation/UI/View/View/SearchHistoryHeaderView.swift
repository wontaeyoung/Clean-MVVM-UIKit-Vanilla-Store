import UIKit

final class SearchHistoryHeaderView: BaseView {
    // MARK: - Property
    let clearAction: (() -> Void)
    
    // MARK: - UI
    private let paddingView: UIView = .init()
    
    private let recentSearchHeaderTitle: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: UIConstant.FontSize.title)
        label.textColor = .black
        label.numberOfLines = 1
        label.text = "최근 검색"
        
        return label
    }()
    
    private lazy var clearKeywordButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.textButtonColor, for: .normal)
        button.addTarget(
            self,
            action: #selector(clearButtonDidTapped),
            for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Initializer
    init(clearAction: @escaping () -> Void) {
        self.clearAction = clearAction
        
        super.init(frame: .zero)
    }
    
    // MARK: - Method
    override func setHierarchy() {
        addSubview(paddingView)
        paddingView.addSubviews(recentSearchHeaderTitle, clearKeywordButton)
    }
    
    override func setConstraint() {
        setTranslatesAutoresizingMaskIntoConstraintsOff(
            paddingView,
            recentSearchHeaderTitle,
            clearKeywordButton)
        
        paddingView.setPaddingAutoLayout(to: self, horizontal: 20)
        
        NSLayoutConstraint.activate([
            recentSearchHeaderTitle.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            recentSearchHeaderTitle.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clearKeywordButton.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
            clearKeywordButton.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor)
        ])
    }
    
    @objc private func clearButtonDidTapped() {
        clearAction()
    }
}
