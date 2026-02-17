# SwiftUI + UIKit ナビゲーション設計サンプル

UIKit と SwiftUI が混在するプロジェクトにおけるナビゲーション設計パターンを、マッチングアプリをモチーフとしたサンプル実装で示すリポジトリです。

[設計情報ドキュメント](https://zrn-ns.github.io/NavigationSample/)

https://github.com/user-attachments/assets/d256606a-de55-4b8c-911d-4e85884a702f

## このプロジェクトについて

### 背景

#### 移行期の課題

- UIKit ベースの既存アプリに SwiftUI を段階的に導入する状況
- アプリの基盤は UIKit であり、これはしばらく変わらない前提
- 将来的な SwiftUI 置き換えを見据え、UIKit に深く依存しすぎない設計が必要
- 統合ポイントの中で「画面遷移」が最も設計上の困難を伴う

#### パラダイムの違い

- UIKit: 手続き的（pushViewController, present）
- SwiftUI: 状態駆動（path.append, modal = .xxx）
- この食い違いを吸収する設計方針が必要

#### ナビゲーション機構を混在させるリスク

- UINavigationController と NavigationStack の混同 → ナビゲーションバー二重化
- cross-framework push（SwiftUI NavigationStack 内に UIKit 画面を push 等）→ 予期しない動作
- → Feature 単位で境界を設計し、Feature 間遷移を Modal で行うアプローチ

### このサンプルが提示するもの

- UIKit / SwiftUI 間のナビゲーション連携パターン（A〜C）の具体的な実装例
- Feature 単位でナビゲーション状態を管理する Router パターン
- App 層（UIKit）と Feature 層（SwiftUI）の責務分離
- Feature 境界によるフレームワーク混在リスクの回避方法
- 設計原則に基づいた意思決定の根拠（アプリ内の設計情報タブで閲覧可能）

## 対象環境

- iOS 17.6+
- Xcode 26.2+
- Swift 6

## ライセンス

MIT License
