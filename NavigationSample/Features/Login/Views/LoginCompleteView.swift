//
//  LoginCompleteView.swift
//  NavigationSample
//

import SwiftUI

/// ログイン完了画面
///
/// 原則12: Modal内の処理結果は「閉じる命令」ではなく「イベント」として返す
struct LoginCompleteView: View {
    let router: LoginRouter

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)

            Text("ログイン完了")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("ようこそ！")
                .font(.title2)
                .foregroundStyle(.secondary)

            Spacer()

            Button {
                router.sendEvent(.completed)
            } label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("完了")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .designInfoButton(ScreenDesignInfoProvider.loginComplete)
    }
}

#Preview {
    NavigationStack {
        LoginCompleteView(router: LoginRouter())
    }
}
