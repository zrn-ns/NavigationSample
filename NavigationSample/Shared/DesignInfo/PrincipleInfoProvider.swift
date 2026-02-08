//
//  PrincipleInfoProvider.swift
//  NavigationSample
//

import Foundation

/// 全設計原則の詳細情報を提供するプロバイダー
enum PrincipleInfoProvider {

    /// 逆引き用の全画面設計情報
    static let allScreenDesignInfos: [ScreenDesignInfo] = [
        ScreenDesignInfoProvider.userGrid,
        ScreenDesignInfoProvider.userDetail,
        ScreenDesignInfoProvider.userPhotoList,
        ScreenDesignInfoProvider.userPhotoDetail,
        ScreenDesignInfoProvider.likeSend,
        ScreenDesignInfoProvider.settings,
        ScreenDesignInfoProvider.designOverview,
        ScreenDesignInfoProvider.loginStart,
        ScreenDesignInfoProvider.loginComplete,
        ScreenDesignInfoProvider.loginFailure,
    ]

    /// 全原則の情報
    static let all: [PrincipleInfo] = [
        s1, s2, c1, c2, c3, f1, f2, f3, p1, p2, r1, r2, e1, e2,
    ]

    /// カテゴリ別にグループ化された原則情報
    static let groupedByCategory: [(category: String, principles: [PrincipleInfo])] = {
        let categories = ["状態駆動", "文脈構造", "Feature境界", "状態分離", "責務分離", "結果伝達"]
        return categories.compactMap { category in
            let matched = all.filter { $0.category == category }
            return matched.isEmpty ? nil : (category, matched)
        }
    }()

    /// 指定した原則の詳細情報を取得
    static func info(for principle: ScreenDesignInfo.Principle) -> PrincipleInfo {
        // all は全ケースを網羅しているため強制アンラップは安全
        all.first { $0.principle == principle }!
    }

    /// 画面パターン別 適用原則マトリクス
    static let navigationPatternMatrix: [(pattern: String, principles: [ScreenDesignInfo.Principle])] = [
        ("全画面共通", [.s1, .s2]),
        ("NavigationStack (push)", [.c1, .c2, .f1, .p1, .r2]),
        ("Modal 表示", [.c1, .c2, .c3, .p2, .r2, .e1, .e2]),
        ("Feature 内遷移", [.f1, .f3]),
        ("Feature 間遷移", [.f2, .e2]),
        ("View 実装", [.r1, .s2]),
        ("RootView 設計", [.p1, .p2, .r2]),
    ]

    // MARK: - 状態駆動

    static let s1 = PrincipleInfo(
        principle: .s1,
        category: "状態駆動",
        explanation: "ナビゲーションは「画面遷移」ではなく「状態遷移」である",
        detailedExplanation: """
        SwiftUI は命令的に画面を遷移させる UI フレームワークではない。\
        「今どの画面が表示されているか」は、状態の結果として決まる。

        つまり開発者が行うのは「画面 A から画面 B に遷移する」ではなく、\
        「状態を変更し、その結果として画面が変わる」ということである。\
        この原則を守ることで、ナビゲーション状態の一元管理・復元・テストが容易になる。
        """,
        codeExamples: [
            .init(
                description: "状態を変更するだけで画面が変わる",
                code: """
                // 状態を変更するだけで画面が変わる
                path.append(.detail(id))  // push
                modal = .login            // modal 表示
                """
            ),
        ]
    )

    static let s2 = PrincipleInfo(
        principle: .s2,
        category: "状態駆動",
        explanation: "Route は「画面」ではなく「意味」を表す",
        detailedExplanation: """
        状態は「何が起きているか」を直接表現すべきである。\
        Bool は「起きている／いない」しか表せないが、\
        Route は「何が起きているか」を明確に表せる。

        Route の命名は画面名ではなくドメイン上の意味を反映させる。\
        これにより、Route を見ただけで「何のために遷移したか」が分かるようになる。
        """,
        codeExamples: [
            .init(
                description: "Route は画面名ではなく意味を表す",
                code: """
                // ❌ 画面名
                case detailView

                // ⭕ 意味
                case itemDetail(id: Item.ID)
                """
            ),
        ]
    )

    // MARK: - 文脈構造

