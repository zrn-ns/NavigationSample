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
        patterns: [.patternB],
        appliedPrinciples: [.s1, .s2, .r1, .r2, .e2],
        description: """
        UIKit の UICollectionView でユーザ一覧をグリッド表示。
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
        patterns: [.featureRoot, .featurePush, .featureModal],
        appliedPrinciples: [.s1, .s2, .c1, .c2, .f1, .p1, .r1, .r2],
        description: """
        UserDetail Feature の起点画面。NavigationStack の root として機能し、
        Feature 内で push 遷移（写真一覧・写真詳細）と modal 表示（レガシー画面）を管理する。
        UserDetailRouter がバケツリレーで状態を管理。
        """
    )

    static let userPhotoList = ScreenDesignInfo(
        id: "userPhotoList",
        screenName: "写真一覧",
        framework: .swiftUI,
        layer: .view,
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
        patterns: [.featurePush],
        appliedPrinciples: [.s1, .s2, .f1, .f3, .r1],
        description: """
        UserDetail Feature 内で push 遷移で表示される写真詳細画面。
        Feature 内の最深部の画面。戻るボタンで NavigationStack が pop を処理する。
        """
    )

    static let legacyProfile = ScreenDesignInfo(
        id: "legacyProfile",
        screenName: "レガシープロフィール (1画面目)",
        framework: .uiKit,
        layer: .view,
        patterns: [.patternA],
        appliedPrinciples: [.c1, .c3, .p2, .r2, .e1],
        description: """
        SwiftUI の UserDetail Feature から modal で表示される UIKit 画面（パターン A）。
        UINavigationController でラップされ、UIKit 側で自由に push/pop 可能。
        閉じるときは onDismiss で SwiftUI 側に通知する。
        """
    )

    static let legacyProfileSecond = ScreenDesignInfo(
        id: "legacyProfileSecond",
        screenName: "レガシープロフィール (2画面目)",
        framework: .uiKit,
        layer: .view,
        patterns: [.patternA],
        appliedPrinciples: [.c1, .c3, .f1, .r2],
        description: """
        LegacyProfileViewController から UIKit の push で遷移した2画面目。
        SwiftUI の NavigationStack とは独立した UINavigationController の文脈で動作する。
        戻るボタンで UINavigationController が pop を処理する。
        """
    )

    // MARK: - Settings Feature (SwiftUI)

    static let settings = ScreenDesignInfo(
        id: "settings",
        screenName: "設定",
        framework: .swiftUI,
        layer: .view,
        patterns: [.featureRoot, .featurePush],
        appliedPrinciples: [.s1, .s2, .c1, .c2, .f1, .p1, .r1, .e2],
        description: """
        Settings Feature の起点画面。NavigationStack の root として機能し、
        Feature 内で push 遷移（設定詳細）を管理する。
        「ログイン」ボタンは Event を上位（App 層）に委譲して modal 表示を要求する（E2）。
        """
    )

    static let settingsDetail = ScreenDesignInfo(
        id: "settingsDetail",
        screenName: "設定詳細",
        framework: .swiftUI,
        layer: .view,
        patterns: [.featurePush],
        appliedPrinciples: [.s1, .s2, .f1, .f3, .r1, .r2],
        description: """
        Settings Feature 内で push 遷移で表示される詳細画面。
        @Environment(\\.dismiss) で「文脈終了の意図」を表明し、
        SwiftUI が適切な方法（pop）で処理する。
        """
    )

    // MARK: - Login Feature (SwiftUI Modal)

    static let loginStart = ScreenDesignInfo(
        id: "loginStart",
        screenName: "ログイン開始",
        framework: .swiftUI,
        layer: .view,
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
        patterns: [.featurePush],
        appliedPrinciples: [.s1, .s2, .f1, .r1],
        description: """
        Login Feature 内で push 遷移で表示されるエラー画面。
        「戻る」ボタンで Feature 内の前画面に戻る（LoginRouter.goBack()）。
        """
    )
}
