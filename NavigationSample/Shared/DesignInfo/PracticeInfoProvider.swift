//
//  PracticeInfoProvider.swift
//  NavigationSample
//

import Foundation

/// 全具体的手段の詳細情報を提供するプロバイダー
enum PracticeInfoProvider {

    /// 全手段の情報
    static let all: [PracticeInfo] = [
        practice1, practice2, practice3, practice4, practice5,
        practice6, practice7, practice8, practice9, practice10,
        practice11,
    ]

    /// 指定した ID の手段情報を取得
    static func info(for id: String) -> PracticeInfo? {
        all.first { $0.id == id }
    }

    // MARK: - 手段1: Feature 単位で Route を定義する

    static let practice1 = PracticeInfo(
        id: "practice1",
        title: "Feature 単位で Route を定義する",
        description: """
        Route は Feature の境界内で定義する。\
        Feature ごとに専用の Route enum を持つことで、\
        Feature 間の結合度を下げ、独立した開発・テストを可能にする。

        グローバルな Route は最小限にとどめ、\
        各 Feature が自身の遷移先を型安全に管理する。
        """,
        codeExamples: [
            .init(
                description: "Feature 単位で Route を定義する例",
                code: """
                enum HomeRoute: Hashable {
                    case itemDetail(Item.ID)
                }

                enum SettingsRoute: Hashable {
                    case detail(String)
                }
                """
            ),
        ],
        relatedPrinciples: [.f3]
    )

    // MARK: - 手段2: NavigationStack は Feature の Root にのみ置く

    static let practice2 = PracticeInfo(
        id: "practice2",
        title: "NavigationStack は Feature の Root にのみ置く",
        description: """
        NavigationStack は Feature の RootView にのみ配置し、\
        子 View には配置しない。

        これにより、Feature 内のナビゲーション文脈が\
        1つに保たれ、文脈の衝突を防げる。\
        また、path の管理が RootView に集約されるため、\
        状態の追跡が容易になる。
        """,
        codeExamples: [
            .init(
                description: "Feature の RootView に NavigationStack を配置する例",
                code: """
                struct HomeRootView: View {
                    @State private var path: [HomeRoute] = []

                    var body: some View {
                        NavigationStack(path: $path) {
                            HomeView()
                        }
                    }
                }
                """
            ),
        ],
        relatedPrinciples: [.c1, .f1]
    )

    // MARK: - 手段3: Modal 用 Route を別 enum として定義する

    static let practice3 = PracticeInfo(
        id: "practice3",
        title: "Modal 用 Route を別 enum として定義する",
        description: """
        push 用の Route と Modal 用の Route は別の enum として定義する。

        push はスタック型（[Route]）、Modal は排他的（Route?）であり、\
        性質が異なるため同一の enum に混在させてはならない。\
        Modal 用の enum は Identifiable に準拠させ、\
        item: ベースの sheet/fullScreenCover で使用する。
        """,
        codeExamples: [
            .init(
                description: "Modal 用の Route を Identifiable な enum で定義する例",
                code: """
                enum AppModal: Identifiable {
                    case login
                    case onboarding
                    case web(URL)

                    var id: String {
                        switch self {
                        case .login: return "login"
                        case .onboarding: return "onboarding"
                        case .web(let url): return "web-\\(url.absoluteString)"
                        }
                    }
                }
                """
            ),
        ],
        relatedPrinciples: [.p1, .s2]
    )

    // MARK: - 手段4: Modal は item: ベースで制御する

    static let practice4 = PracticeInfo(
        id: "practice4",
        title: "Modal は item: ベースで制御する",
        description: """
        Modal の表示制御には isPresented: ではなく item: を使う。

        item: ベースでは「何が表示されているか」を\
        Route enum で明示的に表現でき、意味表現原則に合致する。\
        isPresented: + Bool では「表示中かどうか」しか表せず、\
        複数の Modal を管理する際に状態が複雑になる。
        """,
        codeExamples: [
            .init(
                description: "item: ベースで Modal を制御する例",
                code: """
                .sheet(item: $appModal) {
                    AppModalRoot(modal: $0)
                }
                """
            ),
        ],
        relatedPrinciples: [.p1]
    )

    // MARK: - 手段5: Modal は Feature として RootView を持たせる

