//
//  UserDetailRootView.swift
//  NavigationSample
//

import SwiftUI

/// UserDetail Feature のルート
///
/// 手段2: NavigationStack は Feature の Root にのみ置く
///
/// router を Environment で子 View に公開する。
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
            UserDetailView(viewModel: viewModel)
                .navigationDestination(for: UserDetailPath.self) { destination in
                    switch destination {
                    case .photos:
                        UserPhotoListView(
                            photos: viewModel.user.photos,
                            onShowDetail: { photoId in router.showPhotoDetail(photoId: photoId) }
                        )

                    case .photoDetail(let photoId):
                        UserPhotoDetailView(
                            photos: viewModel.user.photos,
                            photoId: photoId
                        )
                    }
                }
        }
        .environment(router)
        .sheet(item: $router.modal) { modal in
            switch modal {
            case .likeSend:
                LikeSendRootView(
                    user: viewModel.user,
                    onEvent: { event in
                        switch event {
                        case .liked(let type):
                            router.dismissModal()
                            viewModel.sendLike(type)
                            viewModel.sendEvent(.liked(userId: viewModel.user.id, type: type))
                        case .dismissed:
                            router.dismissModal()
                        }
                    }
                )
            }
        }
        .onAppear {
            viewModel.onEvent = onEvent
        }
    }
}

#Preview {
    UserDetailRootView(
        router: UserDetailRouter(),
        viewModel: UserDetailViewModel(user: User.samples[0]),
        onEvent: { _ in }
    )
}
