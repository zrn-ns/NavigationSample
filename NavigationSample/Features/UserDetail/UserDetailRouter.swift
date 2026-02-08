//
//  UserDetailRouter.swift
//  NavigationSample
//

import SwiftUI

/// UserDetail Feature のルーティングを管理
///
/// RootView で生成し、子 View にバケツリレーで渡す。
/// Environment ではなくバケツリレーにすることで、注入忘れをコンパイル時に検出できる。
@MainActor
@Observable
final class UserDetailRouter {
    /// 表示対象のユーザ
    let user: User

    /// いいね済かどうか
    var isLiked: Bool = false

    /// Feature 内の push 遷移状態
    var path: [UserDetailRoute] = []

    /// Feature 内の modal 状態
    var modal: UserDetailModal?

    /// App 層へのイベント通知
    var onEvent: ((UserDetailEvent) -> Void)?

    init(user: User, onEvent: ((UserDetailEvent) -> Void)? = nil) {
        self.user = user
        self.onEvent = onEvent
    }

    /// push 遷移
    func navigate(to route: UserDetailRoute) {
        path.append(route)
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

    /// App 層イベントを発火
    func sendEvent(_ event: UserDetailEvent) {
        onEvent?(event)
    }

    /// 詳細画面を閉じる（戻る）
    func dismiss() {
        sendEvent(.dismissed)
    }

    /// いいねを送る
    func sendLike(_ type: LikeType) {
        modal = nil
        isLiked = true
        sendEvent(.liked(userId: user.id, type: type))
    }
}
