//
//  ScreenDesignInfoProvider.swift
//  NavigationSample
//

import Foundation

/// 各画面の設計情報を提供するプロバイダー
enum ScreenDesignInfoProvider {

    // MARK: - Home Feature (UIKit)

    static let userGrid = ScreenDesignInfo(
        id: "userGrid",
        screenName: "ユーザグリッド (Home)",
        framework: .uiKit,
        layer: .feature,
        rootViewName: "UserGridViewController",
        patterns: [.patternB],
        appliedPrinciples: [.s1, .s2, .r1, .r2, .e2],
        description: """
        UIKit の UICollectionView でユーザ一覧をグリッド表示。
        各セルは UIHostingConfiguration を使い SwiftUI で実装している。
        セル選択時に UserGridCoordinator を介して SwiftUI の UserDetail Feature を \
        fullScreenModal + push 風アニメーションで表示する（パターン B）。
        """
    )

    // MARK: - UserDetail Feature (SwiftUI)

    static let userDetail = ScreenDesignInfo(
        id: "userDetail",
        screenName: "ユーザ詳細",
        framework: .swiftUI,
        layer: .view,
        rootViewName: "UserDetailRootView",
        patterns: [.featureRoot, .featurePush, .featureModal],
        appliedPrinciples: [.s1, .s2, .c1, .c2, .f1, .p1, .r1, .r2],
        description: """
        UserDetail Feature の起点画面。NavigationStack の root として機能し、
        Feature 内で push 遷移（写真一覧・写真詳細）と modal 表示（いいね送信画面）を管理する。
        UserDetailRouter がバケツリレーで状態を管理。

        DisplayMode による表示パターンの違い:
        ・standard — Home タブからの遷移。左上に「← 戻る」ボタン、「いいね！」ボタンあり。
        ・me — 設定タブからのプロフィールプレビュー。右上に「×」ボタン（iOS 慣例の閉じるボタン配置）、\
        「いいね！」ボタンなし。
        どちらも dismiss() → Event(.dismissed) で App 層に終了を通知する点は共通（R2, E2）。
        """
    )

    static let userPhotoList = ScreenDesignInfo(
        id: "userPhotoList",
        screenName: "写真一覧",
        framework: .swiftUI,
        layer: .view,
        rootViewName: "UserPhotoListView",
        patterns: [.featurePush],
        appliedPrinciples: [.s1, .s2, .f1, .f3, .r1],
        description: """
        UserDetail Feature 内で push 遷移で表示される写真一覧画面。
        写真タップで写真詳細画面にさらに push 遷移する。
        Router を通じて遷移を要求し、View 自身は遷移を決定しない（R1）。
        """
    )

    static let userPhotoDetail = ScreenDesignInfo(
        id: "userPhotoDetail",
        screenName: "写真詳細",
        framework: .swiftUI,
        layer: .view,
        rootViewName: "UserPhotoDetailView",
        patterns: [.featurePush],
        appliedPrinciples: [.s1, .s2, .f1, .f3, .r1],
        description: """
        UserDetail Feature 内で push 遷移で表示される写真詳細画面。
        Feature 内の最深部の画面。戻るボタンで NavigationStack が pop を処理する。
        """
    )

    // MARK: - LikeSend Feature (UIKit)

    static let likeSend = ScreenDesignInfo(
        id: "likeSend",
        screenName: "いいね送信",
        framework: .uiKit,
        layer: .feature,
        rootViewName: "LikeSendRootView",
        patterns: [.patternA],
        appliedPrinciples: [.c1, .c3, .p2, .r2, .e1],
        description: """
        独立した LikeSend Feature。UserDetail Feature からセミモーダルで表示される。
        LikeSendRootView が Feature エントリポイントで、UIKit の LikeSendViewController を \
        UIViewControllerRepresentable でラップ（パターン A）。
        LikeSendEvent で上位にいいね送信完了・キャンセルを通知する。
        """
    )

    // MARK: - Settings Feature (SwiftUI)

    static let settings = ScreenDesignInfo(
        id: "settings",
        screenName: "設定",
        framework: .swiftUI,
        layer: .view,
        rootViewName: "SettingsRootView",
        patterns: [.featureRoot],
        appliedPrinciples: [.s1, .s2, .r1, .e2],
        description: """
        Settings Feature の起点画面。Feature 内に push 遷移を持たず、
        Event 委譲のみで App 層と連携する最小構成の Feature。
        「プロフィールプレビュー」は Event 経由で App 層に fullScreenModal 表示を要求（E2）。
        同一の UserDetail Feature を Home とは異なる表示手段で表示する（手段8）。
        「マッチするにはいいねしよう！」はタブ切り替えを Event で委譲する（E2, F2）。
        """
    )

    // MARK: - Login Feature (SwiftUI Modal)

    static let loginStart = ScreenDesignInfo(
        id: "loginStart",
        screenName: "ログイン開始",
        framework: .swiftUI,
        layer: .view,
        rootViewName: "LoginRootView",
        patterns: [.featureRoot, .featurePush],
        appliedPrinciples: [.s1, .s2, .c1, .c3, .p2, .r1, .e1, .e2],
        description: """
        Login Feature の起点画面。App 層から modal で表示される独立した文脈（C3, P2）。
        ログイン成功/失敗で Feature 内 push 遷移し、キャンセルは Event で App 層に通知する（E2）。
        """
    )

    static let loginComplete = ScreenDesignInfo(
        id: "loginComplete",
        screenName: "ログイン完了",
        framework: .swiftUI,
        layer: .view,
        rootViewName: "LoginCompleteView",
        patterns: [.featurePush],
        appliedPrinciples: [.s1, .s2, .f1, .r1, .e1, .e2],
        description: """
        Login Feature 内で push 遷移で表示される完了画面。
        「閉じる」ボタンは Event（.completed）を送信し、App 層が modal を閉じる（E2, R2）。
        View 自身は dismiss を呼ばない。
        """
    )

    static let loginFailure = ScreenDesignInfo(
        id: "loginFailure",
        screenName: "ログイン失敗",
        framework: .swiftUI,
        layer: .view,
        rootViewName: "LoginFailureView",
        patterns: [.featurePush],
        appliedPrinciples: [.s1, .s2, .f1, .r1],
        description: """
        Login Feature 内で push 遷移で表示されるエラー画面。
        「戻る」ボタンで Feature 内の前画面に戻る（LoginRouter.goBack()）。
        """
    )
}
