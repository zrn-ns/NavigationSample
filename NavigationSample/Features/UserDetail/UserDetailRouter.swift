//
//  UserDetailRouter.swift
//  NavigationSample
//

import SwiftUI

/// UserDetail Feature の遷移状態・イベント通知を管理
///
/// push / modal の遷移と、Feature 外への通知を責務とする。
/// データ保持・ビジネスロジックは UserDetailViewModel が担当。
@MainActor
@Observable
final class UserDetailRouter {
    /// Feature 内の push 遷移状態
    var path: [UserDetailPath] = []

    /// Feature 内の modal 状態
    var modal: UserDetailModal?

    /// 上位へのイベント通知
    var onEvent: ((UserDetailEvent) -> Void)?

    /// 上位へイベントを発火
    func sendEvent(_ event: UserDetailEvent) {
        onEvent?(event)
    }

    /// Feature の終了を要求する
    func requestClose() {
        sendEvent(.closeRequested)
    }

    /// push 遷移（内部専用）
    private func navigate(to destination: UserDetailPath) {
        path.append(destination)
    }

    /// 1つ前の画面に戻る
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// ルート画面に戻る
    func navigateToRoot() {
        path.removeAll()
    }

    /// 写真一覧を表示
    func showPhotos() {
        navigate(to: .photos)
    }

    /// 写真詳細を表示
    func showPhotoDetail(photoId: User.Photo.ID) {
        navigate(to: .photoDetail(photoId: photoId))
    }

    /// いいね送信画面をモーダルで表示（パターン A）
    func showLikeSend() {
        modal = .likeSend
    }

    /// モーダルを閉じる
    func dismissModal() {
        modal = nil
    }
}