    static let c1 = PrincipleInfo(
        principle: .c1,
        category: "文脈構造",
        explanation: "表示されている View が属するナビゲーション文脈は常に1つである",
        detailedExplanation: """
        NavigationStack、Modal（sheet / fullScreenCover）、Tab ——\
        これらは同時に1つの文脈だけが有効になる。

        構造的に NavigationStack が複数存在してもよいが、\
        同時に有効なものは1つだけである。\
        この原則を意識することで、ナビゲーション文脈の衝突や\
        予期しない振る舞いを防げる。
        """,
        codeExamples: [
            .init(
                description: "各タブが独立した NavigationStack を持つ例",
                code: """
                TabView {
                    // 各タブが独自の NavigationStack を持つ
                    HomeRootView()      // 内部に NavigationStack
                    SettingsRootView()  // 内部に NavigationStack
                }
                // タブ切り替え時、選択されていないタブの
                // NavigationStack は「存在するが非アクティブ」
                """
            ),
        ]
    )

    static let c2 = PrincipleInfo(
        principle: .c2,
        category: "文脈構造",
        explanation: "文脈（Context）には階層とスコープがある",
        detailedExplanation: """
        文脈は以下の階層で構成される:
        ・App 全体の文脈
        ・Feature の文脈
        ・Feature 内フローの文脈

        遷移設計とは、どの文脈に切り替わるかを定義することである。\
        状態のスコープは、その意味が通用する範囲に一致すべきであり、\
        上位の文脈で管理すべき状態を下位に持たせてはならない。
        """,
        codeExamples: []
    )

    static let c3 = PrincipleInfo(
        principle: .c3,
        category: "文脈構造",
        explanation: "文脈が切り替わると、元の文脈は一時停止される",
        detailedExplanation: """
        文脈が切り替わると、元の文脈は一時停止される。\
        NavigationStack の path は保持されるが操作対象ではなくなる。\
        dismiss / pop により元の文脈が再開される。

        この仕組みを理解することで、Modal 表示中に\
        背後の NavigationStack を操作してしまうような\
        バグを防げる。
        """,
        codeExamples: []
    )

    // MARK: - Feature 境界

    static let f1 = PrincipleInfo(
        principle: .f1,
        category: "Feature境界",
        explanation: "NavigationStack（push）は同一 Feature 内に限定する",
        detailedExplanation: """
        push は文脈の継続を意味する。\
        Feature を跨ぐ push は文脈破壊であり、\
        ナビゲーション状態の管理を複雑にする。

        Feature を跨ぐ場合は push ではなく、\
        Modal や Tab 切り替えなどの「文脈の切断」を用いる。
        """,
        codeExamples: []
    )

    static let f2 = PrincipleInfo(
        principle: .f2,
        category: "Feature境界",
        explanation: "Feature を跨ぐ遷移は「文脈の切断」として扱う",
        detailedExplanation: """
        Feature を跨ぐ遷移の手段は以下に限定される:
        ・Tab 切り替え
        ・Modal 表示
        ・上位 NavigationStack での例外的 push

        これらはいずれも「現在の文脈を一時停止し、\
        新しい文脈を開始する」という意味を持つ。
        """,
        codeExamples: []
    )

    static let f3 = PrincipleInfo(
        principle: .f3,
        category: "Feature境界",
        explanation: "Route は Feature 境界を越えない",
        detailedExplanation: """
        Feature ごとに Route を定義し、\
        グローバル Route は最小限にとどめる。

        Route が Feature 境界を越えると、\
        Feature 間の結合度が高くなり、\
        独立した開発やテストが困難になる。
        """,
        codeExamples: [
            .init(
                description: "Feature 単位で Route を定義する例",
                code: """
                // Feature 単位で Route を定義
                enum HomeRoute: Hashable {
                    case itemDetail(Item.ID)
                }

                enum SettingsRoute: Hashable {
                    case detail(String)
                }
                """
            ),
        ]
    )

    // MARK: - 状態分離

