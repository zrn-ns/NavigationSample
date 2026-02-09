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

    /// ビジネスロジック（いいね等の状態を管理）
    @State private var viewModel: UserDetailViewModel

    /// 上位へのイベント通知
    let onEvent: (UserDetailEvent) -> Void

    init(router: UserDetailRouter, viewModel: UserDetailViewModel, onEvent: @escaping (UserDetailEvent) -> Void) {
        self._router = State(initialValue: router)
        self._viewModel = State(initialValue: viewModel)
        self.onEvent = onEvent
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            UserDetailView(router: router, viewModel: viewModel)
                .navigationDestination(for: UserDetailPath.self) { destination in
                    switch destination {
                    case .photos:
                        UserPhotoListView(
                            photos: router.user.photos,
                            onShowDetail: { photoId in router.showPhotoDetail(photoId: photoId) }
                        )

                    case .photoDetail(let photoId):
                        UserPhotoDetailView(
                            photos: router.user.photos,
                            photoId: photoId
                        )
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
                            router.dismissModal()
                            viewModel.sendLike(type)
                            router.sendEvent(.liked(userId: router.user.id, type: type))
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
        viewModel: UserDetailViewModel(),
        onEvent: { _ in }
    )
}
