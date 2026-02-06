# SwiftUI ナビゲーション／Modal 設計 原理原則まとめ

本ドキュメントは、SwiftUI におけるナビゲーションおよび Modal 設計を、
**原理 → 原則 → 具体的手段** の三層構造で整理したものである。

API や実装テクニックではなく、
「なぜそう設計するのか」を再利用可能な形で言語化することを目的とする。

---

## 原理（Principles）

### 原理1
ナビゲーションは「画面遷移」ではなく「状態遷移」である

- SwiftUI は命令的に画面を遷移させる UI フレームワークではない
- 「今どの画面が表示されているか」は、状態の結果として決まる

---

### 原理2
表示されている View が属するナビゲーション文脈は常に1つである

- NavigationStack
- Modal（sheet / fullScreenCover）
- Tab

これらは **同時に1つの文脈だけが有効** になる

---

### 原理3
文脈（Context）には階層とスコープがある

- App 全体の文脈
- Feature の文脈
- Feature 内フローの文脈

遷移設計とは、**どの文脈に切り替わるかを定義すること**である

---

### 原理4
文脈が切り替わると、元の文脈は一時停止される

- NavigationStack の path は保持される
- ただし操作対象ではなくなる
- dismiss / pop により再開される

---

### 原理5
状態は「何が起きているか」を直接表現すべきである

- Bool は「起きている／いない」しか表せない
- Route は「何が起きているか」を表せる

---

### 原理6
状態のスコープは、その意味が通用する範囲に一致すべきである

- 意味が通じない範囲まで状態を共有すると設計が破綻する
- Route / ModalRoute の定義単位は「意味のスコープ」

---

### 原理7
「画面を閉じる」とは、UI 操作ではなく「文脈を終了させる」ことである

- pop / dismiss は UI 命令ではない
- 現在の文脈が終了したという状態遷移の結果である

---

### 原理8
文脈を開始した主体が、文脈を終了させる責務を持つ

- Feature が開始した文脈は Feature が閉じる
- App が開始した文脈は App が閉じる

View 自身が「自分を閉じる」決定権を持ってはならない

---

### 原理9
文脈の終了は、結果（Outcome）を伴うことがある

- 成功
- キャンセル
- 失敗

これらは UI ではなく、ドメイン上の意味ある結果である

---

## 原則（Rules）

### 原則1
NavigationStack（push）は同一 Feature 内に限定する

- push = 文脈の継続
- Feature を跨ぐ push は文脈破壊

---

### 原則2
Feature を跨ぐ遷移は「文脈の切断」として扱う

- Tab 切り替え
- Modal 表示
- 上位 NavigationStack での例外的 push

---

### 原則3
Push 用の状態と Modal 用の状態は分離する

- push：スタック型（`[Route]`）
- modal：排他的（`Route?`）

同一 state に混在させない

---

### 原則4
Route は「画面」ではなく「意味」を表す

- ❌ DetailView
- ⭕ ItemDetail(id)

---

### 原則5
Route は Feature 境界を越えない

- Feature ごとに Route を定義
- グローバル Route は最小限

---

### 原則6
構造的に NavigationStack が複数存在してもよいが、
同時に有効なものは1つにする

- 表示対象として1つだけが有効であることが重要

**具体例: TabView 内の NavigationStack**

```swift
TabView {
    // 各タブが独自の NavigationStack を持つ
    HomeRootView()      // 内部に NavigationStack
    SearchRootView()    // 内部に NavigationStack
    ProfileRootView()   // 内部に NavigationStack
}
```

タブ切り替え時、選択されていないタブの NavigationStack は「存在するが非アクティブ」となる。

---

### 原則7
Modal は「一時的 UI」ではなく「独立した文脈」である

- dismiss により文脈復帰が起きる
- 内部に独自の Navigation を持てる

---

### 原則8
ModalRoute は「文脈のスコープ」で定義する

- App 文脈 → AppModal
- Feature 文脈 → FeatureModal
- 画面単位では定義しない

---

