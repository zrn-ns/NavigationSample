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
    private weak var coordinator: AppCoordinator?

    init(coordinator: AppCoordinator) {
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
        // Home Tab
        let homeRootView = HomeRootView(onEvent: { [weak self] event in
            self?.coordinator?.handle(event)
        })
        let homeVC = UIHostingController(rootView: homeRootView)
        homeVC.tabBarItem = UITabBarItem(title: "ホーム", image: UIImage(systemName: "house"), tag: 0)

        // Settings Tab
        let settingsRootView = SettingsRootView(onEvent: { [weak self] event in
            self?.coordinator?.handle(event)
        })
        let settingsVC = UIHostingController(rootView: settingsRootView)
        settingsVC.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gear"), tag: 1)

        viewControllers = [homeVC, settingsVC]
    }
}
