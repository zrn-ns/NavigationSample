//
//  LikeSendEvent.swift
//  NavigationSample
//

/// LikeSend Feature から上位へ通知するイベント
enum LikeSendEvent {
    /// いいね送信完了
    case liked(type: LikeType)

    /// キャンセル（モーダルを閉じる）
    case dismissed
}
