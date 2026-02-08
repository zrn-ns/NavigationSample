//
//  DesignInfoDetailView.swift
//  NavigationSample
//

import SwiftUI

/// 設計情報を詳細表示する View
struct DesignInfoDetailView: View {
    let info: ScreenDesignInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                descriptionSection
                patternsSection
                principlesSection
            }
            .padding()
        }
        .navigationTitle("設計情報")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(info.screenName)
                .font(.title2)
                .fontWeight(.bold)

            HStack(spacing: 12) {
                Label(info.framework.rawValue, systemImage: frameworkIcon)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(frameworkColor.opacity(0.2))
                    .foregroundStyle(frameworkColor)
                    .clipShape(Capsule())

                Label(info.layer.rawValue, systemImage: "square.stack.3d.up")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("概要")

            Text(info.description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private var patternsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("実装パターン")

            ForEach(info.patterns, id: \.self) { pattern in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                    Text(pattern.rawValue)
                        .font(.subheadline)
                }
            }
        }
    }

    private var principlesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("適用原則")

            let grouped = Dictionary(grouping: info.appliedPrinciples) { $0.category }
            let sortedCategories = ["状態駆動", "文脈構造", "Feature境界", "状態分離", "責務分離", "結果伝達"]

            ForEach(sortedCategories, id: \.self) { category in
                if let principles = grouped[category], !principles.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(category)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        ForEach(principles, id: \.self) { principle in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(principle.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(principle.explanation)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.top, 8)
    }

    private var frameworkIcon: String {
        switch info.framework {
        case .swiftUI: return "swift"
        case .uiKit: return "uiwindow.split.2x1"
        }
    }

    private var frameworkColor: Color {
        switch info.framework {
        case .swiftUI: return .orange
        case .uiKit: return .blue
        }
    }
}

#Preview {
    NavigationStack {
        DesignInfoDetailView(info: ScreenDesignInfoProvider.userDetail)
    }
}
