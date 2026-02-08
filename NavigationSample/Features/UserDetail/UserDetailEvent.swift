//
//  UserDetailEvent.swift
//  NavigationSample
//

import Foundation

/// UserDetail Feature から App 層へ通知するイベント
///
/// 原則8: 文脈を開始した主体が、文脈を終了させる責務を持つ
/// App 層（UserGridCoordinator）が開始した詳細画面の文脈は、
/// イベント経由で App 層に終了を依頼する
enum UserDetailEvent {
    /// 詳細画面が閉じられた（戻るボタン等）
    case dismissed

    /// いいねが送られた
    case liked(userId: User.ID, type: LikeType)
}
