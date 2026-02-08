//
//  AppCoordinator.swift
//  NavigationSample
//

import UIKit
import SwiftUI

/// App 層の状態管理（UIKit Coordinator）
///
/// 原理8: 文脈を開始した主体が、文脈を終了させる責務を持つ
/// App 層が開始した文脈（Modal、Tab）は App 層が閉じる
@MainActor
final class AppCoordinator {
    private let window: UIWindow
    private var tabBarController: MainTabBarController?

    /// App 層の Modal 状態
    var currentModal: AppModal?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let tabBarController = MainTabBarController(coordinator: self)
        self.tabBarController = tabBarController
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    // MARK: - Event Handling

    func handle(_ event: HomeEvent) {
        switch event {
        case .openSettings:
            tabBarController?.selectedIndex = 1
        }
    }

    func handle(_ event: SettingsEvent) {
        switch event {
        case .openHome:
            tabBarController?.selectedIndex = 0
        case .requireLogin:
            presentLogin()
        }
    }

    func handle(_ event: LoginEvent) {
        switch event {
        case .completed:
            dismissModal()
        case .cancelled:
            dismissModal()
        }
    }

    // MARK: - Modal Management

    private func presentLogin() {
        let loginRootView = LoginRootView(onEvent: { [weak self] event in
            self?.handle(event)
        })
        let hostingController = UIHostingController(rootView: loginRootView)
        hostingController.modalPresentationStyle = .fullScreen
        tabBarController?.present(hostingController, animated: true)
        currentModal = .login
    }

    private func dismissModal() {
        tabBarController?.dismiss(animated: true)
        currentModal = nil
    }
}
