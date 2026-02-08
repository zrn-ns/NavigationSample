//
//  LoginFailureView.swift
//  NavigationSample
//

import SwiftUI

/// ログイン失敗画面
struct LoginFailureView: View {
    let router: LoginRouter

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.red)

            Text("ログイン失敗")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("メールアドレスとパスワードを入力してください")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button {
                router.goBack()
            } label: {
                Text("戻る")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("エラー")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .designInfoButton(ScreenDesignInfoProvider.loginFailure)
    }
}

#Preview {
    NavigationStack {
        LoginFailureView(router: LoginRouter())
    }
}
