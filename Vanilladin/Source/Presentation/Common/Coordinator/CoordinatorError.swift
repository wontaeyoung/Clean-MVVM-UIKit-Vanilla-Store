enum CoordinatorError: AppErrorProtocol {
    case undefiendError
    
    var errorDescription: String {
        switch self {
        case .undefiendError:
            return "정의되지 않은 에러입니다. 다시 시도해주세요."
        }
    }
}
