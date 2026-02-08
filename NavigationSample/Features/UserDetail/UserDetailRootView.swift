//
//  UserDetailRootView.swift
//  NavigationSample
//

import SwiftUI

/// UserDetail Feature のルート
///
/// 手段2: NavigationStack は Feature の Root にのみ置く
///
/// UserDetailRouter を生成し、子 View にバケツリレーで渡す。
/// router 1つだけをバケツリレーすることで、引数の増加を抑制。
struct UserDetailRootView: View {
    /// Feature 内ルーティング（path と modal を管理）
    @State private var router: UserDetailRouter

    /// App層へのイベント通知
    let onEvent: (UserDetailEvent) -> Void

    init(user: User, onEvent: @escaping (UserDetailEvent) -> Void) {
        self._router = State(initialValue: UserDetailRouter(user: user))
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
                LikeSendModalView(
                    user: router.user,
                    onLikeSent: { type in
                        router.sendLike(type)
                    },
                    onDismiss: {
                        router.dismissModal()
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
        user: User.samples[0],
        onEvent: { _ in }
    )
}
