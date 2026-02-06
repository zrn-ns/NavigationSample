//
//  LoginStartView.swift
//  NavigationSample
//

import SwiftUI

/// ログイン開始画面
///
/// 原則9: Viewは遷移の決定権を持たない
struct LoginStartView: View {
    let router: LoginRouter

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 24) {
            Text("ログイン")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 16) {
                TextField("メールアドレス", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("パスワード", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.password)
            }
            .padding(.horizontal)

            Spacer()

            VStack(spacing: 12) {
                Button {
                    if email.isEmpty && password.isEmpty {
                        router.navigate(to: .failure)
                    } else {
                        router.navigate(to: .complete)
                    }
                } label: {
                    Text("ログイン")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button("キャンセル") {
                    router.sendEvent(.cancelled)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("ログイン")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LoginStartView(router: LoginRouter())
    }
}
