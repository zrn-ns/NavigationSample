//
//  PracticeDetailView.swift
//  NavigationSample
//

import SwiftUI

/// 具体的手段の詳細を表示する View
struct PracticeDetailView: View {
    let practiceInfo: PracticeInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                descriptionSection
                if !practiceInfo.codeExamples.isEmpty {
                    codeExamplesSection
                }
                if !practiceInfo.relatedPrinciples.isEmpty {
                    relatedPrinciplesSection
                }
            }
            .padding()
        }
        .navigationTitle(practiceInfo.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: ScreenDesignInfo.Principle.self) { principle in
            PrincipleDetailView(principleInfo: PrincipleInfoProvider.info(for: principle))
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        Text(practiceInfo.title)
            .font(.title3)
            .fontWeight(.bold)
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("説明")

            Text(practiceInfo.description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private var codeExamplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("コードサンプル")

            ForEach(
                Array(practiceInfo.codeExamples.enumerated()),
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

    private var relatedPrinciplesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("関連する原則")

            ForEach(practiceInfo.relatedPrinciples, id: \.self) { principle in
                let principleInfo = PrincipleInfoProvider.info(for: principle)
                NavigationLink(value: principle) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(principle.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(principleInfo.explanation)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
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

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.top, 8)
    }
}

#Preview {
    NavigationStack {
        PracticeDetailView(practiceInfo: PracticeInfoProvider.practice1)
    }
}
