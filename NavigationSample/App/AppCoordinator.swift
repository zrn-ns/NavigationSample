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

    /// Home タブの Coordinator（UIKit グリッド → SwiftUI 詳細への遷移を管理）
    private var userGridCoordinator: UserGridCoordinator?

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

    /// Home タブ用の Coordinator を設定
    func setupUserGridCoordinator(navigationController: UINavigationController) {
        let coordinator = UserGridCoordinator(
            navigationController: navigationController,
            appCoordinator: self
        )
        self.userGridCoordinator = coordinator
        coordinator.start()
    }

    // MARK: - Event Handling

    func handle(_ event: SettingsEvent) {
        switch event {
        case .openHome:
            tabBarController?.selectedIndex = 0
        case .showProfilePreview:
            presentProfilePreview()
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

    /// 手段8: 同一 Feature を異なる表示手段で表示する
    /// Home: push 風トランジション + スワイプ dismiss
    /// Settings: 通常 fullScreenModal（スワイプ dismiss なし）
    private func presentProfilePreview() {
        let router = UserDetailRouter(user: User.myself)
        let detailRootView = UserDetailRootView(
            router: router,
            onEvent: { [weak self] event in
                self?.handleProfilePreviewEvent(event)
            }
        )
        let hostingController = UIHostingController(rootView: detailRootView)
        hostingController.modalPresentationStyle = .fullScreen
        tabBarController?.present(hostingController, animated: true)
        currentModal = .profilePreview
    }

    private func handleProfilePreviewEvent(_ event: UserDetailEvent) {
        switch event {
        case .dismissed:
            dismissModal()
        case .liked:
            // プレビューなのでいいねは無視
            break
        }
    }

    private func dismissModal() {
        tabBarController?.dismiss(animated: true)
        currentModal = nil
    }
}
