//
//  PrincipleInfo.swift
//  NavigationSample
//

import Foundation

/// 設計原則の詳細メタデータを保持する構造体
struct PrincipleInfo: Identifiable {
    let principle: ScreenDesignInfo.Principle
    let category: String
    let explanation: String
    let detailedExplanation: String
    let codeExamples: [CodeExample]

    var id: String { principle.rawValue }

    struct CodeExample {
        let description: String
        let code: String
    }
}

extension PrincipleInfo {
    /// この原則が適用されている画面一覧（ScreenDesignInfoProvider から逆引き）
    var appliedScreens: [ScreenDesignInfo] {
        PrincipleInfoProvider.allScreenDesignInfos.filter {
            $0.appliedPrinciples.contains(principle)
        }
    }
}
