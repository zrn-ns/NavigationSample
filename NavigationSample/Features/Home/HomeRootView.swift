//
//  HomeRootView.swift
//  NavigationSample
//

import SwiftUI

/// Home Feature のルート
///
/// 手段2: NavigationStackはFeatureのRootにのみ置く
///
/// バケツリレーの中継点:
/// - onNavigate: 全ての子 View に渡して path.append を実行
/// - onShowEdit: 全ての子 View に渡して modal を設定
struct HomeRootView: View {
    /// Feature内のpush遷移状態
    /// 原則3: Push用の状態とModal用の状態は分離する
    @State private var path: [HomeRoute] = []

    /// Feature内のmodal状態
    @State private var modal: HomeModal?

    /// App層へのイベント通知
    let onEvent: (HomeEvent) -> Void

    // MARK: - バケツリレー用のコールバック

    /// Feature 内の push 遷移を処理
    private func navigate(to route: HomeRoute) {
        path.append(route)
    }

    /// 編集モーダルを表示
    private func showEdit(itemId: Item.ID) {
        modal = .edit(itemId)
    }

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(
                items: Item.samples,
                onNavigate: navigate,
                onEvent: onEvent
            )
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .itemDetail(let itemId):
                    if let item = Item.samples.first(where: { $0.id == itemId }) {
                        HomeItemDetailView(
                            item: item,
                            onNavigate: navigate,  // バケツリレー
                            onShowEdit: { showEdit(itemId: item.id) }
                        )
                    }

                case .itemRelated(let itemId):
                    if let item = Item.samples.first(where: { $0.id == itemId }) {
                        // 関連アイテムとして、自分以外のアイテムを表示
                        let relatedItems = Item.samples.filter { $0.id != itemId }
                        HomeItemRelatedView(
                            item: item,
                            relatedItems: relatedItems,
                            onNavigate: navigate,    // バケツリレー
                            onShowEdit: showEdit     // バケツリレー
                        )
                    }
                }
            }
        }
        .sheet(item: $modal) { modal in
            switch modal {
            case .edit(let itemId):
                if let item = Item.samples.first(where: { $0.id == itemId }) {
                    HomeItemEditView(
                        item: item,
                        onSave: { _ in
                            // 実際のアプリではここで保存処理を行う
                            self.modal = nil
                        },
                        onCancel: {
                            self.modal = nil
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    HomeRootView(onEvent: { _ in })
}
