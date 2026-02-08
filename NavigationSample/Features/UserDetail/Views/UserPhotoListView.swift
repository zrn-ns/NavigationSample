//
//  UserPhotoListView.swift
//  NavigationSample
//

import SwiftUI

/// ユーザの写真一覧画面
struct UserPhotoListView: View {
    let router: UserDetailRouter

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(router.user.photos) { photo in
                    PhotoThumbnail(photo: photo) {
                        router.showPhotoDetail(photoId: photo.id)
                    }
                }
            }
            .padding()
        }
        .background(Color.swiftUIBackground)
        .navigationTitle("写真")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - PhotoThumbnail

private struct PhotoThumbnail: View {
    let photo: User.Photo
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: photo.imageURL)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundStyle(.gray)

                if let caption = photo.caption {
                    Text(caption)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        UserPhotoListView(
            router: UserDetailRouter(user: User.samples[0])
        )
    }
}
