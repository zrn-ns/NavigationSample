//
//  UserGridCell.swift
//  NavigationSample
//

import SwiftUI
import UIKit

/// ユーザグリッドのセル（SwiftUI で実装）
final class UserGridCell: UICollectionViewCell {
    static let reuseIdentifier = "UserGridCell"

    func configure(with user: User) {
        contentConfiguration = UIHostingConfiguration {
            UserGridCellContent(user: user)
        }
        .margins(.all, 0)
    }
}

// MARK: - SwiftUI Content

private struct UserGridCellContent: View {
    let user: User

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: user.imageURL)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(.blue)

            Text(user.name)
                .font(.headline)

            Text("\(user.age)歳")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
