# SwiftUI + UIKit ナビゲーション設計サンプル

UIKit と SwiftUI が混在するプロジェクトにおけるナビゲーション設計パターンを、マッチングアプリをモチーフとしたサンプル実装で示すリポジトリです。

## このプロジェクトについて

### 背景

多くの iOS プロジェクトでは、UIKit で構築された既存のコードベースに SwiftUI を段階的に導入しています。この移行期において、両フレームワークのナビゲーション機構をどう統合するかは共通の課題です。

### このサンプルが提示するもの

- UIKit / SwiftUI 間のナビゲーション連携パターン（A〜D）の具体的な実装例
- Feature 単位でナビゲーション状態を管理する Router パターン
- App 層（UIKit）と Feature 層（SwiftUI）の責務分離
- 設計原則に基づいた意思決定の根拠（アプリ内の設計情報タブで閲覧可能）

## 対象環境

- iOS 17.0+
- Xcode 26.2+
- Swift 6

## Features

### Home（UIKit ベース）

UICollectionView の Compositional Layout を使ったユーザグリッド画面。セルタップで UserDetail Feature を表示する。セル内の View は SwiftUI（UIHostingConfiguration）で構築している。

### UserDetail（SwiftUI ベース）

NavigationStack ベースのユーザ詳細 Feature。ユーザ詳細 → 写真一覧 → 写真詳細の push 遷移と、いいね送信画面の modal 表示を含む。UserDetailRouter が path（push）と modal の状態を分離管理する。

### LikeSend（UIKit 実装 / SwiftUI ラップ）

UIKit の LikeSendViewController を UIViewControllerRepresentable でラップした単画面 Feature。セミモーダル（`.presentationDetents([.medium])`）で表示され、完了・キャンセルを Event で上位に通知する。

### Settings（SwiftUI ベース）

設定画面の Feature。プロフィールプレビューの表示やタブ切り替えなど、Feature 間の連携を Event 委譲で実現している。

### DesignInfo（SwiftUI ベース）

アプリ内の設計情報タブ。設計原則・具体手段・各画面の設計判断をブラウズできる。

### UIKit / SwiftUI 連携パターン

| パターン | 概要 | 実装箇所 |
|---------|------|---------|
| **A** | SwiftUI Feature 内で UIKit 画面を modal 表示 | UserDetail → LikeSend |
| **B** | UIKit グリッドから SwiftUI Feature を push 遷移 | Home → UserDetail |
| **C** | UIKit 画面から SwiftUI Feature を modal 表示 | （設計上の定義） |
| **D** | UIKit 画面の一部を SwiftUI で構築 | Home のグリッドセル |

## 設計原則

6 カテゴリ・14 原則でナビゲーション設計の指針を定めています。

| カテゴリ | 原則 |
|---------|------|
| **状態駆動** | S1: 状態結果原則 / S2: 意味表現原則 |
| **文脈構造** | C1: 単一文脈原則 / C2: 階層スコープ原則 / C3: 文脈停止原則 |
| **Feature 境界** | F1: Push 限定原則 / F2: 切断遷移原則 / F3: Route 境界原則 |
| **状態分離** | P1: Push/Modal 分離原則 / P2: Modal スコープ原則 |
| **責務分離** | R1: View 無決定権原則 / R2: 開始者終了原則 |
| **結果伝達** | E1: 終了結果原則 / E2: Event 委譲原則 |

各原則の詳細な説明と具体手段は、アプリ内の設計情報タブで確認できます。

## ディレクトリ構造

```
NavigationSample/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── AppCoordinator.swift
│   ├── AppModal.swift
│   └── MainTabBarController.swift
│
├── Features/
│   ├── Home/
│   │   ├── PushTransitionAnimator.swift
│   │   ├── UserGridCoordinator.swift
│   │   └── Views/
│   │       ├── UserGridViewController.swift
│   │       └── UserGridCell.swift
│   │
│   ├── UserDetail/
│   │   ├── UserDetailRoute.swift
│   │   ├── UserDetailEvent.swift
│   │   ├── UserDetailModal.swift
│   │   ├── UserDetailRouter.swift
│   │   ├── UserDetailRootView.swift
│   │   └── Views/
│   │       ├── UserDetailView.swift
│   │       ├── UserPhotoListView.swift
│   │       └── UserPhotoDetailView.swift
│   │
│   ├── LikeSend/
│   │   ├── LikeSendEvent.swift
│   │   ├── LikeSendRootView.swift
│   │   └── Views/
│   │       └── LikeSendViewController.swift
│   │
│   └── Settings/
│       ├── SettingsEvent.swift
│       ├── SettingsRouter.swift
│       ├── SettingsRootView.swift
│       └── Views/
│           └── SettingsView.swift
│
└── Shared/
    ├── DesignInfo/
    │   ├── DesignInfoButton.swift
    │   ├── DesignInfoDetailView.swift
    │   ├── DesignInfoFloatingButton.swift
    │   ├── DesignOverviewView.swift
    │   ├── FlowLayout.swift
    │   ├── PracticeDetailView.swift
    │   ├── PracticeInfo.swift
    │   ├── PracticeInfoProvider.swift
    │   ├── PrincipleDetailView.swift
    │   ├── PrincipleInfo.swift
    │   ├── PrincipleInfoProvider.swift
    │   ├── ScreenDesignInfo.swift
    │   └── ScreenDesignInfoProvider.swift
    │
    └── Models/
        ├── User.swift
        └── LikeType.swift
```

## ライセンス

MIT License
