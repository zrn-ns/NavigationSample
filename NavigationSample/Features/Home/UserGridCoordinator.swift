//
//  UserGridCoordinator.swift
//  NavigationSample
//

import UIKit
import SwiftUI

/// Home タブの遷移を管理する Coordinator
///
/// UIKit グリッド → SwiftUI 詳細 Feature への遷移を管理
/// fullScreenModal + push 風アニメーションで表示
@MainActor
final class UserGridCoordinator {
    private let navigationController: UINavigationController
    private weak var appCoordinator: AppCoordinator?

    /// push 風トランジションのデリゲート（強参照で保持）
    private let transitioningDelegate = PushTransitioningDelegate()

    /// 現在表示中の詳細画面
    private weak var presentedDetailVC: UIViewController?

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

    /// ユーザ詳細画面を fullScreenModal（push 風アニメーション）で表示
    func showUserDetail(user: User) {
        let router = UserDetailRouter(user: user)
        let viewModel = UserDetailViewModel()

        // root 画面でのみスワイプ dismiss を許可する
        let dismissalInteractor = transitioningDelegate.dismissalInteractor
        dismissalInteractor.isAtNavigationRoot = { [weak router] in
            router?.path.isEmpty ?? true
        }

        let detailRootView = UserDetailRootView(
            router: router,
            viewModel: viewModel,
            onEvent: { [weak self] event in
                self?.handle(event)
            }
        )
        let hostingController = UIHostingController(rootView: detailRootView)

        // fullScreenModal + カスタムトランジション
        hostingController.modalPresentationStyle = .fullScreen
        hostingController.transitioningDelegate = transitioningDelegate

        dismissalInteractor.attach(to: hostingController)

        presentedDetailVC = hostingController
        navigationController.present(hostingController, animated: true)
    }

    /// UserDetail Feature からのイベントをハンドリング
    private func handle(_ event: UserDetailEvent) {
        switch event {
        case .dismissed:
            presentedDetailVC?.dismiss(animated: true)
            presentedDetailVC = nil

        case .liked(let userId, let type):
            // いいね処理（ログ出力のみ。詳細画面は閉じない）
            print("いいねを送りました: \(userId)（\(type.displayName) \(type.cost)pt）")
        }
    }
}
