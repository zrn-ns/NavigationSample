//
//  PushTransitionAnimator.swift
//  NavigationSample
//

import UIKit

/// fullScreenModal を push のようなアニメーションで表示するためのトランジションアニメーター
final class PushTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.35
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentation(using: transitionContext)
        } else {
            animateDismissal(using: transitionContext)
        }
    }

    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        let width = containerView.bounds.width

        // 表示する画面を右側から開始
        toView.frame = containerView.bounds.offsetBy(dx: width, dy: 0)
        containerView.addSubview(toView)

        let duration = transitionDuration(using: transitionContext)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                // 新しい画面を左にスライドイン
                toView.frame = containerView.bounds
                // 元の画面を少し左にずらす（push 風の効果）
                fromView.frame = containerView.bounds.offsetBy(dx: -width * 0.3, dy: 0)
            },
            completion: { _ in
                // fromView のフレームを元に戻す（キャンセル時のため）
                fromView.frame = containerView.bounds
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }

    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        let width = containerView.bounds.width

        // 戻り先の画面を左側に配置
        toView.frame = containerView.bounds.offsetBy(dx: -width * 0.3, dy: 0)
        containerView.insertSubview(toView, belowSubview: fromView)

        let duration = transitionDuration(using: transitionContext)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                // 現在の画面を右にスライドアウト
                fromView.frame = containerView.bounds.offsetBy(dx: width, dy: 0)
                // 戻り先の画面を元の位置に
                toView.frame = containerView.bounds
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}

// MARK: - Transitioning Delegate

/// fullScreenModal の push 風トランジションを提供するデリゲート
final class PushTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let dismissalInteractor = SwipeDismissalInteractor()

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        PushTransitionAnimator(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        PushTransitionAnimator(isPresenting: false)
    }

    func interactionControllerForDismissal(
        using animator: any UIViewControllerAnimatedTransitioning
    ) -> (any UIViewControllerInteractiveTransitioning)? {
        // エッジスワイプ中のみインタラクティブトランジションを返す
        // ボタンでの dismiss 時は nil を返し、従来通り非インタラクティブ
        dismissalInteractor.isInteracting ? dismissalInteractor : nil
    }
}

// MARK: - Swipe Dismissal

/// 左→右スワイプによるインタラクティブ dismiss を管理する
final class SwipeDismissalInteractor: UIPercentDrivenInteractiveTransition {
    private(set) var isInteracting = false
    private weak var viewController: UIViewController?

    /// NavigationStack の root 画面かどうかを判定するクロージャ
    ///
    /// Coordinator が router.path.isEmpty を遅延参照するクロージャを設定する。
    /// root 画面でのみ dismiss ジェスチャーを許可し、pushed 画面では抑制する。
    var isAtNavigationRoot: () -> Bool = { true }

    /// 対象の VC にスワイプジェスチャーを追加する
    func attach(to viewController: UIViewController) {
        self.viewController = viewController

        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan(_:))
        )
        pan.delegate = self
        viewController.view.addGestureRecognizer(pan)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }

        let translation = gesture.translation(in: view)
        let progress = max(0, min(1, translation.x / view.bounds.width))

        switch gesture.state {
        case .began:
            isInteracting = true
            viewController?.dismiss(animated: true)

        case .changed:
            update(progress)

        case .ended:
            isInteracting = false
            let velocity = gesture.velocity(in: view).x
            // 速度が十分、または進行度が50%以上なら完了
            if velocity > 300 || progress > 0.5 {
                finish()
            } else {
                cancel()
            }

        case .cancelled:
            isInteracting = false
            cancel()

        default:
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SwipeDismissalInteractor: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer,
              let view = pan.view else { return false }

        let velocity = pan.velocity(in: view)
        // 右方向かつ水平な操作のみ受け付ける
        guard velocity.x > 0 && abs(velocity.x) > abs(velocity.y) else { return false }

        // pushed 画面では dismiss を抑制し、NavigationStack の pop に任せる
        return isAtNavigationRoot()
    }
}