### 原則9
View は遷移の決定権を持たない

- View は「意図」を表明するだけ
- 遷移の解釈は上位レイヤーの責務

---

### 原則10
push された画面は、同じ NavigationStack が閉じる

- `@Environment(\.dismiss)` は「文脈を終了したい」という意図の表明として使用可能
- SwiftUI が文脈に応じて適切な方法（NavigationStack 内では pop、Modal では dismiss）を決定する
- View は「どのように閉じるか」を知らず、フレームワークに委ねる

---

### 原則11
Modal は、それを管理している状態が閉じる

- Modal を開いた state（`ModalRoute?`）を `nil` に戻す
- ModalView 自身が dismiss を決定しない

---

### 原則12
Modal 内の処理結果は「閉じる命令」ではなく「イベント」として返す

- ModalView → Result
- 上位が結果を解釈して閉じる

---

### 原則13
文脈を跨ぐ「強制的な終了」は、常に上位レイヤーの責務である

- ログアウト
- セッション切れ
- 強制アップデート

Feature が勝手に自分や他 Feature の文脈を破壊しない

---

## 具体的手段（Practices）

### 手段1
Feature 単位で Route を定義する

```swift
enum HomeRoute: Hashable {
    case itemDetail(Item.ID)
}
```

---

### 手段2
NavigationStack は Feature の Root にのみ置く

```swift
struct HomeRootView: View {
    @State private var path: [HomeRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
        }
    }
}
```

---

### 手段3
Modal 用 Route を別 enum として定義する

```swift
enum AppModal: Identifiable {
    case login
    case onboarding
    case web(URL)

    var id: String {
        switch self {
        case .login: return "login"
        case .onboarding: return "onboarding"
        case .web(let url): return "web-\(url.absoluteString)"
        }
    }
}
```

---

### 手段4
Modal は `item:` ベースで制御する

```swift
.sheet(item: $appModal) {
    AppModalRoot(modal: $0)
}
```

---

### 手段5
Modal は Feature として RootView を持たせる

```swift
struct LoginRootView: View {
    @State private var path: [LoginRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            LoginStartView()
        }
    }
}
```

---

### 手段6
Feature 間遷移は Event として上位に委譲する

```swift
enum HomeEvent {
    case requireLogin
}
```

```swift
func handle(_ event: HomeEvent) {
    switch event {
    case .requireLogin:
        appModal = .login
    }
}
```

---

### 手段7
遷移を指示するコードは状態を書き換えるだけにする

| 遷移の意味 | 書くコード | 実行場所 |
|---|---|---|
| Feature 内 push | `path.append(route)` | RootView |
| Feature 内 pop | `path.removeLast()` | RootView |
| Feature 内 modal | `modal = .xxx` | RootView |
| modal dismiss | `modal = nil` | RootView |
| Feature 跨ぎ | `send(Event)` | View |
| App modal | `appModal = .xxx` | App層 |
| 上位 push | `appPath.append(route)` | App層 |
| 文脈終了の意図表明 | `dismiss()` | View |

**補足: `@Environment(\.dismiss)` について**

View が「現在の文脈を終了したい」という意図を表明する場合、`@Environment(\.dismiss)` を使用する。
SwiftUI が文脈に応じて適切な方法（NavigationStack 内では pop、Modal では dismiss）を決定するため、
View は具体的な終了方法を知る必要がない。

```swift
struct DetailView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button("戻る") {
            dismiss()  // 文脈終了の意図を表明
        }
    }
}
```

---

## 一文要約

**SwiftUI のナビゲーション設計とは、
アプリの文脈遷移を、状態として正しくモデル化することである。**

---

## 課題・検討事項

本ドキュメントの改善に向けて、以下の課題を検討・実装していく。

### 課題1: NavigationPath vs [Route] の選択基準

**ステータス:** 🟢 解決済み

#### 結論

**原則として `[Route]` を使用する。`NavigationPath` は例外的なケースのみ。**

#### 技術的比較

