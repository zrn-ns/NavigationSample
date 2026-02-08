# SwiftUI + UIKit ナビゲーション設計ガイド

UIKitとSwiftUIが混在するプロジェクトにおける、ナビゲーション設計のコンセプトとサンプル実装をまとめたリポジトリです。

**マッチングアプリをモチーフとしたサンプル**で、UIKit グリッドから SwiftUI 詳細画面への push 遷移パターンを実装しています。

## 背景

### UIKitからSwiftUIへの移行期

多くのiOSプロジェクトでは、UIKitで構築された既存のコードベースにSwiftUIを段階的に導入しています。この移行期において、**ナビゲーションの一貫した管理**は特に難しい課題です。

両フレームワークはそれぞれ独自のナビゲーションの仕組みを持っており、単純に組み合わせるだけでは複雑さが増大します。

## 解決したい課題

### 1. ナビゲーション手段の分散

UIKitとSwiftUIで異なるナビゲーションAPIが存在し、画面遷移の方法が統一されていない状態になりがちです。

### 2. 画面遷移ロジックの散在

各画面に遷移ロジックが埋め込まれると、全体の画面フローが把握しづらくなります。

### 3. Deep Linkingの複雑化

外部からのURLスキームやUniversal Linksを処理する際、UIKitとSwiftUIの両方の画面に対応する必要があります。

### 4. テスタビリティ

画面遷移のロジックがViewに密結合していると、遷移フローのテストが困難になります。

## 目指す状態

- **統一されたナビゲーションAPI**: UIKit/SwiftUIを意識せず画面遷移を記述できる
- **遷移ロジックの分離**: 画面（View/ViewController）は遷移先を知らない
- **型安全な遷移先定義**: 遷移先とそのパラメータが型で保証される
- **テスト可能な設計**: 画面遷移のフローを単体テストできる

## 対象環境

- iOS 17.0+
- Xcode 26.2+
- Swift 6

## ドキュメント構成

```
NavigationSample/
├── README.md          # 本ドキュメント（コンセプト）
├── Docs/              # 設計ドキュメント
└── NavigationSample/  # サンプル実装
```

## サンプル実装

### ディレクトリ構造

```
NavigationSample/
├── App/
│   ├── AppDelegate.swift           # UIApplicationDelegate
│   ├── SceneDelegate.swift         # UIWindowSceneDelegate
│   ├── AppCoordinator.swift        # App層の状態管理 + UserGridCoordinator 保持
│   ├── MainTabBarController.swift  # UITabBarController
│   └── AppModal.swift              # App全体Modal定義
│
├── Features/
│   ├── Home/                       # UIKit ベースのグリッド
│   │   ├── UserGridCoordinator.swift    # UIKit Coordinator
│   │   └── Views/
│   │       ├── UserGridViewController.swift  # UICollectionView グリッド
│   │       └── UserGridCell.swift            # グリッドセル
│   │
│   ├── UserDetail/                 # SwiftUI ベースの詳細 Feature
│   │   ├── UserDetailRoute.swift        # Feature 内 push 用 Route
│   │   ├── UserDetailEvent.swift        # App 層へのイベント
│   │   ├── UserDetailModal.swift        # Feature 内 modal 用
│   │   ├── UserDetailRouter.swift       # path, modal, onEvent 管理
│   │   ├── UserDetailRootView.swift     # NavigationStack 配置
│   │   └── Views/
│   │       ├── UserDetailView.swift          # ユーザ詳細画面
│   │       ├── UserPhotoListView.swift       # 写真一覧（push 遷移）
│   │       ├── UserPhotoDetailView.swift     # 写真拡大
│   │       ├── LegacyProfileViewController.swift   # UIKit 画面（パターン A）
│   │       └── LegacyProfileModalView.swift        # UIKit modal ラッパー
│   │
│   ├── Settings/                   # SwiftUI ベース
│   │   ├── SettingsRoute.swift
│   │   ├── SettingsEvent.swift
│   │   ├── SettingsRouter.swift
│   │   ├── SettingsRootView.swift
│   │   └── Views/
│   │       ├── SettingsView.swift
│   │       └── SettingsDetailView.swift
│   │
└── Shared/
    └── Models/
        └── User.swift              # ユーザモデル
```

### 設計原則の適用

| 原則 | 実装での適用 |
|------|-------------|
| 原則1: push は Feature 内限定 | `UserDetailRoute` は UserDetail 内のみで使用 |
| 原則3: push/modal 状態分離 | `path: [Route]` と `modal: Modal?` を分離 |
| 原則8: 文脈を開始した主体が終了 | UserGridCoordinator が詳細画面の push/pop を管理 |
| 原則9: View は遷移決定権なし | `onEvent` コールバックで意図表明 |
| 原則12: Modal結果はイベント | `UserDetailEvent.dismissed` / `liked` で返却 |

### アーキテクチャ

```
UIKit App層
├── AppCoordinator
│   └── UserDetailEvent をハンドリング
└── MainTabBarController
    ├── [Tab 0: ホーム] UINavigationController
    │   ├── UserGridViewController (UIKit, root)
    │   │   └── didSelectUser → coordinator.showUserDetail()
    │   └── UIHostingController<UserDetailRootView> (pushed)
    │       └── UserDetailRootView (SwiftUI Feature)
    │           ├── UserDetailRouter
    │           │   ├── path: [UserDetailRoute]
    │           │   └── modal: UserDetailModal?
    │           └── NavigationStack
    │               ├── UserDetailView
    │               │   ├── .photos → UserPhotoListView (push)
    │               │   └── .legacyProfile → LegacyProfileModalView (modal)
    │               └── UserPhotoListView
    │                   └── .photoDetail → UserPhotoDetailView (push)
    └── [Tab 1: 設定] UIHostingController<SettingsRootView>
        └── (既存のまま)
```

### 遷移フロー

```
┌──────────────────────────────────────────────────────────┐
│                    App Layer (UIKit)                      │
│  AppCoordinator                                          │
│  └── UserGridCoordinator.handle(event)                   │
│       └── .dismissed / .liked → pop                      │
└───────────────────────┬──────────────────────────────────┘
                        │ Event
┌───────────────────────▼──────────────────────────────────┐
│              UserDetail Feature (SwiftUI)                 │
│  UIHostingController ─ UserDetailRootView                │
│                             │                             │
│                             ├── path.append(.photos)      │
│                             ├── path.append(.photoDetail) │
│                             ├── modal = .legacyProfile    │
│                             └── sendEvent(.liked)         │
└──────────────────────────────────────────────────────────┘
```

### 動作確認できる機能

- **Home (UIKit グリッド)**: ユーザ一覧をグリッド表示
- **UserDetail (SwiftUI)**: UIKit グリッドから push 遷移で詳細表示
- **Feature 内 push**: 詳細 → 写真一覧 → 写真拡大 の push 遷移
- **パターン A**: SwiftUI 詳細画面から UIKit 画面を modal 表示
- **Settings Feature**: 設定項目 → 詳細画面への push/pop 遷移
- **Tab 切り替え**: Home ↔ Settings のタブ切り替え

## ライセンス

MIT License
