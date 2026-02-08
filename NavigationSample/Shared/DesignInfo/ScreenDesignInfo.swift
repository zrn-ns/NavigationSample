//
//  ScreenDesignInfo.swift
//  NavigationSample
//

import Foundation

/// 画面の設計情報を表すデータモデル
struct ScreenDesignInfo: Identifiable {
    let id: String
    let screenName: String
    let framework: Framework
    let layer: Layer
    let rootViewName: String
    let patterns: [Pattern]
    let appliedPrinciples: [Principle]
    let description: String

    /// UI フレームワーク
    enum Framework: String {
        case swiftUI = "SwiftUI"
        case uiKit = "UIKit"
    }

    /// レイヤー
    enum Layer: String {
        case app = "App 層"
        case feature = "Feature 層"
        case view = "View"
    }

    /// 実装パターン
    enum Pattern: String, CaseIterable {
        case patternA = "パターン A: SwiftUI Feature 内で UIKit 画面を modal 表示"
        case patternB = "パターン B: UIKit グリッドから SwiftUI Feature を push 遷移"
        case patternC = "パターン C: UIKit 画面から SwiftUI Feature を modal 表示"
        case patternD = "パターン D: UIKit 画面の一部を SwiftUI で構築"
        case featureRoot = "Feature Root (NavigationStack)"
        case featurePush = "Feature 内 push"
        case featureModal = "Feature 内 modal"
    }

    /// 設計原則
    enum Principle: String, CaseIterable {
        // 状態駆動
        case s1 = "S1: 状態結果原則"
        case s2 = "S2: 意味表現原則"
        // 文脈構造
        case c1 = "C1: 単一文脈原則"
        case c2 = "C2: 階層スコープ原則"
        case c3 = "C3: 文脈停止原則"
        // Feature 境界
        case f1 = "F1: Push限定原則"
        case f2 = "F2: 切断遷移原則"
        case f3 = "F3: Route境界原則"
        // 状態分離
        case p1 = "P1: Push/Modal分離原則"
        case p2 = "P2: Modalスコープ原則"
        // 責務分離
        case r1 = "R1: View無決定権原則"
        case r2 = "R2: 開始者終了原則"
        case r3 = "R3: 上位強制終了原則"
        // 結果伝達
        case e1 = "E1: 終了結果原則"
        case e2 = "E2: Event委譲原則"

        /// カテゴリ名
        var category: String {
            switch self {
            case .s1, .s2: return "状態駆動"
            case .c1, .c2, .c3: return "文脈構造"
            case .f1, .f2, .f3: return "Feature境界"
            case .p1, .p2: return "状態分離"
            case .r1, .r2, .r3: return "責務分離"
            case .e1, .e2: return "結果伝達"
            }
        }

        /// 説明
        var explanation: String {
            switch self {
            case .s1:
                return "ナビゲーションは「画面遷移」ではなく「状態遷移」である"
            case .s2:
                return "Route は「画面」ではなく「意味」を表す"
            case .c1:
                return "表示されている View が属するナビゲーション文脈は常に1つである"
            case .c2:
                return "文脈（Context）には階層とスコープがある"
            case .c3:
                return "文脈が切り替わると、元の文脈は一時停止される"
            case .f1:
                return "NavigationStack（push）は同一 Feature 内に限定する"
            case .f2:
                return "Feature を跨ぐ遷移は「文脈の切断」として扱う"
            case .f3:
                return "Route は Feature 境界を越えない"
            case .p1:
                return "Push 用の状態と Modal 用の状態は分離する"
            case .p2:
                return "Modal は「一時的 UI」ではなく「独立した文脈」である"
            case .r1:
                return "View は遷移の決定権を持たない"
            case .r2:
                return "文脈を開始した主体が、文脈を終了させる責務を持つ"
            case .r3:
                return "文脈を跨ぐ「強制的な終了」は、常に上位レイヤーの責務である"
            case .e1:
                return "「画面を閉じる」とは「文脈を終了させる」ことであり、結果を伴う"
            case .e2:
                return "Modal 内の処理結果は「閉じる命令」ではなく「イベント」として返す"
            }
        }
    }
}
