//
//  UserDetailView.swift
//  NavigationSample
//

import SwiftUI

/// ユーザ詳細画面
struct UserDetailView: View {
    let router: UserDetailRouter

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader
                bioSection
                actionButtons
            }
            .padding()
        }
        .navigationTitle(router.user.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if router.displayMode == .standard {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        router.dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("戻る")
                        }
                    }
                }
            }
            if router.displayMode == .me {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        router.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .designInfoButton(ScreenDesignInfoProvider.userDetail)
    }

    // MARK: - Subviews

    private var profileHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: router.user.imageURL)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(.blue)

            Text("\(router.user.name), \(router.user.age)")
                .font(.title)
                .fontWeight(.bold)
        }
    }

    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("自己紹介")
                .font(.headline)

            Text(router.user.bio)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                router.showPhotos()
            } label: {
                Label("写真を見る", systemImage: "photo.on.rectangle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            if router.displayMode == .standard {
                Button {
                    router.showLikeSend()
                } label: {
                    Label(
                        router.isLiked ? "いいね済" : "いいね！",
                        systemImage: "heart.fill"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(router.isLiked ? .gray : .pink)
                .disabled(router.isLiked)
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserDetailView(
            router: UserDetailRouter(user: User.samples[0])
        )
    }
}
