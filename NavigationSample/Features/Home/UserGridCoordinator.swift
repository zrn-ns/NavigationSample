//
//  UserGridCoordinator.swift
//  NavigationSample
//

import UIKit
import SwiftUI

/// Home タブの遷移を管理する Coordinator
///
/// UIKit グリッド → SwiftUI 詳細 Feature への push 遷移を管理
@MainActor
final class UserGridCoordinator {
    private let navigationController: UINavigationController
    private weak var appCoordinator: AppCoordinator?

    init(navigationController: UINavigationController, appCoordinator: AppCoordinator) {
        self.navigationController = navigationController
        self.appCoordinator = appCoordinator
    }

    /// 初期画面（グリッド）を表示
    func start() {
        let gridVC = UserGridViewController(
            users: User.samples,
            coordinator: self
        )
        navigationController.setViewControllers([gridVC], animated: false)
    }

    /// ユーザ詳細画面を push 遷移で表示
    func showUserDetail(user: User) {
        let detailRootView = UserDetailRootView(
            user: user,
            onEvent: { [weak self] event in
                self?.handle(event)
            }
        )
        let hostingController = UIHostingController(rootView: detailRootView)
        // SwiftUI 側の NavigationBar は非表示にし、UIKit 側で管理
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    /// UserDetail Feature からのイベントをハンドリング
    private func handle(_ event: UserDetailEvent) {
        switch event {
        case .dismissed:
            navigationController.popViewController(animated: true)

        case .liked(let userId):
            // いいね処理（ここでは単純に pop して戻る）
            print("いいねを送りました: \(userId)")
            navigationController.popViewController(animated: true)
        }
    }
}
