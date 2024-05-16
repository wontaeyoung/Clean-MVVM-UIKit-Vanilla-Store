enum PresenterError: AppErrorProtocol {
    case requestFailed
    
    var errorDescription: String {
        switch self {
        case .requestFailed:
            return "네트워크 요청에 실패했습니다. 다시 시도해주세요."
        }
    }
}