    static let practice5 = PracticeInfo(
        id: "practice5",
        title: "Modal は Feature として RootView を持たせる",
        description: """
        Modal で表示する画面にも独自の RootView と NavigationStack を持たせ、\
        Feature として設計する。

        Modal は独立した文脈であり（P2）、\
        内部に独自のナビゲーションフローを持てる。\
        RootView を Feature エントリポイントとすることで、\
        Modal 内の遷移も型安全に管理できる。
        """,
        codeExamples: [
            .init(
                description: "Modal 用の Feature RootView の例",
                code: """
                struct LoginRootView: View {
                    @State private var path: [LoginRoute] = []

                    var body: some View {
                        NavigationStack(path: $path) {
                            LoginStartView()
                        }
                    }
                }
                """
            ),
        ],
        relatedPrinciples: [.p2, .c3]
    )

    // MARK: - 手段6: Feature 間遷移は Event として上位に委譲する

    static let practice6 = PracticeInfo(
        id: "practice6",
        title: "Feature 間遷移は Event として上位に委譲する",
        description: """
        Feature が他の Feature への遷移を必要とする場合、\
        直接遷移するのではなく Event として上位レイヤーに委譲する。

        Feature は自身の Event enum を定義し、\
        上位（Coordinator / App 層）がその Event を解釈して\
        適切な遷移を実行する。\
        これにより Feature 間の疎結合を維持できる。
        """,
        codeExamples: [
            .init(
                description: "Event を上位に委譲する例",
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
        ],
        relatedPrinciples: [.e2, .f2]
    )

    // MARK: - 手段7: 遷移を指示するコードは状態を書き換えるだけにする

    static let practice7 = PracticeInfo(
        id: "practice7",
        title: "遷移を指示するコードは状態を書き換えるだけにする",
        description: """
        遷移を発生させるコードは、状態の書き換えのみを行う。\
        命令的な画面遷移メソッドの呼び出しは行わない。

        遷移の意味と対応するコード:
        ・Feature 内 push → path.append(route) — RootView で実行
        ・Feature 内 pop → path.removeLast() — RootView で実行
        ・Feature 内 modal → modal = .xxx — RootView で実行
        ・modal dismiss → modal = nil — RootView で実行
        ・Feature 跨ぎ → send(Event) — View で実行
        ・App modal（SwiftUI） → appModal = .xxx — App 層で実行
        ・App modal（UIKit） → present(hostingController, animated:) — Coordinator で実行
        ・modal dismiss（UIKit） → dismiss(animated:) — Coordinator で実行
        ・上位 push → appPath.append(route) — App 層で実行
        ・文脈終了の意図表明 → dismiss() — View で実行
        """,
        codeExamples: [],
        relatedPrinciples: [.s1]
    )

    // MARK: - 手段8: 表示手段は Coordinator の責務とする

    static let practice8 = PracticeInfo(
        id: "practice8",
        title: "表示手段（トランジション・インタラクティブ dismiss）は Coordinator の責務とする",
        description: """
        同一の Feature でも表示元によって表示手段が異なることがある。

        例:
        ・UserGrid → UserDetail: push 風カスタムトランジション + スワイプ dismiss
        ・Settings → プロフィールプレビュー: 通常 fullScreenModal（スワイプ dismiss なし）

        Feature の API に表示手段に依存するパラメータ（ナビゲーション深度コールバック等）を追加しない。\
        表示手段の違いは Coordinator が吸収する。\
        Coordinator が Feature の Router の状態を参照する必要がある場合は、\
        Router を Coordinator で生成し Feature に渡す。
        """,
        codeExamples: [
            .init(
                description: "Coordinator が Router を生成し状態を参照する例",
                code: """
                // Coordinator が router を生成し、状態を参照する
                func showUserDetail(user: User) {
                    let router = UserDetailRouter(user: user)

                    dismissalInteractor.isAtNavigationRoot = { [weak router] in
                        router?.path.isEmpty ?? true
                    }

                    let detailRootView = UserDetailRootView(
                        router: router,
                        onEvent: { [weak self] event in self?.handle(event) }
                    )
                    // ...
                }
                """
            ),
        ],
        relatedPrinciples: [.r2]
    )

    // MARK: - 手段9: push 用 path は型安全な [Route] を使用する

    static let practice9 = PracticeInfo(
        id: "practice9",
        title: "push 用 path は型安全な [Route] を使用する",
        description: """
        push 用の path は原則として [Route] を使用する。\
        NavigationPath は例外的なケースのみ検討する。

        [Route] と NavigationPath の比較:
        ・型安全性 — [Route] はコンパイル時チェック、NavigationPath はランタイムのみ
        ・Feature 境界の強制 — [Route] は型エラーで防止、NavigationPath は防止不可
        ・状態復元 — [Route] は Codable で直接対応、NavigationPath は CodableRepresentation 経由
        ・網羅性チェック — [Route] は switch で強制、NavigationPath は不可
        ・複数型の混在 — [Route] は単一型に限定、NavigationPath は可能

        NavigationPath を検討するケース（例外的）:
        ・App 層での統合ナビゲーション（オンボーディングフロー等）
        ・CMS 連携等の動的な画面構成
        ・外部 URL からの複雑な Deep Linking 復元
        """,
        codeExamples: [
            .init(
                description: "推奨: 型安全な [Route]",
                code: """
                // ✅ 推奨: 型安全な [Route]
                @State private var path: [HomeRoute] = []
                """
            ),
            .init(
                description: "非推奨: 型消去された NavigationPath",
                code: """
                // ❌ 使用しない: 型消去された NavigationPath
                @State private var path = NavigationPath()
                """
            ),
        ],
        relatedPrinciples: [.f1, .f3]
    )

    // MARK: - 手段10: UIKit App 層 + SwiftUI Feature 層で構成する

    static let practice10 = PracticeInfo(
        id: "practice10",
        title: "UIKit App 層 + SwiftUI Feature 層で構成する",
        description: """
        UIKit ベースの既存アプリに SwiftUI を導入する際の推奨構成。

        構成:
        UIKit App
        ├── AppDelegate.swift (UIKit)
        ├── SceneDelegate.swift (UIKit)
        ├── AppCoordinator.swift (UIKit Coordinator)
        ├── MainTabBarController.swift (UITabBarController)
        └── Features/
            ├── Home/ (UIHostingController + SwiftUI NavigationStack)
            ├── Settings/ (UIHostingController + SwiftUI NavigationStack)
            └── Login/ (UIHostingController + SwiftUI NavigationStack)

        UIKit Coordinator が App 層の Modal 表示・非表示を管理し、\
        Feature 層は Event を上位に委譲するのみ。\
        UITabBarController の各タブが UIHostingController で SwiftUI View をラップし、\
        タブ切り替え時、選択されていないタブの NavigationStack は非アクティブになる。

        ポイント:
        ・SwiftUI View は既存の設計を変更不要（onEvent パターンはそのまま使用可能）
        ・UIKit Coordinator が App 層の Modal 状態・Tab 選択状態を管理
        ・SwiftUI Router が Feature 内の path・modal 状態を管理
        ・イベントフロー: SwiftUI View → Event → UIHostingController → Coordinator → UIKit の遷移処理
        """,
        codeExamples: [
            .init(
                description: "AppCoordinator（UIKit）の例",
                code: """
                @MainActor
                final class AppCoordinator {
                    private let window: UIWindow
                    private var tabBarController: MainTabBarController?
                    var currentModal: AppModal?

                    func start() {
                        let tabBarController = MainTabBarController(coordinator: self)
                        self.tabBarController = tabBarController
                        window.rootViewController = tabBarController
                        window.makeKeyAndVisible()
                    }

                    func handle(_ event: LoginEvent) {
                        switch event {
                        case .completed, .cancelled:
                            dismissModal()
                        }
                    }
                }
                """
            ),
            .init(
                description: "MainTabBarController（UIKit）の例",
                code: """
                final class MainTabBarController: UITabBarController {
                    private weak var coordinator: AppCoordinator?

                    private func setupTabs() {
                        let homeRootView = HomeRootView(onEvent: { [weak self] event in
                            self?.coordinator?.handle(event)
                        })
                        let homeVC = UIHostingController(rootView: homeRootView)
                        homeVC.tabBarItem = UITabBarItem(
                            title: "ホーム",
                            image: UIImage(systemName: "house"),
                            tag: 0
                        )
                        viewControllers = [homeVC, settingsVC]
                    }
                }
                """
            ),
        ],
        relatedPrinciples: [.r2, .c1]
    )

    // MARK: - 手段11: UIKit / SwiftUI 連携パターンを用途に応じて使い分ける

    static let practice11 = PracticeInfo(
        id: "practice11",
        title: "UIKit / SwiftUI 連携パターンを用途に応じて使い分ける",
        description: """
        UIKit App 層と SwiftUI Feature 層の境界では、\
        用途に応じて以下のパターンを使い分ける。

        パターン A: SwiftUI Feature 内で UIKit 画面を modal 表示
        ・既存 UIKit 画面の遷移ロジックを変更せずに統合できる
        ・UINavigationController でラップして modal 表示
        ・閉じるときだけ SwiftUI 側に onDismiss で通知

        パターン B: UIKit グリッドから SwiftUI Feature を push 遷移
        ・UINavigationController を UIKit Coordinator が保持
        ・SwiftUI Feature を UIHostingController でラップして push
        ・push された Feature 内では独自の NavigationStack で Feature 内遷移が可能

        パターン C: UIKit 画面から SwiftUI Feature を modal 表示
        ・UIHostingController で SwiftUI View をラップして present
        ・onEvent クロージャで UIKit 側にイベントを伝達

        パターン D: UIKit 画面の一部を SwiftUI で構築
        ・UIHostingController を child view controller として追加
        ・Auto Layout で SwiftUI View のサイズ・位置を制御
        ・SwiftUI View からのイベントはクロージャで UIKit 側に伝達
        """,
        codeExamples: [
            .init(
                description: "パターン A: SwiftUI Feature 内で UIKit 画面を modal 表示",
                code: """
                // UINavigationController を SwiftUI でラップ
                struct LegacyProfileNavigationControllerRepresentable:
                    UIViewControllerRepresentable
                {
                    let rootViewController: UIViewController

                    func makeUIViewController(context: Context) -> UINavigationController {
                        UINavigationController(rootViewController: rootViewController)
                    }

                    func updateUIViewController(
                        _ uiViewController: UINavigationController,
                        context: Context
                    ) {}
                }

                // sheet で表示
                .sheet(item: $router.modal) { modal in
                    switch modal {
                    case .legacyProfile:
                        LegacyProfileModalView(
                            user: router.user,
                            onDismiss: { router.dismissModal() }
                        )
                    }
                }
                """
            ),
            .init(
                description: "パターン B: UIKit グリッドから SwiftUI Feature を push 遷移",
                code: """
                // UIKit Coordinator
                @MainActor
                final class UserGridCoordinator {
                    private let navigationController: UINavigationController

                    func showUserDetail(user: User) {
                        let detailRootView = UserDetailRootView(
                            user: user,
                            onEvent: { [weak self] event in
                                self?.handle(event)
                            }
                        )
                        let hostingController = UIHostingController(rootView: detailRootView)
                        navigationController.pushViewController(
                            hostingController,
                            animated: true
                        )
                    }
                }
                """
            ),
            .init(
                description: "パターン C: UIKit 画面から SwiftUI Feature を modal 表示",
                code: """
                final class SomeViewController: UIViewController {
                    private func presentSwiftUIFeature() {
                        let swiftUIView = LoginRootView(onEvent: { [weak self] event in
                            self?.handleLoginEvent(event)
                        })
                        let hostingController = UIHostingController(rootView: swiftUIView)
                        hostingController.modalPresentationStyle = .fullScreen
                        present(hostingController, animated: true)
                    }
                }
                """
            ),
            .init(
                description: "パターン D: UIKit 画面の一部を SwiftUI で構築",
                code: """
                final class HybridViewController: UIViewController {
                    private var hostingController: UIHostingController<SomeSwiftUIView>?

                    private func setupSwiftUIView() {
                        let swiftUIView = SomeSwiftUIView(
                            onTap: { [weak self] in self?.handleTap() }
                        )
                        let hosting = UIHostingController(rootView: swiftUIView)

                        addChild(hosting)
                        view.addSubview(hosting.view)
                        hosting.didMove(toParent: self)

                        hosting.view.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            hosting.view.topAnchor.constraint(
                                equalTo: view.safeAreaLayoutGuide.topAnchor
                            ),
                            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                            hosting.view.heightAnchor.constraint(equalToConstant: 200),
                        ])

                        hostingController = hosting
                    }
                }
                """
            ),
        ],
        relatedPrinciples: [.f2, .e2]
    )
}
