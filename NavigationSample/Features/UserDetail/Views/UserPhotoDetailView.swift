//
//  UserPhotoDetailView.swift
//  NavigationSample
//

import SwiftUI

/// 写真詳細画面（写真拡大表示）
struct UserPhotoDetailView: View {
    let router: UserDetailRouter
    let photoId: User.Photo.ID

    private var photo: User.Photo? {
        router.user.photos.first { $0.id == photoId }
    }

    var body: some View {
        VStack(spacing: 20) {
            if let photo {
                Spacer()

                Image(systemName: photo.imageURL)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .foregroundStyle(.gray)

                if let caption = photo.caption {
                    Text(caption)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            } else {
                Text("写真が見つかりません")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("写真")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        UserPhotoDetailView(
            router: UserDetailRouter(user: User.samples[0]),
            photoId: User.samples[0].photos[0].id
        )
    }
}
