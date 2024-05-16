enum DataSourceError: AppErrorProtocol {
    case findEntityFailed(entityName: String)
    case noISBN13
    
    var errorDescription: String {
        switch self {
        case let .findEntityFailed(entityName):
            return "\(entityName) 정보를 찾는데 실패했습니다. 다시 시도해주세요."
            
        case .noISBN13:
            return "ISBN13을 지원하지 않는 도서입니다."
        }
    }
}
