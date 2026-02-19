//
//  UserDetailView.swift
//  NavigationSample
//

import SwiftUI

/// ユーザ詳細画面
struct UserDetailView: View {
    @Environment(UserDetailRouter.self) private var router
    let viewModel: UserDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader
                bioSection
                actionButtons
            }
            .padding()
        }
        .navigationTitle(viewModel.user.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.displayMode == .standard {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.requestClose()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("戻る")
                        }
                    }
                }
            }
            if viewModel.displayMode == .me {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.requestClose()
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
            Image(systemName: viewModel.user.imageURL)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(.blue)

            Text("\(viewModel.user.name), \(viewModel.user.age)")
                .font(.title)
                .fontWeight(.bold)
        }
    }

    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("自己紹介")
                .font(.headline)

            Text(viewModel.user.bio)
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

            if viewModel.displayMode == .standard {
                Button {
                    router.showLikeSend()
                } label: {
                    Label(
                        viewModel.isLiked ? "いいね済" : "いいね！",
                        systemImage: "heart.fill"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(viewModel.isLiked ? .gray : .pink)
                .disabled(viewModel.isLiked)
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserDetailView(viewModel: UserDetailViewModel(user: User.samples[0]))
    }
    .environment(UserDetailRouter())
}
