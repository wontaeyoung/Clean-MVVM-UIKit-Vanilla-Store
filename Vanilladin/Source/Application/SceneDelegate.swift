import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        let rootNavigationController: UINavigationController = .init()
        appCoordinator = AppCoordinator(rootNavigationController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        
        guard let appCoordinator else {
            return
        }
        
        appCoordinator.start()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        ImageCacheManager.shared.addMemoryObserver()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        ImageCacheManager.shared.removeMemoryObserver()
    }
}
