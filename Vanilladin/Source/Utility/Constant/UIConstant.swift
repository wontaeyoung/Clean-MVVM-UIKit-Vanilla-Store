import UIKit

enum UIConstant {
    enum DeviceSize {
        static let width: CGFloat = UIScreen.main.bounds.size.width
        static let height: CGFloat = UIScreen.main.bounds.size.height
    }
    
    enum FontSize {
        static let title: CGFloat = 15.0
        static let description: CGFloat = 13.0
    }
    
    enum SFSymbol {
        static let xMark: String = "xmark"
        static let textBookClosedFill: String = "text.book.closed.fill"
        static let listBullet: String = "list.bullet"
        static let tableCellsFill: String = "tablecells.fill"
        static let star: String = "star"
        static let starFill: String = "star.fill"
        static let starLeadinghalfFilled: String = "star.leadinghalf.filled"
        static let rectangleAndPencilAndEllipsis: String = "rectangle.and.pencil.and.ellipsis"
        static let textBubble: String = "text.bubble"
        static let wonsignSquare: String = "wonsign.square"
        static let bookPages: String = "book.pages"
        static let ruler: String = "ruler"
        static let scalemass: String = "scalemass"
        static let booksVerticalCircle: String = "books.vertical.circle"
        static let keyboardChevronCompactDown: String = "keyboard.chevron.compact.down"
        static let booksVertical: String = "books.vertical"
        static let bookVerticalFill: String = "books.vertical.fill"
    }
    
    enum Rating {
        static let maxStarRatingCount: Int = 5
    }
    
    enum Alert {
        static let removeMyBookTitle: String = "내 서재에서 꺼내기"
        static let removeMyBookMessage: String = "내 서재에서 책을 꺼내면 메모한 내용이 삭제됩니다. 정말 꺼내시겠어요?"
    }
}
