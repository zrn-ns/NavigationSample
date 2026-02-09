//
//  MainTabBarController.swift
//  NavigationSample
//

import UIKit
import SwiftUI

/// メインの TabBarController
///
/// 原則6: 構造的に NavigationStack が複数存在してもよいが、
/// 同時に有効なものは1つにする
final class MainTabBarController: UITabBarController {
    private weak var coordinator: MainTabCoordinator?

    init(coordinator: MainTabCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        // Home Tab (UIKit ベースのグリッド)
        let homeNavController = UINavigationController()
        homeNavController.tabBarItem = UITabBarItem(title: "ホーム", image: UIImage(systemName: "heart.circle"), tag: 0)
        coordinator?.setupUserGridCoordinator(navigationController: homeNavController)

        // Settings Tab (SwiftUI ベース)
        let settingsRootView = SettingsRootView(onEvent: { [weak self] event in
            self?.coordinator?.handle(event)
        })
        let settingsVC = UIHostingController(rootView: settingsRootView)
        settingsVC.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gear"), tag: 1)

        // 設計情報タブ (SwiftUI ベース)
        let designOverviewView = DesignOverviewView()
        let designVC = UIHostingController(rootView: designOverviewView)
        designVC.tabBarItem = UITabBarItem(
            title: "設計情報",
            image: UIImage(systemName: "doc.text.magnifyingglass"),
            tag: 2
        )

        viewControllers = [homeNavController, settingsVC, designVC]
    }
}
