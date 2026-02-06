//
//  HomeRootView.swift
//  NavigationSample
//

import SwiftUI

/// Home Feature のルート
///
/// 手段2: NavigationStackはFeatureのRootにのみ置く
struct HomeRootView: View {
    /// Feature内のpush遷移状態
    /// 原則3: Push用の状態とModal用の状態は分離する
    @State private var path: [HomeRoute] = []

    /// App層へのイベント通知
    let onEvent: (HomeEvent) -> Void

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(
                items: Item.samples,
                onNavigate: { route in
                    path.append(route)
                },
                onEvent: onEvent
            )
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .itemDetail(let itemId):
                    if let item = Item.samples.first(where: { $0.id == itemId }) {
                        HomeItemDetailView(
                            item: item,
                            onPop: {
                                path.removeLast()
                            }
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    HomeRootView(onEvent: { _ in })
}
