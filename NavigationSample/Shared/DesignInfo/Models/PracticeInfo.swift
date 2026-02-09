//
//  PracticeInfo.swift
//  NavigationSample
//

import Foundation

/// 具体的手段の詳細メタデータを保持する構造体
struct PracticeInfo: Hashable, Identifiable {
    let id: String
    let title: String
    let description: String
    let codeExamples: [CodeExample]
    let relatedPrinciples: [ScreenDesignInfo.Principle]

    var displayId: String {
        let number = id.replacingOccurrences(of: "practice", with: "")
        return "手段\(number)"
    }

    struct CodeExample: Hashable {
        let description: String
        let code: String
    }
}