    static let p1 = PrincipleInfo(
        principle: .p1,
        category: "状態分離",
        explanation: "Push 用の状態と Modal 用の状態は分離する",
        detailedExplanation: """
        push はスタック型（[Route]）、Modal は排他的（Route?）であり、\
        同一 state に混在させてはならない。

        これらを分離することで、push と Modal の\
        ライフサイクルが互いに干渉せず、\
        状態管理がシンプルになる。
        """,
        codeExamples: [
            .init(
                description: "Router で push と modal の状態を分離する例",
                code: """
                @Observable final class FeatureRouter {
                    var path: [FeatureRoute] = []   // push 用
                    var modal: FeatureModal?         // modal 用
                }
                """
            ),
        ]
    )

    static let p2 = PrincipleInfo(
        principle: .p2,
        category: "状態分離",
        explanation: "Modal は「一時的 UI」ではなく「独立した文脈」である",
        detailedExplanation: """
        Modal は dismiss により文脈復帰が起きる独立した文脈である。\
        内部に独自の Navigation を持つことができる。

        ModalRoute は「文脈のスコープ」で定義する:
        ・App 文脈 → AppModal
        ・Feature 文脈 → FeatureModal
        ・画面単位では定義しない
        """,
        codeExamples: []
    )

    // MARK: - 責務分離

    static let r1 = PrincipleInfo(
        principle: .r1,
        category: "責務分離",
        explanation: "View は遷移の決定権を持たない",
        detailedExplanation: """
        View は「意図」を表明するだけであり、\
        遷移の解釈は上位レイヤーの責務である。

        View が直接 NavigationLink の遷移先を決定したり、\
        Modal を表示したりするのではなく、\
        Router 等の上位レイヤーに「こうしたい」という意図を伝える。
        """,
        codeExamples: [
            .init(
                description: "View は意図を表明し、Router が遷移を決定する",
                code: """
                // View は意図を表明
                Button("詳細を見る") {
                    router.showDetail(id)  // 「詳細を見たい」という意図
                }
                // Router が遷移方法を決定
                """
            ),
        ]
    )

    static let r2 = PrincipleInfo(
        principle: .r2,
        category: "責務分離",
        explanation: "文脈を開始した主体が、文脈を終了させる責務を持つ",
        detailedExplanation: """
        ・Feature が開始した文脈は Feature が閉じる
        ・App が開始した文脈は App が閉じる
        ・push された画面は、同じ NavigationStack が閉じる
        ・Modal は、それを管理している状態が閉じる

        @Environment(\\.dismiss) は「文脈を終了したい」という\
        意図の表明として使用可能。SwiftUI が文脈に応じて\
        適切な方法（NavigationStack 内では pop、Modal では dismiss）を決定する。
        """,
        codeExamples: [
            .init(
                description: "Modal を開いた状態を nil に戻して閉じる",
                code: """
                // Modal を開いた state（ModalRoute?）を nil に戻す
                func dismissModal() {
                    modal = nil
                }
                """
            ),
        ]
    )

    // MARK: - 結果伝達

    static let e1 = PrincipleInfo(
        principle: .e1,
        category: "結果伝達",
        explanation: "「画面を閉じる」とは「文脈を終了させる」ことであり、結果を伴う",
        detailedExplanation: """
        pop / dismiss は UI 命令ではなく、\
        現在の文脈が終了したという状態遷移の結果である。

        文脈の終了には、成功・キャンセル・失敗など\
        ドメイン上の意味ある結果が伴う。\
        この結果を適切に上位レイヤーに伝達することで、\
        後続処理を正しく行える。
        """,
        codeExamples: []
    )

    static let e2 = PrincipleInfo(
        principle: .e2,
        category: "結果伝達",
        explanation: "Modal 内の処理結果は「閉じる命令」ではなく「イベント」として返す",
        detailedExplanation: """
        ModalView は処理結果を Result として上位に返し、\
        上位が結果を解釈して Modal を閉じる。

        Feature 間の連携も Event として上位に委譲する。\
        これにより Feature は他の Feature の存在を知らずに済み、\
        疎結合なアーキテクチャが実現できる。
        """,
        codeExamples: [
            .init(
                description: "Event を上位に委譲して Feature 間を連携する例",
                code: """
                enum HomeEvent {
                    case requireLogin
                }

                func handle(_ event: HomeEvent) {
                    switch event {
                    case .requireLogin:
                        appModal = .login
                    }
                }
                """
            ),
        ]
    )
}
