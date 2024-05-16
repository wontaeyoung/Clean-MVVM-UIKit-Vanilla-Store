protocol DataSourceProtocol: DependencyContainable {
    associatedtype Entity = EntityProtocol
    
    var entities: [Entity] { get set }
    
    func entity(at index: Int) -> Entity?
}

extension DataSourceProtocol {
    func entity(at index: Int) -> Entity? {
        guard index < entities.count else {
            return nil
        }
        
        return entities[index]
    }
}
