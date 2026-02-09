//
//  SceneDelegate.swift
//  NavigationSample
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainTabCoordinator: MainTabCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let mainTabCoordinator = MainTabCoordinator(window: window)
        self.window = window
        self.mainTabCoordinator = mainTabCoordinator

        mainTabCoordinator.start()
    }
}
