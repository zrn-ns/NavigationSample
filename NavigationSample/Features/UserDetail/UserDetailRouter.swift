//
//  UserDetailRouter.swift
//  NavigationSample
//

import SwiftUI

/// UserDetail Feature の遷移状態を管理
///
/// push / modal の遷移のみを責務とする。
/// データ保持・イベント通知は UserDetailViewModel が担当。
@MainActor
@Observable
final class UserDetailRouter {
    /// Feature 内の push 遷移状態
    var path: [UserDetailPath] = []

    /// Feature 内の modal 状態
    var modal: UserDetailModal?

    /// push 遷移
    func navigate(to destination: UserDetailPath) {
        path.append(destination)
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
