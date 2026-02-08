# SwiftUI + UIKit ナビゲーション設計ガイド

UIKitとSwiftUIが混在するプロジェクトにおける、ナビゲーション設計のコンセプトとサンプル実装をまとめたリポジトリです。

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
│   ├── AppCoordinator.swift        # App層の状態管理
│   ├── MainTabBarController.swift  # UITabBarController
│   └── AppModal.swift              # App全体Modal定義
│
├── Features/
│   ├── Home/
│   │   ├── HomeRoute.swift         # push用Route
│   │   ├── HomeEvent.swift         # App層へのイベント
│   │   ├── HomeRootView.swift      # NavigationStack配置
│   │   ├── HomeView.swift          # 一覧画面
│   │   └── HomeItemDetailView.swift # 詳細画面
│   │
│   ├── Settings/
│   │   ├── SettingsRoute.swift
│   │   ├── SettingsEvent.swift
│   │   ├── SettingsRootView.swift
│   │   ├── SettingsView.swift
│   │   └── SettingsDetailView.swift
│   │
│   └── Login/
│       ├── LoginRoute.swift
│       ├── LoginEvent.swift
│       ├── LoginRootView.swift
│       ├── LoginStartView.swift
│       └── LoginCompleteView.swift
│
└── Shared/
    └── Models/
        └── Item.swift              # サンプルモデル
```

### 設計原則の適用

| 原則 | 実装での適用 |
|------|-------------|
| 原則1: push は Feature 内限定 | `HomeRoute` は Home 内のみで使用 |
| 原則3: push/modal 状態分離 | `path: [Route]` と `modal: AppModal?` を分離 |
| 原則9: View は遷移決定権なし | `onNavigate` / `onEvent` コールバックで意図表明 |
| 原則12: Modal結果はイベント | `LoginEvent.completed` / `cancelled` で返却 |

### 連携フロー

```
┌──────────────────────────────────────────────────────────┐
│                    App Layer (UIKit)                      │
│  AppCoordinator.handle(event) → 状態変更 → UI更新        │
│  MainTabBarController - タブ管理、Modal表示              │
└───────────────────────┬──────────────────────────────────┘
                        │ Event
┌───────────────────────▼──────────────────────────────────┐
│              Feature Layer (SwiftUI)                      │
│  UIHostingController ─ HomeRootView ─ HomeView           │
│                             │               │             │
│                             │ onEvent       │ onNavigate  │
│                             ▼               ▼             │
│                        App層へ委譲    path.append()       │
└──────────────────────────────────────────────────────────┘
```

### 動作確認できる機能

- **Home Feature**: アイテム一覧 → 詳細画面への push/pop 遷移
- **Settings Feature**: 設定項目 → 詳細画面への push/pop 遷移
- **Tab 切り替え**: Home ↔ Settings のタブ切り替え（Event 経由）
- **Login Modal**: Home からログインモーダル表示 → 完了/キャンセルで自動クローズ

## ライセンス

MIT License
