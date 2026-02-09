//
//  DesignOverviewView.swift
//  NavigationSample
//

import SwiftUI

/// 設計全体を俯瞰する View
struct DesignOverviewView: View {
    var body: some View {
        NavigationStack {
            List {
                principlesSection
                matrixSection
                practicesSection
            }
            .navigationTitle("設計情報")
            .navigationDestination(for: ScreenDesignInfo.Principle.self) { principle in
                PrincipleDetailView(principleInfo: PrincipleInfoProvider.info(for: principle))
            }
            .navigationDestination(for: PracticeInfo.self) { practice in
                PracticeDetailView(practiceInfo: practice)
            }
        }
    }

    // MARK: - 設計原則セクション

    private var principlesSection: some View {
        Section("設計原則") {
            ForEach(PrincipleInfoProvider.groupedByCategory, id: \.category) { group in
                DisclosureGroup(group.category) {
                    ForEach(group.principles) { principleInfo in
                        NavigationLink(value: principleInfo.principle) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(principleInfo.principle.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(principleInfo.explanation)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
        }
    }

    // MARK: - 画面パターン別マトリクスセクション

    private var matrixSection: some View {
        Section("画面パターン別マトリクス") {
            ForEach(
                PrincipleInfoProvider.navigationPatternMatrix,
                id: \.pattern
            ) { entry in
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.pattern)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    FlowLayout(spacing: 4) {
                        ForEach(entry.principles, id: \.self) { principle in
                            principleCodeBadge(principle)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: - 具体的手段セクション

    private var practicesSection: some View {
        Section("具体的手段") {
            ForEach(PracticeInfoProvider.all) { practice in
                NavigationLink(value: practice) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(practice.displayId): \(practice.title)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(principlesCodes(for: practice))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }

    // MARK: - Helpers

    private func principleCodeBadge(_ principle: ScreenDesignInfo.Principle) -> some View {
        let code = String(principle.rawValue.prefix(2))
        return Text(code)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.accentColor.opacity(0.12))
            .foregroundStyle(Color.accentColor)
            .clipShape(Capsule())
    }

    private func principlesCodes(for practice: PracticeInfo) -> String {
        practice.relatedPrinciples
            .map { String($0.rawValue.prefix(2)) }
            .joined(separator: ", ")
    }
}

#Preview {
    DesignOverviewView()
}
