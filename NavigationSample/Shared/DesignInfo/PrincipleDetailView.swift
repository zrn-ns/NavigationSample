//
//  PrincipleDetailView.swift
//  NavigationSample
//

import SwiftUI

/// 設計原則の詳細を表示する View
struct PrincipleDetailView: View {
    let principleInfo: PrincipleInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                detailedExplanationSection
                if !principleInfo.navigationPatterns.isEmpty {
                    navigationPatternsSection
                }
                if !principleInfo.codeExamples.isEmpty {
                    codeExamplesSection
                }
                if !principleInfo.relatedPractices.isEmpty {
                    relatedPracticesSection
                }
                if !principleInfo.appliedScreens.isEmpty {
                    appliedScreensSection
                }
            }
            .padding()
        }
        .navigationTitle(principleInfo.principle.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: PracticeInfo.self) { practice in
            PracticeDetailView(practiceInfo: practice)
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(principleInfo.category)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.accentColor.opacity(0.15))
                .foregroundStyle(Color.accentColor)
                .clipShape(Capsule())

            Text(principleInfo.explanation)
                .font(.body)
                .fontWeight(.medium)
        }
    }

    private var detailedExplanationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("詳細説明")

            Text(principleInfo.detailedExplanation)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private var codeExamplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("コードサンプル")

            ForEach(
                Array(principleInfo.codeExamples.enumerated()),
                id: \.offset
            ) { _, example in
                VStack(alignment: .leading, spacing: 6) {
                    Text(example.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(example.code)
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    private var navigationPatternsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("画面パターン")

            FlowLayout(spacing: 6) {
                ForEach(principleInfo.navigationPatterns, id: \.self) { pattern in
                    Text(pattern)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.accentColor.opacity(0.12))
                        .foregroundStyle(Color.accentColor)
                        .clipShape(Capsule())
                }
            }
        }
    }

    private var relatedPracticesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("関連する具体的手段")

            ForEach(principleInfo.relatedPractices) { practice in
                NavigationLink(value: practice) {
                    HStack {
                        Text(practice.title)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
            }
        }
    }

    private var appliedScreensSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("適用されている画面")

            ForEach(principleInfo.appliedScreens) { screen in
                HStack(spacing: 8) {
                    Image(systemName: screenIcon(for: screen))
                        .foregroundStyle(screenColor(for: screen))
                        .font(.caption)
                    Text(screen.screenName)
                        .font(.subheadline)
                }
                .padding(.vertical, 2)
            }
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.top, 8)
    }

    private func screenIcon(for screen: ScreenDesignInfo) -> String {
        switch screen.framework {
        case .swiftUI: "swift"
        case .uiKit: "uiwindow.split.2x1"
        }
    }

    private func screenColor(for screen: ScreenDesignInfo) -> Color {
        switch screen.framework {
        case .swiftUI: .orange
        case .uiKit: .blue
        }
    }
}

#Preview {
    NavigationStack {
        PrincipleDetailView(principleInfo: PrincipleInfoProvider.s1)
    }
}
