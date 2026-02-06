//
//  AppModal.swift
//  NavigationSample
//

import Foundation

/// App全体で管理するModal定義
///
/// 原則8: ModalRoute は「文脈のスコープ」で定義する
/// - App 文脈 → AppModal
enum AppModal: Identifiable {
    case login

    var id: String {
        switch self {
        case .login:
            return "login"
        }
    }
}
