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
        // 結果伝達
        case e1 = "E1: 終了結果原則"
        case e2 = "E2: Event委譲原則"
    }
}