| 観点 | `[Route]` | `NavigationPath` |
|------|-----------|------------------|
| 型安全性 | ✅ コンパイル時チェック | ❌ ランタイムのみ |
| Feature 境界の強制 | ✅ 型エラーで防止 | ❌ 防止不可 |
| 状態復元 | ✅ Codable で直接対応 | △ CodableRepresentation 経由 |
| 網羅性チェック | ✅ switch で強制 | ❌ 不可 |
| 複数型の混在 | ❌ 単一型に限定 | ✅ 可能 |

#### 設計原則との整合性

- **原則1**「NavigationStack（push）は同一 Feature 内に限定する」→ `[Route]` が完全適合
- **原則5**「Route は Feature 境界を越えない」→ `[Route]` なら型システムで強制可能
- Feature 境界を越える遷移は Modal / Tab / Event で対応するため、複数型混在の必要がない

#### 選択フローチャート

```
遷移の種類を判定
    │
    ├─ 単一 Feature 内の遷移
    │   └─→ [Route] を使用
    │
    ├─ Feature 間遷移
    │   └─→ Modal / Tab / Event で対応（[Route] を維持）
    │
    └─ App 層で統合的なスタックが必要（例外的）
        └─→ NavigationPath を検討
```

#### NavigationPath を使用するケース（例外的）

以下のような特殊なケースでのみ `NavigationPath` を検討する：

1. **App 層での統合ナビゲーション**
   - オンボーディングフロー等、複数 Feature を順に表示する必要がある場合
   - ただし、Modal で代替できないか先に検討すること

2. **動的な画面構成**
   - CMS 連携等、実行時に画面構成が決まる場合
   - A/B テストで画面フローが変わる場合

3. **Deep Linking の複雑な復元**
   - 外部 URL から複数階層の状態を復元する必要がある場合
   - ただし、大抵は Feature 単位の `[Route]` で対応可能

#### 本プロジェクトの決定

**全 Feature で `[Route]` を採用し、`NavigationPath` は使用しない。**

```swift
// ✅ 推奨: 型安全な [Route]
@State private var path: [HomeRoute] = []

// ❌ 使用しない: 型消去された NavigationPath
@State private var path = NavigationPath()
```

理由：
- 本プロジェクトの全遷移は Feature 内 push または Feature 間の Modal/Tab で実現可能
- 型安全性と設計原則の整合性を優先

---

### 課題2: Deep Linking の実装パターン

URL から Route への変換、および状態復元のパターンを具体化する。

```swift
// 例: URL → Route への変換
func route(from url: URL) -> AppRoute? { ... }

// 例: 状態復元
func restore(from url: URL) {
    // path や modal の状態を URL から復元
}
```

**検討ポイント:**
- URL スキーム設計
- 複数階層の遷移をどう表現するか
- 認証が必要な画面への Deep Link

**ステータス:** 🔴 未検討

---

### 課題3: UIKit との混在パターン

UIKit と SwiftUI が混在する環境での状態管理パターンを明確化する。

**検討ポイント:**
- `UIHostingController` で SwiftUI をラップする場合の状態管理
- `UIViewControllerRepresentable` で UIKit をラップする場合
- UIKit の `UINavigationController` と SwiftUI の `NavigationStack` の共存

**ステータス:** 🔴 未検討

---

### 課題4: エラーハンドリングと文脈遷移

エラー発生時の文脈遷移パターンを原則化する。

**検討ポイント:**
- アラート表示は文脈の切り替えか？
- エラーによる強制的な pop to root
- リトライ可能なエラーの扱い

**ステータス:** 🔴 未検討

---

### 課題5: テスト可能性の担保

ナビゲーション状態のテスト方法を具体化する。

**検討ポイント:**
- Route の状態変化をテストする方法
- UI テストでの画面遷移検証
- Event 発行のテスト

**ステータス:** 🔴 未検討

---

## 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-02-06 | 課題1「NavigationPath vs [Route] の選択基準」を解決済みに更新 |
| 2026-02-05 | 初版作成、課題セクション追加 |
