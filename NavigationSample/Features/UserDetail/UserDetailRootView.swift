//
//  UserDetailRootView.swift
//  NavigationSample
//

import SwiftUI

/// UserDetail Feature のルート
///
/// 手段2: NavigationStack は Feature の Root にのみ置く
///
/// router を受け取り、子 View にバケツリレーで渡す。
/// router 1つだけをバケツリレーすることで、引数の増加を抑制。
struct UserDetailRootView: View {
    /// Feature 内ルーティング（path と modal を管理）
    @State private var router: UserDetailRouter

    /// App層へのイベント通知
    let onEvent: (UserDetailEvent) -> Void

    init(router: UserDetailRouter, onEvent: @escaping (UserDetailEvent) -> Void) {
        self._router = State(initialValue: router)
        self.onEvent = onEvent
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            UserDetailView(router: router)
                .navigationDestination(for: UserDetailRoute.self) { route in
                    switch route {
                    case .photos:
                        UserPhotoListView(router: router)

                    case .photoDetail(let photoId):
                        UserPhotoDetailView(router: router, photoId: photoId)
                    }
                }
        }
        .sheet(item: $router.modal) { modal in
            switch modal {
            case .likeSend:
                LikeSendRootView(
                    user: router.user,
                    onEvent: { event in
                        switch event {
                        case .liked(let type):
                            router.sendLike(type)
                        case .dismissed:
                            router.dismissModal()
                        }
                    }
                )
            }
        }
        .onAppear {
            router.onEvent = onEvent
        }
    }
}

#Preview {
    UserDetailRootView(
        router: UserDetailRouter(user: User.samples[0]),
        onEvent: { _ in }
    )
}
