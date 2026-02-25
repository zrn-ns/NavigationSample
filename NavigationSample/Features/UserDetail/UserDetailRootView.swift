//
//  UserDetailRootView.swift
//  NavigationSample

import SwiftUI

/// UserDetail Feature のルート
///
/// 手段2: NavigationStack は Feature の Root にのみ置く
///
/// path / modal を @State で直接管理し、子 View にはクロージャで渡す。
struct UserDetailRootView: View {
    /// Feature 内の push 遷移状態
    @State private var path: [UserDetailPath] = []

    /// Feature 内の modal 状態
    @State private var modal: UserDetailModal?

    /// ビジネスロジック（いいね等の状態を管理）
    @State private var viewModel: UserDetailViewModel

    /// 上位へのイベント通知
    let onEvent: (UserDetailEvent) -> Void

    init(viewModel: UserDetailViewModel, onEvent: @escaping (UserDetailEvent) -> Void) {
        self._viewModel = State(initialValue: viewModel)
        self.onEvent = onEvent
    }

    var body: some View {
        NavigationStack(path: $path) {
            UserDetailView(
                viewModel: viewModel,
                onClose: { onEvent(.closeRequested) },
                onShowPhotos: { path.append(.photos) },
                onShowLikeSend: { modal = .likeSend }
            )
                .blockUserToolbar(displayMode: viewModel.displayMode) {
                    viewModel.blockUser()
                    onEvent(.blocked(userId: viewModel.user.id))
                }
                .navigationDestination(for: UserDetailPath.self) { destination in
                    switch destination {
                    case .photos:
                        UserPhotoListView(
                            photos: viewModel.user.photos,
                            onShowDetail: { photoId in path.append(.photoDetail(photoId: photoId)) }
                        )
                        .blockUserToolbar(displayMode: viewModel.displayMode) {
                            viewModel.blockUser()
                            onEvent(.blocked(userId: viewModel.user.id))
                        }

                    case .photoDetail(let photoId):
                        UserPhotoDetailView(
                            photos: viewModel.user.photos,
                            photoId: photoId,
                            isLiked: viewModel.isLiked,
                            onLikeTap: viewModel.displayMode == .standard
                                ? { modal = .likeSend }
                                : nil
                        )
                        .blockUserToolbar(displayMode: viewModel.displayMode) {
                            viewModel.blockUser()
                            onEvent(.blocked(userId: viewModel.user.id))
                        }
                    }
                }
        }
        .sheet(item: $modal) { modal in
            switch modal {
            case .likeSend:
                LikeSendRootView(
                    user: viewModel.user,
                    onEvent: { event in
                        switch event {
                        case .liked(let type):
                            self.modal = nil
                            path.removeAll()
                            viewModel.sendLike(type)
                            onEvent(.liked(userId: viewModel.user.id, type: type))
                        case .closeRequested:
                            self.modal = nil
                        }
                    }
                )
            }
        }
    }
}

#Preview {
    UserDetailRootView(
        viewModel: UserDetailViewModel(user: User.samples[0]),
        onEvent: { _ in }
    )
}
