//
//  UserPhotoDetailView.swift
//  NavigationSample
//

import SwiftUI

/// 写真詳細画面（写真拡大表示）
struct UserPhotoDetailView: View {
    let photos: [User.Photo]
    let photoId: User.Photo.ID

    private var photo: User.Photo? {
        photos.first { $0.id == photoId }
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
        .designInfoButton(ScreenDesignInfoProvider.userPhotoDetail)
    }
}

#Preview {
    NavigationStack {
        UserPhotoDetailView(
            photos: User.samples[0].photos,
            photoId: User.samples[0].photos[0].id
        )
    }
}
