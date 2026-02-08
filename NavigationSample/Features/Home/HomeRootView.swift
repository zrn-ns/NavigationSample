//
//  HomeRootView.swift
//  NavigationSample
//

import SwiftUI

/// Home Feature のルート
///
/// 手段2: NavigationStackはFeatureのRootにのみ置く
///
/// HomeRouter を生成し、子 View にバケツリレーで渡す。
/// router 1つだけをバケツリレーすることで、引数の増加を抑制。
struct HomeRootView: View {
    /// Feature 内ルーティング（path と modal を管理）
    @State private var router = HomeRouter()

    /// App層へのイベント通知
    let onEvent: (HomeEvent) -> Void

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView(
                items: Item.samples,
                router: router
            )
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .itemDetail(let itemId):
                    if let item = Item.samples.first(where: { $0.id == itemId }) {
                        HomeItemDetailView(
                            item: item,
                            router: router  // バケツリレー
                        )
                    } else {
                        ContentUnavailableView(
                            "アイテムが見つかりません",
                            systemImage: "questionmark.circle"
                        )
                    }

                case .itemRelated(let itemId):
                    if let item = Item.samples.first(where: { $0.id == itemId }) {
                        let relatedItems = Item.samples.filter { $0.id != itemId }
                        HomeItemRelatedView(
                            item: item,
                            relatedItems: relatedItems,
                            router: router  // バケツリレー
                        )
                    } else {
                        ContentUnavailableView(
                            "アイテムが見つかりません",
                            systemImage: "questionmark.circle"
                        )
                    }
                }
            }
        }
        .sheet(item: $router.modal) { modal in
            switch modal {
            case .edit(let itemId):
                if let item = Item.samples.first(where: { $0.id == itemId }) {
                    HomeItemEditView(
                        item: item,
                        onSave: { _ in
                            // 実際のアプリではここで保存処理を行う
                            router.dismissModal()
                        },
                        onCancel: {
                            router.dismissModal()
                        }
                    )
                }

            case .legacyItemDetail(let itemId):
                if let item = Item.samples.first(where: { $0.id == itemId }) {
                    // UIKit 画面を UINavigationController でラップして modal 表示
                    // UIKit 側で自由に push/pop できる
                    LegacyItemDetailModalView(
                        item: item,
                        onDismiss: {
                            router.dismissModal()
                        }
                    )
                }
            }
        }
        .onAppear {
            router.onEvent = onEvent
        }
    }
}

#Preview {
    HomeRootView(onEvent: { _ in })
}
